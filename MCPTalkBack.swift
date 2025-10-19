import Cocoa
import AppKit
import Foundation
import AVFoundation

class MCPFloatingAvatarWindow: NSWindow {
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

class MCPAvatarView: NSView {
    var message = "Watching your code... 👀"
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
    
    // Audio recording
    var audioRecorder: AVAudioRecorder?
    var recordingURL: URL?
    
    // MCP monitoring
    var mcpMonitorTimer: Timer?
    var lastMCPMessageTime: TimeInterval = 0
    
    // APIs
    let openAIAPIKey = "YOUR_OPENAI_API_KEY_HERE"
    let openAIAPIURL = "https://api.openai.com/v1/chat/completions"
    
    let elevenLabsAPIKey = "YOUR_ELEVENLABS_API_KEY_HERE"
    let elevenLabsVoiceID = "cgSgspJ2msm6clMCkdW9" // Ivanna
    
    var elevenLabsTTSURL: String {
        return "https://api.elevenlabs.io/v1/text-to-speech/\(elevenLabsVoiceID)"
    }
    
    let elevenLabsSTTURL = "https://api.elevenlabs.io/v1/speech-to-text"
    let mcpMessageFile = "/tmp/talkback_message.json"
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
        
        // Start MCP monitoring
        self.startMCPMonitoring()
        
        // Start activity monitoring
        self.startActivityMonitoring()
        
        // Initial greeting
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.askOpenAI(prompt: "Introduce yourself as TalkBack, your Cursor IDE code monitor. Tell me you're watching my code and ready to roast me when I mess up. Be sassy!")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMCPMonitoring() {
        print("🔍 Starting MCP monitoring...")
        
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
        
        // Call OpenAI
        self.askOpenAI(prompt: prompt, systemPrompt: systemPrompt)
    }
    
    func askOpenAI(prompt: String, systemPrompt: String? = nil) {
        guard let url = URL(string: openAIAPIURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(openAIAPIKey)", forHTTPHeaderField: "Authorization")
        
        let finalSystemPrompt = systemPrompt ?? """
        You are TalkBack, a sassy AI companion watching the user's code in Cursor IDE.
        Be witty, dramatic, and full of attitude. Keep responses under 40 words.
        """
        
        var messages: [[String: String]] = [
            ["role": "system", "content": finalSystemPrompt]
        ]
        
        // Add chat history (last 5 messages)
        messages.append(contentsOf: Array(chatHistory.suffix(5)))
        
        // Add current prompt
        messages.append(["role": "user", "content": prompt])
        
        let requestBody: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": messages,
            "max_tokens": 50,
            "temperature": 0.9
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("❌ JSON error: \(error)")
            return
        }
        
        isThinking = true
        message = "Thinking... 🤔"
        needsDisplay = true
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isThinking = false
                
                if let error = error {
                    print("❌ OpenAI Error: \(error)")
                    self?.message = "Ugh, connection error! 😤"
                    self?.needsDisplay = true
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let httpResponse = response as? HTTPURLResponse {
                            print("OpenAI HTTP Status: \(httpResponse.statusCode)")
                        }
                        print("OpenAI Response: \(json)")
                        
                        if let choices = json["choices"] as? [[String: Any]],
                           let firstChoice = choices.first,
                           let message = firstChoice["message"] as? [String: Any],
                           let content = message["content"] as? String {
                            
                            // Add to chat history
                            self?.chatHistory.append(["role": "user", "content": prompt])
                            self?.chatHistory.append(["role": "assistant", "content": content])
                            
                            // Speak the response
                            self?.speakText(content)
                        }
                    }
                } catch {
                    print("❌ Parse error: \(error)")
                }
            }
        }.resume()
    }
    
    func speakText(_ text: String) {
        print("🎤 Speaking with Ivanna's voice: \(text)")
        
        message = text
        needsDisplay = true
        
        // Clean text for ElevenLabs
        let cleanText = text.replacingOccurrences(of: "[\\p{So}\\p{Cn}]", with: "", options: .regularExpression)
        
        // Use ElevenLabs TTS
        speakWithElevenLabs(cleanText)
    }
    
    func speakWithElevenLabs(_ text: String) {
        guard let url = URL(string: elevenLabsTTSURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(elevenLabsAPIKey, forHTTPHeaderField: "xi-api-key")
        
        let requestBody: [String: Any] = [
            "text": text,
            "model_id": "eleven_multilingual_v2",
            "voice_settings": [
                "stability": 0.5,
                "similarity_boost": 0.5
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("🎤 ElevenLabs JSON error: \(error)")
            fallbackSpeech(text: text)
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("🎤 ElevenLabs Error: \(error)")
                DispatchQueue.main.async {
                    self?.fallbackSpeech(text: text)
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("🎤 ElevenLabs TTS HTTP Status: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("🎤 No audio data")
                DispatchQueue.main.async {
                    self?.fallbackSpeech(text: text)
                }
                return
            }
            
            print("🎤 Received audio data: \(data.count) bytes")
            
            DispatchQueue.main.async {
                self?.playAudio(data)
            }
        }.resume()
    }
    
    func playAudio(_ data: Data) {
        if let sound = NSSound(data: data) {
            sound.volume = 1.0
            if sound.play() {
                print("🎤 Audio playback started successfully!")
                return
            }
        }
        
        do {
            let audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer.volume = 1.0
            if audioPlayer.play() {
                print("🎤 AVAudioPlayer playback started!")
                return
            }
        } catch {
            print("🎤 AVAudioPlayer error: \(error)")
        }
    }
    
    func fallbackSpeech(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        speechSynthesizer.speak(utterance)
    }
    
    func startActivityMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            self?.checkActivity()
        }
    }
    
    func checkActivity() {
        let timeSinceActivity = Date().timeIntervalSince(lastActivity)
        if timeSinceActivity > 300 { // 5 minutes
            askOpenAI(prompt: "The user hasn't coded in 5 minutes. Give them a sassy reminder to get back to work!")
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        
        drawCustomIcon(in: context)
        drawSpeechBubble(in: context)
        
        if trashCanVisible {
            drawTrashCan(in: context)
        }
        
        if isThinking {
            drawThinkingIndicator(in: context)
        }
        
        if isRecording {
            drawRecordingIndicator(in: context)
        }
    }
    
    func drawCustomIcon(in context: CGContext) {
        let centerX: CGFloat = 150
        let centerY: CGFloat = 100
        
        // Main purse body
        context.setFillColor(NSColor.systemYellow.cgColor)
        let bodyRect = CGRect(x: centerX - 40, y: centerY - 30, width: 80, height: 50)
        context.fillEllipse(in: bodyRect)
        
        // Eyes
        let leftEyeX = centerX - 20 + eyeOffset.x * 3
        let rightEyeX = centerX + 20 + eyeOffset.x * 3
        let eyeY = centerY + eyeOffset.y * 3
        
        context.setFillColor(NSColor.black.cgColor)
        context.fillEllipse(in: CGRect(x: leftEyeX - 5, y: eyeY - 5, width: 10, height: 10))
        context.fillEllipse(in: CGRect(x: rightEyeX - 5, y: eyeY - 5, width: 10, height: 10))
        
        // Mouth (different based on state)
        context.setLineWidth(3)
        context.setStrokeColor(NSColor.black.cgColor)
        
        let mouthY = centerY - 15
        
        if isThinking {
            // Wavy thinking mouth
            context.move(to: CGPoint(x: centerX - 15, y: mouthY))
            context.addCurve(to: CGPoint(x: centerX + 15, y: mouthY),
                           control1: CGPoint(x: centerX - 5, y: mouthY - 5),
                           control2: CGPoint(x: centerX + 5, y: mouthY + 5))
        } else if isRecording {
            // Open mouth (recording)
            context.addEllipse(in: CGRect(x: centerX - 8, y: mouthY - 8, width: 16, height: 16))
        } else {
            // Sassy smirk
            context.move(to: CGPoint(x: centerX - 15, y: mouthY))
            context.addCurve(to: CGPoint(x: centerX + 15, y: mouthY + 5),
                           control1: CGPoint(x: centerX - 5, y: mouthY - 5),
                           control2: CGPoint(x: centerX + 5, y: mouthY + 5))
        }
        
        context.strokePath()
    }
    
    func drawSpeechBubble(in context: CGContext) {
        let bubbleRect = CGRect(x: 320, y: 50, width: 260, height: 100)
        
        context.setFillColor(NSColor.white.withAlphaComponent(0.95).cgColor)
        context.setStrokeColor(NSColor.black.cgColor)
        context.setLineWidth(2)
        
        let bubblePath = NSBezierPath(roundedRect: bubbleRect, xRadius: 10, yRadius: 10)
        bubblePath.fill()
        bubblePath.stroke()
        
        // Text
        let textRect = CGRect(x: bubbleRect.minX + 10, y: bubbleRect.minY + 10,
                            width: bubbleRect.width - 20, height: bubbleRect.height - 20)
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 13),
            .foregroundColor: NSColor.black,
            .paragraphStyle: textStyle
        ]
        
        message.draw(in: textRect, withAttributes: attributes)
    }
    
    func drawTrashCan(in context: CGContext) {
        let trashX: CGFloat = bounds.width / 2 - 25
        let trashY: CGFloat = bounds.height - 100
        
        context.setFillColor(NSColor.red.withAlphaComponent(0.8).cgColor)
        context.fillEllipse(in: CGRect(x: trashX, y: trashY, width: 50, height: 50))
        
        let trashText = "🗑️"
        let trashAttr: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 30)
        ]
        trashText.draw(at: CGPoint(x: trashX + 10, y: trashY + 10), withAttributes: trashAttr)
    }
    
    func drawThinkingIndicator(in context: CGContext) {
        // Animated dots
        let dotCount = Int(Date().timeIntervalSinceReferenceDate * 2) % 4
        let dots = String(repeating: ".", count: dotCount)
        
        let thinkingText = "Thinking\(dots)"
        let thinkingAttr: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 12),
            .foregroundColor: NSColor.gray
        ]
        thinkingText.draw(at: CGPoint(x: 20, y: 20), withAttributes: thinkingAttr)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.needsDisplay = true
        }
    }
    
    func drawRecordingIndicator(in context: CGContext) {
        context.setFillColor(NSColor.red.cgColor)
        context.fillEllipse(in: CGRect(x: 280, y: 140, width: 15, height: 15))
        
        let recText = "🎤 LISTENING"
        let recAttr: [NSAttributedString.Key: Any] = [
            .font: NSFont.boldSystemFont(ofSize: 12),
            .foregroundColor: NSColor.red
        ]
        recText.draw(at: CGPoint(x: 300, y: 137), withAttributes: recAttr)
    }
    
    override func mouseMoved(with event: NSEvent) {
        let mouseLocation = event.locationInWindow
        let centerX: CGFloat = 150
        let centerY: CGFloat = 100
        
        let dx = mouseLocation.x - centerX
        let dy = mouseLocation.y - centerY
        let distance = sqrt(dx*dx + dy*dy)
        
        if distance > 0 {
            eyeOffset.x = (dx / distance) * 0.3
            eyeOffset.y = (dy / distance) * 0.3
        }
        
        needsDisplay = true
        lastActivity = Date()
    }
    
    override func mouseDown(with event: NSEvent) {
        dragStartPoint = event.locationInWindow
        isBeingDragged = true
    }
    
    override func mouseDragged(with event: NSEvent) {
        guard let window = self.window else { return }
        
        let currentLocation = event.locationInWindow
        let dx = currentLocation.x - dragStartPoint.x
        let dy = currentLocation.y - dragStartPoint.y
        
        let newOrigin = NSPoint(x: window.frame.origin.x + dx,
                               y: window.frame.origin.y + dy)
        window.setFrameOrigin(newOrigin)
        
        // Check if near menu bar for trash can
        if let screen = NSScreen.main {
            let menuBarHeight = screen.frame.height - screen.visibleFrame.height
            let distanceFromTop = screen.frame.height - window.frame.maxY
            
            trashCanVisible = distanceFromTop < menuBarHeight + 50
            needsDisplay = true
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        if trashCanVisible {
            NSApplication.shared.terminate(nil)
        }
        
        isBeingDragged = false
        trashCanVisible = false
        needsDisplay = true
    }
}

class MCPAppDelegate: NSObject, NSApplicationDelegate {
    var window: MCPFloatingAvatarWindow!
    var avatarView: MCPAvatarView!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let screenFrame = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 1920, height: 1080)
        let windowRect = NSRect(x: screenFrame.width - 650, y: screenFrame.height - 250, width: 600, height: 200)
        
        window = MCPFloatingAvatarWindow(contentRect: windowRect,
                                        styleMask: [.borderless],
                                        backing: .buffered,
                                        defer: false)
        
        avatarView = MCPAvatarView(frame: NSRect(x: 0, y: 0, width: 600, height: 200))
        window.contentView = avatarView
        window.makeKeyAndOrderFront(nil)
        
        avatarView.window?.acceptsMouseMovedEvents = true
        
        print("🤖 TalkBack MCP Monitor Started!")
        print("   - Connected to Cursor IDE via MCP")
        print("   - Monitoring code execution")
        print("   - Ready to ROAST on errors! 🔥")
        print("   - Drag me around")
        print("   - Drag to menu bar → trash to quit")
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

let app = NSApplication.shared
let delegate = MCPAppDelegate()
app.delegate = delegate
app.run()

