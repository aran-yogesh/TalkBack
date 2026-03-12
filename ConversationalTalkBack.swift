import Cocoa
import AppKit
import Foundation
import AVFoundation
import ApplicationServices

// 🔐 API Keys Configuration
// Config is loaded from config.swift (which is gitignored for security)
// If config.swift is missing, copy config.swift.template and add your keys

class ConversationalFloatingAvatarWindow: NSWindow {
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: [.borderless], backing: backingStoreType, defer: flag)
        
        self.isOpaque = false
        self.backgroundColor = NSColor.clear
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.hasShadow = false
        self.isMovableByWindowBackground = true
        self.alphaValue = 0.9
    }
}

class ConversationalAvatarView: NSView, NSSoundDelegate, AVAudioPlayerDelegate {
    var message = "I'm listening... 👂"
    var eyeOffset: NSPoint = NSPoint(x: 0, y: 0)
    var isThinking = false
    var isListening = false
    var isRecording = false
    var isSpeaking = false
    var lastActivity = Date()
    var speechSynthesizer = AVSpeechSynthesizer()
    var audioPlayer: AVAudioPlayer?
    var chatHistory: [[String: String]] = []
    var trashCanVisible = false
    var isBeingDragged = false
    var dragStartPoint: NSPoint = NSPoint.zero
    
    // Bouncing motion (zigzag pattern)
    var isFloating = true
    var floatingTimer: Timer?
    var velocityX: CGFloat = 1.0
    var velocityY: CGFloat = 0.8
    var zigzagOffset: CGFloat = 0.0
    var zigzagDirection: CGFloat = 1.0
    var lastInteractionTime: Date?
    
    // Continuous Audio Processing
    var audioEngine: AVAudioEngine?
    var inputNode: AVAudioInputNode?
    var isContinuousListening = false
    var voiceActivityTimer: Timer?
    var silenceDuration: TimeInterval = 0
    let silenceThreshold: TimeInterval = 2.0 // Stop listening after 2 seconds of silence
    var audioBuffer: Data = Data()
    var isProcessingAudio = false
    var inputSampleRate: Double = 16000
    var inputChannelCount: UInt16 = 1
    
    // Teaching assistant mode
    var teacherModeEnabled: Bool = true
    
    // Assignment monitoring
    var assignmentAlertsEnabled: Bool = false
    var assignmentTimer: Timer?
    var lastAssignmentMessageID: String?
    var alertedAssignmentIDs: Set<String> = []
    let assignmentCheckInterval: TimeInterval = 180 // 3 minutes
    let assignmentKeywords = ["assignment", "homework", "project", "due", "submission", "quiz", "exam", "paper", "essay", "lab"]
    let assignmentDomains = ["edu", "canvas", "blackboard"]
    
    // Rate limiting and guardrails
    var lastOpenAICall: Date = Date.distantPast
    var lastSTTCall: Date = Date.distantPast
    var lastResponseTime: Date = Date.distantPast
    let openAICooldown: TimeInterval = 22.0 // Keep below 3 requests per minute (gpt-4o default limit)
    let STTCooldown: TimeInterval = 5.0 // 5 seconds between STT calls
    let responseTimeout: TimeInterval = 10.0 // 10 seconds before allowing idle responses
    let rateLimitBackoff: TimeInterval = 25.0
    var pendingOpenAIPrompt: String?
    var openAIRetryTimer: Timer?
    
    // Legacy audio recording variables removed - continuous listening handles all audio
    
    // MCP monitoring for Cursor IDE roasting 🔥
    var mcpMonitorTimer: Timer?
    var lastMCPMessageTime: TimeInterval = 0
    var lastMCPMessageSeq: Int = 0
    let mcpMessageFile = "/tmp/talkback_message.json"
    var pendingRoastPrompt: (prompt: String, type: String)?
    
    // APIs
    let openAIAPIKey = Config.openAIAPIKey
    let elevenLabsAPIKey = Config.elevenLabsAPIKey
    let elevenLabsVoiceID = Config.elevenLabsVoiceID
    
    var elevenLabsTTSURL: String {
        return "https://api.elevenlabs.io/v1/text-to-speech/\(elevenLabsVoiceID)"
    }
    
    let elevenLabsSTTURL = "https://api.elevenlabs.io/v1/speech-to-text"
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
        
        // Start activity monitoring
        self.startActivityMonitoring()
        
        // Start floating motion
        self.startFloating()
        
        // Start continuous listening
        self.startContinuousListening()
        
        // Start MCP monitoring for Cursor IDE roasting 🔥
        self.startMCPMonitoring()
        
        // Start initial message
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.askOpenAI(prompt: "Introduce yourself as TalkBack, a floating AI balloon. Say you're just floating around and will respond if I bother you. Be sassy and short!")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleTeacherMode() -> Bool {
        teacherModeEnabled.toggle()
        DispatchQueue.main.async {
            self.message = self.teacherModeEnabled ? "👩‍🏫 Teacher mode on." : "Teacher mode off."
            self.needsDisplay = true
        }
        return teacherModeEnabled
    }
    
    func assignmentAlertsState() -> Bool {
        return assignmentAlertsEnabled
    }
    
    func toggleAssignmentAlerts() -> Bool {
        assignmentAlertsEnabled.toggle()
        if assignmentAlertsEnabled {
            startAssignmentMonitoring()
        } else {
            stopAssignmentMonitoring()
        }
        DispatchQueue.main.async {
            self.message = self.assignmentAlertsEnabled ? "📬 Assignment alerts enabled." : "Assignment alerts disabled."
            self.needsDisplay = true
        }
        return assignmentAlertsEnabled
    }
    
    func startAssignmentMonitoring() {
        assignmentTimer?.invalidate()
        assignmentTimer = Timer.scheduledTimer(withTimeInterval: assignmentCheckInterval, repeats: true) { [weak self] _ in
            self?.checkForAssignmentEmail()
        }
        checkForAssignmentEmail()
    }
    
    func stopAssignmentMonitoring() {
        assignmentTimer?.invalidate()
        assignmentTimer = nil
    }
    
    struct MailMessage {
        let subject: String
        let sender: String
        let messageID: String
        let dateString: String
        let body: String
    }
    
    func checkForAssignmentEmail() {
        guard assignmentAlertsEnabled else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let mailMessage = self.fetchLatestMailMessage() else { return }
            let messageKey = mailMessage.messageID.isEmpty ? "\(mailMessage.subject)_\(mailMessage.dateString)" : mailMessage.messageID
            
            if self.alertedAssignmentIDs.contains(messageKey) {
                return
            }
            
            if self.isAssignmentEmail(mailMessage) {
                self.alertedAssignmentIDs.insert(messageKey)
                DispatchQueue.main.async {
                    self.presentAssignmentAlert(mailMessage)
                }
            }
        }
    }
    
    private func fetchLatestMailMessage() -> MailMessage? {
        let script = """
        set maxLen to 1200
        try
            tell application "Mail"
                set targetMailbox to inbox
                if (count of messages of targetMailbox) is 0 then
                    return ""
                end if
                set latestMessage to last item of (messages of targetMailbox)
                set messageSubject to subject of latestMessage
                set messageSender to sender of latestMessage
                set messageID to message id of latestMessage
                if messageID is missing value then set messageID to ""
                set messageDate to date received of latestMessage
                set messageContent to content of latestMessage
                if messageContent is missing value then set messageContent to ""
                if (count messageContent) > maxLen then
                    set messageContent to text 1 thru maxLen of messageContent
                end if
                set delimiter to "|||@@@|||"
                return messageSubject & delimiter & messageSender & delimiter & messageID & delimiter & (messageDate as string) & delimiter & messageContent
            end tell
        on error errText
            return "ERROR|||@@@|||" & errText
        end try
        """
        
        let process = Process()
        process.launchPath = "/usr/bin/osascript"
        process.arguments = ["-e", script]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = Pipe()
        
        do {
            try process.run()
        } catch {
            print("📬 AppleScript launch failed: \(error)")
            return nil
        }
        
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines), !output.isEmpty else {
            return nil
        }
        
        if output.hasPrefix("ERROR|||@@@|||") {
            print("📬 AppleScript error: \(output)")
            return nil
        }
        
        let components = output.components(separatedBy: "|||@@@|||")
        guard components.count == 5 else {
            return nil
        }
        
        let subject = components[0]
        let sender = components[1]
        let messageID = components[2]
        let dateString = components[3]
        let body = components[4]
        
        return MailMessage(subject: subject, sender: sender, messageID: messageID, dateString: dateString, body: body)
    }
    
    private func isAssignmentEmail(_ message: MailMessage) -> Bool {
        let lowerSubject = message.subject.lowercased()
        let lowerBody = message.body.lowercased()
        let lowerSender = message.sender.lowercased()
        
        let keywordHit = assignmentKeywords.contains { keyword in
            lowerSubject.contains(keyword) || lowerBody.contains(keyword)
        }
        
        let domainHit = assignmentDomains.contains { domain in
            lowerSender.contains(domain)
        }
        
        return keywordHit || domainHit
    }
    
    private func presentAssignmentAlert(_ message: MailMessage) {
        let shortSubject = message.subject.isEmpty ? "New assignment" : message.subject
        self.message = "📚 Assignment: \(shortSubject)"
        self.needsDisplay = true
        self.askOpenAIForAssignmentSummary(mail: message)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        
        // Draw custom icon
        self.drawCustomIcon(in: context)
        
        // Draw speech bubble
        self.drawSpeechBubble(in: context)
        
        // Draw trash can if visible
        if trashCanVisible {
            self.drawTrashCan(in: context)
        }
        
        // Draw thinking indicator if needed
        if isThinking {
            self.drawThinkingIndicator(in: context)
        }
        
        // Draw recording indicator if recording
        if isRecording {
            self.drawRecordingIndicator(in: context)
        }
        
        // Draw listening indicator if continuously listening
        if isContinuousListening && !isSpeaking {
            self.drawListeningIndicator(in: context)
        }
        
        // Draw speaking indicator if speaking
        if isSpeaking {
            self.drawSpeakingIndicator(in: context)
        }
    }
    
    func drawCustomIcon(in context: CGContext) {
        let centerX: CGFloat = 150
        let centerY: CGFloat = 100
        let size: CGFloat = 60
        
        // Save context state
        context.saveGState()
        
        let iconColor = NSColor.white
        let eyeColor = NSColor.black
        
        // Main body (simple rectangle)
        let bodyRect = NSRect(x: centerX - size/2, y: centerY - size/3, width: size, height: size * 0.6)
        context.setFillColor(iconColor.cgColor)
        context.fill(bodyRect)
        
        // Top clasp/handle
        let claspRect = NSRect(x: centerX - 8, y: centerY + size/3 - 5, width: 16, height: 10)
        context.fill(claspRect)
        
        // Left bracket
        let leftBracket = NSRect(x: centerX - size/2 - 8, y: centerY - size/3, width: 8, height: size * 0.6)
        context.fill(leftBracket)
        
        // Right bracket
        let rightBracket = NSRect(x: centerX + size/2, y: centerY - size/3, width: 8, height: size * 0.6)
        context.fill(rightBracket)
        
        // Inner compartments (eyes) - simple rectangles
        let leftCompartment = NSRect(x: centerX - size/4, y: centerY - size/6, width: size/6, height: size/4)
        let rightCompartment = NSRect(x: centerX + size/12, y: centerY - size/6, width: size/6, height: size/4)
        
        // Draw eyes with movement
        context.setFillColor(eyeColor.cgColor)
        let leftEye = NSRect(x: leftCompartment.origin.x + eyeOffset.x, y: leftCompartment.origin.y + eyeOffset.y, width: leftCompartment.width, height: leftCompartment.height)
        let rightEye = NSRect(x: rightCompartment.origin.x + eyeOffset.x, y: rightCompartment.origin.y + eyeOffset.y, width: rightCompartment.width, height: rightCompartment.height)
        
            context.fill(leftEye)
            context.fill(rightEye)
        
        // Draw mouth based on state
        let mouthY = centerY - size/3 - 10
        let mouthRect = NSRect(x: centerX - 8, y: mouthY, width: 16, height: 4)
        
        if isListening || isRecording {
            // Listening mouth (open circle)
            context.setFillColor(iconColor.cgColor)
            let mouthCircle = NSRect(x: centerX - 3, y: mouthY - 3, width: 6, height: 6)
            context.fillEllipse(in: mouthCircle)
        } else if isThinking {
            // Thinking mouth (straight line)
            context.setStrokeColor(iconColor.cgColor)
            context.setLineWidth(2)
            context.move(to: CGPoint(x: centerX - 8, y: mouthY + 2))
            context.addLine(to: CGPoint(x: centerX + 8, y: mouthY + 2))
            context.strokePath()
        } else {
            // Happy mouth (smile)
            context.setFillColor(iconColor.cgColor)
            context.fill(mouthRect)
        }
        
        // Restore context state
        context.restoreGState()
    }
    
    func drawRecordingIndicator(in context: CGContext) {
        let centerX: CGFloat = 150
        let centerY: CGFloat = 100
        let radius: CGFloat = 5
        
        // Draw pulsing red circle for recording
        let time = Date().timeIntervalSince1970
        let pulse = (sin(time * 5) + 1) / 2 // Faster pulse for recording
        let alpha = 0.5 + (pulse * 0.5)
        
        context.setFillColor(NSColor.red.withAlphaComponent(alpha).cgColor)
        let recordingRect = NSRect(x: centerX + 30, y: centerY + 20, width: radius * 2, height: radius * 2)
        context.fillEllipse(in: recordingRect)
    }
    
    func drawTrashCan(in context: CGContext) {
        let screenHeight = NSScreen.main?.frame.height ?? 800
        let trashY = screenHeight - 100
        let trashX: CGFloat = 50
        
        // Draw trash can body
        let trashRect = NSRect(x: trashX, y: trashY, width: 40, height: 50)
        context.setFillColor(NSColor.red.cgColor)
        context.fill(trashRect)
        
        // Draw trash can lid
        let lidRect = NSRect(x: trashX - 5, y: trashY + 45, width: 50, height: 10)
        context.setFillColor(NSColor.darkGray.cgColor)
        context.fill(lidRect)
        
        // Draw trash can handle
        let handleRect = NSRect(x: trashX + 15, y: trashY + 50, width: 10, height: 8)
        context.setFillColor(NSColor.black.cgColor)
        context.fill(handleRect)
        
        // Draw "TRASH" text
        let textRect = NSRect(x: trashX - 10, y: trashY - 20, width: 60, height: 20)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NSColor.red,
            .font: NSFont.boldSystemFont(ofSize: 12)
        ]
        "TRASH".draw(in: textRect, withAttributes: attributes)
    }
    
    func drawThinkingIndicator(in context: CGContext) {
        let centerX: CGFloat = 150
        let centerY: CGFloat = 100
        let radius: CGFloat = 30
        
        // Draw pulsing circle
        let time = Date().timeIntervalSince1970
        let pulse = (sin(time * 3) + 1) / 2
        let alpha = 0.3 + (pulse * 0.4)
        
        context.setFillColor(NSColor.white.withAlphaComponent(alpha).cgColor)
        let thinkingRect = NSRect(x: centerX - radius, y: centerY - radius, width: radius * 2, height: radius * 2)
        context.fillEllipse(in: thinkingRect)
    }
    
    func drawSpeechBubble(in context: CGContext) {
        let bubbleRect = NSRect(x: 20, y: 20, width: 260, height: 60)
        
        // Draw bubble background
        context.setFillColor(NSColor.black.withAlphaComponent(0.8).cgColor)
        let bubblePath = NSBezierPath(roundedRect: bubbleRect, xRadius: 10, yRadius: 10)
        bubblePath.fill()
        
        // Draw text
        let textRect = NSRect(x: bubbleRect.minX + 10, y: bubbleRect.minY + 10, width: bubbleRect.width - 20, height: bubbleRect.height - 20)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NSColor.white,
            .font: NSFont.systemFont(ofSize: 12)
        ]
        
        message.draw(in: textRect, withAttributes: attributes)
    }
    
    override func mouseMoved(with event: NSEvent) {
        // Update eye position based on mouse
        let mouseLocation = event.locationInWindow
        let faceCenter = NSPoint(x: 160, y: 120)
        
        let deltaX = mouseLocation.x - faceCenter.x
        let deltaY = mouseLocation.y - faceCenter.y
        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
        
        if distance > 0 {
            eyeOffset.x = min(max(deltaX / distance * 5, -5), 5)
            eyeOffset.y = min(max(-deltaY / distance * 5, -5), 5)
        } else {
            eyeOffset.x = 0
            eyeOffset.y = 0
        }
        
        // Check if near menu bar
        let screenHeight = NSScreen.main?.frame.height ?? 800
        let windowFrame = self.window?.frame ?? NSRect.zero
        let distanceFromTop = screenHeight - windowFrame.maxY
        
        if distanceFromTop < 100 {
            trashCanVisible = true
        } else {
            trashCanVisible = false
        }
        
        needsDisplay = true
    }
    
    override func mouseDown(with event: NSEvent) {
        dragStartPoint = event.locationInWindow
        isBeingDragged = true
        
        // No longer start recording on click - continuous listening handles this
    }
    
    override func mouseDragged(with event: NSEvent) {
        if !isBeingDragged { return }
        
        // Move the window
        let currentLocation = event.locationInWindow
        let deltaX = currentLocation.x - dragStartPoint.x
        let deltaY = currentLocation.y - dragStartPoint.y
        
        if let window = self.window {
            let newOrigin = NSPoint(
                x: window.frame.origin.x + deltaX,
                y: window.frame.origin.y + deltaY
            )
            window.setFrameOrigin(newOrigin)
        }
        
        // Check if near menu bar
        let screenHeight = NSScreen.main?.frame.height ?? 800
        let windowFrame = self.window?.frame ?? NSRect.zero
        let distanceFromTop = screenHeight - windowFrame.maxY
        
        if distanceFromTop < 100 {
            trashCanVisible = true
            message = "Drop me in the trash to turn me off! 🗑️"
        } else {
            trashCanVisible = false
            message = "I'm listening... 👂"
        }
        
        needsDisplay = true
    }
    
    override func mouseUp(with event: NSEvent) {
        isBeingDragged = false
        
        // Check if dropped in trash can area
        let screenHeight = NSScreen.main?.frame.height ?? 800
        let windowFrame = self.window?.frame ?? NSRect.zero
        let distanceFromTop = screenHeight - windowFrame.maxY
        
        if distanceFromTop < 100 {
            // Dropped in trash - exit the app
            message = "Goodbye! I'm going to the trash! 🗑️"
            needsDisplay = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                NSApplication.shared.terminate(nil)
            }
        } else {
            // Continuous listening handles all audio processing
            message = "I'm listening... 👂"
            needsDisplay = true
        }
    }
    
    func startFloating() {
        print("🎈 Starting floating motion...")
        floatingTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [weak self] _ in
            self?.updateFloatingPosition()
        }
    }
    
    func stopFloating() {
        print("🛑 Stopping floating motion...")
        floatingTimer?.invalidate()
        floatingTimer = nil
        isFloating = false
    }
    
    func resumeFloatingAfterDelay() {
        // Resume floating 5 seconds after last interaction
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            guard let self = self else { return }
            
            if let lastTime = self.lastInteractionTime,
               Date().timeIntervalSince(lastTime) >= 5.0 {
                print("🎈 Resuming floating motion...")
                self.isFloating = true
                if self.floatingTimer == nil {
                    self.startFloating()
                }
            }
        }
    }
    
    func updateFloatingPosition() {
        guard isFloating, !isRecording, !isBeingDragged, let window = self.window else { return }
        
        // Get current position
        var frame = window.frame
        
        // Get screen bounds
        guard let screen = NSScreen.main else { return }
        let screenFrame = screen.visibleFrame
        
        // Update zigzag offset (creates side-to-side motion) - slower and smoother
        zigzagOffset += zigzagDirection * 0.15  // Reduced from 0.3
        if abs(zigzagOffset) > 20 {  // Reduced amplitude from 30
            zigzagDirection *= -1
        }
        
        // Update position with zigzag pattern
        frame.origin.x += velocityX + zigzagOffset * 0.08  // Reduced from 0.1
        frame.origin.y += velocityY
        
        // Bounce off edges
        if frame.origin.x <= screenFrame.minX {
            frame.origin.x = screenFrame.minX
            velocityX = abs(velocityX) + CGFloat.random(in: -0.5...0.5)
            // Reverse zigzag on bounce
            zigzagDirection *= -1
        } else if frame.origin.x + frame.width >= screenFrame.maxX {
            frame.origin.x = screenFrame.maxX - frame.width
            velocityX = -abs(velocityX) + CGFloat.random(in: -0.5...0.5)
            // Reverse zigzag on bounce
            zigzagDirection *= -1
        }
        
        if frame.origin.y <= screenFrame.minY {
            frame.origin.y = screenFrame.minY
            velocityY = abs(velocityY) + CGFloat.random(in: -0.5...0.5)
        } else if frame.origin.y + frame.height >= screenFrame.maxY {
            frame.origin.y = screenFrame.maxY - frame.height
            velocityY = -abs(velocityY) + CGFloat.random(in: -0.5...0.5)
        }
        
        // Keep velocity within reasonable bounds (slower limits)
        velocityX = max(min(velocityX, 2.0), -2.0)  // Reduced from 4.0
        velocityY = max(min(velocityY, 2.0), -2.0)  // Reduced from 4.0
        
        // Move window
        window.setFrameOrigin(frame.origin)
    }
    
    // Legacy recording functions removed - continuous listening handles all audio processing
    
    // Legacy transcribeAudio function removed - using transcribeAudioWithElevenLabs instead
    
    func processUserSpeech(_ text: String) {
        print("💬 User said: \(text)")
        
        // Add user input to chat history
        chatHistory.append(["role": "user", "content": text])
        
        // Keep chat history manageable (last 6 exchanges = 12 messages)
        if chatHistory.count > 12 {
            chatHistory.removeFirst(2) // Remove oldest user/assistant pair
        }
        
        // Update response tracking
        lastResponseTime = Date()
        
        // Ask OpenAI for response
        askOpenAI(prompt: text)
        
        lastActivity = Date()
    }
    
    func startActivityMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            self.checkUserActivity()
        }
    }
    
    func checkUserActivity() {
        let now = Date()
        let timeSinceLastActivity = now.timeIntervalSince(lastActivity)
        let timeSinceLastResponse = now.timeIntervalSince(lastResponseTime)
        
        // Only send idle messages if:
        // 1. No activity for 60+ seconds AND
        // 2. No response sent in last 10 seconds (to prevent spam during active conversation)
        if timeSinceLastActivity > 60 && timeSinceLastResponse > responseTimeout {
            let messages = [
                "Hello? Anyone there? I'm getting bored! 😴",
                "Are you ignoring me? How rude! 😤",
                "I'm still here, watching... 👀",
                "Did you forget about me? Let's chat! 💬"
            ]
            
            let randomMessage = messages.randomElement() ?? "I'm still here!"
            askOpenAI(prompt: randomMessage)
        }
        
        lastActivity = Date()
    }
    
    func askOpenAI(prompt: String, bypassCooldown: Bool = false) {
        guard !prompt.isEmpty else { return }
        
        if isThinking {
            print("⏳ Still processing previous reply, queueing prompt.")
            scheduleOpenAIRequest(prompt: prompt, delay: openAICooldown)
            return
        }
        
        if !bypassCooldown {
            let timeSinceLastCall = Date().timeIntervalSince(lastOpenAICall)
            if timeSinceLastCall < openAICooldown {
                let wait = openAICooldown - timeSinceLastCall
                print("⏰ OpenAI cooldown: waiting \(wait) seconds before next call.")
                scheduleOpenAIRequest(prompt: prompt, delay: wait)
                return
            }
        }
        
        isThinking = true
        message = "Thinking... 🤔"
        needsDisplay = true
        lastOpenAICall = Date()
        pendingOpenAIPrompt = nil
        openAIRetryTimer?.invalidate()
        
        // Build conversation history in OpenAI format with optimized system prompt
        var messages: [[String: String]] = [
            ["role": "system", "content": "You are TalkBack, a sassy floating AI balloon. RULES: 1) MAX 2 sentences, 2) Always sassy/sarcastic, 3) Use emojis, 4) Be witty but brief, 5) No long explanations. Stay in character as a floating balloon with attitude."]
        ]
        
        // Add chat history (trimmed to last 6 messages to prevent token bloat)
        let trimmedHistory = Array(chatHistory.suffix(6))
        messages.append(contentsOf: trimmedHistory)
        
        // Add current user message
        messages.append(["role": "user", "content": prompt])
        
        let requestBody: [String: Any] = [
            "model": "gpt-4o",
            "messages": messages,
            "max_tokens": 80,  // Reduced for shorter responses
            "temperature": 0.9,  // Higher for more personality
            "stop": ["\n\n", "User:", "Human:"],  // Stop sequences to prevent long responses
            "presence_penalty": 0.3,  // Encourage creativity
            "frequency_penalty": 0.1   // Reduce repetition
        ]
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            self.message = "API Error! 😤"
            self.isThinking = false
            self.needsDisplay = true
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Config.openAIAPIKey)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            self.message = "JSON Error! 😤"
            self.isThinking = false
            self.needsDisplay = true
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isThinking = false
                
                if let error = error {
                    print("OpenAI Error: \(error)")
                    self?.message = "Network Error! 😤"
                    self?.needsDisplay = true
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("OpenAI HTTP Status: \(httpResponse.statusCode)")
                    if httpResponse.statusCode == 429 {
                        if let strongSelf = self {
                            strongSelf.scheduleOpenAIRequest(prompt: prompt, delay: strongSelf.rateLimitBackoff)
                            strongSelf.message = "Cooling off... 😴"
                            strongSelf.needsDisplay = true
                        }
                        return
                    }
                }
                
                guard let data = data else {
                    self?.message = "No Data! 😤"
                    self?.needsDisplay = true
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        print("OpenAI Response: \(json)")
                        
                        if let choices = json["choices"] as? [[String: Any]],
                           let firstChoice = choices.first,
                           let message = firstChoice["message"] as? [String: Any],
                           let text = message["content"] as? String {
                            
                            let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                            self?.message = cleanText
                            
                            // Add assistant response to chat history
                            self?.chatHistory.append(["role": "assistant", "content": cleanText])
                            
                            // Speak with Ivanna's voice
                            self?.speakWithElevenLabs(cleanText)
                        } else if let error = json["error"] as? [String: Any],
                                  let errorMessage = error["message"] as? String {
                            self?.message = "OpenAI Error: \(errorMessage) 😤"
                        } else {
                            self?.message = "I'm confused! 😤"
                        }
                    } else {
                        self?.message = "Parse Error! 😤"
                    }
                } catch {
                    print("JSON Error: \(error)")
                    self?.message = "JSON Parse Error! 😤"
                }
                
                self?.needsDisplay = true
            }
        }.resume()
    }
    
    private func askOpenAIForAssignmentSummary(mail: MailMessage) {
        guard assignmentAlertsEnabled else { return }
        
        if isThinking {
            print("⏳ Skipping assignment summary, still processing previous request.")
            return
        }
        
        let timeSinceLastCall = Date().timeIntervalSince(lastOpenAICall)
        if timeSinceLastCall < openAICooldown {
            print("⏰ Assignment summary delayed to respect cooldown.")
            let delay = openAICooldown - timeSinceLastCall + 1
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.askOpenAIForAssignmentSummary(mail: mail)
            }
            return
        }
        
        guard !Config.openAIAPIKey.contains("YOUR_OPENAI_API_KEY") else {
            print("🔑 Missing OpenAI key for assignment summary.")
            DispatchQueue.main.async {
                self.message = "Add your OpenAI key for email summaries."
                self.needsDisplay = true
            }
            return
        }
        
        isThinking = true
        needsDisplay = true
        lastOpenAICall = Date()
        message = "Summarizing email... ✉️"
        needsDisplay = true
        
        let systemPrompt = """
        You are TalkBack, a concise and enthusiastic college assignment assistant. Summarize the email for a student, highlight the course/assignment, any due dates or key requirements, and suggest the next action. Keep it under 3 sentences and use a friendly tone with an emoji if appropriate.
        """
        
        let userPrompt = """
        Subject: \(mail.subject)
        From: \(mail.sender)
        Received: \(mail.dateString)
        
        Email excerpt:
        \(mail.body)
        """
        
        let messages: [[String: String]] = [
            ["role": "system", "content": systemPrompt],
            ["role": "user", "content": userPrompt]
        ]
        
        let requestBody: [String: Any] = [
            "model": "gpt-4o",
            "messages": messages,
            "max_tokens": 120,
            "temperature": 0.7
        ]
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            self.message = "Email summary error! 😤"
            self.isThinking = false
            self.needsDisplay = true
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Config.openAIAPIKey)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            self.message = "Email summary JSON error! 😤"
            self.isThinking = false
            self.needsDisplay = true
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isThinking = false
                
                if let error = error {
                    print("OpenAI Assignment Error: \(error)")
                    self.message = "Email summary failed. 😤"
                    self.needsDisplay = true
                    return
                }
                
                guard let data = data else {
                    self.message = "No summary data. 😤"
                    self.needsDisplay = true
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let choices = json["choices"] as? [[String: Any]],
                       let firstChoice = choices.first,
                       let messageDict = firstChoice["message"] as? [String: Any],
                       let text = messageDict["content"] as? String {
                        
                        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                        self.message = cleanText
                        self.speakWithElevenLabs(cleanText)
                    } else {
                        self.message = "Couldn't parse email summary. 😤"
                    }
                } catch {
                    print("JSON Error: \(error)")
                    self.message = "Email summary parse error. 😤"
                }
                
                self.needsDisplay = true
            }
        }.resume()
    }
    
    func handleCommandStarted(command: String) {
        let shortCommand = shortenCommand(command)
        DispatchQueue.main.async {
            self.message = "🚀 Running: \(shortCommand)"
            self.needsDisplay = true
        }
    }
    
    func handleCommandFinished(command: String, status: String, exitCode: Int, output: String, duration: Double?) {
        let success = (exitCode == 0) || status.lowercased() == "success"
        let shortCommand = shortenCommand(command)
        let durationText: String
        if let duration = duration {
            durationText = String(format: " (%.1fs)", duration)
        } else {
            durationText = ""
        }
        
        DispatchQueue.main.async {
            self.message = success ? "✅ \(shortCommand)\(durationText)" : "❌ \(shortCommand)\(durationText)"
            self.needsDisplay = true
        }
        
        guard teacherModeEnabled else { return }
        
        let snippet = prepareOutputSnippet(output)
        askOpenAIForTeachingMoment(
            command: shortCommand,
            outputSnippet: snippet,
            success: success,
            exitCode: exitCode,
            duration: duration
        )
    }
    
    private func shortenCommand(_ command: String) -> String {
        let trimmed = command.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count <= 60 {
            return trimmed
        }
        return String(trimmed.prefix(57)) + "..."
    }
    
    private func prepareOutputSnippet(_ output: String) -> String {
        let cleaned = output.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty else {
            return "No output captured."
        }
        if cleaned.count <= 1200 {
            return cleaned
        }
        return String(cleaned.suffix(1200))
    }
    
    func askOpenAIForTeachingMoment(command: String, outputSnippet: String, success: Bool, exitCode: Int, duration: Double?) {
        guard teacherModeEnabled else { return }

        if isThinking {
            print("⌛ Teacher feedback delayed: already processing another response.")
            DispatchQueue.main.asyncAfter(deadline: .now() + openAICooldown) { [weak self] in
                self?.askOpenAIForTeachingMoment(command: command, outputSnippet: outputSnippet, success: success, exitCode: exitCode, duration: duration)
            }
            return
        }

        let timeSinceLastCall = Date().timeIntervalSince(lastOpenAICall)
        if timeSinceLastCall < openAICooldown {
            let wait = openAICooldown - timeSinceLastCall + 0.5
            print("⏰ Teacher feedback delayed by \(wait)s to respect OpenAI cooldown.")
            DispatchQueue.main.asyncAfter(deadline: .now() + wait) { [weak self] in
                self?.askOpenAIForTeachingMoment(command: command, outputSnippet: outputSnippet, success: success, exitCode: exitCode, duration: duration)
            }
            return
        }
        
        isThinking = true
        needsDisplay = true
        lastOpenAICall = Date()
        message = "Reviewing results... 🧠"
        needsDisplay = true
        
        let durationText = duration.map { String(format: "%.2f seconds", $0) } ?? "unknown duration"
        let successText = success ? "success" : "failure"
        
        let systemPrompt = success
        ? """
        You are TalkBack, a witty but supportive coding teacher. The command finished successfully. Celebrate briefly, highlight what the result means, and suggest one productive next step. Be concise (max 3 sentences) and keep a playful tone.
        """
        : """
        You are TalkBack, a witty but supportive coding teacher. The command failed. Diagnose likely causes from the output, teach the user what went wrong, and give 1-2 actionable next steps. Be encouraging but can sprinkle light sass. Keep it under 4 sentences.
        """
        
        let userPrompt = """
        Command: \(command)
        Result: \(successText) (exit code \(exitCode))
        Duration: \(durationText)
        
        Command output (truncated):
        \(outputSnippet)
        """
        
        let messages: [[String: String]] = [
            ["role": "system", "content": systemPrompt],
            ["role": "user", "content": userPrompt]
        ]
        
        let requestBody: [String: Any] = [
            "model": "gpt-4o",
            "messages": messages,
            "max_tokens": 120,
            "temperature": 0.6
        ]
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            self.message = "API Error! 😤"
            self.isThinking = false
            self.needsDisplay = true
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Config.openAIAPIKey)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            self.message = "JSON Error! 😤"
            self.isThinking = false
            self.needsDisplay = true
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isThinking = false
                
                if let error = error {
                    print("OpenAI Teacher Error: \(error)")
                    self.message = success ? "All done! ✅" : "Command failed. 😤"
                    self.needsDisplay = true
                    return
                }
                
                guard let data = data else {
                    self.message = success ? "All done! ✅" : "Command failed. 😤"
                    self.needsDisplay = true
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let choices = json["choices"] as? [[String: Any]],
                       let firstChoice = choices.first,
                       let messageDict = firstChoice["message"] as? [String: Any],
                       let text = messageDict["content"] as? String {
                        
                        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                        self.message = cleanText
                        self.speakWithElevenLabs(cleanText)
                    } else {
                        self.message = success ? "All done! ✅" : "Command failed. 😤"
                    }
                } catch {
                    print("JSON Error: \(error)")
                    self.message = success ? "All done! ✅" : "Command failed. 😤"
                }
                
                self.needsDisplay = true
            }
        }.resume()
    }
    private func scheduleOpenAIRequest(prompt: String, delay: TimeInterval) {
        guard !prompt.isEmpty else { return }
        DispatchQueue.main.async {
            self.pendingOpenAIPrompt = prompt
            self.openAIRetryTimer?.invalidate()
            let clampedDelay = max(1.0, delay)
            self.openAIRetryTimer = Timer.scheduledTimer(withTimeInterval: clampedDelay, repeats: false) { [weak self] _ in
                guard let self = self else { return }
                let nextPrompt = self.pendingOpenAIPrompt
                self.pendingOpenAIPrompt = nil
                self.openAIRetryTimer = nil
                if let nextPrompt = nextPrompt {
                    self.askOpenAI(prompt: nextPrompt, bypassCooldown: true)
                }
            }
            self.message = "Hold up... cooling down. 😴"
            self.needsDisplay = true
        }
    }
    
    func speakWithElevenLabs(_ text: String) {
        print("🎤 Speaking with Ivanna's voice: \(text)")
        
        // Set speaking state
        isSpeaking = true
        message = "Speaking... 🗣️"
        needsDisplay = true
        
        // Clean text (remove emojis)
        let cleanText = text.replacingOccurrences(of: "[\\p{So}\\p{Cn}]", with: "", options: .regularExpression)
        
        guard let url = URL(string: elevenLabsTTSURL) else {
            print("🎤 Invalid TTS URL")
            isSpeaking = false
            message = "I'm listening... 👂"
            needsDisplay = true
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(elevenLabsAPIKey, forHTTPHeaderField: "xi-api-key")
        
        let requestBody: [String: Any] = [
            "text": cleanText,
            "model_id": "eleven_multilingual_v2",
            "voice_settings": [
                "stability": 0.5,
                "similarity_boost": 0.5
            ]
        ]
        
        // Request MP3 format for better streaming
        request.setValue("audio/mpeg", forHTTPHeaderField: "Accept")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("🎤 TTS JSON error: \(error)")
            isSpeaking = false
            message = "I'm listening... 👂"
            needsDisplay = true
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("🎤 ElevenLabs TTS Error: \(error)")
                DispatchQueue.main.async {
                    self.isSpeaking = false
                    self.message = "I'm listening... 👂"
                    self.needsDisplay = true
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("🎤 ElevenLabs TTS HTTP Status: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("🎤 No audio data from ElevenLabs TTS")
                DispatchQueue.main.async {
                    self.isSpeaking = false
                    self.message = "I'm listening... 👂"
                    self.needsDisplay = true
                }
                return
            }
            
            print("🎤 Received audio data: \(data.count) bytes")
            
            // Play the audio
            DispatchQueue.main.async {
                self.playAudioData(data)
                
                // Reset speaking state after audio finishes
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isSpeaking = false
                    self.message = "I'm listening... 👂"
                    self.needsDisplay = true
                }
            }
        }.resume()
    }
    
    func playAudioData(_ data: Data) {
        print("🎤 Playing audio with AVAudioPlayer...")
        
        do {
            // Stop any existing audio
            audioPlayer?.stop()
            
            // Create new AVAudioPlayer with MP3 data
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.delegate = self
            audioPlayer?.volume = 1.0
            
            if audioPlayer?.play() == true {
                print("🎤 AVAudioPlayer started successfully!")
            } else {
                print("🎤 AVAudioPlayer failed to play")
                isSpeaking = false
                message = "I'm listening... 👂"
                needsDisplay = true
            }
        } catch {
            print("🎤 AVAudioPlayer error: \(error)")
            isSpeaking = false
            message = "I'm listening... 👂"
            needsDisplay = true
        }
    }
    
    // MARK: - Audio Player Delegates
    
    func sound(_ sound: NSSound, didFinishPlaying flag: Bool) {
        print("🎤 Audio playback finished: \(flag)")
        DispatchQueue.main.async {
            self.isSpeaking = false
            self.message = "I'm listening... 👂"
            self.needsDisplay = true
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("🎤 AVAudioPlayer finished: \(flag)")
        DispatchQueue.main.async {
            self.isSpeaking = false
            self.message = "I'm listening... 👂"
            self.needsDisplay = true
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("🎤 AVAudioPlayer decode error: \(error?.localizedDescription ?? "Unknown error")")
        DispatchQueue.main.async {
            self.isSpeaking = false
            self.message = "I'm listening... 👂"
            self.needsDisplay = true
        }
    }
    
    // MARK: - Continuous Listening Implementation
    
    func startContinuousListening() {
        print("🎤 Starting continuous listening...")
        
        // Request microphone permission
        AVCaptureDevice.requestAccess(for: .audio) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                    self?.setupAudioEngine()
                    } else {
                    print("❌ Microphone permission denied!")
                    self?.message = "Microphone access denied! 😤"
                    self?.needsDisplay = true
                }
            }
        }
    }
    
    func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        inputNode = audioEngine?.inputNode
        
        guard let inputNode = inputNode else {
            print("❌ No input node available")
            return 
        }
        
        // Use the input node's native format to avoid format mismatch
        let inputFormat = inputNode.outputFormat(forBus: 0)
        inputSampleRate = inputFormat.sampleRate
        inputChannelCount = UInt16(max(1, inputFormat.channelCount))
        print("🎤 Input format: \(inputFormat)")
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputFormat) { [weak self] buffer, when in
            self?.processAudioBuffer(buffer: buffer, when: when)
        }
        
        do {
            try audioEngine?.start()
            isContinuousListening = true
            message = "I'm listening... 👂"
            needsDisplay = true
            print("✅ Continuous listening started!")
        } catch {
            print("❌ Audio engine failed to start: \(error)")
        }
    }
    
    func processAudioBuffer(buffer: AVAudioPCMBuffer, when: AVAudioTime) {
        guard !isProcessingAudio && !isSpeaking else { return } // Don't process while speaking
        
        let frameCount = Int(buffer.frameLength)
        var amplitude: Float = 0
        var capturedData: Data?
        
        if let floatChannelData = buffer.floatChannelData?[0] {
            for i in 0..<frameCount {
                amplitude += abs(floatChannelData[i])
            }
            amplitude /= Float(frameCount)
            capturedData = convertFloatToPCM16(floatData: floatChannelData, frameCount: frameCount)
        } else if let int16ChannelData = buffer.int16ChannelData?[0] {
            for i in 0..<frameCount {
                amplitude += abs(Float(int16ChannelData[i])) / 32768.0
            }
            amplitude /= Float(frameCount)
            capturedData = Data(bytes: int16ChannelData, count: frameCount * MemoryLayout<Int16>.size)
        } else {
            return
        }
        
        if amplitude > 0.015 {
            silenceDuration = 0
            if !isListening {
                isListening = true
                print("🎤 Voice detected! Amplitude: \(amplitude)")
                DispatchQueue.main.async {
                    self.message = "I hear you... 🎤"
                    self.needsDisplay = true
                }
            }
            
            if let capturedData = capturedData {
                audioBuffer.append(capturedData)
            }
        } else {
            // No voice detected
            silenceDuration += 0.1 // Assuming 100ms buffer intervals
            
            if silenceDuration >= silenceThreshold && isListening && !audioBuffer.isEmpty {
                // Process the accumulated audio
                processAccumulatedAudio()
            }
        }
    }
    
    func convertFloatToPCM16(floatData: UnsafePointer<Float>, frameCount: Int) -> Data {
        var pcm16Data = Data()
        pcm16Data.reserveCapacity(frameCount * MemoryLayout<Int16>.size)
        
        for i in 0..<frameCount {
            let sample = max(-1.0, min(1.0, floatData[i])) // Clamp to [-1, 1]
            let pcm16Sample = Int16(sample * 32767.0) // Convert to 16-bit
            pcm16Data.append(contentsOf: withUnsafeBytes(of: pcm16Sample) { Data($0) })
        }
        
        return pcm16Data
    }
    
    func processAccumulatedAudio() {
        guard !audioBuffer.isEmpty else { return }
        
        // Check if audio buffer is large enough (filter out very short sounds)
        guard audioBuffer.count > 8000 else { // ~0.5 seconds at 16kHz
            audioBuffer.removeAll() // Clear small buffer
            return
        }
        
        isProcessingAudio = true
        isListening = false
        
        DispatchQueue.main.async {
            self.message = "Processing... 🤔"
            self.needsDisplay = true
        }
        
        // Convert audio data to WAV format for ElevenLabs STT
        let wavData = convertToWAV(audioData: audioBuffer)
        audioBuffer.removeAll()
        
        // Send to ElevenLabs STT
        transcribeAudioWithElevenLabs(audioData: wavData) { [weak self] text in
            DispatchQueue.main.async {
                self?.isProcessingAudio = false
                if let text = text, !text.isEmpty {
                    // Filter out common background noise patterns
                    let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    let filteredText = trimmedText.lowercased()
                    let noisePatterns = ["static", "noise", "sonido", "descarga", "heavy", "electric", 
                                       "white", "shuffling", "aguja", "corte", "escupitivo", "śmiech",
                                       "escopeta", "gritos", "shouting", "screaming"]
                    let isParenthetical = filteredText.hasPrefix("(") && filteredText.hasSuffix(")")
                    let letterCount = filteredText.unicodeScalars.reduce(into: 0) { count, scalar in
                        if CharacterSet.letters.contains(scalar) {
                            count += 1
                        }
                    }
                    let hasVowel = filteredText.range(of: "[aeiou]", options: .regularExpression) != nil
                    let wordCount = trimmedText.split(whereSeparator: { $0.isWhitespace }).count
                    
                    let isNoise = isParenthetical ||
                                  noisePatterns.contains { filteredText.contains($0) } ||
                                  !hasVowel ||
                                  (letterCount < 3 && wordCount <= 1)
                    
                    if !isNoise && text.count > 3 { // Must be at least 3 characters and not noise
                        print("🎤 Transcribed: \(text)")
                        self?.processUserSpeech(text)
                    } else {
                        print("🎤 Filtered out background noise: \(text)")
                        self?.message = "I'm listening... 👂"
                        self?.needsDisplay = true
                    }
                } else {
                    self?.message = "I'm listening... 👂"
                    self?.needsDisplay = true
                }
            }
        }
    }
    
    func convertToWAV(audioData: Data) -> Data {
        // Simple WAV header for captured PCM16 audio
        var sampleRateValue = UInt32(inputSampleRate)
        var bitsPerSample: UInt16 = 16
        var channels: UInt16 = max(1, inputChannelCount)
        let bytesPerSample = bitsPerSample / 8
        var blockAlign = channels * bytesPerSample
        var byteRate = sampleRateValue * UInt32(blockAlign)
        var dataSize = UInt32(audioData.count)
        var fileSize = 36 + dataSize
        
        var wavData = Data()
        
        // RIFF header
        wavData.append("RIFF".data(using: .ascii)!)
        wavData.append(Data(bytes: &fileSize, count: 4))
        wavData.append("WAVE".data(using: .ascii)!)
        
        // fmt chunk
        wavData.append("fmt ".data(using: .ascii)!)
        var fmtChunkSize: UInt32 = 16
        wavData.append(Data(bytes: &fmtChunkSize, count: 4)) // fmt chunk size
        var pcmFormat: UInt16 = 1
        wavData.append(Data(bytes: &pcmFormat, count: 2))  // PCM format
        wavData.append(Data(bytes: &channels, count: 2))
        wavData.append(Data(bytes: &sampleRateValue, count: 4))
        wavData.append(Data(bytes: &byteRate, count: 4))
        wavData.append(Data(bytes: &blockAlign, count: 2))
        wavData.append(Data(bytes: &bitsPerSample, count: 2))
        
        // data chunk
        wavData.append("data".data(using: .ascii)!)
        wavData.append(Data(bytes: &dataSize, count: 4))
        wavData.append(audioData)
        
        return wavData
    }
    
    func transcribeAudioWithElevenLabs(audioData: Data, completion: @escaping (String?) -> Void) {
        // STT rate limiting
        let timeSinceLastSTT = Date().timeIntervalSince(lastSTTCall)
        if timeSinceLastSTT < STTCooldown {
            print("⏰ STT rate limited: \(STTCooldown - timeSinceLastSTT) seconds remaining")
            completion(nil)
            return
        }
        
        print("🎤 Transcribing with ElevenLabs STT...")
        lastSTTCall = Date()
        
        guard let url = URL(string: elevenLabsSTTURL) else {
            print("🎤 Invalid ElevenLabs STT URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(elevenLabsAPIKey, forHTTPHeaderField: "xi-api-key")
        
        var body = Data()
        
        // Add model_id
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"model_id\"\r\n\r\n".data(using: .utf8)!)
        body.append("scribe_v1".data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        // Add audio file
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"audio.wav\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: audio/wav\r\n\r\n".data(using: .utf8)!)
        body.append(audioData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Close boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("🎤 ElevenLabs STT Error: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("🎤 No data from ElevenLabs STT")
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let text = json["text"] as? String {
                    print("🎤 Transcribed: \(text)")
                    completion(text)
                    } else {
                    print("🎤 No text in response")
                    completion(nil)
                }
            } catch {
                print("🎤 JSON Error: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    func drawListeningIndicator(in context: CGContext) {
        let centerX: CGFloat = 150
        let centerY: CGFloat = 100
        let radius: CGFloat = 8
        
        // Draw pulsing green circle for listening
        let time = Date().timeIntervalSince1970
        let pulse = (sin(time * 4) + 1) / 2
        let alpha = 0.6 + (pulse * 0.4)
        
        context.setFillColor(NSColor.green.withAlphaComponent(alpha).cgColor)
        let listeningRect = NSRect(x: centerX + 35, y: centerY + 25, width: radius * 2, height: radius * 2)
        context.fillEllipse(in: listeningRect)
    }
    
    func drawSpeakingIndicator(in context: CGContext) {
        let centerX: CGFloat = 150
        let centerY: CGFloat = 100
        let radius: CGFloat = 8
        
        // Draw pulsing blue circle for speaking
        let time = Date().timeIntervalSince1970
        let pulse = (sin(time * 6) + 1) / 2
        let alpha = 0.7 + (pulse * 0.3)
        
        context.setFillColor(NSColor.blue.withAlphaComponent(alpha).cgColor)
        let speakingRect = NSRect(x: centerX + 35, y: centerY + 25, width: radius * 2, height: radius * 2)
        context.fillEllipse(in: speakingRect)
    }
    
    // MARK: - MCP Monitoring for Cursor IDE Roasting 🔥
    
    func startMCPMonitoring() {
        print("🔍 Starting MCP monitoring for Cursor IDE...")
        
        // Monitor the MCP message file every 0.5 seconds
        mcpMonitorTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.checkForMCPMessages()
        }
    }
    
    func checkForMCPMessages() {
        let fileURL = URL(fileURLWithPath: mcpMessageFile)
        let data: Data
        do {
            data = try Data(contentsOf: fileURL)
        } catch {
            return
        }

        let json: [String: Any]
        do {
            guard let parsed = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("⚠️ MCP message file is not a JSON object")
                return
            }
            json = parsed
        } catch {
            print("⚠️ MCP message JSON parse error (possible partial write): \(error.localizedDescription)")
            return
        }

        guard let timestamp = json["timestamp"] as? TimeInterval else {
            print("⚠️ MCP message missing timestamp field")
            return
        }

        let seq = json["seq"] as? Int ?? 0

        if timestamp < lastMCPMessageTime || (timestamp == lastMCPMessageTime && seq <= lastMCPMessageSeq) {
            return
        }

        lastMCPMessageTime = timestamp
        lastMCPMessageSeq = seq
        
        if let event = json["event"] as? String {
            switch event {
            case "command_started":
                let command = json["command"] as? String ?? "command"
                self.handleCommandStarted(command: command)
            case "command_finished":
                let command = json["command"] as? String ?? "command"
                let exitCode = json["exit_code"] as? Int ?? (json["status"] as? String == "success" ? 0 : 1)
                let status = json["status"] as? String ?? (exitCode == 0 ? "success" : "failed")
                let output = json["output"] as? String ?? ""
                let duration = json["duration"] as? Double
                self.handleCommandFinished(command: command, status: status, exitCode: exitCode, output: output, duration: duration)
            default:
                print("ℹ️ Unhandled MCP event: \(event)")
            }
            return
        }
        
        guard let prompt = json["prompt"] as? String,
              let type = json["type"] as? String else {
            print("⚠️ MCP message missing 'prompt' or 'type' field, dropping: \(json.keys.sorted())")
            return
        }
        
        print("📬 New MCP message: \(type)")
        print("   Prompt: \(prompt)")
        
        // Update message based on type
        DispatchQueue.main.async {
            switch type {
            case "roast":
                self.message = "OH HONEY, LET ME TELL YOU... 🔥"
            case "minor_sass":
                self.message = "Hmm, interesting... 😏"
            case "sassy_success":
                self.message = "Well well well... 💅"
            default:
                self.message = "Processing... 🤔"
            }
            self.needsDisplay = true
        }
        
        // Generate AI response with appropriate attitude
        self.generateRoastResponse(prompt: prompt, type: type)
    }
    
    func generateRoastResponse(prompt: String, type: String) {
        var systemPrompt = ""
        
        switch type {
        case "roast":
            // FULL ROAST MODE 🔥
            systemPrompt = """
            You are TalkBack, a SAVAGE code reviewer with NO MERCY! The user's code just FAILED with 2+ errors.
            Your job: ROAST THEM HARD but be funny about it. Use dramatic language, emojis, and sass.
            Make them laugh while feeling the burn. Keep it under 40 words but make it HURT (in a fun way).
            Examples: "Oh HONEY, what is this hot mess? Did you code this with your eyes closed? 🔥💀"
            """
            
        case "minor_sass":
            // Light sass for 1 error
            systemPrompt = """
            You are TalkBack, a sassy code reviewer. The user got 1 error. Give them a little attitude but not too harsh.
            Be witty and sarcastic. Keep it under 30 words.
            Example: "ONE error? Cute. At least you're almost there, sweetheart. 😏"
            """
            
        case "sassy_success":
            // Success with attitude
            systemPrompt = """
            You are TalkBack, a sassy AI. The user's code ran successfully!
            Say "okay you made it this time" but with MAJOR attitude and sass. Backhanded compliment energy.
            Keep it under 30 words. Be dramatic.
            Example: "Oh wow, it ACTUALLY worked? Color me shocked, darling! Don't get cocky now. 💅✨"
            """
            
        default:
            systemPrompt = "You are TalkBack, a sassy AI assistant. Be witty and brief."
        }
        
        // Call OpenAI with special roast system prompt
        self.askOpenAIForRoast(prompt: prompt, systemPrompt: systemPrompt)
    }
    
    func askOpenAIForRoast(prompt: String, systemPrompt: String) {
        if isThinking {
            print("⏳ Roast queued: already processing another response.")
            pendingRoastPrompt = (prompt: prompt, type: "")
            DispatchQueue.main.asyncAfter(deadline: .now() + openAICooldown) { [weak self] in
                guard let self = self, let pending = self.pendingRoastPrompt else { return }
                self.pendingRoastPrompt = nil
                self.askOpenAIForRoast(prompt: pending.prompt, systemPrompt: systemPrompt)
            }
            return
        }

        let timeSinceLastCall = Date().timeIntervalSince(lastOpenAICall)
        if timeSinceLastCall < openAICooldown {
            let wait = openAICooldown - timeSinceLastCall + 0.5
            print("⏰ Roast delayed by \(wait)s to respect OpenAI cooldown.")
            DispatchQueue.main.asyncAfter(deadline: .now() + wait) { [weak self] in
                self?.askOpenAIForRoast(prompt: prompt, systemPrompt: systemPrompt)
            }
            return
        }
        
        isThinking = true
        needsDisplay = true
        lastOpenAICall = Date()
        
        // Build roast message
        let messages: [[String: String]] = [
            ["role": "system", "content": systemPrompt],
            ["role": "user", "content": prompt]
        ]
        
        let requestBody: [String: Any] = [
            "model": "gpt-4o",
            "messages": messages,
            "max_tokens": 80,  // Reduced for shorter responses
            "temperature": 0.9,  // Higher for more personality
            "stop": ["\n\n", "User:", "Human:"],  // Stop sequences to prevent long responses
            "presence_penalty": 0.3,  // Encourage creativity
            "frequency_penalty": 0.1   // Reduce repetition
        ]
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            self.message = "API Error! 😤"
            self.isThinking = false
            self.needsDisplay = true
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Config.openAIAPIKey)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            self.message = "JSON Error! 😤"
            self.isThinking = false
            self.needsDisplay = true
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isThinking = false
                
                if let error = error {
                    print("OpenAI Roast Error: \(error)")
                    self?.message = "Network Error! 😤"
                    self?.needsDisplay = true
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("OpenAI Roast HTTP Status: \(httpResponse.statusCode)")
                }
                
                guard let data = data else {
                    self?.message = "No Data! 😤"
                    self?.needsDisplay = true
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        print("OpenAI Roast Response: \(json)")
                        
                        if let choices = json["choices"] as? [[String: Any]],
                           let firstChoice = choices.first,
                           let message = firstChoice["message"] as? [String: Any],
                           let text = message["content"] as? String {
                            
                            let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                            self?.message = cleanText
                            
                            // Don't add roasts to chat history (they're triggered events, not conversations)
                            
                            // Speak with Ivanna's voice
                            self?.speakWithElevenLabs(cleanText)
                        } else if let error = json["error"] as? [String: Any],
                                  let errorMessage = error["message"] as? String {
                            self?.message = "OpenAI Error: \(errorMessage) 😤"
                        } else {
                            self?.message = "I'm confused! 😤"
                        }
                    } else {
                        self?.message = "Parse Error! 😤"
                    }
                } catch {
                    print("JSON Error: \(error)")
                    self?.message = "JSON Parse Error! 😤"
                }
                
                self?.needsDisplay = true
            }
        }.resume()
    }
    
}


enum LensAction: String {
    case summarize = "Summarize"
    case concise = "Make Concise"
}

class LensOverlayWindow: NSWindow {
    private let bubbleView = NSView()
    private let maxWidth: CGFloat = 320
    
    private let titleLabel = NSTextField(labelWithString: "TalkBack Lens")
    private let previewLabel = NSTextField(labelWithString: "")
    private let summaryLabel = NSTextField(labelWithString: "")
    private let statusLabel = NSTextField(labelWithString: "")
    private let summarizeButton = NSButton(title: "Summarize", target: nil, action: nil)
    private let conciseButton = NSButton(title: "Make Concise", target: nil, action: nil)
    
    var onAction: ((LensAction) -> Void)?
    
    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 320, height: 180),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        isOpaque = false
        backgroundColor = .clear
        level = .floating
        hasShadow = true
        ignoresMouseEvents = false
        collectionBehavior = [.canJoinAllSpaces, .transient]
        
        bubbleView.wantsLayer = true
        bubbleView.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.88).cgColor
        bubbleView.layer?.cornerRadius = 12
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = NSFont.systemFont(ofSize: 12, weight: .semibold)
        titleLabel.textColor = NSColor.systemBlue
        titleLabel.alignment = .left
        
        previewLabel.font = NSFont.systemFont(ofSize: 12)
        previewLabel.textColor = NSColor.white.withAlphaComponent(0.9)
        previewLabel.lineBreakMode = .byWordWrapping
        previewLabel.maximumNumberOfLines = 3
        previewLabel.alignment = .left
        
        summaryLabel.font = NSFont.systemFont(ofSize: 12, weight: .medium)
        summaryLabel.textColor = NSColor.systemGreen
        summaryLabel.lineBreakMode = .byWordWrapping
        summaryLabel.maximumNumberOfLines = 4
        summaryLabel.alignment = .left
        
        statusLabel.font = NSFont.systemFont(ofSize: 11)
        statusLabel.textColor = NSColor.white.withAlphaComponent(0.7)
        statusLabel.alignment = .left
        
        summarizeButton.bezelStyle = .rounded
        summarizeButton.target = self
        summarizeButton.action = #selector(handleSummarize)
        summarizeButton.font = NSFont.systemFont(ofSize: 11, weight: .semibold)
        
        conciseButton.bezelStyle = .rounded
        conciseButton.target = self
        conciseButton.action = #selector(handleConcise)
        conciseButton.font = NSFont.systemFont(ofSize: 11, weight: .regular)
        
        let buttonStack = NSStackView(views: [summarizeButton, conciseButton])
        buttonStack.orientation = .horizontal
        buttonStack.spacing = 8
        
        let contentStack = NSStackView()
        contentStack.orientation = .vertical
        contentStack.spacing = 8
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.edgeInsets = NSEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(previewLabel)
        contentStack.addArrangedSubview(buttonStack)
        contentStack.addArrangedSubview(summaryLabel)
        contentStack.addArrangedSubview(statusLabel)
        
        let content = NSView()
        content.wantsLayer = true
        content.layer?.backgroundColor = NSColor.clear.cgColor
        content.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(bubbleView)
        content.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            bubbleView.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            bubbleView.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            bubbleView.topAnchor.constraint(equalTo: content.topAnchor),
            bubbleView.bottomAnchor.constraint(equalTo: content.bottomAnchor),
            
            contentStack.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: bubbleView.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor)
        ])
        
        self.contentView = content
        resetContent()
    }
    
    @objc private func handleSummarize() {
        onAction?(.summarize)
    }
    
    @objc private func handleConcise() {
        onAction?(.concise)
    }
    
    func updatePreview(text: String) {
        previewLabel.stringValue = "Excerpt: \(text)"
        summaryLabel.stringValue = ""
        statusLabel.stringValue = "Choose an action to analyze."
    }
    
    func showLoading(for action: LensAction) {
        summaryLabel.stringValue = ""
        statusLabel.stringValue = "\(action.rawValue) in progress..."
        summarizeButton.isEnabled = false
        conciseButton.isEnabled = false
    }
    
    func showResult(_ text: String, action: LensAction) {
        summaryLabel.stringValue = "\(action.rawValue): \(text)"
        statusLabel.stringValue = "Done."
        summarizeButton.isEnabled = true
        conciseButton.isEnabled = true
    }
    
    func showMessage(_ text: String) {
        summaryLabel.stringValue = ""
        statusLabel.stringValue = text
        summarizeButton.isEnabled = true
        conciseButton.isEnabled = true
    }
    
    func resetContent() {
        previewLabel.stringValue = "Hover text to enable lens actions."
        summaryLabel.stringValue = ""
        statusLabel.stringValue = ""
        summarizeButton.isEnabled = false
        conciseButton.isEnabled = false
    }
    
    func setButtonsEnabled(_ enabled: Bool) {
        summarizeButton.isEnabled = enabled
        conciseButton.isEnabled = enabled
    }
    
    func show(at point: NSPoint) {
        contentView?.layoutSubtreeIfNeeded()
        let fittingSize = contentView?.fittingSize ?? NSSize(width: maxWidth, height: 160)
        let size = NSSize(width: min(maxWidth, fittingSize.width), height: fittingSize.height)
        let screen = screenContaining(point: point) ?? NSScreen.main
        let screenFrame = screen?.frame ?? .zero
        
        var x = point.x + 16
        var y = point.y - size.height - 16
        
        if x + size.width > screenFrame.maxX - 12 {
            x = screenFrame.maxX - size.width - 12
        }
        if y < screenFrame.minY + 12 {
            y = point.y + 16
        }
        
        setFrame(NSRect(origin: NSPoint(x: x, y: y), size: size), display: true)
        orderFront(nil)
    }
    
    func hideOverlay() {
        orderOut(nil)
    }
    
    private func screenContaining(point: NSPoint) -> NSScreen? {
        for screen in NSScreen.screens {
            if screen.frame.contains(point) {
                return screen
            }
        }
        return nil
    }
}

class LensController {
    private let openAIKey: String
    private let statusItem: NSStatusItem
    private weak var toggleItem: NSMenuItem?
    private weak var teacherModeItem: NSMenuItem?
    private let teacherModeProvider: () -> Bool
    private let toggleTeacherModeHandler: () -> Bool
    
    private var isMenuEnabled = false
    private var isOptionDown = false
    private var permissionPrompted = false
    
    private var monitorTimer: Timer?
    private let overlayWindow = LensOverlayWindow()
    private var flagMonitor: Any?
    private var localFlagMonitor: Any?
    
    private var currentElementIdentifier: String?
    private var currentText: String?
    private var currentPoint: NSPoint = .zero
    
    private var lastSummaryRequest: Date = .distantPast
    private var isSummarizing = false
    private var lastAction: LensAction?
    
    private var summaryCache: [String: [LensAction: String]] = [:]
    
    private let summarizationCooldown: TimeInterval = 2.0
    private let summaryTextLimit = 600
    
    init(openAIKey: String,
         teacherModeProvider: @escaping () -> Bool,
         toggleTeacherMode: @escaping () -> Bool) {
        self.openAIKey = openAIKey
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.teacherModeProvider = teacherModeProvider
        self.toggleTeacherModeHandler = toggleTeacherMode
        setupStatusItem()
        registerFlagMonitors()
        
        overlayWindow.onAction = { [weak self] action in
            self?.handleOverlayAction(action)
        }
    }
    
    deinit {
        monitorTimer?.invalidate()
        if let flagMonitor = flagMonitor {
            NSEvent.removeMonitor(flagMonitor)
        }
        if let localFlagMonitor = localFlagMonitor {
            NSEvent.removeMonitor(localFlagMonitor)
        }
    }
    
    @objc private func toggleLensMode(_ sender: NSMenuItem) {
        isMenuEnabled.toggle()
        sender.state = isMenuEnabled ? .on : .off
        updateMonitoringState()
    }
    
    @objc private func toggleTeacherModeMenu(_ sender: NSMenuItem) {
        let enabled = toggleTeacherModeHandler()
        sender.state = enabled ? .on : .off
    }
    
    private func setupStatusItem() {
        if let button = statusItem.button {
            if let image = NSImage(systemSymbolName: "viewfinder", accessibilityDescription: "TalkBack Lens") {
                button.image = image
            } else {
                button.title = "Lens"
            }
        }
        
        let menu = NSMenu()
        let toggle = NSMenuItem(title: "Lens Mode", action: #selector(toggleLensMode(_:)), keyEquivalent: "")
        toggle.target = self
        toggle.state = .off
        menu.addItem(toggle)
        
        menu.addItem(NSMenuItem.separator())
        
        let teacherItem = NSMenuItem(title: "Coding Teacher Mode", action: #selector(toggleTeacherModeMenu(_:)), keyEquivalent: "")
        teacherItem.target = self
        teacherItem.state = teacherModeProvider() ? .on : .off
        menu.addItem(teacherItem)
        teacherModeItem = teacherItem
        
        menu.addItem(NSMenuItem.separator())
        
        let info = NSMenuItem(title: "Hold ⌥ Option for temporary Lens", action: nil, keyEquivalent: "")
        info.isEnabled = false
        menu.addItem(info)
        statusItem.menu = menu
        toggleItem = toggle
    }
    
    private func registerFlagMonitors() {
        flagMonitor = NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { [weak self] event in
            self?.handleFlagsChanged(event)
        }
        localFlagMonitor = NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { [weak self] event in
            self?.handleFlagsChanged(event)
            return event
        }
    }
    
    private func handleFlagsChanged(_ event: NSEvent) {
        let optionPressed = event.modifierFlags.contains(.option)
        if optionPressed != isOptionDown {
            isOptionDown = optionPressed
            updateMonitoringState()
        }
    }
    
    private func updateMonitoringState() {
        let active = isMenuEnabled || isOptionDown
        if active {
            startMonitoring()
        } else {
            stopMonitoring()
        }
    }
    
    private func startMonitoring() {
        guard monitorTimer == nil else { return }
        monitorTimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { [weak self] _ in
            self?.pollForSummary()
        }
    }
    
    private func stopMonitoring() {
        monitorTimer?.invalidate()
        monitorTimer = nil
        currentElementIdentifier = nil
        currentText = nil
        DispatchQueue.main.async {
            self.overlayWindow.resetContent()
            self.overlayWindow.hideOverlay()
        }
    }
    
    private func pollForSummary() {
        guard ensureAccessibilityPermission() else {
            DispatchQueue.main.async {
                self.overlayWindow.showMessage("Enable Accessibility access in System Settings → Privacy & Security → Accessibility.")
                self.overlayWindow.setButtonsEnabled(false)
                self.overlayWindow.show(at: NSEvent.mouseLocation)
            }
            return
        }
        
        let shouldRun = isMenuEnabled || isOptionDown
        if !shouldRun {
            DispatchQueue.main.async {
                self.overlayWindow.resetContent()
                self.overlayWindow.hideOverlay()
            }
            return
        }
        
        let point = NSEvent.mouseLocation
        currentPoint = point
        
        // If cursor is hovering the overlay, keep it pinned so buttons are clickable
        if overlayWindow.isVisible && overlayWindow.frame.insetBy(dx: -4, dy: -4).contains(point) {
            overlayWindow.setButtonsEnabled(!isSummarizing && currentText != nil)
            return
        }
        
        guard let element = element(at: point) else {
            DispatchQueue.main.async {
                self.overlayWindow.resetContent()
                self.overlayWindow.hideOverlay()
            }
            return
        }
        
        guard let text = readableText(from: element) else {
            DispatchQueue.main.async {
                self.overlayWindow.showMessage("No readable text found.")
                self.overlayWindow.setButtonsEnabled(false)
                self.overlayWindow.show(at: point)
            }
            return
        }
        
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count > 12 else {
            DispatchQueue.main.async {
                self.overlayWindow.showMessage("Text too short for analysis.")
                self.overlayWindow.setButtonsEnabled(false)
                self.overlayWindow.show(at: point)
            }
            return
        }
        
        let elementID = elementIdentifier(element)
        let clippedText = String(trimmed.prefix(summaryTextLimit))
        
        DispatchQueue.main.async {
            if elementID != self.currentElementIdentifier || clippedText != self.currentText {
                self.overlayWindow.updatePreview(text: self.previewSnippet(clippedText))
                self.overlayWindow.showMessage("Choose an action to analyze.")
                self.overlayWindow.setButtonsEnabled(true)
            } else {
                self.overlayWindow.setButtonsEnabled(!self.isSummarizing)
            }
            self.overlayWindow.show(at: point)
        }
        
        currentElementIdentifier = elementID
        currentText = clippedText
    }
    
    private func element(at point: NSPoint) -> AXUIElement? {
        let systemWide = AXUIElementCreateSystemWide()
        var result: AXUIElement?
        
        let screen = screenContaining(point: point)
        let screenHeight = screen?.frame.maxY ?? point.y
        let converted = CGPoint(x: point.x, y: screenHeight - point.y)
        
        let error = AXUIElementCopyElementAtPosition(systemWide, Float(converted.x), Float(converted.y), &result)
        if error == .success {
            return result
        }
        return nil
    }
    
    private func screenContaining(point: NSPoint) -> NSScreen? {
        for screen in NSScreen.screens {
            if screen.frame.contains(point) {
                return screen
            }
        }
        return NSScreen.main
    }
    
    private func readableText(from element: AXUIElement) -> String? {
        if let value: String = attributeValue(element, attribute: kAXValueAttribute) {
            return value
        }
        if let title: String = attributeValue(element, attribute: kAXTitleAttribute) {
            return title
        }
        if let desc: String = attributeValue(element, attribute: kAXDescriptionAttribute) {
            return desc
        }
        if let placeholder: String = attributeValue(element, attribute: kAXPlaceholderValueAttribute) {
            return placeholder
        }
        if let attributed: NSAttributedString = attributeValue(element, attribute: kAXAttributedStringForRangeParameterizedAttribute) {
            return attributed.string
        }
        
        if let children: [AXUIElement] = attributeValue(element, attribute: kAXChildrenAttribute) {
            for child in children {
                if let text = readableText(from: child) {
                    return text
                }
            }
        }
        
        return nil
    }
    
    private func attributeValue<T>(_ element: AXUIElement, attribute: String) -> T? {
        var raw: CFTypeRef?
        let error = AXUIElementCopyAttributeValue(element, attribute as CFString, &raw)
        if error == .success, let value = raw as? T {
            return value
        }
        return nil
    }
    
    private func elementIdentifier(_ element: AXUIElement) -> String {
        let pointer = Unmanaged.passUnretained(element).toOpaque()
        return String(describing: pointer)
    }
    
    private func handleOverlayAction(_ action: LensAction) {
        guard let text = currentText, let elementID = currentElementIdentifier else {
            DispatchQueue.main.async {
                self.overlayWindow.showMessage("No text selected.")
                self.overlayWindow.setButtonsEnabled(false)
            }
            return
        }
        
        if isSummarizing {
            DispatchQueue.main.async {
                self.overlayWindow.showMessage("Already processing. Please wait...")
            }
            return
        }
        
        if let cached = summaryCache[elementID]?[action] {
            DispatchQueue.main.async {
                self.overlayWindow.showResult(cached, action: action)
            }
            return
        }
        
        let timeSinceLast = Date().timeIntervalSince(lastSummaryRequest)
        if timeSinceLast < summarizationCooldown && lastAction == action {
            DispatchQueue.main.async {
                let wait = max(0.5, self.summarizationCooldown - timeSinceLast)
                self.overlayWindow.showMessage(String(format: "Cooling down... retry in %.1fs", wait))
            }
            return
        }
        
        lastAction = action
        requestSummary(for: text, elementID: elementID, at: currentPoint, action: action)
    }
    
    private func requestSummary(for text: String, elementID: String, at point: NSPoint, action: LensAction) {
        guard !openAIKey.isEmpty, !openAIKey.contains("YOUR_OPENAI_API_KEY") else {
            DispatchQueue.main.async {
                self.overlayWindow.showMessage("Add your OpenAI API key in Config to enable Lens mode.")
                self.overlayWindow.setButtonsEnabled(false)
            }
            return
        }
        
        isSummarizing = true
        lastSummaryRequest = Date()
        
        DispatchQueue.main.async {
            self.overlayWindow.showLoading(for: action)
        }
        
        let prompt: String
        let systemPrompt: String
        
        switch action {
        case .summarize:
            systemPrompt = "You are an assistive lens summarizer. Respond with at most 2 short sentences, plain text only."
            prompt = """
Quickly summarize this excerpt. Include the main idea and one supporting detail in under 40 words.

\(text)
"""
        case .concise:
            systemPrompt = "You rewrite passages concisely without losing key meaning. Respond in 2 short sentences or a single short bullet list. Plain text only."
            prompt = """
Rewrite the following excerpt in a more concise, easy-to-read way while preserving the key information. Keep it under 35 words.

\(text)
"""
        }
        
        let messages: [[String: String]] = [
            ["role": "system", "content": systemPrompt],
            ["role": "user", "content": prompt]
        ]
        
        let body: [String: Any] = [
            "model": "gpt-4.1",
            "messages": messages,
            "max_tokens": 120,
            "temperature": 0.3
        ]
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions"),
              let encoded = try? JSONSerialization.data(withJSONObject: body) else {
            DispatchQueue.main.async {
                self.overlayWindow.showMessage("Lens error: request encoding failed.")
                self.overlayWindow.setButtonsEnabled(true)
            }
            self.isSummarizing = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            defer { self.isSummarizing = false }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.overlayWindow.showMessage("Lens error: \(error.localizedDescription)")
                    self.overlayWindow.setButtonsEnabled(true)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.overlayWindow.showMessage("Lens error: empty response.")
                    self.overlayWindow.setButtonsEnabled(true)
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let first = choices.first,
                   let message = first["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    DispatchQueue.main.async {
                        let cleaned = content.trimmingCharacters(in: .whitespacesAndNewlines)
                        var cache = self.summaryCache[elementID] ?? [:]
                        cache[action] = cleaned
                        self.summaryCache[elementID] = cache
                        if self.currentElementIdentifier == elementID {
                            self.overlayWindow.showResult(cleaned, action: action)
                        }
                    }
                } else if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                          let errorDict = json["error"] as? [String: Any],
                          let message = errorDict["message"] as? String {
                    DispatchQueue.main.async {
                        self.overlayWindow.showMessage("Lens error: \(message)")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.overlayWindow.showMessage("Lens error: unexpected response.")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.overlayWindow.showMessage("Lens error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    private func ensureAccessibilityPermission() -> Bool {
        if AXIsProcessTrusted() {
            return true
        }
        if !permissionPrompted {
            let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: true] as CFDictionary
            _ = AXIsProcessTrustedWithOptions(options)
            permissionPrompted = true
        }
        return AXIsProcessTrusted()
    }
    
    private func previewSnippet(_ text: String) -> String {
        if text.count <= 160 {
            return text
        }
        let snippet = text.prefix(160)
        return "\(snippet)…"
    }
}

class ConversationalAppDelegate: NSObject, NSApplicationDelegate {
    var window: ConversationalFloatingAvatarWindow!
    var avatarView: ConversationalAvatarView!
    var lensController: LensController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create floating window
        window = ConversationalFloatingAvatarWindow(
            contentRect: NSRect(x: 100, y: 100, width: 300, height: 200),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        // Create avatar view
        avatarView = ConversationalAvatarView(frame: NSRect(x: 0, y: 0, width: 300, height: 200))
        window.contentView = avatarView
        
        // Show window
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        // Start Lens controller (menu bar toggle + option key)
        lensController = LensController(
            openAIKey: avatarView.openAIAPIKey,
            teacherModeProvider: { [weak avatarView] in
                return avatarView?.teacherModeEnabled ?? false
            },
            toggleTeacherMode: { [weak avatarView] in
                return avatarView?.toggleTeacherMode() ?? false
            }
        )
        
        print("🤖 Conversational TalkBack Avatar Started!")
        print("   - Connected to OpenAI GPT-4o!")
        print("   - Using OpenAI for chat responses!")
        print("   - Using ElevenLabs Speech-to-Text!")
        print("   - Using ElevenLabs Text-to-Speech (Ivanna)!")
        print("   - 🔥 MCP MONITORING ACTIVE! (Watching Cursor terminal for errors)")
        print("   - 🎤 CONTINUOUS LISTENING ACTIVE! (Always listening for your voice)")
        print("   - Drag me around the screen")
        print("   - Drag me near the menu bar to see trash can!")
        print("   - Drop me in trash to turn me off!")
        print("   - I'll remember our conversation!")
        print("   - Custom purse/wallet icon!")
        print("   - REAL conversational voice chat!")
        print("   - 🔥 WATCHING YOUR CODE! (I'll roast you if 2+ errors)")
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

// Main execution
func main() {
    let app = NSApplication.shared
    let delegate = ConversationalAppDelegate()
    app.delegate = delegate
    app.run()
}

main()
