# TalkBack - Annoying But Useful AI Companion 🤖

A mischievous macOS floating avatar that acts as your sassy, helpful (but pushy) productivity coach. TalkBack is an interactive AI companion that listens to you, remembers your conversations, and responds with attitude-filled voice feedback — plus it can roast your broken code, summarize on-screen text, teach you coding concepts, and alert you about upcoming assignments.

## Table of Contents

- [🎯 Features](#-features)
- [🛠️ Tech Stack](#️-tech-stack)
- [🚀 Quick Start](#-quick-start)
- [🎮 How to Use](#-how-to-use)
- [🔍 TalkBack Lens](#-talkback-lens)
- [👩‍🏫 Coding Teacher Mode](#-coding-teacher-mode)
- [📬 Assignment Alerts](#-assignment-alerts)
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

### 🔥 **MCP Code Monitor** (Cursor IDE Integration)
- **Watches your terminal for code execution results**
- **Auto-roasts you when you mess up!**
  - 🔥 **2+ errors**: Full savage roast mode
  - 😏 **1 error**: Light sass and sarcasm
  - 💅 **Success**: Sassy compliment with attitude
- Integrates with Cursor IDE workflow
- Real-time feedback via Ivanna's voice

### 🔍 **TalkBack Lens** (Accessibility Text Summarizer)
- Hover over any text on screen and get an AI-powered summary or concise rewrite
- Toggle via the menu-bar icon or hold **⌥ Option** for a temporary lens
- Uses **GPT-4.1** for fast, accurate summarization
- Requires macOS Accessibility permission

### 👩‍🏫 **Coding Teacher Mode**
- When enabled, MCP results are handled by a supportive coding teacher persona
- Successful runs get a brief celebration and a suggested next step
- Failed runs get a diagnosis, explanation, and actionable fix — with light sass
- Toggle from the menu-bar status item

### 📬 **Assignment Alerts** (Mail.app Integration)
- Monitors your macOS Mail.app inbox for assignment-related emails
- Detects keywords like *assignment*, *homework*, *due*, *quiz*, *exam*, etc.
- Recognizes `.edu`, Canvas, and Blackboard sender domains
- Summarizes the email and highlights due dates via OpenAI
- Checks every 3 minutes; toggle from the menu-bar status item

### 👁️ **Vision-Based Behavior Monitoring** *(Planned)*
- Gemini API key slot is included in the config for future vision features
- Planned capabilities:
  - 👀 Detecting when you look away from the screen
  - 😊😤😐 Emotion recognition (happy, frustrated, confused)
  - 🧐 Focus level tracking
  - 📱 Phone usage detection

## 🛠️ Tech Stack

- **Language**: Swift 6.2
- **Framework**: AppKit (native macOS)
- **AI & Voice Services**:
  - [OpenAI GPT-4o](https://platform.openai.com/) — Conversational AI & code roasts
  - [OpenAI GPT-4.1](https://platform.openai.com/) — Lens summarization
  - [Gemini](https://aistudio.google.com/) — Vision & behavior analysis *(planned)*
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) — Voice recognition
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) — Voice synthesis (Ivanna voice)
- **Audio & Video**: AVFoundation (NSSound, AVAudioRecorder, AVCaptureSession)
- **Accessibility**: ApplicationServices (AXUIElement) for Lens mode

## 🚀 Quick Start

### Prerequisites

1. **macOS 13.0+** (developed on macOS 26.0.1 beta)
2. **Xcode Command Line Tools** installed
3. **API Keys**:
   - OpenAI API key ([Get one here](https://platform.openai.com/account/api-keys))
   - ElevenLabs API key ([Get one here](https://elevenlabs.io/))
   - Gemini API key ([Get one here](https://aistudio.google.com/app/apikey)) *(optional — for future vision features)*

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

5. **Grant permissions** when prompted:
   - **Microphone** — for voice interaction
   - **Accessibility** — for TalkBack Lens (optional)
   - **Camera** — for future vision monitoring (optional)

## 🎮 How to Use

### Basic Voice Chat

1. **Start the App**: Run `./ConversationalTalkBack`
2. **Talk to TalkBack**:
   - **Click and HOLD** the avatar
   - **Speak** your message
   - **Release** to send
3. **Listen**: TalkBack responds with Ivanna's voice and attitude
4. **Drag**: Move the avatar anywhere on your screen
5. **Quit**: Drag avatar near the menu bar → drop in trash can

### 🔥 MCP Code Monitoring (Cursor IDE Integration)

TalkBack can watch your terminal and roast you when your code fails! Here's how:

1. **Start TalkBack** (it automatically monitors `/tmp/talkback_message.yaml`)

2. **Install the Python dependency**:
   ```bash
   pip3 install watchdog
   ```

3. **Run your code through the monitor**:
   ```bash
   python3 cursor_code_monitor.py run 'python3 your_broken_script.py'

   python3 cursor_code_monitor.py run 'python3 your_working_script.py'

   python3 cursor_code_monitor.py run 'swift your_code.swift'
   ```

4. **TalkBack will roast you based on errors**:
   - ✅ **0 errors**: "Oh wow, it ACTUALLY worked? Color me shocked, darling! 💅✨"
   - 😏 **1 error**: "ONE error? Cute. At least you're almost there, sweetheart. 😏"
   - 🔥 **2+ errors**: "Oh HONEY, what is this hot mess? Did you code this with your eyes closed? 🔥💀"

5. **Example test**:
   ```bash
   python3 cursor_code_monitor.py run 'python3 broken_code.py'
   ```

### 🔌 MCP Connection Test

Verify the IPC channel between Python scripts and TalkBack:
```bash
python3 test_mcp_connection.py
```

## 🔍 TalkBack Lens

TalkBack Lens uses macOS Accessibility APIs to read text under your cursor and summarize or rewrite it with AI.

### Activation
- **Menu bar** → click the 🔍 viewfinder icon → toggle **Lens Mode** on
- **Hold ⌥ Option** anywhere for a temporary lens (releases when you let go)

### Actions
| Button | What it does |
|---|---|
| **Summarize** | 2-sentence summary of the hovered text |
| **Concise** | Shorter rewrite preserving key meaning |

### Requirements
- macOS Accessibility permission (System Settings → Privacy & Security → Accessibility)
- Valid OpenAI API key

## 👩‍🏫 Coding Teacher Mode

When Coding Teacher Mode is enabled, MCP code-execution results are handled by a supportive teacher persona instead of the default roast persona.

- **Success** → brief celebration, what the result means, and a suggested next step
- **Failure** → diagnosis of likely causes, explanation of what went wrong, and 1–2 actionable fixes

Toggle from the menu-bar status item → **Coding Teacher Mode**. Enabled by default.

## 📬 Assignment Alerts

TalkBack can monitor your macOS Mail.app inbox and alert you when it detects assignment-related emails.

### How it works
1. Toggle **Assignment Alerts** from the menu-bar status item
2. TalkBack checks your inbox every 3 minutes via AppleScript
3. Emails matching keywords (`assignment`, `homework`, `due`, `quiz`, `exam`, `project`, `submission`, `paper`, `essay`, `lab`) or sender domains (`.edu`, `canvas`, `blackboard`) trigger an alert
4. TalkBack summarizes the email, highlights due dates, and suggests a next action

### Requirements
- macOS Mail.app configured with your email account
- Automation permission for Mail.app (granted on first use)

## 📂 Project Structure

| File | Purpose |
|---|---|
| `ConversationalTalkBack.swift` | Main app — floating avatar, voice chat, Lens, teacher mode, assignment alerts, MCP polling |
| `config.swift.template` | API key template (copy to `config.swift` and add your keys) |
| `cursor_code_monitor.py` | Standalone code monitor — wraps commands and writes roast triggers to `/tmp/talkback_message.yaml` |
| `cursor_mcp_server.py` | MCP server for Cursor IDE integration (stdio transport) |
| `test_mcp_connection.py` | Quick test to verify `/tmp/talkback_message.yaml` IPC works |
| `broken_code.py` | Intentionally broken script for testing roast triggers |
| `start_talkback_mcp.sh` | Compiles and launches TalkBack with MCP support |
| `start_integration.sh` | Sets up venv and verifies MCP connection |
| `mcp_config.json` | Cursor IDE MCP server configuration |
| `cline_mcp_settings.json` | Cline MCP client settings |
| `tests/` | Unit tests for the MCP server, code monitor, and shared YAML utilities |

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
- **Model**: `gpt-4o` (conversation, roasts, teacher mode, assignment summaries) / `gpt-4.1` (Lens)
- **Temperature**: 0.9 for conversation, 0.3 for Lens
- **Max Tokens**: 80 (conversation) / 120 (Lens)

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
- 👩‍🏫 **Supportive**: Switches to a teaching persona when Coding Teacher Mode is on

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
- OpenAI has a built-in 22-second cooldown between requests
- Check your OpenAI account for current usage limits
- Add a payment method or wait between requests

### Missing `config.swift`?
- Copy the template: `cp config.swift.template config.swift`
- Add your API keys to `config.swift`

### MCP Roasts Not Triggering?
- Ensure TalkBack is running (it polls `/tmp/talkback_message.yaml` every 0.5s)
- Run commands through the monitor: `python3 cursor_code_monitor.py run "YOUR_COMMAND"`
- Check that `watchdog` is installed: `pip3 install watchdog`

### Lens Mode Not Working?
- Grant Accessibility permission: System Settings → Privacy & Security → Accessibility → enable TalkBack
- Ensure your OpenAI API key is set in `config.swift`
- Try holding **⌥ Option** to activate temporary lens

### Assignment Alerts Not Appearing?
- Ensure Mail.app is running and has messages in the inbox
- Grant Automation permission for Mail.app when prompted
- Toggle Assignment Alerts on from the menu-bar status item

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
- IPC between Python scripts and the Swift app uses `/tmp/talkback_message.yaml` (JSON-encoded despite the `.yaml` extension)

### Running Tests

```bash
python3 -m pytest tests/ -v
```

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
