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


![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 🎯 Features

### 🎤 **Continuous Voice Interaction**
- **Always-on microphone** with automatic voice activity detection
- **ElevenLabs Speech-to-Text** for accurate voice recognition
- Silence detection automatically sends your message after 2 seconds of quiet
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
- Bouncing zigzag motion when idle

### 🗑️ **"The Great Escape" Feature**
- Drag avatar near the menu bar to reveal trash can
- Drop in trash to quit (the only way to close it!)
- Adds a fun, mischievous interaction

### 🔍 **TalkBack Lens** (Menu Bar)
- Toggle from the menu bar status icon or hold **⌥ Option** for temporary activation
- Hover over any on-screen text to get an overlay with two actions:
  - **Summarize** — condenses the text into key points
  - **Make Concise** — rewrites the passage in fewer words
- Powered by **OpenAI GPT-4.1** with result caching to avoid redundant API calls

### 👩‍🏫 **Coding Teacher Mode** (MCP Integration)
- Enabled by default; toggle from the menu bar
- When a monitored command finishes, TalkBack reviews the output and gives a short teaching moment:
  - ✅ **Success**: celebrates briefly, explains what the result means, suggests a next step
  - ❌ **Failure**: diagnoses likely causes, teaches what went wrong, gives actionable fixes
- Uses **GPT-4o** with a supportive-but-sassy coding teacher persona

### 📬 **Assignment Email Alerts**
- Monitors Apple Mail for assignment-related emails (homework, projects, exams, etc.)
- Checks every 3 minutes for new messages matching education keywords and domains (`.edu`, Canvas, Blackboard)
- Summarizes detected emails with course name, due dates, and suggested next actions via **GPT-4o**
- Speaks the summary aloud with Ivanna's voice

### 🔥 **MCP Code Monitor** (Cursor IDE Integration)
- **Watches your terminal for code execution results**
- **Auto-roasts you when you mess up!**
  - 🔥 **2+ errors**: Full savage roast mode
  - 😏 **1 error**: Light sass and sarcasm
  - 💅 **Success**: Sassy compliment with attitude
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
- **Frameworks**: AppKit (native macOS), AVFoundation, ApplicationServices (accessibility)
- **AI & Voice Services**:
  - [OpenAI GPT-4o / GPT-4.1](https://platform.openai.com/) — Conversational AI, Lens summarization
  - [Gemini](https://aistudio.google.com/) — Vision & behavior analysis *(planned)*
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) — Voice recognition
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) — Voice synthesis (Ivanna voice)
- **Audio**: AVFoundation (AVAudioEngine for continuous listening, NSSound for playback)

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

## 🎮 How to Use

### Basic Usage

1. **Start the App**: Run `./ConversationalTalkBack`
2. **Grant Permissions**: Allow microphone and camera access when prompted
3. **Talk to TalkBack**: The microphone is always on — just speak and TalkBack will detect your voice, then send the message after 2 seconds of silence
4. **Listen**: TalkBack responds with Ivanna's voice and attitude
5. **Drag**: Move the avatar anywhere on your screen
6. **Quit**: Drag avatar near the menu bar → drop in trash can

### 🔍 TalkBack Lens

1. Click the **viewfinder icon** in the menu bar to toggle Lens Mode on/off
2. Alternatively, **hold ⌥ Option** for temporary Lens activation
3. Hover over text on screen — an overlay appears with **Summarize** and **Make Concise** buttons
4. Click an action to get an AI-powered rewrite in the overlay

### 👩‍🏫 Coding Teacher Mode

Enabled by default. Toggle it from the menu bar icon → **Coding Teacher Mode**.

When TalkBack detects a command result via MCP, it provides a short teaching moment instead of (or in addition to) a roast.

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

### 📬 Assignment Email Alerts

Assignment alerts are off by default. When enabled, TalkBack checks Apple Mail every 3 minutes for emails matching education-related keywords (`assignment`, `homework`, `due`, `exam`, etc.) or domains (`.edu`, Canvas, Blackboard). Detected emails are summarized and spoken aloud.

## 📂 Project Structure

| File | Purpose |
|---|---|
| `ConversationalTalkBack.swift` | Main app — floating avatar, voice chat, Lens, teacher mode, assignment alerts, MCP polling |
| `config.swift.template` | API key template (copy to `config.swift` and add your keys) |
| `cursor_code_monitor.py` | Standalone code monitor — wraps commands and writes roast triggers to `/tmp/talkback_message.yaml` |
| `cursor_mcp_server.py` | MCP server for Cursor IDE integration (stdio transport) |
| `test_mcp_connection.py` | Quick test to verify `/tmp/talkback_message.yaml` IPC works |
| `broken_code.py` | Intentionally broken script for testing roast triggers |
| `start_talkback_mcp.sh` | Legacy starter script (references removed `MCPTalkBack.swift`) |
| `start_integration.sh` | Sets up venv and verifies MCP connection |
| `mcp_config.json` | Cursor IDE MCP server configuration |
| `cline_mcp_settings.json` | Cline IDE MCP server configuration |
| `package.json` | Node.js package metadata and dependencies |
| `tests/` | Unit tests for code monitor, MCP server, and YAML utilities |
| `QUICK_START.md` | Condensed getting-started guide |
| `API_KEY_SETUP.md` | Detailed API key configuration instructions |
| `MCP_SETUP.md` | MCP integration setup walkthrough |
| `MCP_INTEGRATION.md` | In-depth MCP architecture and usage reference |
| `MCP_SETUP_COMPLETE.md` | Post-setup verification checklist |

## 📋 API Endpoints Used

### ElevenLabs Speech-to-Text
- **Endpoint**: `https://api.elevenlabs.io/v1/speech-to-text`
- **Model**: `scribe_v1`
- **Input**: WAV audio (16 kHz, mono, PCM)
- **Output**: Transcribed text with language detection

### ElevenLabs Text-to-Speech
- **Endpoint**: `https://api.elevenlabs.io/v1/text-to-speech/{voice_id}`
- **Model**: `eleven_multilingual_v2`
- **Voice**: Ivanna (`cgSgspJ2msm6clMCkdW9`)
- **Output**: MP3 audio

### OpenAI Chat Completions
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Models used**:
  - `gpt-4o` — conversational responses (temperature 0.9, max 80 tokens), MCP roasts (temperature 0.7, max 120 tokens), coding teacher feedback (temperature 0.6, max 120 tokens), assignment summaries (temperature 0.7, max 120 tokens)
  - `gpt-4.1` — Lens summarization and rewriting (temperature 0.3, max 120 tokens)

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
- Ensure the audio engine started (look for `✅ Continuous listening started!` in terminal)

### Rate Limit Errors?
- OpenAI usage limits: Check your account for current limits
- TalkBack enforces a 22-second cooldown between OpenAI calls and a 5-second cooldown between STT calls
- Add payment method or wait between requests

### Missing `config.swift`?
- Copy the template: `cp config.swift.template config.swift`
- Add your API keys to `config.swift`

### MCP Roasts Not Triggering?
- Ensure TalkBack is running (it polls `/tmp/talkback_message.yaml` every 0.5s)
- Run commands through the monitor: `python3 cursor_code_monitor.py run "YOUR_COMMAND"`
- Check that `watchdog` is installed: `pip3 install watchdog`

### Lens Mode Not Working?
- Ensure your OpenAI API key is set in `config.swift`
- Click the viewfinder icon in the menu bar to toggle Lens on
- Check terminal for `Lens error:` messages

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
- Continuous listening via `AVAudioEngine` with tap-based buffer processing

## 📚 Additional Documentation

- **[QUICK_START.md](QUICK_START.md)** — Condensed getting-started guide
- **[API_KEY_SETUP.md](API_KEY_SETUP.md)** — Detailed API key configuration
- **[MCP_SETUP.md](MCP_SETUP.md)** — MCP integration setup walkthrough
- **[MCP_INTEGRATION.md](MCP_INTEGRATION.md)** — In-depth MCP architecture and usage reference
- **[MCP_SETUP_COMPLETE.md](MCP_SETUP_COMPLETE.md)** — Post-setup verification checklist

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
