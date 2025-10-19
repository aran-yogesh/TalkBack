import Cocoa
import AppKit
import Foundation
import AVFoundation
import Speech

class CustomIconFloatingAvatarWindow: NSWindow {
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

class CustomIconAvatarView: NSView {
    var message = "Click me to chat! 💬"
    var eyeOffset: NSPoint = NSPoint(x: 0, y: 0)
    var clickCount = 0
    var isThinking = false
    var isListening = false
    var isAlwaysListening = true
    var lastActivity = Date()
    var speechSynthesizer = AVSpeechSynthesizer()
    var chatHistory: [[String: String]] = []
    var listeningTimer: Timer?
    
    // Speech recognition
    private var speechRecognizer: SFSpeechRecognizer?
    private var audioEngine: AVAudioEngine?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    // APIs - REPLACE WITH YOUR OWN API KEYS
    // Get OpenAI key from: https://platform.openai.com/account/api-keys
    // Get ElevenLabs key from: https://elevenlabs.io/
    let openAIAPIKey = "YOUR_OPENAI_API_KEY_HERE"
    let openAIAPIURL = "https://api.openai.com/v1/chat/completions"
    
    let elevenLabsAPIKey = "YOUR_ELEVENLABS_API_KEY_HERE"
    let elevenLabsVoiceID = "XB0fDUnXU5powFXDhCwa" // Ivanna - sassy, dramatic voice
    // Find more voices at: https://elevenlabs.io/voice-library
    
    var elevenLabsAPIURL: String {
        return "https://api.elevenlabs.io/v1/text-to-speech/\(elevenLabsVoiceID)"
    }
    
    // Pre-written responses
    let sassyResponses = [
        "Oh, you clicked me! How original! 😏",
        "That tickles! But I'm not impressed! 😄",
        "More attention? You're so needy! 😊",
        "I like attention, but you're being too obvious! 💕",
        "Click me again! I dare you! 🎯",
        "You're persistent, I'll give you that! 😤",
        "Stop clicking me! I'm trying to think! 🤔",
        "You're like a child with a new toy! 🧸",
        "I'm not your personal entertainment! 😒",
        "This is getting old, but I'm still here! 😏"
    ]
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
        
        // Initialize speech recognition
        self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        self.audioEngine = AVAudioEngine()
        
        // Start activity monitoring
        self.startActivityMonitoring()
        
        // Speech recognition disabled due to beta macOS issues
        // No voice input - using text dialog instead
        
        // Start initial message
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.askOpenAI(prompt: "Introduce yourself as TalkBack, the annoying but helpful AI companion. Be sassy and dramatic.")
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
        
        // Draw thinking indicator if needed
        if isThinking {
            self.drawThinkingIndicator(in: context)
        }
    }
    
    func drawCustomIcon(in context: CGContext) {
        let centerX: CGFloat = 150
        let centerY: CGFloat = 100
        let size: CGFloat = 60
        
        // Save context state
        context.saveGState()
        
        // Simple approach: use basic shapes instead of complex paths
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
        
        if isListening || isAlwaysListening {
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
    
    func drawThinkingIndicator(in context: CGContext) {
        let centerX: CGFloat = 150
        let centerY: CGFloat = 100
        let radius: CGFloat = 30
        
        // Draw pulsing circle
        let time = Date().timeIntervalSince1970
        let pulse = (sin(time * 3) + 1) / 2 // 0 to 1
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
        
        needsDisplay = true
    }
    
    override func mouseDown(with event: NSEvent) {
        // Start simple speech recognition
        startSimpleSpeechRecognition()
    }
    
    override func mouseUp(with event: NSEvent) {
        // Do nothing on mouse up
    }
    
    // Voice input disabled due to beta macOS issues
    
    // Audio engine setup disabled due to beta macOS issues
    
    // Stop listening disabled due to beta macOS issues
    
    func startSimpleSpeechRecognition() {
        print("🎤 Starting simple speech recognition...")
        isListening = true
        message = "I'm listening... speak now! 🎤"
        needsDisplay = true
        
        // Use a simpler approach - just request permission and try basic recognition
        SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    print("🎤 Microphone permission granted")
                    self?.trySimpleRecognition()
                case .denied:
                    self?.message = "Microphone permission denied! 😤"
                    self?.isListening = false
                    self?.needsDisplay = true
                case .restricted:
                    self?.message = "Microphone restricted! 😤"
                    self?.isListening = false
                    self?.needsDisplay = true
                case .notDetermined:
                    self?.message = "Microphone permission not determined! 😤"
                    self?.isListening = false
                    self?.needsDisplay = true
                @unknown default:
                    self?.message = "Permission error! 😤"
                    self?.isListening = false
                    self?.needsDisplay = true
                }
            }
        }
    }
    
    func trySimpleRecognition() {
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            message = "Speech recognition not available! 😤"
            isListening = false
            needsDisplay = true
            return
        }
        
        // Create a simple file-based recognition request
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("speech_temp.wav")
        
        // For now, let's just simulate a successful recognition after a delay
        // This avoids the complex audio engine setup that was causing crashes
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.simulateSpeechInput()
        }
    }
    
    func simulateSpeechInput() {
        // For now, simulate speech input since the real recognition is crashing
        // In a real implementation, you'd process actual speech here
        let simulatedInput = "Hello TalkBack, how are you today?"
        print("🎤 Simulated speech input: \(simulatedInput)")
        
        isListening = false
        message = "Click me to talk! 🎤"
        needsDisplay = true
        
        // Process the simulated input
        processTextInput(simulatedInput)
    }
    
    func showTextInputDialog() {
        let alert = NSAlert()
        alert.messageText = "Talk to TalkBack! 💬"
        alert.informativeText = "Type your message and I'll respond with sass!"
        alert.addButton(withTitle: "Send")
        alert.addButton(withTitle: "Cancel")
        
        let inputField = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
        inputField.placeholderString = "Say something to me..."
        inputField.stringValue = ""
        
        alert.accessoryView = inputField
        alert.window.initialFirstResponder = inputField
        
        let response = alert.runModal()
        
        if response == .alertFirstButtonReturn {
            let userInput = inputField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
            if !userInput.isEmpty {
                print("💬 User typed: \(userInput)")
                processTextInput(userInput)
            }
        }
    }
    
    func processTextInput(_ text: String) {
        print("💬 Processing text input: \(text)")
        
        // Add user input to chat history
        chatHistory.append(["role": "user", "content": text])
        
        // Keep only last 10 messages to avoid token limits
        if chatHistory.count > 10 {
            chatHistory.removeFirst()
        }
        
        // Create prompt with context
        let historyContext = chatHistory.map { msg in
            "\(msg["role"]!): \(msg["content"]!)"
        }.joined(separator: "\n")
        
        let prompt = "User said: \(text)\n\nChat history:\n\(historyContext)\n\nRespond with sass and attitude!"
        
        askOpenAI(prompt: prompt)
    }
    
    func simulateThinkingAndResponse() {
        // Show thinking state
        isThinking = true
        message = "Hmm, let me think about that... 🤔"
        needsDisplay = true
        
        // Simulate thinking delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isThinking = false
            
            // Get AI response
            self.askOpenAI(prompt: "User clicked me. Respond with sass and attitude!")
        }
    }
    
    // Voice input processing disabled due to beta macOS issues
    
    func startActivityMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            self.checkUserActivity()
        }
    }
    
    func checkUserActivity() {
        let now = Date()
        let timeSinceLastActivity = now.timeIntervalSince(lastActivity)
        
        if timeSinceLastActivity > 30 {
            // User has been inactive for 30 seconds
            let messages = [
                "Are you still there? I'm getting lonely! 😢",
                "Hello? Anyone home? 🏠",
                "I'm starting to think you've forgotten about me! 😤",
                "This silence is deafening! Say something! 🗣️",
                "I'm here, watching and waiting... 👀"
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
        
        let personalityPrompt = "You are TalkBack, a sassy AI companion who remembers our conversation. Keep responses SHORT (1-2 sentences max) with attitude and emojis. Be witty, sarcastic, and slightly passive-aggressive. Reference our chat history when relevant!"
        
        // Build messages array with chat history
        var messages: [[String: String]] = []
        
        // Add system message
        messages.append(["role": "system", "content": personalityPrompt])
        
        // Add chat history
        messages.append(contentsOf: chatHistory)
        
        // Add current prompt
        messages.append(["role": "user", "content": prompt])
        
        let requestBody: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": messages,
            "max_tokens": 50,
            "temperature": 0.9
        ]
        
        guard let url = URL(string: openAIAPIURL) else {
            self.message = "API Error! 😤"
            self.isThinking = false
            self.needsDisplay = true
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(openAIAPIKey)", forHTTPHeaderField: "Authorization")
        
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
                    print("Network Error: \(error)")
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
                           let content = message["content"] as? String {
                            
                            let cleanText = content.trimmingCharacters(in: .whitespacesAndNewlines)
                            self?.message = cleanText
                            
                            // Add assistant response to chat history
                            self?.chatHistory.append(["role": "assistant", "content": cleanText])
                            
                            // Convert to speech using ElevenLabs
                            self?.speakText(cleanText)
                        } else if let error = json["error"] as? [String: Any],
                                  let message = error["message"] as? String {
                            self?.message = "OpenAI Error: \(message) 😤"
                        } else {
                            // Fallback to a sassy message if parsing fails
                            let fallbackMessages = [
                                "I'm having a moment! 😤",
                                "Something's not right here! 🤔",
                                "I'm confused but still sassy! 😏",
                                "Technical difficulties, but I'm still watching! 👀"
                            ]
                            self?.message = fallbackMessages.randomElement() ?? "I'm broken but still here! 😤"
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
    
    func speakText(_ text: String) {
        print("🎤 Attempting to speak: \(text)")
        
        // Clean text for ElevenLabs (remove emojis)
        let cleanText = text.replacingOccurrences(of: "[\\p{So}\\p{Cn}]", with: "", options: .regularExpression)
        print("🎤 Cleaned text: \(cleanText)")
        
        // Try ElevenLabs first
        speakWithElevenLabs(cleanText)
    }
    
    func speakWithElevenLabs(_ text: String) {
        guard let url = URL(string: elevenLabsAPIURL) else {
            fallbackSpeech(text: text)
            return
        }
        
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
            fallbackSpeech(text: text)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("🎤 ElevenLabs Error: \(error)")
                DispatchQueue.main.async {
                    self.fallbackSpeech(text: text)
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("🎤 ElevenLabs HTTP Status: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("🎤 No audio data from ElevenLabs")
                DispatchQueue.main.async {
                    self.fallbackSpeech(text: text)
                }
                return
            }
            
            print("🎤 Received audio data: \(data.count) bytes")
            
            // Play the audio
            DispatchQueue.main.async {
                self.playAudioData(data, fallbackText: text)
            }
        }.resume()
    }
    
    func playAudioData(_ data: Data, fallbackText: String) {
        print("🎤 Attempting to play ElevenLabs audio data: \(data.count) bytes")
        
        // Try using NSSound first (better for MP3 on macOS)
        if let sound = NSSound(data: data) {
            sound.volume = 1.0
            if sound.play() {
                print("🎤 ElevenLabs audio playback started successfully with NSSound!")
                return
            } else {
                print("🎤 NSSound failed to play - trying AVAudioPlayer")
            }
        } else {
            print("🎤 NSSound couldn't create sound from data - trying AVAudioPlayer")
        }
        
        // Fallback to AVAudioPlayer
        do {
            let audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer.volume = 1.0
            if audioPlayer.play() {
                print("🎤 ElevenLabs audio playback started successfully with AVAudioPlayer!")
                return
            } else {
                print("🎤 AVAudioPlayer failed to play")
            }
        } catch {
            print("🎤 AVAudioPlayer error: \(error)")
        }
        
        // Final fallback to system speech
        print("🎤 Using system voice (ElevenLabs audio format issue)")
        fallbackSpeech(text: fallbackText)
    }
    
    func fallbackSpeech(text: String) {
        print("🎤 Using fallback speech synthesis for: \(text)")
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.2
        
        speechSynthesizer.speak(utterance)
        print("🎤 Fallback speech synthesis started")
    }
}

class CustomIconAppDelegate: NSObject, NSApplicationDelegate {
    var window: CustomIconFloatingAvatarWindow!
    var avatarView: CustomIconAvatarView!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create floating window
        window = CustomIconFloatingAvatarWindow(
            contentRect: NSRect(x: 100, y: 100, width: 300, height: 200),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        // Create avatar view
        avatarView = CustomIconAvatarView(frame: NSRect(x: 0, y: 0, width: 300, height: 200))
        window.contentView = avatarView
        
        // Show window
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        print("🤖 Custom Icon TalkBack Avatar Started!")
        print("   - Connected to OpenAI GPT-4o-mini")
        print("   - Drag me around the screen")
        print("   - Watch my eyes follow your cursor!")
        print("   - Click me to talk!")
        print("   - I'll remember our conversation!")
        print("   - I'll speak with Ivanna's voice!")
        print("   - Custom purse/wallet icon!")
        print("   - Simple speech recognition (simulated for now)!")
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

// Main execution
let app = NSApplication.shared
let delegate = CustomIconAppDelegate()
app.delegate = delegate
app.run()