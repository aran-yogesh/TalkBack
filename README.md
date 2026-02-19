# TalkBack - Annoying But Useful AI Companion 🤖

A mischievous macOS floating avatar that acts as your sassy, helpful (but pushy) productivity coach. TalkBack is an interactive AI companion that continuously listens to you, remembers your conversations, and responds with attitude-filled voice feedback.

![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 🎯 Features

### 🎤 **Continuous Voice Interaction**
- **Always-on listening** via `AVAudioEngine` with voice activity detection
- **ElevenLabs Speech-to-Text** (`scribe_v1`) for accurate voice recognition
- Supports multiple languages (English, Bengali, Hindi, and more!)
- Automatic silence detection stops recording after 2 seconds of quiet

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
- Bouncing zigzag floating animation (pauses during recording)

### 🗑️ **"The Great Escape" Feature**
- Drag avatar near the menu bar to reveal trash can
- Drop in trash to quit (the only way to close it!)
- Adds a fun, mischievous interaction

### 🔍 **TalkBack Lens** (Accessibility Summarizer)
- **Hold ⌥ Option** to activate Lens mode on any UI element
- Uses macOS Accessibility APIs to read on-screen text
- **GPT-4.1** powered summarization with multiple actions (Summarize, Explain, Simplify)
- Toggleable from the menu bar status item
- Result caching to avoid repeated API calls

### 👩‍🏫 **Coding Teacher Mode**
- AI-powered code review feedback on command results
- Analyzes terminal output (errors, success, exit codes)
- Provides constructive teaching moments via GPT-4o
- Toggleable from the menu bar

### 📬 **Assignment Email Alerts**
- Monitors Apple Mail for assignment-related emails via AppleScript
- Detects keywords like "assignment", "homework", "due", "exam"
- GPT-4o summarizes assignment details with due dates
- Checks every 3 minutes when enabled
- Toggleable from the menu bar

### 🔥 **MCP Code Monitor** (Cursor IDE Integration)
- Watches your terminal for code execution results
- Auto-roasts you when you mess up!
  - 🔥 **2+ errors**: Full savage roast mode
  - 😏 **1 error**: Light sass and sarcasm
  - 💅 **Success**: Sassy compliment with attitude
- Integrates with Cursor IDE workflow
- Real-time feedback via Ivanna's voice

## 🛠️ Tech Stack

- **Language**: Swift 6.2
- **Framework**: AppKit (native macOS)
- **AI & Voice Services**:
  - [OpenAI GPT-4o](https://platform.openai.com/) — Conversational AI, code review, assignment summaries
  - [OpenAI GPT-4.1](https://platform.openai.com/) — TalkBack Lens summarization
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) — Voice recognition (`scribe_v1`)
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) — Voice synthesis (`eleven_multilingual_v2`, Ivanna voice)
- **Audio**: AVFoundation (`AVAudioEngine`, `NSSound`, `AVAudioPlayer`)
- **Accessibility**: ApplicationServices (Accessibility APIs for Lens mode)

## 🚀 Quick Start

### Prerequisites

1. **macOS 13.0+** (developed on macOS 26.0.1 beta)
2. **Xcode Command Line Tools** installed
3. **API Keys**:
   - OpenAI API key ([Get one here](https://platform.openai.com/account/api-keys))
   - ElevenLabs API key ([Get one here](https://elevenlabs.io/))

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/aran-yogesh/TalkBack.git
   cd TalkBack
   ```

2. **Configure API Keys**:

   Copy the template and add your keys:
   ```bash
   cp config.swift.template config.swift
   ```

   Edit `config.swift` with your actual API keys:
   ```swift
   struct Config {
       static let openAIAPIKey = "YOUR_OPENAI_API_KEY_HERE"
       static let elevenLabsAPIKey = "YOUR_ELEVENLABS_API_KEY_HERE"
       static let elevenLabsVoiceID = "cgSgspJ2msm6clMCkdW9"
       static let geminiAPIKey = "YOUR_GEMINI_API_KEY_HERE"
   }
   ```

   > **Note**: `config.swift` is gitignored so your keys stay private.

3. **Compile the app**:
   ```bash
   swiftc -o ConversationalTalkBack config.swift ConversationalTalkBack.swift \
     -framework Cocoa -framework Foundation -framework AVFoundation \
     -framework ApplicationServices -target arm64-apple-macosx13.0
   ```

4. **Run TalkBack**:
   ```bash
   ./ConversationalTalkBack
   ```

## 🎮 How to Use

### Basic Usage

1. **Start the App**: Run `./ConversationalTalkBack`
2. **Grant Microphone Permission**: Allow microphone access when prompted
3. **Talk to TalkBack**: Just speak — TalkBack continuously listens and detects when you're talking
4. **Listen**: TalkBack responds with Ivanna's voice and attitude
5. **Use Lens Mode**: Hold ⌥ Option and hover over any UI element for AI-powered summaries
6. **Drag**: Move the avatar anywhere on your screen (it floats on its own too!)
7. **Menu Bar**: Toggle Teacher Mode, Assignment Alerts, and Lens from the status bar
8. **Quit**: Drag avatar near the menu bar → drop in trash can

### 🔥 MCP Code Monitoring (Cursor IDE Integration)

TalkBack can watch your terminal and roast you when your code fails! Here's how:

1. **Start TalkBack** (it automatically monitors `/tmp/talkback_message.json`)

2. **Run your code with the monitor**:
   ```bash
   python3 cursor_code_monitor.py run "python3 your_script.py"

   python3 cursor_code_monitor.py run "swift your_code.swift"
   ```

3. **TalkBack will roast you based on errors**:
   - ✅ **0 errors**: "Oh wow, it ACTUALLY worked? Color me shocked, darling! 💅✨"
   - 😏 **1 error**: "ONE error? Cute. At least you're almost there, sweetheart. 😏"
   - 🔥 **2+ errors**: "Oh HONEY, what is this hot mess? Did you code this with your eyes closed? 🔥💀"

4. **Example test**:
   ```bash
   python3 cursor_code_monitor.py run "python3 broken_code.py"
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
- **Voice**: Ivanna (`cgSgspJ2msm6clMCkdW9`)
- **Output**: MP3 audio

### OpenAI GPT-4o
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Model**: `gpt-4o`
- **Temperature**: 0.9 (conversational), 0.7 (assignments), 0.6 (teaching)
- **Max Tokens**: 80 (conversational), 120 (assignments/teaching)

### OpenAI GPT-4.1 (Lens Mode)
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Model**: `gpt-4.1`
- **Temperature**: 0.3 (precise summarization)
- **Max Tokens**: 120

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

### Voice Not Detected?
- Ensure microphone permissions are granted (System Settings → Privacy & Security → Microphone)
- Check that `AVAudioEngine` started successfully in terminal output
- Verify ElevenLabs API key is valid for STT

### Lens Mode Not Working?
- Grant Accessibility permissions (System Settings → Privacy & Security → Accessibility)
- Ensure OpenAI API key is set in `config.swift`
- Try toggling Lens mode from the menu bar status item

### Rate Limit Errors?
- OpenAI usage limits: Check your account for current limits
- Add payment method or wait 20 seconds between requests
- Built-in cooldown: 22 seconds between GPT-4o calls

### Crashes on Launch?
- Compile with explicit target: `-target arm64-apple-macosx13.0`
- Check Swift version: `swift --version`
- Ensure `config.swift` exists (copy from `config.swift.template`)

## 📝 Development Notes

This project was developed on **macOS 26.0.1 beta** with **Swift 6.2**, which required special handling:
- Explicit compilation target (`-target arm64-apple-macosx13.0`)
- Avoided unstable `SFSpeechRecognizer` framework
- Used ElevenLabs STT instead of macOS built-in speech recognition
- Prioritized `NSSound` over `AVAudioPlayer` for better MP3 compatibility
- Uses `AVAudioEngine` for continuous audio capture instead of `AVAudioRecorder`

## 📚 Additional Documentation

- [API Key Setup Guide](API_KEY_SETUP.md)
- [Quick Start Guide](QUICK_START.md)
- [MCP Integration Guide](MCP_INTEGRATION.md)
- [MCP Setup Guide](MCP_SETUP.md)

## 🔮 Future Features

- [ ] Vision-based behavior monitoring (webcam + Gemini)
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

- **OpenAI** for GPT-4o and GPT-4.1 APIs
- **ElevenLabs** for Speech-to-Text and Text-to-Speech APIs
- **Ivanna** for the sassy voice that brings TalkBack to life

## 💬 Questions or Feedback?

Open an issue or reach out! TalkBack loves to chat (obviously). 😉

---

**Made with 💻 and a lot of sass** by [@aran-yogesh](https://github.com/aran-yogesh)
