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
- [🔮 Future Features](#-future-features)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)
- [🙏 Acknowledgments](#-acknowledgments)
- [💬 Questions or Feedback?](#-questions-or-feedback)

![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 🎯 Features

### 🎤 **Continuous Voice Interaction**
- **Always-on listening** via `AVAudioEngine` with voice activity detection — just start talking
- **ElevenLabs Speech-to-Text** (`scribe_v1`) for accurate voice recognition
- Supports multiple languages (English, Bengali, Hindi, and more!)
- Smart silence detection (2-second threshold) and multi-layer noise filtering
- Rate-limited STT with a 5-second cooldown between requests

### 🗣️ **Sassy AI Responses**
- **OpenAI GPT-4o** powered responses with conversation history (last 6 exchanges)
- **ElevenLabs Text-to-Speech** (`eleven_multilingual_v2`) with Ivanna's voice
- Attitude-filled, personality-driven replies
- Short, snappy responses (max 80 tokens) that pack a punch
- Built-in rate limiting (22-second cooldown) and HTTP 429 backoff handling

### 🧠 **Conversational Memory**
- Remembers your chat history (last 6 exchanges / 12 messages)
- Maintains context across conversations
- Smart follow-ups based on previous interactions

### 🎨 **Custom Floating Avatar**
- Transparent floating window (always on top, joins all spaces)
- Custom purse/wallet icon design
- Animated eyes that follow your cursor
- Dynamic expressions based on mood (listening, thinking, happy)
- Draggable anywhere on your screen
- Bouncing zigzag floating motion when idle (~33 FPS, resumes 5 seconds after interaction)
- Sassy idle messages after 60 seconds of inactivity

### 🗑️ **"The Great Escape" Feature**
- Drag avatar near the menu bar to reveal trash can
- Drop in trash to quit (the only way to close it!)
- Adds a fun, mischievous interaction

### 🔍 **Lens Mode**
- **Summarize or condense any on-screen text** using the macOS Accessibility API
- Activate via the status bar menu (persistent) or hold ⌥ Option for temporary access
- Floating overlay with **Summarize** and **Make Concise** buttons
- Powered by **OpenAI GPT-4.1** (temperature 0.3) with result caching and a 2-second cooldown
- Polls every 0.6 seconds, reads text from the UI element under the cursor
- Requires Accessibility permission (`System Settings → Privacy & Security → Accessibility`)

### 🎓 **Coding Teacher Mode**
- Enabled by default — toggle from the status bar menu
- Analyzes command output from MCP events (success or failure)
- Provides teaching feedback: celebrates wins, diagnoses failures, and suggests next steps
- Uses GPT-4o (temperature 0.6, max 120 tokens) with context-specific system prompts

### 📧 **Assignment Email Monitoring**
- Monitors Mail.app inbox via AppleScript every 3 minutes (disabled by default)
- Detects academic emails by keyword (`assignment`, `homework`, `due`, `exam`, etc.) and domain matching (`.edu`, `canvas`, `blackboard`)
- Summarizes assignments with GPT-4o and speaks the summary aloud
- Deduplicates alerts so you only hear about each email once

### 🔥 **MCP Code Monitor** (Cursor IDE Integration)
- **Watches your terminal for code execution results** via `/tmp/talkback_message.yaml`
- **Auto-roasts you when you mess up!**
  - 🔥 **2+ errors**: Full savage roast mode
  - 😏 **1 error**: Light sass and sarcasm
  - 💅 **Success**: Sassy compliment with attitude
- Integrates with Cursor IDE workflow
- Real-time feedback via Ivanna's voice
- Polls the IPC file every 0.5 seconds with timestamp-based deduplication

### 📊 **Status Bar Menu**
- Menu bar icon (`viewfinder`) for quick access to settings
- Toggle **Lens Mode** and **Coding Teacher Mode**
- Option key hint for temporary Lens activation

### 👁️ **Vision-Based Behavior Monitoring** *(Planned)*
- Gemini API key slot is included in the config for future vision features
- Planned capabilities:
  - 👀 Detecting when you look away from the screen
  - 😊😤😐 Emotion recognition (happy, frustrated, confused)
  - 🧐 Focus level tracking
  - 📱 Phone usage detection

## 🛠️ Tech Stack

- **Language**: Swift 6.2
- **Framework**: AppKit (native macOS, no SwiftUI)
- **AI & Voice Services**:
  - [OpenAI GPT-4o](https://platform.openai.com/) — Conversational AI, roasts, teacher mode, assignment summaries
  - [OpenAI GPT-4.1](https://platform.openai.com/) — Lens mode summarization
  - [Gemini](https://aistudio.google.com/) — Vision & behavior analysis *(planned — API key slot reserved but not yet used)*
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) — Voice recognition (`scribe_v1`)
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) — Voice synthesis (`eleven_multilingual_v2`, Ivanna voice)
- **Audio**: AVFoundation (`AVAudioEngine` for continuous listening, `AVAudioPlayer` for TTS playback)
- **Accessibility**: macOS Accessibility API (`AXUIElement`) for Lens mode text extraction
- **MCP Integration**: Python-based MCP server and code monitor (`watchdog` + `mcp` packages)

## 🚀 Quick Start

### Prerequisites

1. **macOS 13.0+** (developed on macOS 26.0.1 beta)
2. **Xcode Command Line Tools** installed
3. **Python 3** (for MCP integration scripts)
4. **API Keys**:
   - OpenAI API key ([Get one here](https://platform.openai.com/account/api-keys))
   - ElevenLabs API key ([Get one here](https://elevenlabs.io/))
   - *(Optional)* Gemini API key ([Get one here](https://aistudio.google.com/app/apikey)) — reserved for future vision features

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
2. **Grant Permissions**:
   - Allow **microphone** access when prompted
   - Grant **Accessibility** access for Lens mode (`System Settings → Privacy & Security → Accessibility`)
3. **Talk to TalkBack**: Just start speaking — continuous listening with voice activity detection picks up your voice automatically
4. **Listen**: TalkBack responds with Ivanna's voice and attitude
5. **Drag**: Move the avatar anywhere on your screen
6. **Lens Mode**: Hold ⌥ Option to temporarily activate, or toggle from the status bar menu — hover over text to summarize or condense it
7. **Quit**: Drag avatar near the menu bar → drop in trash can

### 🔥 MCP Code Monitoring (Cursor IDE Integration)

TalkBack can watch your terminal and roast you when your code fails! Here's how:

1. **Start TalkBack** (it automatically monitors `/tmp/talkback_message.yaml`)

2. **Run your code through the monitor**:
   ```bash
   python3 cursor_code_monitor.py run 'python3 your_broken_script.py'
   
   python3 cursor_code_monitor.py run 'python3 your_working_script.py'
   
   python3 cursor_code_monitor.py run 'swift your_code.swift'
   ```

3. **TalkBack will roast you based on errors**:
   - ✅ **0 errors**: "Oh wow, it ACTUALLY worked? Color me shocked, darling! 💅✨"
   - 😏 **1 error**: "ONE error? Cute. At least you're almost there, sweetheart. 😏"
   - 🔥 **2+ errors**: "Oh HONEY, what is this hot mess? Did you code this with your eyes closed? 🔥💀"

4. **Example test**:
   ```bash
   python3 cursor_code_monitor.py run 'python3 broken_code.py'
   ```

5. **Test the IPC connection**:
   ```bash
   python3 test_mcp_connection.py
   ```

See [MCP_INTEGRATION.md](MCP_INTEGRATION.md) for the full integration guide, shell aliases, and Cursor IDE task configuration.

## 📂 Project Structure

| File | Purpose |
|---|---|
| `ConversationalTalkBack.swift` | Main app — floating avatar, voice chat, lens mode, teacher mode, email monitoring, MCP polling |
| `config.swift.template` | API key template (copy to `config.swift` and add your keys) |
| `cursor_code_monitor.py` | Standalone code monitor — wraps commands and writes roast triggers to `/tmp/talkback_message.yaml` |
| `cursor_mcp_server.py` | MCP server for Cursor IDE integration (stdio transport, exposes 2 tools + 2 resources) |
| `test_mcp_connection.py` | Quick test to verify `/tmp/talkback_message.yaml` IPC works |
| `broken_code.py` | Intentionally broken script for testing roast triggers (3 errors) |
| `start_talkback_mcp.sh` | Compiles and launches TalkBack with MCP support |
| `start_integration.sh` | Sets up venv and verifies MCP connection |
| `mcp_config.json` | Cursor IDE MCP server configuration |
| `cline_mcp_settings.json` | Cline/Cursor auto-start MCP server configuration |
| `tests/` | Unit tests for MCP server, YAML utilities, and code monitor |
| `MCP_INTEGRATION.md` | Full MCP integration guide with architecture, aliases, and examples |
| `MCP_SETUP.md` | MCP setup instructions and Cursor IDE configuration |
| `MCP_SETUP_COMPLETE.md` | Complete step-by-step MCP integration setup guide |
| `QUICK_START.md` | Quick-start guide for MCP code monitoring |
| `API_KEY_SETUP.md` | Detailed API key configuration guide |
| `AGENTS.md` | Guidelines for AI coding agents working in this repo |

## 📋 API Endpoints Used

### ElevenLabs Speech-to-Text
- **Endpoint**: `https://api.elevenlabs.io/v1/speech-to-text`
- **Model**: `scribe_v1`
- **Input**: WAV audio from AVAudioEngine (float32 → PCM16 conversion)
- **Output**: Transcribed text with language detection

### ElevenLabs Text-to-Speech
- **Endpoint**: `https://api.elevenlabs.io/v1/text-to-speech/{voice_id}`
- **Model**: `eleven_multilingual_v2`
- **Voice**: Ivanna (`cgSgspJ2msm6clMCkdW9`)
- **Output**: MP3 audio (played via `AVAudioPlayer`)

### OpenAI Chat Completions
- **Endpoint**: `https://api.openai.com/v1/chat/completions`

| Context | Model | Max Tokens | Temperature |
|---|---|---|---|
| General chat | `gpt-4o` | 80 | 0.9 |
| Code roasts | `gpt-4o` | 80 | 0.9 |
| Teacher mode | `gpt-4o` | 120 | 0.6 |
| Assignment summaries | `gpt-4o` | 120 | 0.7 |
| Lens mode | `gpt-4.1` | 120 | 0.3 |

### Gemini (Vision) — *Planned*
- A Gemini API key slot is included in `config.swift.template` for future vision-based behavior monitoring
- Not currently used in the codebase

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
- Speak clearly — voice activity detection requires amplitude above the silence threshold (`0.015`)
- Check microphone permissions (`System Settings → Privacy & Security → Microphone`)
- Verify ElevenLabs API key is valid
- Check for STT rate-limit cooldown (5-second minimum between requests)

### Rate Limit Errors?
- OpenAI has a 22-second cooldown between requests built in
- If you hit HTTP 429, TalkBack backs off for 25 seconds automatically
- Check your OpenAI account for usage limits

### Missing `config.swift`?
- Copy the template: `cp config.swift.template config.swift`
- Add your API keys to `config.swift`

### MCP Roasts Not Triggering?
- Ensure TalkBack is running (it polls `/tmp/talkback_message.yaml` every 0.5s)
- Run commands through the monitor: `python3 cursor_code_monitor.py run "YOUR_COMMAND"`
- Check that `watchdog` is installed: `pip3 install watchdog`
- Verify the IPC file: `python3 test_mcp_connection.py`

### Lens Mode Not Working?
- Grant Accessibility permission: `System Settings → Privacy & Security → Accessibility`
- Toggle Lens Mode from the status bar menu or hold ⌥ Option
- Ensure the app under the cursor exposes text via the Accessibility API
- Check that your OpenAI API key is valid (Lens uses GPT-4.1)

### Crashes on Launch?
- Compile with explicit target: `-target arm64-apple-macosx13.0`
- Check Swift version: `swift --version`
- Beta macOS can be unstable with Speech framework

## 📝 Development Notes

This project was developed on **macOS 26.0.1 beta** with **Swift 6.2**, which required special handling:
- Explicit compilation target (`-target arm64-apple-macosx13.0`)
- Avoided unstable `SFSpeechRecognizer` framework
- Used ElevenLabs STT instead of macOS built-in speech recognition
- Continuous listening via `AVAudioEngine` with amplitude-based voice activity detection
- Pure AppKit (no SwiftUI) for maximum compatibility
- IPC between Python scripts and Swift app uses `/tmp/talkback_message.yaml` (polled every 0.5s, JSON format despite `.yaml` extension)

## 🔮 Future Features

- [ ] Gemini vision-based behavior monitoring (webcam gaze/emotion detection) — API key slot already reserved
- [ ] Screen monitoring (detect what user is doing)
- [ ] Context-aware productivity tips
- [ ] Custom voice selection
- [ ] Multiple personality modes
- [ ] Scheduled check-ins
- [ ] Integration with calendar/reminders
- [ ] Git hook integration for pre-commit roasts
- [ ] Roast history and statistics tracking

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
