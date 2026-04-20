# TalkBack - Annoying But Useful AI Companion 🤖

A mischievous macOS floating avatar that acts as your sassy, helpful (but pushy) productivity coach. TalkBack is an interactive AI companion that listens to you, remembers your conversations, and responds with attitude-filled voice feedback.

## Table of Contents


- [🎭 Personality](#-personality)
- [🐛 Troubleshooting](#-troubleshooting)
- [📝 Development Notes](#-development-notes)
- [🔮 Future Features](#-future-features)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)
- [🙏 Acknowledgments](#-acknowledgments)
- [✍️ Authors](#️-authors)
- [💬 Questions or Feedback?](#-questions-or-feedback)


![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 🎯 Features

### 🎤 **Real Voice Interaction**
- **Continuous listening** via `AVAudioEngine` with automatic silence detection (2s threshold)
- **ElevenLabs Speech-to-Text** (`scribe_v1`) for accurate voice recognition
- Supports multiple languages (English, Bengali, Hindi, and more!)
- Natural conversation flow with real-time transcription

### 🗣️ **Sassy AI Responses**
- **OpenAI GPT-4o** powered responses (temperature 0.9 for maximum sass)
- **ElevenLabs Text-to-Speech** with Ivanna's voice (`eleven_multilingual_v2`)
- Attitude-filled, personality-driven replies
- Short, snappy responses (max 80 tokens — punchy by design)

### 🧠 **Conversational Memory**
- Remembers your chat history (last 6 messages for context)
- Maintains context across conversations
- Smart follow-ups based on previous interactions

### 🎨 **Custom Floating Avatar**
- Transparent floating window (always on top)
- Custom purse/wallet icon design
- Zigzag bouncing motion pattern
- Dynamic expressions based on mood
- Draggable anywhere on your screen

### 🗑️ **"The Great Escape" Feature**
- Drag avatar near the menu bar to reveal trash can
- Drop in trash to quit (the only way to close it!)
- Adds a fun, mischievous interaction

### 🔍 **Lens Mode** (Accessibility-Powered Text Analysis)
- Hold **⌥ Option** or toggle from the menu bar to activate
- Hover over any UI element to read its text via macOS Accessibility APIs
- Floating overlay with two actions:
  - **Summarize** — condenses text into ≤2 sentences
  - **Make Concise** — rewrites text in ≤35 words
- Powered by **OpenAI GPT-4.1** (temperature 0.3 for precision)
- Includes a summary cache and 2-second cooldown to avoid redundant calls

### 🎓 **Teacher Mode** (Coding Coach)
- Enabled by default — toggle via the menu bar ("Coding Teacher Mode")
- Intercepts MCP command results and generates educational feedback
- On **success**: celebrates, explains the result, and suggests a next step
- On **failure**: diagnoses likely causes, teaches what went wrong, and gives actionable fixes
- Powered by **GPT-4o** (temperature 0.6, max 120 tokens)

### 📧 **Assignment Email Monitoring**
- Periodically checks Apple Mail inbox (every 3 minutes) via AppleScript
- Detects assignment-related emails by scanning subjects, bodies, and sender domains for keywords like `assignment`, `homework`, `due`, `submission`, `exam`, etc.
- Matches `.edu`, `canvas`, and `blackboard` sender domains
- Summarizes matched emails with course, due dates, and next actions
- Disabled by default — toggle via the menu bar

### 👁️ **Vision-Based Behavior Monitoring** *(Planned)*
- Gemini API key slot is included in the config for future vision features
- Planned capabilities:
  - 👀 Detecting when you look away from the screen
  - 😊😤😐 Emotion recognition (happy, frustrated, confused)
  - 🧐 Focus level tracking
  - 📱 Phone usage detection

### 🔥 **MCP Code Monitor** (Cursor IDE Integration)
- **Watches your terminal for code execution results** (polls `/tmp/talkback_message.json` every 0.5s)
- **Auto-roasts you when you mess up!**
  - 🔥 **2+ errors**: Full savage roast mode
  - 😏 **1 error**: Light sass and sarcasm
  - 💅 **Success**: Sassy compliment with attitude
- Error detection via regex matching (15+ patterns: `Traceback`, `SyntaxError`, `TypeError`, `compilation failed`, etc.)
- Integrates with Cursor IDE workflow
- Real-time feedback via Ivanna's voice

## 🛠️ Tech Stack

- **Language**: Swift 6.2
- **Frameworks**: AppKit, AVFoundation, ApplicationServices (native macOS)
- **AI & Voice Services**:
  - [OpenAI GPT-4o / GPT-4.1](https://platform.openai.com/) — Conversational AI & Lens Mode
  - [Gemini](https://aistudio.google.com/) — Vision & behavior analysis *(planned)*
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) — Voice recognition (`scribe_v1`)
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) — Voice synthesis (`eleven_multilingual_v2`, Ivanna voice)
- **Audio**: AVFoundation (NSSound, AVAudioEngine)
- **Accessibility**: ApplicationServices (AXUIElement APIs for Lens Mode)
- **IPC**: JSON file polling (`/tmp/talkback_message.json`)
- **Python**: MCP server, code monitor, integration scripts

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
2. **Grant Permissions**: Allow microphone access when prompted; grant Accessibility access for Lens Mode (System Settings → Privacy & Security → Accessibility)
3. **Talk to TalkBack**: Continuous listening is active — just speak and TalkBack will detect your voice (2s silence threshold triggers processing)
4. **Listen**: TalkBack responds with Ivanna's voice and attitude
5. **Lens Mode**: Hold **⌥ Option** (or toggle from menu bar) and hover over text to summarize or condense it
6. **Teacher Mode**: Enabled by default — toggle via menu bar. Get educational feedback on your terminal commands
7. **Drag**: Move the avatar anywhere on your screen
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
| `ConversationalTalkBack.swift` | Main app — floating avatar, voice chat, Lens Mode, Teacher Mode, MCP polling |
| `config.swift.template` | API key template (copy to `config.swift` and add your keys) |
| `cursor_code_monitor.py` | Standalone code monitor — wraps commands and writes roast triggers |
| `cursor_mcp_server.py` | MCP server for Cursor IDE integration (stdio transport) |
| `test_mcp_connection.py` | Quick test to verify `/tmp/talkback_message.json` IPC works |
| `broken_code.py` | Intentionally broken script for testing roast triggers |
| `start_talkback_mcp.sh` | Compiles and launches TalkBack with MCP support |
| `start_integration.sh` | Sets up venv and verifies MCP connection |
| `mcp_config.json` | Cursor IDE MCP server configuration |
| `cline_mcp_settings.json` | Cline (Roo Cline) extension MCP server configuration |
| `QUICK_START.md` | Quick-start guide for TalkBack + Cursor MCP integration |
| `MCP_SETUP.md` | Detailed MCP setup guide with architecture overview |
| `MCP_SETUP_COMPLETE.md` | MCP verification checklist and Cursor IDE configuration |
| `MCP_INTEGRATION.md` | Technical documentation of the MCP integration architecture |
| `API_KEY_SETUP.md` | Guide for configuring API keys (OpenAI, ElevenLabs, Gemini) |
| `AGENTS.md` | AI agent guidelines and project conventions |

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
- **Models & settings by feature**:

| Feature | Model | Temperature | Max Tokens |
|---|---|---|---|
| Conversation & Roasts | `gpt-4o` | 0.9 | 80 |
| Teacher Mode | `gpt-4o` | 0.6 | 120 |
| Assignment Summaries | `gpt-4o` | 0.7 | 120 |
| Lens Mode | `gpt-4.1` | 0.3 | 120 |

### Gemini (Vision) — *Planned*
- A Gemini API key slot is included in `config.swift.template` for future vision-based behavior monitoring
- Not currently called from the app

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
- Ensure the environment is not too noisy (silence detection threshold is 2s)
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
- Grant Accessibility access: System Settings → Privacy & Security → Accessibility → enable your terminal or the app
- Ensure the ⌥ Option key is held or Lens Mode is toggled on via the menu bar
- Text must be under 600 characters to trigger summarization

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

## ✍️ Authors

- **Yogesh Mahendran** — Creator & Lead Developer

## 💬 Questions or Feedback?

Open an issue or reach out! TalkBack loves to chat (obviously). 😉

---

**Made with 💻 and a lot of sass** by [@aran-yogesh](https://github.com/aran-yogesh)
