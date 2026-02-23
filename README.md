# TalkBack - Annoying But Useful AI Companion 🤖

A mischievous macOS floating avatar that acts as your sassy, helpful (but pushy) productivity coach. TalkBack is an interactive AI companion that listens to you, remembers your conversations, and responds with attitude-filled voice feedback.

![macOS](https://img.shields.io/badge/macOS-26.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 🎯 Features

### 🎤 **Real Voice Interaction**
- **Click and Hold** the avatar to speak your mind
- **ElevenLabs Speech-to-Text** for accurate voice recognition
- Supports multiple languages (English, Bengali, Hindi, and more!)
- Natural conversation flow with real-time transcription

### 🗣️ **Sassy AI Responses**
- **OpenAI GPT-4o** powered responses
- **ElevenLabs Text-to-Speech** with Ivanna's voice
- Attitude-filled, personality-driven replies
- Short, snappy responses that pack a punch

### 🧠 **Conversational Memory**
- Remembers your chat history
- Maintains context across conversations
- Smart follow-ups based on previous interactions

### 🎨 **Custom Floating Avatar**
- Transparent floating window (always on top)
- Custom purse/wallet icon design
- Animated eyes that follow your cursor
- Dynamic expressions based on mood
- Draggable anywhere on your screen

### 🗑️ **"The Great Escape" Feature**
- Drag avatar near the menu bar to reveal trash can
- Drop in trash to quit (the only way to close it!)
- Adds a fun, mischievous interaction

### 👁️ **Vision-Based Behavior Monitoring**
- **Gemini 2.5 Flash** watches you through your webcam
- Detects when you're:
  - 👀 Looking away from the screen
  - 😊😤😐 Your emotions (happy, frustrated, confused)
  - 🧐 Focus level (distracted, working seriously)
  - 📱 Using your phone
- Delivers sassy roasts based on your behavior
- Automatic analysis every 15 seconds

### 🔥 **MCP Code Monitor** (Cursor IDE Integration) (NEW!)
- **Watches your terminal for code execution results**
- **Auto-roasts you when you mess up!**
  - 🔥 **2+ errors**: Full savage roast mode
  - 😏 **1 error**: Light sass and sarcasm
  - 💅 **Success**: Sassy compliment with attitude
- Integrates with Cursor IDE workflow
- Real-time feedback via Ivanna's voice
- Setup docs: [MCP_SETUP.md](MCP_SETUP.md) and [QUICK_START.md](QUICK_START.md)

## 🛠️ Tech Stack

- **Language**: Swift 6.2
- **Framework**: AppKit (native macOS)
- **AI & Voice Services**:
  - [OpenAI GPT-4o](https://platform.openai.com/) - Conversational AI
  - [Gemini 2.5 Flash](https://aistudio.google.com/) - Vision & behavior analysis
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) - Voice recognition
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) - Voice synthesis (Ivanna voice)
- **Audio & Video**: AVFoundation (NSSound, AVAudioRecorder, AVCaptureSession)

## 🚀 Quick Start

### Prerequisites

1. **macOS 13.0+** (developed on macOS 26.0.1 beta)
2. **Xcode Command Line Tools** installed
3. **API Keys**:
   - OpenAI API key ([Get one here](https://platform.openai.com/account/api-keys))
   - ElevenLabs API key ([Get one here](https://elevenlabs.io/))
   - Gemini API key ([Get one here](https://aistudio.google.com/app/apikey))

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/aran-yogesh/TalkBack.git
   cd TalkBack
   ```

2. **Configure API Keys**:
   
   Edit the `Config` struct at the top of `ConversationalTalkBack.swift` (around line 8):
   ```swift
   struct Config {
       static let openAIAPIKey: String = {
           return "YOUR_OPENAI_API_KEY_HERE"
       }()
       
       static let elevenLabsAPIKey: String = {
           return "YOUR_ELEVENLABS_API_KEY_HERE"
       }()
       
       static let elevenLabsVoiceID: String = {
           return "cgSgspJ2msm6clMCkdW9" // Ivanna's voice
       }()
       
       static let geminiAPIKey: String = {
           return "YOUR_GEMINI_API_KEY_HERE"
       }()
   }
   ```
   
   > **Note**: API keys are embedded in the code for simplicity. For production use, consider using environment variables or a secure keychain.

3. **Compile the app**:
   ```bash
   swiftc -o ConversationalTalkBack ConversationalTalkBack.swift \
     -framework Cocoa -framework Foundation -framework AVFoundation \
     -target arm64-apple-macosx13.0
   ```

4. **Run TalkBack**:
   ```bash
   ./ConversationalTalkBack
   ```

## 🎮 How to Use

### Basic Usage

1. **Start the App**: Run `./ConversationalTalkBack`
2. **Grant Camera Permission**: Allow camera access when prompted (required for vision monitoring)
3. **Talk to TalkBack**:
   - **Click and HOLD** the avatar
   - **Speak** your message
   - **Release** to send
4. **Listen**: TalkBack responds with Ivanna's voice and attitude
5. **Get Roasted**: TalkBack monitors your behavior every 15 seconds:
   - Looking away? → "HEY! Where are you going?"
   - Using your phone? → "Seriously? TikTok is more important than me?"
   - Looking stressed? → "Uh oh, code not compiling?"
6. **Drag**: Move the avatar anywhere on your screen
7. **Quit**: Drag avatar near the menu bar → drop in trash can

### 🔥 MCP Code Monitoring (Cursor IDE Integration)

TalkBack can watch your terminal and roast you when your code fails! Here's how:

1. **Start TalkBack** (it automatically monitors `/tmp/talkback_message.json`)

2. **Optional: verify the MCP connection**:
   ```bash
   python3 test_mcp_connection.py
   ```

3. **Run your code with the monitor**:
   ```bash
   # Test with a script that has errors (will trigger full roast 🔥)
   python3 cursor_code_monitor.py run "python3 your_broken_script.py"
   
   # Test with successful code (will get sassy compliment 💅)
   python3 cursor_code_monitor.py run "python3 your_working_script.py"
   
   # Test with any command
   python3 cursor_code_monitor.py run "swift your_code.swift"
   ```

4. **TalkBack will roast you based on errors**:
   - ✅ **0 errors**: "Oh wow, it ACTUALLY worked? Color me shocked, darling! 💅✨"
   - 😏 **1 error**: "ONE error? Cute. At least you're almost there, sweetheart. 😏"
   - 🔥 **2+ errors**: "Oh HONEY, what is this hot mess? Did you code this with your eyes closed? 🔥💀"

5. **Example test**:
   ```bash
   # This will trigger a savage roast
   python3 cursor_code_monitor.py run "python3 broken_code.py"
   
   # TalkBack will speak the roast with Ivanna's voice!
   ```

## 📋 API Endpoints Used

### ElevenLabs Speech-to-Text
- **Endpoint**: `https://api.elevenlabs.io/v1/speech-to-text`
- **Model**: `scribe_v1`
- **Input**: WAV audio (16kHz, mono, PCM)
- **Output**: Transcribed text with language detection

### ElevenLabs Text-to-Speech
- **Endpoint**: `https://api.elevenlabs.io/v1/text-to-speech/{voice_id}`
- **Model**: `eleven_multilingual_v2`
- **Voice**: Ivanna (`XB0fDUnXU5powFXDhCwa`)
- **Output**: MP3 audio

### OpenAI GPT-4o
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Model**: `gpt-4o`
- **Temperature**: 0.9 (for sassy responses)
- **Max Tokens**: 50 (short, snappy replies)

### Gemini 2.5 Flash (Vision)
- **Endpoint**: `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent`
- **Model**: `gemini-2.0-flash-exp`
- **Input**: Base64-encoded JPEG images from webcam
- **Output**: Behavior analysis (gaze, emotion, focus, distraction detection)
- **Frequency**: Every 15 seconds

## 🎭 Personality

TalkBack is designed to be:
- 😏 **Sassy**: Witty comebacks and attitude-filled responses
- 🎯 **Helpful**: Actually useful advice (hidden in the sass)
- 💁‍♀️ **Pushy**: Won't let you procrastinate
- 🧠 **Smart**: Remembers your conversations
- 🎤 **Talkative**: Loves to chat (maybe too much)

## 🐛 Troubleshooting

### No Voice Output?
- Check system volume and audio output device
- Verify ElevenLabs API key and voice ID
- Look for `🎤 ElevenLabs TTS HTTP Status: 200` in terminal

### Empty Transcriptions?
- Ensure you're holding the mouse button while speaking
- Check microphone permissions (System Settings → Privacy & Security → Microphone)
- Verify ElevenLabs API key is valid

### Rate Limit Errors?
- OpenAI usage limits: Check your account for current limits
- Add payment method or wait 20 seconds between requests

### Crashes on Launch?
- Compile with explicit target: `-target arm64-apple-macosx13.0`
- Check Swift version: `swift --version`
- Beta macOS can be unstable with Speech framework

## 📝 Development Notes

This project was developed on **macOS 26.0.1 beta** with **Swift 6.2**, which required special handling:
- Explicit compilation target (`-target arm64-apple-macosx13.0`)
- Avoided unstable `SFSpeechRecognizer` framework
- Used ElevenLabs STT instead of macOS built-in speech recognition
- Prioritized `NSSound` over `AVAudioPlayer` for better MP3 compatibility

## 🔮 Future Features

- [ ] Screen monitoring (detect what user is doing)
- [ ] Context-aware productivity tips
- [ ] Custom voice selection
- [ ] Multiple personality modes
- [ ] Scheduled check-ins
- [ ] Integration with calendar/reminders

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Submit pull requests
- Improve documentation

## 📄 License

MIT License - feel free to use, modify, and distribute.

## 🙏 Acknowledgments

- **OpenAI** for GPT-4o API
- **ElevenLabs** for Speech-to-Text and Text-to-Speech APIs
- **Ivanna** for the sassy voice that brings TalkBack to life

## 💬 Questions or Feedback?

Open an issue or reach out! TalkBack loves to chat (obviously). 😉

---

**Made with 💻 and a lot of sass** by [@aran-yogesh](https://github.com/aran-yogesh)

