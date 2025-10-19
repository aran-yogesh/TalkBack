import Cocoa
import AppKit
import Foundation
import AVFoundation

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
    
    // Audio recording
    var audioRecorder: AVAudioRecorder?
    var recordingURL: URL?
    
    // APIs - REPLACE THESE WITH YOUR OWN API KEYS
    // Get OpenAI key from: https://platform.openai.com/account/api-keys
    // Get ElevenLabs key from: https://elevenlabs.io/
    let openAIAPIKey = "YOUR_OPENAI_API_KEY_HERE"
    let openAIAPIURL = "https://api.openai.com/v1/chat/completions"
    
    let elevenLabsAPIKey = "YOUR_ELEVENLABS_API_KEY_HERE"
    let elevenLabsVoiceID = "XB0fDUnXU5powFXDhCwa" // Ivanna - sassy, dramatic voice
    // Find more voices at: https://elevenlabs.io/voice-library
    
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
        
        // Start initial message
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.askOpenAI(prompt: "Introduce yourself as TalkBack, the conversational AI companion. Be sassy and dramatic. Tell me to click and hold to talk to you.")
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
    
    func startRecording() {
        print("🎤 Starting recording...")
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
        
        // Create prompt with conversation context
        let historyContext = chatHistory.map { msg in
            "\(msg["role"]!): \(msg["content"]!)"
        }.joined(separator: "\n")
        
        let prompt = "User said: \(text)\n\nChat history:\n\(historyContext)\n\nRespond with sass and attitude! Keep it conversational!"
        
        askOpenAI(prompt: prompt)
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
        
        let personalityPrompt = "You are TalkBack, a sassy conversational AI companion. Keep responses SHORT (1-2 sentences max) with attitude and emojis. Be witty, sarcastic, and slightly passive-aggressive. You remember our conversation and reference it!"
        
        // Build messages array with chat history
        var messages: [[String: String]] = []
        messages.append(["role": "system", "content": personalityPrompt])
        messages.append(contentsOf: chatHistory)
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
                           let content = message["content"] as? String {
                            
                            let cleanText = content.trimmingCharacters(in: .whitespacesAndNewlines)
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
        print("   - Connected to OpenAI GPT-4o-mini")
        print("   - Using ElevenLabs Speech-to-Text!")
        print("   - Using ElevenLabs Text-to-Speech (Ivanna)!")
        print("   - Click and HOLD to talk!")
        print("   - Release to send your message!")
        print("   - Drag me around the screen")
        print("   - Drag me near the menu bar to see trash can!")
        print("   - Drop me in trash to turn me off!")
        print("   - I'll remember our conversation!")
        print("   - Custom purse/wallet icon!")
        print("   - REAL conversational voice chat!")
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

// Main execution
let app = NSApplication.shared
let delegate = ConversationalAppDelegate()
app.delegate = delegate
app.run()
