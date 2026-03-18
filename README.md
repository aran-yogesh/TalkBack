# TalkBack - Annoying But Useful AI Companion 🤖

A mischievous macOS floating avatar that acts as your sassy, helpful (but pushy) productivity coach. TalkBack is an interactive AI companion that listens to you, remembers your conversations, and responds with attitude-filled voice feedback.

## Table of Contents

- [🎯 Features](#-features)
- [🛠️ Tech Stack](#️-tech-stack)
- [🚀 Quick Start](#-quick-start)
- [🎮 How to Use](#-how-to-use)
- [📂 Project Structure](#-project-structure)
- [🧪 Running Tests](#-running-tests)
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

### 🎤 **Continuous Voice Interaction**
- **Always-on listening** — TalkBack continuously monitors your microphone and responds when you speak
- **ElevenLabs Speech-to-Text** for accurate voice recognition
- Supports multiple languages (English, Bengali, Hindi, and more!)
- Natural conversation flow with real-time transcription
- Automatic silence detection (stops listening after 2 seconds of silence)

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
- Bouncing zigzag floating motion when idle

### 🗑️ **"The Great Escape" Feature**
- Drag avatar near the menu bar to reveal trash can
- Drop in trash to quit (the only way to close it!)
- Adds a fun, mischievous interaction

### 👩‍🏫 **Coding Teacher Mode**
- Toggle on/off from the menu bar
- Watches terminal command results and provides teaching feedback
- On success: celebrates briefly, explains the result, suggests a next step
- On failure: diagnoses likely causes, teaches what went wrong, gives actionable next steps
- Powered by GPT-4o with a witty but supportive tone

### 🔍 **Lens Mode** (Accessibility-Powered Text Analysis)
- Activate from the menu bar or hold **⌥ Option** for temporary use
- Hover over any on-screen text to analyze it
- Two actions: **Summarize** and **Make Concise**
- Uses GPT-4.1 for fast, accurate text analysis
- Results are cached per element to avoid redundant API calls
- Requires Accessibility permission (System Settings → Privacy & Security → Accessibility)

### 📬 **Assignment Alerts** (Email Monitoring)
- Toggle on/off from the avatar menu
- Polls Apple Mail every 3 minutes for new assignment-related emails
- Detects keywords like "assignment", "homework", "due", "exam", etc.
- Recognizes educational domains (`.edu`, Canvas, Blackboard)
- Summarizes detected assignment emails using GPT-4o and speaks the summary aloud

### 🔥 **MCP Code Monitor** (Cursor IDE Integration)
- **Watches your terminal for code execution results**
- **Auto-roasts you when you mess up!**
  - 🔥 **2+ errors**: Full savage roast mode
  - 😏 **1 error**: Light sass and sarcasm
  - 💅 **Success**: Sassy compliment with attitude
- Communicates via `/tmp/talkback_message.yaml` (YAML-based IPC)
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
- **Frameworks**: AppKit (native macOS), AVFoundation, ApplicationServices (Accessibility API)
- **AI & Voice Services**:
  - [OpenAI GPT-4o](https://platform.openai.com/) — Conversational AI & teacher mode
  - [OpenAI GPT-4.1](https://platform.openai.com/) — Lens mode text analysis
  - [Gemini](https://aistudio.google.com/) — Vision & behavior analysis *(planned)*
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) — Voice recognition
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) — Voice synthesis (Ivanna voice)
- **Python**: MCP server, code monitor, and test scripts (requires `mcp`, `watchdog`)
- **Audio**: AVFoundation (NSSound, AVAudioRecorder, AVAudioEngine for continuous listening)

## 🚀 Quick Start

### Prerequisites

1. **macOS 13.0+** (developed on macOS 26.0.1 beta)
2. **Xcode Command Line Tools** installed
3. **Python 3** with `pip` (for MCP integration and code monitor)
4. **API Keys**:
   - OpenAI API key ([Get one here](https://platform.openai.com/account/api-keys))
   - ElevenLabs API key ([Get one here](https://elevenlabs.io/))
   - Gemini API key ([Get one here](https://aistudio.google.com/app/apikey)) *(optional — for planned vision features)*

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

3. **Install Python dependencies** (for MCP and code monitoring):
   ```bash
   pip3 install mcp watchdog
   ```

4. **Compile the app**:
   ```bash
   swiftc -o ConversationalTalkBack ConversationalTalkBack.swift \
     -framework Cocoa -framework Foundation -framework AVFoundation \
     -target arm64-apple-macosx13.0
   ```

5. **Run TalkBack**:
   ```bash
   ./ConversationalTalkBack
   ```

## 🎮 How to Use

### Basic Usage

1. **Start the App**: Run `./ConversationalTalkBack`
2. **Grant Permissions**: Allow microphone access when prompted. For Lens Mode, also grant Accessibility access (System Settings → Privacy & Security → Accessibility).
3. **Talk to TalkBack**: TalkBack uses continuous listening — just speak and it will pick up your voice automatically. It stops listening after 2 seconds of silence.
4. **Listen**: TalkBack responds with Ivanna's voice and attitude
5. **Drag**: Move the avatar anywhere on your screen
6. **Quit**: Drag avatar near the menu bar → drop in trash can

### 👩‍🏫 Coding Teacher Mode

Teacher Mode is enabled by default. Toggle it from the menu bar status item. When active, TalkBack watches terminal command results and provides teaching feedback with a witty tone.

### 🔍 Lens Mode

1. Click the **viewfinder** icon in the menu bar and enable **Lens Mode**, or hold **⌥ Option** for temporary activation.
2. Hover over any on-screen text — an overlay appears with a preview.
3. Choose **Summarize** or **Make Concise** to get a GPT-powered analysis.

### 📬 Assignment Alerts

Right-click the avatar to toggle assignment alerts. When enabled, TalkBack checks Apple Mail every 3 minutes for assignment-related emails and speaks a summary aloud.

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
   - ✅ **0 errors**: Sassy compliment with attitude 💅
   - 😏 **1 error**: Light sass and sarcasm
   - 🔥 **2+ errors**: Full savage roast mode

4. **Example test**:
   ```bash
   python3 cursor_code_monitor.py run 'python3 broken_code.py'
   ```

## 📂 Project Structure

| File | Purpose |
|---|---|
| `ConversationalTalkBack.swift` | Main app — floating avatar, voice chat, teacher mode, lens mode, assignment alerts, MCP polling |
| `config.swift.template` | API key template (copy to `config.swift` and add your keys) |
| `cursor_code_monitor.py` | Standalone code monitor — wraps commands and writes roast triggers to `/tmp/talkback_message.yaml` |
| `cursor_mcp_server.py` | MCP server for Cursor IDE integration (stdio transport) |
| `test_mcp_connection.py` | Quick test to verify `/tmp/talkback_message.yaml` IPC works |
| `broken_code.py` | Intentionally broken script for testing roast triggers |
| `start_talkback_mcp.sh` | Compiles and launches TalkBack with MCP support |
| `start_integration.sh` | Sets up venv and verifies MCP connection |
| `mcp_config.json` | Cursor IDE MCP server configuration |
| `cline_mcp_settings.json` | Cline MCP server configuration |
| `tests/` | Python unit tests for YAML utils, code monitor, and MCP server |
| `AGENTS.md` | Agent guide with project context and editing rules |

## 🧪 Running Tests

The `tests/` directory contains Python unit tests for the code monitor, MCP server, and shared YAML utilities:

```bash
python3 -m pytest tests/ -v
```

You can also verify the MCP IPC file is working:

```bash
python3 test_mcp_connection.py
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

### OpenAI GPT-4o (Chat & Teacher Mode)
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Model**: `gpt-4o`
- **Temperature**: 0.9 (chat), 0.6 (teacher mode)
- **Max Tokens**: 80 (chat), 120 (teacher mode)

### OpenAI GPT-4.1 (Lens Mode)
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Model**: `gpt-4.1`
- **Temperature**: 0.3
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
- Check microphone permissions (System Settings → Privacy & Security → Microphone)
- Verify ElevenLabs API key is valid
- Ensure you're speaking clearly — TalkBack uses continuous listening with silence detection

### Rate Limit Errors?
- OpenAI usage limits: Check your account for current limits
- Add payment method or wait 20 seconds between requests

### Missing `config.swift`?
- Copy the template: `cp config.swift.template config.swift`
- Add your API keys to `config.swift`

### MCP Roasts Not Triggering?
- Ensure TalkBack is running (it polls `/tmp/talkback_message.yaml` every 0.5s)
- Run commands through the monitor: `python3 cursor_code_monitor.py run "YOUR_COMMAND"`
- Check that `watchdog` is installed: `pip3 install watchdog`

### Lens Mode Not Working?
- Grant Accessibility permission: System Settings → Privacy & Security → Accessibility
- Ensure Lens Mode is enabled from the menu bar viewfinder icon, or hold **⌥ Option**
- Verify your OpenAI API key is set in `config.swift`

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
- Uses `AVAudioEngine` for continuous listening with voice activity detection
- MCP IPC uses a lightweight YAML format written to `/tmp/talkback_message.yaml`
- Lens Mode leverages the macOS Accessibility API (`AXUIElement`) to read on-screen text
- Rate limiting is built in: 22-second cooldown between OpenAI calls, 5-second cooldown between STT calls

## 🔮 Future Features

- [ ] Gemini vision-based behavior monitoring (webcam gaze/emotion detection)
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
- **Google** for Gemini API (planned vision features)
- **ElevenLabs** for Speech-to-Text and Text-to-Speech APIs
- **Ivanna** for the sassy voice that brings TalkBack to life

## 💬 Questions or Feedback?

Open an issue or reach out! TalkBack loves to chat (obviously). 😉

---

**Made with 💻 and a lot of sass** by [@aran-yogesh](https://github.com/aran-yogesh)
