# TalkBack - Annoying But Useful AI Companion 🤖

A mischievous macOS floating avatar that acts as your sassy, helpful (but pushy) productivity coach. TalkBack is an interactive AI companion that continuously listens to you, remembers your conversations, and responds with attitude-filled voice feedback.

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
- **Always-on listening** via `AVAudioEngine` — just speak and TalkBack responds
- **ElevenLabs Speech-to-Text** for accurate voice recognition
- Automatic voice activity detection with silence-based segmentation
- Supports multiple languages (English, Bengali, Hindi, and more!)

### 🗣️ **Sassy AI Responses**
- **OpenAI GPT-4o** powered responses
- **ElevenLabs Text-to-Speech** with Ivanna's voice
- Attitude-filled, personality-driven replies
- Short, snappy responses that pack a punch

### 🧠 **Conversational Memory**
- Remembers your chat history (last 6 messages for context)
- Maintains context across conversations
- Smart follow-ups based on previous interactions

### 🎨 **Custom Floating Avatar**
- Transparent floating window (always on top)
- Animated eyes that follow your cursor
- Dynamic expressions based on mood
- Draggable anywhere on your screen
- Bouncing zigzag floating motion when idle

### 🗑️ **"The Great Escape" Feature**
- Drag avatar near the menu bar to reveal trash can
- Drop in trash to quit (the only way to close it!)
- Adds a fun, mischievous interaction

### 🔥 **MCP Code Monitor** (Cursor IDE Integration)
- **Watches your terminal for code execution results** via `/tmp/talkback_message.yaml`
- **Auto-roasts you when you mess up!**
  - 🔥 **2+ errors**: Full savage roast mode
  - 😏 **1 error**: Light sass and sarcasm
  - 💅 **Success**: Sassy compliment with attitude
- Supports structured command events (`command_started`, `command_finished`)
- Real-time feedback via Ivanna's voice

### 👩‍🏫 **Teaching Assistant Mode**
- Automatically reviews command output after execution
- Provides educational feedback on failures (diagnoses errors, suggests fixes)
- Celebrates successes with a productive next-step suggestion
- Togglable via the app menu

### 📬 **Assignment Email Monitoring**
- Monitors Apple Mail for assignment-related emails (homework, projects, exams, etc.)
- Detects keywords like `assignment`, `homework`, `due`, `submission`, `quiz`, `exam`
- Filters by educational domains (`edu`, `canvas`, `blackboard`)
- Summarizes assignment emails with GPT-4o and speaks the summary aloud
- Checks every 3 minutes when enabled; togglable via the app menu

### 🔍 **TalkBack Lens** (Text Summarization Overlay)
- Hover over any on-screen text while Lens mode is active
- Actions: **Summarize** or **Make Concise**
- Uses Accessibility APIs to read text under the cursor
- Powered by **GPT-4.1** for high-quality summaries
- Toggle via the menu bar icon or hold **⌥ Option** for temporary activation
- Results cached per element to avoid redundant API calls

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
  - [OpenAI GPT-4o](https://platform.openai.com/) — Conversational AI, roasts, teaching feedback, email summaries
  - [OpenAI GPT-4.1](https://platform.openai.com/) — TalkBack Lens text summarization
  - [Gemini](https://aistudio.google.com/) — Vision & behavior analysis *(planned)*
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) — Voice recognition
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) — Voice synthesis (Ivanna voice)
- **Audio**: AVFoundation (`AVAudioEngine` for continuous listening, `NSSound` / `AVAudioPlayer` for playback)
- **Accessibility**: ApplicationServices (for TalkBack Lens screen text reading)

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
   swiftc -o ConversationalTalkBack ConversationalTalkBack.swift config.swift \
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
2. **Grant Permissions**: Allow microphone access when prompted (required for continuous listening). For TalkBack Lens, grant Accessibility access in System Settings → Privacy & Security → Accessibility.
3. **Talk to TalkBack**: Just speak — TalkBack uses continuous listening with automatic voice activity detection. It detects when you start and stop talking.
4. **Listen**: TalkBack responds with Ivanna's voice and attitude
5. **Drag**: Move the avatar anywhere on your screen
6. **Quit**: Drag avatar near the menu bar → drop in trash can

### 🔥 MCP Code Monitoring (Cursor IDE Integration)

TalkBack can watch your terminal and roast you when your code fails! Here's how:

1. **Start TalkBack** (it automatically monitors `/tmp/talkback_message.yaml`)

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
   # This will trigger a savage roast (broken_code.py has 3 deliberate errors)
   python3 cursor_code_monitor.py run 'python3 broken_code.py'
   ```

### 🔍 TalkBack Lens

1. **Enable Lens Mode** via the menu bar icon or hold **⌥ Option** for temporary activation
2. **Hover** over any on-screen text
3. **Choose an action**: Summarize or Make Concise
4. The overlay displays the AI-generated result near your cursor

> **Requires**: Accessibility access (System Settings → Privacy & Security → Accessibility)

## 📂 Project Structure

| File | Purpose |
|---|---|
| `ConversationalTalkBack.swift` | Main app — floating avatar, continuous voice chat, MCP polling, Lens, teaching mode, email monitoring |
| `config.swift.template` | API key template (copy to `config.swift` and add your keys) |
| `cursor_code_monitor.py` | Standalone code monitor — wraps commands and writes roast triggers to `/tmp/talkback_message.yaml` |
| `cursor_mcp_server.py` | MCP server for Cursor IDE integration (stdio transport) |
| `test_mcp_connection.py` | Quick smoke test to verify `/tmp/talkback_message.yaml` IPC works |
| `broken_code.py` | Intentionally broken script (3 errors) for testing roast triggers |
| `start_talkback_mcp.sh` | Compiles and launches TalkBack with MCP support |
| `start_integration.sh` | Sets up venv and verifies MCP connection |
| `mcp_config.json` | Cursor IDE MCP server configuration |
| `cline_mcp_settings.json` | Cline MCP client configuration |
| `tests/` | Unit tests for code monitor, MCP server, and YAML utilities |

### Documentation Files

| File | Purpose |
|---|---|
| `AGENTS.md` | AI agent guide with project context and editing rules |
| `API_KEY_SETUP.md` | Detailed API key setup instructions |
| `MCP_SETUP.md` | MCP integration setup guide |
| `MCP_SETUP_COMPLETE.md` | Post-setup verification checklist |
| `MCP_INTEGRATION.md` | MCP architecture and integration details |
| `QUICK_START.md` | Condensed quick-start guide |

## 📋 API Endpoints Used

### ElevenLabs Speech-to-Text
- **Endpoint**: `https://api.elevenlabs.io/v1/speech-to-text`
- **Model**: `scribe_v1`
- **Input**: WAV audio (native sample rate, mono, PCM)
- **Output**: Transcribed text with language detection

### ElevenLabs Text-to-Speech
- **Endpoint**: `https://api.elevenlabs.io/v1/text-to-speech/{voice_id}`
- **Model**: `eleven_multilingual_v2`
- **Voice**: Ivanna (`cgSgspJ2msm6clMCkdW9`)
- **Output**: MP3 audio

### OpenAI GPT-4o
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Model**: `gpt-4o`
- **Used for**: Conversational responses, MCP roasts, teaching feedback, email summaries
- **Temperature**: 0.9 (conversation/roasts), 0.7 (email summaries), 0.6 (teaching feedback)
- **Max Tokens**: 80 (conversation/roasts), 120 (teaching/email)

### OpenAI GPT-4.1
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Model**: `gpt-4.1`
- **Used for**: TalkBack Lens text summarization
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
- 👩‍🏫 **Educational**: Teaches you what went wrong when your code fails

## 🐛 Troubleshooting

### No Voice Output?
- Check system volume and audio output device
- Verify ElevenLabs API key and voice ID
- Look for `🎤 ElevenLabs TTS HTTP Status: 200` in terminal

### No Transcriptions?
- Check microphone permissions (System Settings → Privacy & Security → Microphone)
- Verify ElevenLabs API key is valid
- Look for `🎤 Voice detected!` in terminal output to confirm audio is being captured

### Rate Limit Errors?
- OpenAI usage limits: Check your account for current limits
- TalkBack enforces a 22-second cooldown between OpenAI calls
- Add payment method or wait between requests

### Missing `config.swift`?
- Copy the template: `cp config.swift.template config.swift`
- Add your API keys to `config.swift`

### Compilation Errors?
- Ensure `config.swift` exists (the compile command requires it)
- Compile with explicit target: `-target arm64-apple-macosx13.0`
- Check Swift version: `swift --version`

### MCP Roasts Not Triggering?
- Ensure TalkBack is running (it polls `/tmp/talkback_message.yaml` every 0.5s)
- Run commands through the monitor: `python3 cursor_code_monitor.py run "YOUR_COMMAND"`
- Check that `watchdog` is installed: `pip3 install watchdog`

### TalkBack Lens Not Working?
- Grant Accessibility access: System Settings → Privacy & Security → Accessibility
- Ensure Lens mode is enabled via the menu bar icon
- Check that your OpenAI API key is configured

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
- Continuous listening via `AVAudioEngine` with voice activity detection

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
