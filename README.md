# TalkBack - Annoying But Useful AI Companion 🤖

A mischievous macOS floating avatar that acts as your sassy, helpful (but pushy) productivity coach. TalkBack is an interactive AI companion that listens to you, remembers your conversations, and responds with attitude-filled voice feedback.

## Table of Contents

- [🎯 Features](#-features)
- [🛠️ Tech Stack](#️-tech-stack)
- [🚀 Quick Start](#-quick-start)
- [🎮 How to Use](#-how-to-use)
- [📋 API Endpoints Used](#-api-endpoints-used)
- [🎭 Personality](#-personality)
- [🐛 Troubleshooting](#-troubleshooting)
- [📝 Development Notes](#-development-notes)
- [🔮 Future Features](#-future-features)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)
- [🙏 Acknowledgments](#-acknowledgments)
- [💬 Questions or Feedback?](#-questions-or-feedback)


![macOS](https://img.shields.io/badge/macOS-26.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 🎯 Features

### 🎤 **Always-On Voice Interaction**
- **Continuous listening** — just speak and TalkBack hears you (no button press needed)
- Voice activity detection with automatic 2-second silence cutoff
- **ElevenLabs Speech-to-Text** for accurate voice recognition
- Supports multiple languages (English, Bengali, Hindi, and more!)

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
- DVD-screensaver-style bouncing/zigzag motion when idle

### 🗑️ **"The Great Escape" Feature**
- Drag avatar near the menu bar to reveal trash can
- Drop in trash to quit (the only way to close it!)
- Adds a fun, mischievous interaction

### 🔍 **Lens Mode** (Accessibility Overlay)
- Toggle from the menu bar status item
- Reads on-screen text under your cursor via macOS Accessibility APIs
- **Summarize** and **Make Concise** buttons powered by OpenAI
- Hold the **Option key** for temporary lens activation
- Result caching for previously analyzed elements

### 👨‍🏫 **Teacher Mode** (Coding Assistant)
- Monitors your terminal command executions
- Provides teaching feedback on command results
- Explains errors and suggests fixes with a sassy twist
- Toggleable from the menu bar

### 📧 **Assignment Alerts** (Email Monitoring)
- Monitors Apple Mail for assignment-related emails
- Detects keywords like "assignment", "homework", "quiz", "exam"
- Watches for `.edu`, `canvas`, and `blackboard` domains
- Summarizes assignment details via OpenAI

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
  - [OpenAI GPT-4o](https://platform.openai.com/) — Conversational AI & roasts
  - [OpenAI GPT-4.1](https://platform.openai.com/) — Lens Mode summarization
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) — Voice recognition
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) — Voice synthesis (Ivanna voice)
- **Audio**: AVFoundation (AVAudioEngine, AVAudioPlayer, NSSound)
- **Accessibility**: ApplicationServices (AXUIElement APIs for Lens Mode)

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

   Then edit `config.swift` with your actual API keys:
   ```swift
   struct Config {
       static let openAIAPIKey = "YOUR_OPENAI_API_KEY_HERE"
       static let elevenLabsAPIKey = "YOUR_ELEVENLABS_API_KEY_HERE"
       static let elevenLabsVoiceID = "cgSgspJ2msm6clMCkdW9" // Ivanna's voice
       static let geminiAPIKey = "YOUR_GEMINI_API_KEY_HERE"
   }
   ```

   > **Note**: `config.swift` is gitignored for security. Never commit your actual API keys.

3. **Compile the app**:
   ```bash
   swiftc -O -o ConversationalTalkBack config.swift ConversationalTalkBack.swift \
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
2. **Grant Permissions**: Allow microphone and accessibility access when prompted
3. **Talk to TalkBack**: Just speak — continuous listening is always active. After 2 seconds of silence, your speech is transcribed and sent automatically
4. **Listen**: TalkBack responds with Ivanna's voice and attitude
5. **Drag**: Move the avatar anywhere on your screen (it bounces around on its own when idle)
6. **Menu Bar**: Use the status item to toggle Lens Mode and Teacher Mode
7. **Quit**: Drag avatar near the menu bar → drop in trash can

### 🔍 Lens Mode

1. Click the **menu bar status item** and enable Lens Mode
2. Hover over any text on screen — TalkBack reads it via Accessibility APIs
3. Use the **Summarize** or **Make Concise** buttons for AI-powered summaries
4. Hold the **Option key** for temporary lens activation without toggling

### 🔥 MCP Code Monitoring (Cursor IDE Integration)

TalkBack can watch your terminal and roast you when your code fails:

1. **Start TalkBack** (it automatically monitors `/tmp/talkback_message.json`)

2. **Run your code with the code monitor**:
   ```bash
   python3 cursor_code_monitor.py run "python3 your_script.py"
   ```

3. **Or send a test message directly**:
   ```bash
   python3 test_mcp_connection.py
   ```

4. **TalkBack will roast you based on errors**:
   - ✅ **0 errors**: "Oh wow, it ACTUALLY worked? Color me shocked, darling! 💅✨"
   - 😏 **1 error**: "ONE error? Cute. At least you're almost there, sweetheart. 😏"
   - 🔥 **2+ errors**: "Oh HONEY, what is this hot mess? Did you code this with your eyes closed? 🔥💀"

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

### OpenAI Chat Completions
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Model**: `gpt-4o` (chat, roasts, teacher mode) / `gpt-4.1` (Lens Mode)
- **Temperature**: 0.9 (for sassy responses)
- **Max Tokens**: 80 (chat) / 120 (teacher & Lens Mode)

## ⏱️ Rate Limiting

TalkBack has built-in rate limiting to stay within API quotas:
- **OpenAI**: 22-second cooldown between calls
- **Speech-to-Text**: 5-second cooldown between calls
- **Rate limit backoff**: 25-second pause when rate-limited
- Requests are queued and retried automatically

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

### Not Hearing Your Speech?
- Check microphone permissions (System Settings → Privacy & Security → Microphone)
- Verify ElevenLabs API key is valid
- Ensure your mic is working — TalkBack uses continuous listening, so just speak normally

### Lens Mode Not Working?
- Grant Accessibility permissions (System Settings → Privacy & Security → Accessibility)
- Ensure the app is added to the allowed list

### Rate Limit Errors?
- OpenAI usage limits: Check your account for current limits
- Add payment method or wait for the built-in 22-second cooldown to elapse

### Crashes on Launch?
- Compile with explicit target: `-target arm64-apple-macosx13.0`
- Check Swift version: `swift --version`
- Beta macOS can be unstable with Speech framework

## 📝 Development Notes

This project was developed on **macOS 26.0.1 beta** with **Swift 6.2**, which required special handling:
- Explicit compilation target (`-target arm64-apple-macosx13.0`)
- Avoided unstable `SFSpeechRecognizer` framework
- Used ElevenLabs STT instead of macOS built-in speech recognition
- Continuous listening via `AVAudioEngine` with voice activity detection
- Prioritized `NSSound` over `AVAudioPlayer` for better MP3 compatibility

## 📚 Additional Documentation

- [`API_KEY_SETUP.md`](API_KEY_SETUP.md) — Detailed API key configuration guide
- [`MCP_INTEGRATION.md`](MCP_INTEGRATION.md) — MCP integration architecture
- [`MCP_SETUP.md`](MCP_SETUP.md) — MCP server setup instructions
- [`QUICK_START.md`](QUICK_START.md) — Quick start guide

## 🔮 Future Features

- [ ] Vision-based behavior monitoring (webcam + Gemini)
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

