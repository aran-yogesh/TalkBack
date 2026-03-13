# TalkBack - Annoying But Useful AI Companion 🤖

A mischievous macOS floating avatar that acts as your sassy, helpful (but pushy) productivity coach. TalkBack is an interactive AI companion that listens to you, remembers your conversations, and responds with attitude-filled voice feedback.

## Table of Contents

- [🎯 Features](#-features)
- [🛠️ Tech Stack](#️-tech-stack)
- [🚀 Quick Start](#-quick-start)
- [🎮 How to Use](#-how-to-use)
- [📂 Project Structure](#-project-structure)
- [📋 API Endpoints Used](#-api-endpoints-used)
- [📚 Additional Documentation](#-additional-documentation)
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

### 🎤 **Real Voice Interaction**
- **Continuous listening** — TalkBack is always listening for your voice (hands-free)
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

### 👁️ **Vision-Based Behavior Monitoring** *(Planned)*
- Gemini API key slot is included in the config for future vision features
- Planned capabilities:
  - 👀 Detecting when you look away from the screen
  - 😊😤😐 Emotion recognition (happy, frustrated, confused)
  - 🧐 Focus level tracking
  - 📱 Phone usage detection

### 🔥 **MCP Code Monitor** (Cursor IDE Integration)
- **Watches your terminal for code execution results**
- **Auto-roasts you when you mess up!**
  - 🔥 **2+ errors**: Full savage roast mode
  - 😏 **1 error**: Light sass and sarcasm
  - 💅 **Success**: Sassy compliment with attitude
- Integrates with Cursor IDE workflow
- Real-time feedback via Ivanna's voice

### 👩‍🏫 **Coding Teacher Mode**
- Toggle from the menu bar — TalkBack reviews every command you run
- On **success**: celebrates briefly, explains the result, suggests a next step
- On **failure**: diagnoses the error, teaches what went wrong, gives actionable fixes
- Powered by GPT-4o with a supportive-but-sassy teaching personality

### 🔍 **TalkBack Lens** (AI Text Summarizer)
- Menu bar icon (🔍) to toggle Lens mode on/off
- Hold **⌥ Option** for temporary Lens activation
- Hover over any text on screen — TalkBack reads it via macOS Accessibility APIs
- **Summarize**: get a 2-sentence summary of the text under your cursor
- **Make Concise**: rewrite verbose text into a shorter version
- Results cached per element to avoid redundant API calls
- Powered by GPT-4.1

### 📬 **Assignment Email Alerts**
- Monitors Apple Mail for assignment-related emails (homework, projects, due dates, exams)
- Toggle from the menu bar — checks every 3 minutes
- TalkBack announces new assignment emails with a sassy nudge via voice

## 🛠️ Tech Stack

- **Language**: Swift 6.2
- **Framework**: AppKit (native macOS)
- **AI & Voice Services**:
  - [OpenAI GPT-4o](https://platform.openai.com/) — Conversational AI, roasts, and teaching feedback
  - [OpenAI GPT-4.1](https://platform.openai.com/) — Lens text summarization
  - [Gemini](https://aistudio.google.com/) — Vision & behavior analysis *(planned)*
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) — Voice recognition (Scribe v1)
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) — Voice synthesis (Ivanna voice)
- **macOS Integration**: Accessibility APIs (Lens), AppleScript/Mail.app (assignment alerts)
- **Audio**: AVFoundation (NSSound, AVAudioEngine for continuous listening)

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
   
   > **Note**: `config.swift` is gitignored so your keys stay local. Never commit real API keys. See [`API_KEY_SETUP.md`](API_KEY_SETUP.md) for more details.

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
2. **Grant Permissions**: Allow microphone access when prompted (camera if vision features are enabled)
3. **Talk to TalkBack**: Continuous listening is active by default — just speak and TalkBack will hear you
4. **Listen**: TalkBack responds with Ivanna's voice and attitude
5. **Drag**: Move the avatar anywhere on your screen
6. **Quit**: Drag avatar near the menu bar → drop in trash can

### Menu Bar Controls

TalkBack adds a **Lens** icon (🔍) to the menu bar with these toggles:

- **Lens Mode** — enable/disable the AI text summarizer (or hold **⌥ Option** for temporary activation)
- **Coding Teacher Mode** — enable/disable teaching feedback on command results
- **Assignment Alerts** — enable/disable Apple Mail assignment monitoring

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
| `ConversationalTalkBack.swift` | Main app — floating avatar, voice chat, Lens, teacher mode, MCP polling |
| `config.swift.template` | API key template (copy to `config.swift` and add your keys) |
| `cursor_code_monitor.py` | Standalone code monitor — wraps commands and writes roast triggers |
| `cursor_mcp_server.py` | MCP server for Cursor IDE integration (stdio transport) |
| `test_mcp_connection.py` | Quick test to verify `/tmp/talkback_message.json` IPC works |
| `broken_code.py` | Intentionally broken script for testing roast triggers |
| `start_talkback_mcp.sh` | Compiles and launches TalkBack with MCP support |
| `start_integration.sh` | Sets up venv and verifies MCP connection |
| `mcp_config.json` | Cursor IDE MCP server configuration |
| `cline_mcp_settings.json` | Cline/Cursor MCP auto-start configuration |
| `AGENTS.md` | Guidelines for AI coding agents working in this repo |

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
- **Temperature**: 0.9 (for sassy responses)
- **Max Tokens**: 80 (short, snappy replies)

### OpenAI GPT-4.1 (Lens Summarization)
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Model**: `gpt-4.1`
- **Temperature**: 0.3 (for accurate summaries)
- **Max Tokens**: 120

### Gemini (Vision) — *Planned*
- **Endpoint**: `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent`
- A Gemini API key slot is included in `config.swift.template` for future vision-based behavior monitoring

## 📚 Additional Documentation

| Document | Description |
|---|---|
| [`API_KEY_SETUP.md`](API_KEY_SETUP.md) | Detailed guide for configuring and securing API keys |
| [`MCP_INTEGRATION.md`](MCP_INTEGRATION.md) | Architecture diagram, roast levels, error detection patterns, and technical details |
| [`MCP_SETUP.md`](MCP_SETUP.md) | Step-by-step MCP + Cursor IDE integration setup |
| [`MCP_SETUP_COMPLETE.md`](MCP_SETUP_COMPLETE.md) | End-to-end MCP configuration, verification, and troubleshooting |
| [`QUICK_START.md`](QUICK_START.md) | Condensed quick-start guide using convenience scripts |

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
- Speak clearly — continuous listening detects voice activity automatically
- Check microphone permissions (System Settings → Privacy & Security → Microphone)
- Verify ElevenLabs API key is valid

### Rate Limit Errors?
- OpenAI usage limits: Check your account for current limits
- Add payment method or wait 20 seconds between requests

### Missing `config.swift`?
- Copy the template: `cp config.swift.template config.swift`
- Add your API keys to `config.swift`

### MCP Roasts Not Triggering?
- Ensure TalkBack is running (it polls `/tmp/talkback_message.json` every 0.5s)
- Run commands through the monitor: `python3 cursor_code_monitor.py run "YOUR_COMMAND"`
- Check that `watchdog` is installed: `pip3 install watchdog`

### Lens Mode Not Working?
- Grant Accessibility permissions: System Settings → Privacy & Security → Accessibility → allow your terminal or the app
- Ensure OpenAI API key is set in `config.swift` (Lens uses GPT-4.1)
- Hold **⌥ Option** to temporarily activate Lens without toggling the menu

### Assignment Alerts Not Appearing?
- Ensure Apple Mail is running and has messages in the inbox
- Grant Automation permissions: System Settings → Privacy & Security → Automation → allow access to Mail
- Alerts check every 3 minutes — wait for the next cycle or toggle off/on to trigger an immediate check

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

- [ ] Gemini vision-based behavior monitoring (webcam gaze/emotion detection)
- [ ] Screen monitoring (detect what user is doing)
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

