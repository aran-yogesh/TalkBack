import Cocoa
import AppKit
import Foundation
import AVFoundation

// 🔐 API Keys Configuration
// Load from config.swift if available, otherwise use placeholders
struct Config {
    static let geminiAPIKey = "YOUR_GEMINI_API_KEY_HERE"
    static let openAIAPIKey = "YOUR_OPENAI_API_KEY_HERE"
    static let elevenLabsAPIKey = "YOUR_ELEVENLABS_API_KEY_HERE"
    static let elevenLabsVoiceID = "cgSgspJ2msm6clMCkdW9" // Ivanna
}

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

class ConversationalAvatarView: NSView {
    var message = "Click and hold to talk! 🎤"
    var eyeOffset: NSPoint = NSPoint(x: 0, y: 0)
    var isThinking = false
    var isListening = false
    var isRecording = false
    var lastActivity = Date()
    var speechSynthesizer = AVSpeechSynthesizer()
    var chatHistory: [[String: String]] = []
    var trashCanVisible = false
    var isBeingDragged = false
    var dragStartPoint: NSPoint = NSPoint.zero
    
    // Bouncing motion (zigzag pattern)
    var isFloating = true
    var floatingTimer: Timer?
    var velocityX: CGFloat = 1.0  // Reduced from 2.0
    var velocityY: CGFloat = 0.8  // Reduced from 1.5
    var zigzagOffset: CGFloat = 0.0
    var zigzagDirection: CGFloat = 1.0
    var lastInteractionTime: Date?
    
    // Audio recording
    var audioRecorder: AVAudioRecorder?
    var recordingURL: URL?
    
    // Gemini Vision (Background Monitoring)
    var captureSession: AVCaptureSession?
    var videoOutput: AVCaptureVideoDataOutput?
    var latestCameraImage: NSImage?
    var visionAnalysisTimer: Timer?
    var lastVisionAnalysis: Date?
    var cameraFrameCount: Int = 0
    
    // MCP monitoring for Cursor IDE roasting 🔥
    var mcpMonitorTimer: Timer?
    var lastMCPMessageTime: TimeInterval = 0
    let mcpMessageFile = "/tmp/talkback_message.json"
    
    // APIs - Loaded from config.swift (gitignored)
    let geminiAPIKey = Config.geminiAPIKey
    var geminiAPIURL: String {
        return "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=\(geminiAPIKey)"
    }
    
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
        
        // Start Gemini vision monitoring (background behavior detection)
        self.setupCamera()
        self.startVisionMonitoring()
        
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
        
        // Start recording audio
        if !isRecording {
            startRecording()
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        if !isBeingDragged { return }
        
        // Stop recording if dragging
        if isRecording {
            stopRecording()
        }
        
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
            message = "Click and hold to talk! 🎤"
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
            // Stop recording and process
            if isRecording {
                stopRecording()
            }
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
    
    func startRecording() {
        print("🎤 Starting recording...")
        
        // Stop floating while recording
        isFloating = false
        lastInteractionTime = Date()
        
        isRecording = true
        isListening = true
        message = "Recording... Speak now! 🎤"
        needsDisplay = true
        
        // Create recording URL (WAV file)
        let tempDir = FileManager.default.temporaryDirectory
        recordingURL = tempDir.appendingPathComponent("talkback_recording.wav")
        
        // Set up audio recording (WAV format for better ElevenLabs STT compatibility)
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 16000.0,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL!, settings: settings)
            audioRecorder?.record()
            print("🎤 Recording started successfully")
        } catch {
            print("🎤 Recording error: \(error)")
            message = "Recording error! 😤"
            isRecording = false
            isListening = false
            needsDisplay = true
        }
    }
    
    func stopRecording() {
        print("🎤 Stopping recording...")
        isRecording = false
        isListening = false
        message = "Processing your speech... 🤔"
        needsDisplay = true
        
        audioRecorder?.stop()
        
        // Resume floating after 5 seconds
        resumeFloatingAfterDelay()
        
        // Send to ElevenLabs Speech-to-Text
        if let audioURL = recordingURL {
            transcribeAudio(audioURL: audioURL)
        }
    }
    
    func transcribeAudio(audioURL: URL) {
        print("🎤 Transcribing audio with ElevenLabs...")
        
        guard let url = URL(string: elevenLabsSTTURL) else {
            print("🎤 Invalid ElevenLabs STT URL")
            message = "Speech recognition error! 😤"
            needsDisplay = true
            return
        }
        
        // Create multipart form data
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(elevenLabsAPIKey, forHTTPHeaderField: "xi-api-key")
        
        var body = Data()
        
        // Add model_id FIRST (required - use scribe_v1 for STT)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"model_id\"\r\n\r\n".data(using: .utf8)!)
        body.append("scribe_v1".data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        // Add audio file (parameter name must be "file")
        do {
            let audioData = try Data(contentsOf: audioURL)
            print("🎤 Audio file size: \(audioData.count) bytes")
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"recording.wav\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: audio/wav\r\n\r\n".data(using: .utf8)!)
            body.append(audioData)
            body.append("\r\n".data(using: .utf8)!)
        } catch {
            print("🎤 Error reading audio file: \(error)")
            message = "Audio read error! 😤"
            needsDisplay = true
            return
        }
        
        // Close boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("🎤 ElevenLabs STT Error: \(error)")
                    self?.message = "Speech recognition error! 😤"
                    self?.needsDisplay = true
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("🎤 ElevenLabs STT HTTP Status: \(httpResponse.statusCode)")
                }
                
                guard let data = data else {
                    print("🎤 No data from ElevenLabs STT")
                    self?.message = "No speech data! 😤"
                    self?.needsDisplay = true
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        print("🎤 ElevenLabs STT Response: \(json)")
                        
                        if let text = json["text"] as? String {
                            print("🎤 Transcribed text: \(text)")
                            self?.processUserSpeech(text)
                        } else {
                            print("🎤 No text in response")
                            self?.message = "Couldn't understand! 😤"
                            self?.needsDisplay = true
                        }
                    }
                } catch {
                    print("🎤 JSON Error: \(error)")
                    self?.message = "Parse error! 😤"
                    self?.needsDisplay = true
                }
            }
        }.resume()
    }
    
    func processUserSpeech(_ text: String) {
        print("💬 User said: \(text)")
        
        // Add user input to chat history
        chatHistory.append(["role": "user", "content": text])
        
        // Keep only last 10 messages
        if chatHistory.count > 10 {
            chatHistory.removeFirst()
        }
        
        // Check if user is asking about their screen
        let lowercasedText = text.lowercased()
        let screenQuestionTriggers = [
            "what am i watching",
            "what's on my screen",
            "what am i looking at",
            "what should i do",
            "what am i supposed to do",
            "what is this",
            "help me with this",
            "what's this"
        ]
        
        let isScreenQuestion = screenQuestionTriggers.contains { trigger in
            lowercasedText.contains(trigger)
        }
        
        if isScreenQuestion {
            // Take screenshot and analyze it
            print("📸 Taking screenshot to analyze what you're looking at...")
            takeScreenshotAndAnalyze(userQuestion: text)
        } else {
            // Normal conversation flow
            let historyContext = chatHistory.map { msg in
                "\(msg["role"]!): \(msg["content"]!)"
            }.joined(separator: "\n")
            
            let prompt = "User said: \(text)\n\nChat history:\n\(historyContext)\n\nYou're a floating AI balloon and the user just disturbed you while you were floating around. Respond SHORT and annoyed like 'Why'd you disturb me? I was flying!' Be sassy and dramatic but keep it under 2 sentences!"
            
            askOpenAI(prompt: prompt)
        }
    }
    
    func startActivityMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            self.checkUserActivity()
        }
    }
    
    func checkUserActivity() {
        let now = Date()
        let timeSinceLastActivity = now.timeIntervalSince(lastActivity)
        
        if timeSinceLastActivity > 60 {
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
    
    func askOpenAI(prompt: String) {
        guard !isThinking else { return }
        
        isThinking = true
        needsDisplay = true
        
        // Build conversation history in OpenAI format
        var messages: [[String: String]] = [
            ["role": "system", "content": "You are TalkBack, a sassy conversational AI companion. Keep responses SHORT (1-2 sentences max) with attitude and emojis. Be witty, sarcastic, and slightly passive-aggressive."]
        ]
        
        // Add chat history
        messages.append(contentsOf: chatHistory)
        
        // Add current user message
        messages.append(["role": "user", "content": prompt])
        
        let requestBody: [String: Any] = [
            "model": "gpt-4o",
            "messages": messages,
            "max_tokens": 150,
            "temperature": 0.9
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
    
    func speakWithElevenLabs(_ text: String) {
        print("🎤 Speaking with Ivanna's voice: \(text)")
        
        // Clean text (remove emojis)
        let cleanText = text.replacingOccurrences(of: "[\\p{So}\\p{Cn}]", with: "", options: .regularExpression)
        
        guard let url = URL(string: elevenLabsTTSURL) else {
            print("🎤 Invalid TTS URL")
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
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("🎤 TTS JSON error: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("🎤 ElevenLabs TTS Error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("🎤 ElevenLabs TTS HTTP Status: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("🎤 No audio data from ElevenLabs TTS")
                return
            }
            
            print("🎤 Received audio data: \(data.count) bytes")
            
            // Play the audio
            DispatchQueue.main.async {
                self.playAudioData(data)
            }
        }.resume()
    }
    
    func playAudioData(_ data: Data) {
        print("🎤 Playing audio with NSSound...")
        
        if let sound = NSSound(data: data) {
            sound.volume = 1.0
            if sound.play() {
                print("🎤 Audio playback started successfully!")
            } else {
                print("🎤 NSSound failed to play")
            }
        } else {
            print("🎤 NSSound couldn't create sound from data")
        }
    }
    
    // MARK: - Gemini Vision Monitoring (Background Behavior Detection)
    
    func setupCamera() {
        print("📷 Setting up camera for behavior monitoring...")
        
        // Check camera permission first
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        print("📷 Camera authorization status: \(cameraStatus.rawValue)")
        
        switch cameraStatus {
        case .authorized:
            print("✅ Camera permission granted")
            setupCameraSession()
        case .notDetermined:
            print("⚠️ Camera permission not determined, requesting...")
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        print("✅ Camera permission granted!")
                        self?.setupCameraSession()
                    } else {
                        print("❌ Camera permission denied!")
                    }
                }
            }
        case .denied, .restricted:
            print("❌ Camera permission denied or restricted!")
            print("💡 Please enable camera access in System Settings → Privacy & Security → Camera")
        @unknown default:
            print("❌ Unknown camera permission status")
        }
    }
    
    func setupCameraSession() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { 
            print("❌ Failed to create capture session")
            return 
        }
        
        captureSession.sessionPreset = .medium
        
        // Get front camera
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("❌ No front camera found!")
            return
        }
        
        print("📷 Found camera: \(camera.localizedName)")
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                print("✅ Camera input added")
            } else {
                print("❌ Cannot add camera input")
                return
            }
            
            videoOutput = AVCaptureVideoDataOutput()
            videoOutput?.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            
            if let videoOutput = videoOutput, captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
                print("✅ Video output added")
            } else {
                print("❌ Cannot add video output")
                return
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                captureSession.startRunning()
                print("✅ Camera session started!")
            }
            
        } catch {
            print("❌ Camera setup failed: \(error)")
        }
    }
    
    func startVisionMonitoring() {
        print("👁️ Starting vision monitoring...")
        
        // Analyze every 15 seconds (less frequent to not be annoying)
        visionAnalysisTimer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { [weak self] _ in
            self?.analyzeUserBehavior()
        }
        
        // First analysis after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            self?.analyzeUserBehavior()
        }
    }
    
    func analyzeUserBehavior() {
        print("🔍 analyzeUserBehavior() called at \(Date())")
        
        guard let image = latestCameraImage else {
            print("❌ No camera image available for analysis")
            return
        }
        
        print("📸 Camera image available: \(image.size)")
        
        // Don't interrupt if user is talking or listening
        if isRecording || isListening {
            print("⏸️ Skipping analysis - user is recording/listening")
            return
        }
        
        print("🔍 Analyzing your behavior...")
        
        // Convert image to base64
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let jpegData = bitmap.representation(using: .jpeg, properties: [.compressionFactor: 0.7]) else {
            print("❌ Failed to convert image to JPEG")
            return
        }
        
        let base64Image = jpegData.base64EncodedString()
        print("📸 Image converted to base64: \(base64Image.count) characters")
        
        // Gemini prompt for behavior analysis
        let prompt = """
        Analyze this person's behavior in 2-3 SHORT sentences:
        1. Are they looking at the screen or away? (gaze direction)
        2. What's their emotion? (happy, frustrated, focused, confused, neutral)
        3. Are they working seriously or distracted? (using phone, looking away, etc.)
        
        Be concise and direct. Example: "Person looking away from screen, appears distracted. Not focused on work."
        """
        
        // Gemini API request
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt],
                        [
                            "inline_data": [
                                "mime_type": "image/jpeg",
                                "data": base64Image
                            ]
                        ]
                    ]
                ]
            ],
            "generationConfig": [
                "temperature": 0.4,
                "maxOutputTokens": 100
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            return
        }
        
        var request = URLRequest(url: URL(string: geminiAPIURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("❌ Gemini API Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("❌ No data received from Gemini API")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("🌐 Gemini HTTP Status: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    print("❌ Gemini API returned error status: \(httpResponse.statusCode)")
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                    }
                    return
                }
            }
            
            print("📥 Received Gemini response: \(data.count) bytes")
            
            // Parse Gemini response
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("📋 Gemini JSON response: \(json)")
                    
                    if let candidates = json["candidates"] as? [[String: Any]],
                       let firstCandidate = candidates.first,
                       let content = firstCandidate["content"] as? [String: Any],
                       let parts = content["parts"] as? [[String: Any]],
                       let firstPart = parts.first,
                       let analysis = firstPart["text"] as? String {
                        
                        print("🎯 Gemini detected: \(analysis.trimmingCharacters(in: .whitespacesAndNewlines))")
                        
                        // Generate sassy response based on analysis
                        self?.generateSassyVisionResponse(from: analysis)
                    } else {
                        print("❌ Failed to parse Gemini response structure")
                        print("Available keys: \(json.keys)")
                    }
                }
            } catch {
                print("❌ Failed to parse Gemini JSON: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Raw response: \(responseString)")
                }
            }
        }
        
        task.resume()
    }
    
    func generateSassyVisionResponse(from analysis: String) {
        let lowercased = analysis.lowercased()
        var sassyMessage = ""
        
        // Looking away detection (HIGHEST PRIORITY)
        if lowercased.contains("looking away") || lowercased.contains("not looking at") || lowercased.contains("eyes are covered") {
            sassyMessage = "HEY! Where are you going? Look at the screen, I'm talking to you!"
        }
        // Phone usage detection
        else if lowercased.contains("phone") || lowercased.contains("mobile") {
            sassyMessage = "Seriously? TikTok is more important than me? Put that phone down!"
        }
        // Frustrated/stressed detection
        else if lowercased.contains("frustrated") || lowercased.contains("stressed") || lowercased.contains("angry") {
            sassyMessage = "Uh oh, someone's code isn't compiling... Want to vent?"
        }
        // Distracted detection
        else if lowercased.contains("distracted") || lowercased.contains("not focused") {
            sassyMessage = "You're distracted! Focus up, dummy!"
        }
        // Confused detection
        else if lowercased.contains("confused") || lowercased.contains("puzzled") {
            sassyMessage = "That confused look tells me you're reading Stack Overflow again!"
        }
        // Happy detection
        else if lowercased.contains("happy") || lowercased.contains("smiling") || lowercased.contains("smile") {
            sassyMessage = "Oh, so NOW you're happy? What did I miss?"
        }
        // Focused detection
        else if (lowercased.contains("focused") || lowercased.contains("concentrated")) && 
                 !lowercased.contains("not focused") {
            sassyMessage = "Whoa, look at Mr. Serious over here! What are you coding, rocket science?"
        }
        // Neutral/working state (random variety)
        else if lowercased.contains("neutral") && (lowercased.contains("working") || lowercased.contains("looking at")) {
            let neutralMessages = [
                "You look like you're plotting world domination. Or just debugging. Same thing.",
                "That blank stare... Are you thinking or buffering?",
                "Wow, such focus. Much coding. Very productive. Or are you just staring into the void?",
                "You okay there? You've got that 'my code broke and I don't know why' face."
            ]
            sassyMessage = neutralMessages.randomElement() ?? neutralMessages[0]
        }
        
        // Only speak if we have a sassy message
        if !sassyMessage.isEmpty {
            print("💬 Vision Roast: \(sassyMessage)")
            
            // Speak with Ivanna's voice (interrupt floating to deliver the roast!)
            DispatchQueue.main.async { [weak self] in
                self?.speakWithElevenLabs(sassyMessage)
            }
        }
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
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: mcpMessageFile)),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let timestamp = json["timestamp"] as? TimeInterval else {
            return
        }
        
        // Only process new messages
        if timestamp <= lastMCPMessageTime {
            return
        }
        
        lastMCPMessageTime = timestamp
        
        guard let prompt = json["prompt"] as? String,
              let type = json["type"] as? String else {
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
        guard !isThinking else { return }
        
        isThinking = true
        needsDisplay = true
        
        // Build roast message
        var messages: [[String: String]] = [
            ["role": "system", "content": systemPrompt],
            ["role": "user", "content": prompt]
        ]
        
        let requestBody: [String: Any] = [
            "model": "gpt-4o",
            "messages": messages,
            "max_tokens": 150,
            "temperature": 0.9
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
    
    // MARK: - Screenshot Analysis
    
    func takeScreenshotAndAnalyze(userQuestion: String) {
        print("📸 Capturing screenshot...")
        
        // Get main screen
        guard let screen = NSScreen.main else {
            print("⚠️ Couldn't access main screen")
            return
        }
        
        let screenRect = screen.frame
        
        // Create CGImage from screen
        guard let cgImage = CGDisplayCreateImage(CGMainDisplayID()) else {
            print("⚠️ Failed to capture screenshot")
            return
        }
        
        // Convert to NSImage then to JPEG data
        let screenshot = NSImage(cgImage: cgImage, size: screenRect.size)
        
        guard let tiffData = screenshot.tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffData),
              let jpegData = bitmapImage.representation(using: .jpeg, properties: [.compressionFactor: 0.7]) else {
            print("⚠️ Failed to convert screenshot to JPEG")
            return
        }
        
        // Convert to base64
        let base64Screenshot = jpegData.base64EncodedString()
        
        print("✅ Screenshot captured (\(jpegData.count) bytes)")
        
        // Send to Gemini for analysis
        analyzeScreenshot(imageBase64: base64Screenshot, userQuestion: userQuestion)
    }
    
    func analyzeScreenshot(imageBase64: String, userQuestion: String) {
        print("🔍 Analyzing screenshot with Gemini...")
        
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        [
                            "text": "The user is asking: '\(userQuestion)'. Look at their screen and give a SHORT, SASSY response about what they're looking at. Be helpful but with major attitude. Roast them a bit if they're doing something silly. Keep it under 2 sentences!"
                        ],
                        [
                            "inline_data": [
                                "mime_type": "image/jpeg",
                                "data": imageBase64
                            ]
                        ]
                    ]
                ]
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            return
        }
        
        var request = URLRequest(url: URL(string: geminiAPIURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("⚠️ Gemini screenshot analysis error: \(error?.localizedDescription ?? "unknown")")
                return
            }
            
            // Parse Gemini response
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let candidates = json["candidates"] as? [[String: Any]],
               let firstCandidate = candidates.first,
               let content = firstCandidate["content"] as? [String: Any],
               let parts = content["parts"] as? [[String: Any]],
               let firstPart = parts.first,
               let analysisText = firstPart["text"] as? String {
                
                print("🖼️ Gemini screen analysis: \(analysisText)")
                
                // Add to chat history
                DispatchQueue.main.async {
                    self?.chatHistory.append(["role": "assistant", "content": analysisText])
                    
                    // Speak the response
                    self?.speakWithElevenLabs(analysisText)
                }
            } else {
                print("⚠️ Failed to parse Gemini screenshot response")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Raw response: \(responseString)")
                }
            }
        }
        
        task.resume()
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension ConversationalAvatarView: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { 
            print("❌ Failed to get image buffer from camera")
            return 
        }
        
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        let context = CIContext()
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { 
            print("❌ Failed to create CGImage from camera buffer")
            return 
        }
        
        let newImage = NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
        latestCameraImage = newImage
        
        // Debug: Print every 100th frame to avoid spam
        cameraFrameCount += 1
        if cameraFrameCount % 100 == 0 {
            print("📸 Camera frame captured: \(newImage.size) (frame #\(cameraFrameCount))")
        }
    }
}

class ConversationalAppDelegate: NSObject, NSApplicationDelegate {
    var window: ConversationalFloatingAvatarWindow!
    var avatarView: ConversationalAvatarView!
    
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
        
        print("🤖 Conversational TalkBack Avatar Started!")
        print("   - Connected to OpenAI GPT-4o-mini!")
        print("   - Using OpenAI for chat responses!")
        print("   - Using Gemini 2.5 Flash for vision & screenshots!")
        print("   - Using ElevenLabs Speech-to-Text!")
        print("   - Using ElevenLabs Text-to-Speech (Ivanna)!")
        print("   - 🔥 MCP MONITORING ACTIVE! (Watching Cursor terminal for errors)")
        print("   - Click and HOLD to talk!")
        print("   - Release to send your message!")
        print("   - Drag me around the screen")
        print("   - Drag me near the menu bar to see trash can!")
        print("   - Drop me in trash to turn me off!")
        print("   - I'll remember our conversation!")
        print("   - Custom purse/wallet icon!")
        print("   - REAL conversational voice chat!")
        print("   - 👁️ WATCHING YOUR BEHAVIOR! (I'll roast you if you get distracted)")
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
