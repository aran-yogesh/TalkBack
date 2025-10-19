#!/usr/bin/env swift

import Cocoa
import AVFoundation
import Foundation

// 🔐 API Keys Configuration
struct Config {
    static let geminiAPIKey = "YOUR_GEMINI_API_KEY_HERE"
    static let elevenLabsAPIKey = "YOUR_ELEVENLABS_API_KEY_HERE"
    static let elevenLabsVoiceID = "cgSgspJ2msm6clMCkdW9" // Ivanna
}

// 🎯 Gemini Vision Test - Testing Emotion & Focus Detection
// This captures your webcam and sends frames to Gemini 2.5 Flash for analysis

class GeminiVisionTester: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: - Configuration
    let geminiAPIKey = Config.geminiAPIKey
    var geminiAPIURL: String {
        return "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=\(geminiAPIKey)"
    }
    
    // ElevenLabs Configuration
    let elevenLabsAPIKey = Config.elevenLabsAPIKey
    let elevenLabsVoiceID = Config.elevenLabsVoiceID
    var elevenLabsAPIURL: String {
        return "https://api.elevenlabs.io/v1/text-to-speech/\(elevenLabsVoiceID)"
    }
    
    // Audio player
    var audioPlayer: NSSound?
    
    // MARK: - Camera Setup
    var captureSession: AVCaptureSession?
    var videoOutput: AVCaptureVideoDataOutput?
    var lastAnalysisTime: Date?
    let analysisInterval: TimeInterval = 10.0 // Analyze every 10 seconds
    
    override init() {
        super.init()
        setupCamera()
        schedulePeriodicAnalysis()
    }
    
    // MARK: - Camera Setup
    func setupCamera() {
        print("📷 Setting up camera...")
        
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { return }
        
        captureSession.sessionPreset = .medium
        
        // Get default camera
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("❌ No front camera found!")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            videoOutput = AVCaptureVideoDataOutput()
            videoOutput?.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            
            if let videoOutput = videoOutput, captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                captureSession.startRunning()
            }
            
            print("✅ Camera ready!")
        } catch {
            print("❌ Camera setup failed: \(error)")
        }
    }
    
    // MARK: - Periodic Analysis
    func schedulePeriodicAnalysis() {
        Timer.scheduledTimer(withTimeInterval: analysisInterval, repeats: true) { [weak self] _ in
            self?.captureAndAnalyze()
        }
        
        // Capture immediately on start
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.captureAndAnalyze()
        }
    }
    
    // MARK: - Capture Frame
    var latestImage: NSImage?
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        let context = CIContext()
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        
        latestImage = NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
    }
    
    // MARK: - Capture and Analyze
    func captureAndAnalyze() {
        guard let image = latestImage else {
            print("📷 No image captured yet, waiting...")
            return
        }
        
        print("\n🔍 Analyzing current frame with Gemini 2.5 Flash...")
        analyzeWithGemini(image: image)
    }
    
    // MARK: - Gemini Vision Analysis
    func analyzeWithGemini(image: NSImage) {
        // Convert image to base64
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let jpegData = bitmap.representation(using: .jpeg, properties: [.compressionFactor: 0.7]) else {
            print("❌ Failed to convert image")
            return
        }
        
        let base64Image = jpegData.base64EncodedString()
        
        // Gemini prompt for behavior analysis
        let prompt = """
        Analyze this person's behavior and state in 2-3 SHORT sentences:
        1. Are they looking at the screen or away? (gaze direction)
        2. What's their emotion? (happy, frustrated, focused, confused, neutral)
        3. Are they working seriously or distracted? (using phone, looking away, etc.)
        
        Be concise and direct. Example: "Person looking away from screen, appears distracted. Not focused on work."
        """
        
        // Gemini API request body
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
            print("❌ Failed to create JSON")
            return
        }
        
        // Make API request
        var request = URLRequest(url: URL(string: geminiAPIURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Gemini API Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("❌ No data received")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("🌐 Gemini HTTP Status: \(httpResponse.statusCode)")
            }
            
            // Parse response
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let candidates = json["candidates"] as? [[String: Any]],
                   let firstCandidate = candidates.first,
                   let content = firstCandidate["content"] as? [String: Any],
                   let parts = content["parts"] as? [[String: Any]],
                   let firstPart = parts.first,
                   let text = firstPart["text"] as? String {
                    
                    print("\n🎯 GEMINI ANALYSIS:")
                    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
                    print(text.trimmingCharacters(in: .whitespacesAndNewlines))
                    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
                    
                    // Generate sassy response based on analysis
                    self.generateSassyResponse(from: text)
                    
                } else if let error = json["error"] as? [String: Any] {
                    print("❌ Gemini Error: \(error)")
                }
            }
        }
        
        task.resume()
    }
    
    // MARK: - Sassy Response Generator
    func generateSassyResponse(from analysis: String) {
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
        // Frustrated/stressed detection (BEFORE distracted)
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
        // Happy detection (BEFORE focused, since Gemini might say "happy and engaged")
        else if lowercased.contains("happy") || lowercased.contains("smiling") || lowercased.contains("smile") {
            sassyMessage = "Oh, so NOW you're happy? What did I miss?"
        }
        // Focused/serious detection (LAST - catch neutral focused states)
        else if (lowercased.contains("focused") || lowercased.contains("concentrated")) && 
                 !lowercased.contains("not focused") {
            sassyMessage = "Whoa, look at Mr. Serious over here! What are you coding, rocket science?"
        }
        // Neutral/working state (NEW - different response)
        else if lowercased.contains("neutral") && (lowercased.contains("working") || lowercased.contains("looking at")) {
            let neutralMessages = [
                "You look like you're plotting world domination. Or just debugging. Same thing.",
                "That blank stare... Are you thinking or buffering?",
                "Wow, such focus. Much coding. Very productive. Or are you just staring into the void?",
                "You okay there? You've got that 'my code broke and I don't know why' face."
            ]
            sassyMessage = neutralMessages.randomElement() ?? neutralMessages[0]
        }
        
        if !sassyMessage.isEmpty {
            print("💬 SASSY RESPONSE:")
            print("   \(sassyMessage)\n")
            
            // Speak with Ivanna's voice!
            speakWithIvanna(sassyMessage)
        }
    }
    
    // MARK: - ElevenLabs TTS
    func speakWithIvanna(_ text: String) {
        print("🎤 Speaking with Ivanna's voice: \(text)")
        
        let requestBody: [String: Any] = [
            "text": text,
            "model_id": "eleven_monolingual_v1",
            "voice_settings": [
                "stability": 0.5,
                "similarity_boost": 0.75
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            print("❌ Failed to create TTS JSON")
            return
        }
        
        var request = URLRequest(url: URL(string: elevenLabsAPIURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(elevenLabsAPIKey, forHTTPHeaderField: "xi-api-key")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("❌ ElevenLabs TTS Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("❌ No audio data received")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("🎤 ElevenLabs TTS HTTP Status: \(httpResponse.statusCode)")
            }
            
            print("🎤 Received audio data: \(data.count) bytes")
            
            // Save to temp file and play with NSSound
            let tempDir = FileManager.default.temporaryDirectory
            let audioURL = tempDir.appendingPathComponent("ivanna_roast.mp3")
            
            do {
                try data.write(to: audioURL)
                
                DispatchQueue.main.async {
                    self?.audioPlayer = NSSound(contentsOf: audioURL, byReference: false)
                    self?.audioPlayer?.volume = 1.0
                    
                    if self?.audioPlayer?.play() == true {
                        print("🎤 Playing audio with NSSound...")
                        print("🎤 Audio playback started successfully!")
                    } else {
                        print("❌ Failed to play audio")
                    }
                }
            } catch {
                print("❌ Failed to save audio: \(error)")
            }
        }
        
        task.resume()
    }
}

// MARK: - Main Execution
print("""
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎯 GEMINI VISION TEST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Testing Gemini 2.5 Flash's ability to detect:
- Looking away from screen 👀
- Emotion (happy, frustrated, etc.) 😊😤
- Focus level (distracted, working, etc.) 🧐
- Phone usage 📱

Analysis happens every 10 seconds.
Press Ctrl+C to stop.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
""")

let tester = GeminiVisionTester()

// Keep the app running
RunLoop.main.run()

