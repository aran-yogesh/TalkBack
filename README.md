# TalkBack - Annoying But Useful AI Companion 🤖

A mischievous macOS floating avatar that acts as your sassy, helpful (but pushy) productivity coach. TalkBack is an interactive AI companion that listens to you, remembers your conversations, and responds with attitude-filled voice feedback.

## Table of Contents

- [🎯 Features](#-features)
- [🛠️ Tech Stack](#️-tech-stack)
- [🚀 Quick Start](#-quick-start)
- [🎮 How to Use](#-how-to-use)
- [📂 Project Structure](#-project-structure)
- [📋 API Endpoints Used](#-api-endpoints-used)
- [🎭 Personality](#-personality)
- [🐛 Troubleshooting](#-troubleshooting)
- [📝 Development Notes](#-development-notes)
- [📚 Additional Documentation](#-additional-documentation)
- [🔮 Future Features](#-future-features)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)
- [🙏 Acknowledgments](#-acknowledgments)
- [💬 Questions or Feedback?](#-questions-or-feedback)


![macOS](https://img.shields.io/badge/macOS-26.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 🎯 Features

### 🎤 **Real Voice Interaction**
- **Always-on microphone** with voice activity detection — just start talking
- **ElevenLabs Speech-to-Text** (`scribe_v1`) for accurate voice recognition
- Supports multiple languages (English, Bengali, Hindi, and more!)
- Automatic silence detection (2s threshold) triggers transcription
- Smart amplitude filtering to ignore background noise

### 🗣️ **Sassy AI Responses**
- **OpenAI GPT-4o** powered responses
- **ElevenLabs Text-to-Speech** (`eleven_multilingual_v2`) with Ivanna's voice
- Attitude-filled, personality-driven replies
- Short, snappy responses (80 token limit) that pack a punch
- Built-in rate limiting and 429 backoff handling

### 🧠 **Conversational Memory**
- Remembers your last 6 exchanges (12 messages)
- Maintains context across conversations
- Smart follow-ups based on previous interactions

### 🎨 **Custom Floating Avatar**
- Transparent floating window (always on top)
- Custom purse/wallet icon design
- Animated eyes that follow your cursor
- Bouncing zigzag motion across the screen (pauses during recording)
- Dynamic expressions based on mood
- Draggable anywhere on your screen

### 🗑️ **"The Great Escape" Feature**
- Drag avatar near the menu bar to reveal trash can
- Drop in trash to quit (the only way to close it!)
- Adds a fun, mischievous interaction

### 🔍 **Lens Mode** (Accessibility Overlay)
- Reads text under your cursor via macOS Accessibility APIs
- **Summarize** or **Make Concise** any on-screen text with one click
- Powered by **OpenAI GPT-4.1** for high-quality summarization
- Toggle from the menu bar status item or hold the Option key
- Smart caching to avoid redundant API calls

### 📚 **Teaching Assistant Mode**
- Analyzes command output (success or failure) and provides educational feedback
- Toggleable from the menu bar status item
- Uses a lower temperature (0.6) for more focused, instructional responses

### 📧 **Assignment Email Alerts**
- Monitors macOS Mail.app via AppleScript for assignment-related emails
- Keyword and domain matching to detect relevant messages
- AI-powered summaries of detected assignments
- Checks every 3 minutes in the background

### 😴 **Idle Activity Monitoring**
- Sends sassy idle messages after 60 seconds of inactivity
- Keeps you on your toes with attitude-filled nudges

### 🔥 **MCP Code Monitor** (Cursor IDE Integration)
- **Watches your terminal for code execution results**
- **Auto-roasts you when you mess up!**
  - 🔥 **2+ errors**: Full savage roast mode
  - 😏 **1 error**: Light sass and sarcasm
  - 💅 **Success**: Sassy compliment with attitude
- Polls `/tmp/talkback_message.json` every 0.5 seconds
- Integrates with Cursor IDE workflow
- Real-time feedback via Ivanna's voice

### 👁️ **Vision-Based Behavior Monitoring** *(Planned)*
- Gemini API key slot is included in the config for future vision features
- Planned capabilities:
  - 👀 Detecting when you look away from the screen
  - 😊😤😐 Emotion recognition (happy, frustrated, confused)
  - 🧐 Focus level tracking
  - 📱 Phone usage detection

## 🛠️ Tech Stack

- **Language**: Swift 6.2
- **Frameworks**: Cocoa, AppKit, Foundation, AVFoundation, ApplicationServices
- **AI & Voice Services**:
  - [OpenAI GPT-4o](https://platform.openai.com/) — Conversational AI and roast generation
  - [OpenAI GPT-4.1](https://platform.openai.com/) — Lens mode summarization
  - [Gemini](https://aistudio.google.com/) — Vision & behavior analysis *(planned)*
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) — Voice recognition (`scribe_v1`)
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) — Voice synthesis (`eleven_multilingual_v2`, Ivanna voice)
- **Audio**: AVFoundation (AVAudioEngine, NSSound)
- **Accessibility**: ApplicationServices (AXUIElement APIs for Lens mode)
- **MCP Integration**: Python-based code monitor and MCP server (stdio transport)

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
   
   Copy the template and add your keys:
   ```bash
   cp config.swift.template config.swift
   ```
   
   Edit `config.swift` with your actual API keys:
   ```swift
   struct Config {
       static let openAIAPIKey = "YOUR_OPENAI_API_KEY_HERE"
       static let elevenLabsAPIKey = "YOUR_ELEVENLABS_API_KEY_HERE"
       static let elevenLabsVoiceID = "cgSgspJ2msm6clMCkdW9"  // Ivanna's voice
       static let geminiAPIKey = "YOUR_GEMINI_API_KEY_HERE"
   }
   ```
   
   > **Note**: `config.swift` is gitignored so your keys stay local. Never commit real API keys.

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
2. **Grant Microphone Permission**: Allow microphone access when prompted
3. **Talk to TalkBack**: Just start speaking — continuous listening is always on
   - Voice activity detection picks up your speech automatically
   - 2 seconds of silence triggers transcription and a response
4. **Listen**: TalkBack responds with Ivanna's voice and attitude
5. **Drag**: Move the avatar anywhere on your screen
6. **Lens Mode**: Hold **Option** or toggle from the menu bar to summarize on-screen text
7. **Teaching Mode**: Toggle from the menu bar for educational feedback on command output
8. **Quit**: Drag avatar near the menu bar → drop in trash can

### 🔥 MCP Code Monitoring (Cursor IDE Integration)

TalkBack can watch your terminal and roast you when your code fails! Here's how:

1. **Start TalkBack** (it automatically monitors `/tmp/talkback_message.json`)

2. **Run your code through the monitor**:
   ```bash
   # Test with a script that has errors (will trigger full roast 🔥)
   python3 cursor_code_monitor.py run 'python3 your_broken_script.py'
   
   # Test with successful code (will get sassy compliment 💅)
   python3 cursor_code_monitor.py run 'python3 your_working_script.py'
   
   # Test with any command
   python3 cursor_code_monitor.py run 'swift your_code.swift'
   ```

3. **TalkBack will roast you based on errors**:
   - ✅ **0 errors**: "Oh wow, it ACTUALLY worked? Color me shocked, darling! 💅✨"
   - 😏 **1 error**: "ONE error? Cute. At least you're almost there, sweetheart. 😏"
   - 🔥 **2+ errors**: "Oh HONEY, what is this hot mess? Did you code this with your eyes closed? 🔥💀"

4. **Example test**:
   ```bash
   # This will trigger a savage roast
   python3 cursor_code_monitor.py run 'python3 broken_code.py'
   
   # TalkBack will speak the roast with Ivanna's voice!
   ```

## 📂 Project Structure

| File | Purpose |
|---|---|
| `ConversationalTalkBack.swift` | Main app — floating avatar, voice chat, Lens mode, teaching mode, MCP polling |
| `config.swift.template` | API key template (copy to `config.swift` and add your keys) |
| `cursor_code_monitor.py` | Standalone code monitor — wraps commands, detects errors, and writes roast triggers |
| `cursor_mcp_server.py` | MCP server for Cursor IDE integration (stdio transport, exposes 2 tools + 2 resources) |
| `test_mcp_connection.py` | Quick smoke test to verify `/tmp/talkback_message.json` IPC works |
| `broken_code.py` | Intentionally broken script (3 errors) for testing roast triggers |
| `start_talkback_mcp.sh` | Compiles and launches TalkBack with MCP support, installs Python deps |
| `start_integration.sh` | Sets up venv, verifies MCP connection, prints next steps |
| `mcp_config.json` | Cursor IDE MCP server configuration |
| `cline_mcp_settings.json` | Cline extension MCP server configuration |
| `QUICK_START.md` | Beginner-friendly 3-step launch guide |
| `MCP_SETUP.md` | Step-by-step MCP integration setup |
| `MCP_SETUP_COMPLETE.md` | Detailed MCP setup with verification and troubleshooting |
| `MCP_INTEGRATION.md` | Full MCP architecture, workflows, and shell alias examples |
| `API_KEY_SETUP.md` | Dedicated API key configuration guide |

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

### OpenAI GPT-4o (Chat & Roasts)
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Model**: `gpt-4o`
- **Temperature**: 0.9 (for sassy responses), 0.6 (teaching mode), 0.7 (assignment summaries)
- **Max Tokens**: 80 (chat/roasts), 120 (teaching/assignments)

### OpenAI GPT-4.1 (Lens Mode)
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Model**: `gpt-4.1`
- **Temperature**: 0.3 (for precise summarization)
- **Max Tokens**: 120

### Gemini (Vision) — *Planned*
- **Endpoint**: `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent`
- A Gemini API key slot is included in `config.swift.template` for future vision-based behavior monitoring

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
- Speak clearly — the amplitude threshold filters out quiet background noise
- Check microphone permissions (System Settings → Privacy & Security → Microphone)
- Verify ElevenLabs API key is valid
- Wait for the 2-second silence gap to trigger transcription

### Rate Limit Errors?
- OpenAI usage limits: Check your account for current limits
- The app enforces a 22-second cooldown between OpenAI calls and a 25-second backoff on HTTP 429
- Add a payment method to your OpenAI account if you hit free-tier limits

### Missing `config.swift`?
- Copy the template: `cp config.swift.template config.swift`
- Add your API keys to `config.swift`

### MCP Roasts Not Triggering?
- Ensure TalkBack is running (it polls `/tmp/talkback_message.json` every 0.5s)
- Run commands through the monitor: `python3 cursor_code_monitor.py run "YOUR_COMMAND"`
- Check that `watchdog` is installed: `pip3 install watchdog`

### Lens Mode Not Working?
- Grant Accessibility permissions (System Settings → Privacy & Security → Accessibility)
- Ensure `AXIsProcessTrusted()` returns true (the app will prompt on first use)
- Hold the **Option** key or toggle Lens from the menu bar status item

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

## 📚 Additional Documentation

| Document | Description |
|---|---|
| [QUICK_START.md](QUICK_START.md) | 3-step beginner guide to launching TalkBack with MCP roasting |
| [API_KEY_SETUP.md](API_KEY_SETUP.md) | Detailed API key configuration walkthrough |
| [MCP_SETUP.md](MCP_SETUP.md) | Step-by-step MCP integration setup |
| [MCP_SETUP_COMPLETE.md](MCP_SETUP_COMPLETE.md) | Full MCP setup with verification steps and troubleshooting |
| [MCP_INTEGRATION.md](MCP_INTEGRATION.md) | Architecture overview, shell aliases, and Cursor IDE workflow integration |

## 🔮 Future Features

- [ ] Gemini vision-based behavior monitoring (webcam gaze/emotion detection)
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
- **Google** for Gemini API (planned vision features)
- **ElevenLabs** for Speech-to-Text and Text-to-Speech APIs
- **Ivanna** for the sassy voice that brings TalkBack to life

## 💬 Questions or Feedback?

Open an issue or reach out! TalkBack loves to chat (obviously). 😉

---

**Made with 💻 and a lot of sass** by [@aran-yogesh](https://github.com/aran-yogesh)

