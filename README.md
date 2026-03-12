# TalkBack - Annoying But Useful AI Companion 🤖

A mischievous macOS floating avatar that acts as your sassy, helpful (but pushy) productivity coach. TalkBack is an interactive AI companion that continuously listens to you, remembers your conversations, and responds with attitude-filled voice feedback. It also monitors your code, summarizes on-screen text, and nags you about assignment emails.

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
- **Always-on microphone** — TalkBack listens continuously; just speak and it picks up your voice
- **ElevenLabs Speech-to-Text** (`scribe_v1`) for accurate voice recognition
- Automatic silence detection (stops recording after 2 seconds of silence)
- Supports multiple languages (English, Bengali, Hindi, and more!)

### 🗣️ **Sassy AI Responses**
- **OpenAI GPT-4o** powered responses
- **ElevenLabs Text-to-Speech** (`eleven_multilingual_v2`) with Ivanna's voice
- Attitude-filled, personality-driven replies
- Short, snappy responses (max 80 tokens) that pack a punch

### 🧠 **Conversational Memory**
- Remembers your chat history (last 6 exchanges)
- Maintains context across conversations
- Smart follow-ups based on previous interactions
- Sends idle messages when you ignore it for too long

### 🎨 **Custom Floating Avatar**
- Transparent floating window (always on top)
- Custom purse/wallet icon design
- Animated eyes that follow your cursor
- Bouncing zigzag motion when idle
- Draggable anywhere on your screen

### 🗑️ **"The Great Escape" Feature**
- Drag avatar near the menu bar to reveal trash can
- Drop in trash to quit (the only way to close it!)
- Adds a fun, mischievous interaction

### 🔍 **TalkBack Lens** (Text Summarization)
- Menu bar status item with a viewfinder icon
- Toggle **Lens Mode** from the menu bar, or hold **⌥ Option** for temporary activation
- Hover over any on-screen text to get a floating overlay with two actions:
  - **Summarize** — condenses the text into 1–2 sentences
  - **Make Concise** — rewrites the text in fewer words
- Powered by **OpenAI GPT-4.1** with result caching
- Requires **Accessibility** permission (System Settings → Privacy & Security → Accessibility)

### 👩‍🏫 **Coding Teacher Mode**
- Enabled by default; toggle from the menu bar status item
- When a terminal command finishes, TalkBack reviews the output and gives a short teaching moment
- Explains errors, suggests fixes, and offers encouragement on success

### 📬 **Assignment Email Monitoring**
- Scans your Apple Mail inbox every 3 minutes for assignment-related emails
- Detects keywords like "assignment", "homework", "due", "exam", etc.
- Alerts you with a sassy summary and speaks it aloud via Ivanna's voice

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
- Polls `/tmp/talkback_message.json` every 0.5 seconds
- Integrates with Cursor IDE workflow
- Real-time feedback via Ivanna's voice

## 🛠️ Tech Stack

- **Language**: Swift 6.2
- **Frameworks**: AppKit (native macOS), AVFoundation, ApplicationServices (Accessibility API)
- **AI & Voice Services**:
  - [OpenAI GPT-4o](https://platform.openai.com/) — Conversational AI & code teaching
  - [OpenAI GPT-4.1](https://platform.openai.com/) — Lens text summarization
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) — Voice recognition (`scribe_v1`)
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) — Voice synthesis (`eleven_multilingual_v2`, Ivanna voice)
  - [Gemini](https://aistudio.google.com/) — Vision & behavior analysis *(planned, not yet active)*
- **Audio**: AVFoundation (AVAudioEngine for continuous listening, NSSound for playback)

## 🚀 Quick Start

### Prerequisites

1. **macOS 13.0+** (developed on macOS 26.0.1 beta)
2. **Xcode Command Line Tools** installed
3. **API Keys**:
   - OpenAI API key ([Get one here](https://platform.openai.com/account/api-keys))
   - ElevenLabs API key ([Get one here](https://elevenlabs.io/))
   - Gemini API key ([Get one here](https://aistudio.google.com/app/apikey)) — optional, reserved for future vision features
4. **Permissions** (macOS will prompt on first launch):
   - **Microphone** — for continuous voice listening
   - **Accessibility** — for TalkBack Lens (System Settings → Privacy & Security → Accessibility)

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

### Basic Voice Chat

1. **Start the App**: Run `./ConversationalTalkBack`
2. **Grant Permissions**: Allow microphone access when prompted
3. **Talk to TalkBack**: Just speak — continuous listening is always active. TalkBack detects your voice and stops recording after 2 seconds of silence.
4. **Listen**: TalkBack responds with Ivanna's voice and attitude
5. **Drag**: Move the avatar anywhere on your screen
6. **Quit**: Drag avatar near the menu bar → drop in trash can

### 🔍 TalkBack Lens (Text Summarization)

1. Click the **viewfinder icon** in the menu bar
2. Enable **Lens Mode**, or hold **⌥ Option** for temporary activation
3. Hover over any text on screen — a floating overlay appears
4. Click **Summarize** or **Make Concise** to analyze the text
5. Results are cached per element so repeated hovers are instant

> Requires Accessibility permission: System Settings → Privacy & Security → Accessibility

### 👩‍🏫 Coding Teacher Mode

Teacher mode is on by default. Toggle it from the menu bar status item.

When enabled, TalkBack reviews terminal command output and gives short teaching feedback — explaining errors, suggesting fixes, or congratulating you on success.

### 🔥 MCP Code Monitoring (Cursor IDE Integration)

TalkBack can watch your terminal and roast you when your code fails! Here's how:

1. **Start TalkBack** (it automatically monitors `/tmp/talkback_message.json`)

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

## 📂 Project Structure

| File | Purpose |
|---|---|
| `ConversationalTalkBack.swift` | Main app — floating avatar, voice chat, Lens, teacher mode, MCP polling |
| `config.swift.template` | API key template (copy to `config.swift` and add your keys) |
| `cursor_code_monitor.py` | Standalone code monitor — wraps commands and writes roast triggers (requires `watchdog`) |
| `cursor_mcp_server.py` | MCP server for Cursor IDE integration (stdio transport, requires `mcp`) |
| `test_mcp_connection.py` | Quick test to verify `/tmp/talkback_message.json` IPC works |
| `broken_code.py` | Intentionally broken script for testing roast triggers |
| `start_talkback_mcp.sh` | Compiles and launches TalkBack with MCP support |
| `start_integration.sh` | Sets up venv and verifies MCP connection |
| `mcp_config.json` | Cursor IDE MCP server configuration |
| `cline_mcp_settings.json` | Cline/Roo-Cline MCP settings for Cursor |
| `MCP_INTEGRATION.md` | Detailed MCP integration architecture and usage guide |
| `MCP_SETUP.md` | MCP setup walkthrough with Cursor IDE |
| `MCP_SETUP_COMPLETE.md` | Post-setup verification steps |
| `QUICK_START.md` | Condensed quick-start for MCP roasting |
| `API_KEY_SETUP.md` | API key configuration guide |

## 📋 API Endpoints Used

### ElevenLabs Speech-to-Text
- **Endpoint**: `https://api.elevenlabs.io/v1/speech-to-text`
- **Model**: `scribe_v1`
- **Input**: WAV audio (16 kHz, mono, 16-bit PCM)
- **Output**: Transcribed text with language detection

### ElevenLabs Text-to-Speech
- **Endpoint**: `https://api.elevenlabs.io/v1/text-to-speech/{voice_id}`
- **Model**: `eleven_multilingual_v2`
- **Voice**: Ivanna (`cgSgspJ2msm6clMCkdW9`)
- **Output**: MP3 audio

### OpenAI GPT-4o (Chat, Teaching, Roasting)
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Model**: `gpt-4o`
- **Temperature**: 0.9 (for sassy responses)
- **Max Tokens**: 80 (short, snappy replies)
- **Rate Limit**: 22-second cooldown between requests

### OpenAI GPT-4.1 (Lens Summarization)
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Model**: `gpt-4.1`
- **Temperature**: 0.3 (for factual summaries)
- **Max Tokens**: 120

### Gemini (Vision) — *Planned*
- A Gemini API key slot is included in `config.swift.template` for future vision-based behavior monitoring
- Not yet active in the codebase

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
- Ensure ambient noise isn't too loud — the silence threshold is 2 seconds

### Lens Not Working?
- Grant Accessibility permission: System Settings → Privacy & Security → Accessibility
- Ensure Lens Mode is toggled on in the menu bar, or hold **⌥ Option**
- Text must be longer than ~12 characters to trigger analysis

### Rate Limit Errors?
- TalkBack enforces a 22-second cooldown between OpenAI requests
- Check your OpenAI account for usage limits
- Add a payment method or wait between requests

### Missing `config.swift`?
- Copy the template: `cp config.swift.template config.swift`
- Add your API keys to `config.swift`

### MCP Roasts Not Triggering?
- Ensure TalkBack is running (it polls `/tmp/talkback_message.json` every 0.5s)
- Run commands through the monitor: `python3 cursor_code_monitor.py run "YOUR_COMMAND"`
- Check that `watchdog` is installed: `pip3 install watchdog`

### Crashes on Launch?
- Compile with explicit target: `-target arm64-apple-macosx13.0`
- Check Swift version: `swift --version`
- Beta macOS can be unstable with Speech framework

## 📝 Development Notes

This project was developed on **macOS 26.0.1 beta** with **Swift 6.2**, which required special handling:
- Explicit compilation target (`-target arm64-apple-macosx13.0`)
- Avoided unstable `SFSpeechRecognizer` framework — uses ElevenLabs STT instead
- Uses `AVAudioEngine` for continuous microphone input (16 kHz, mono)
- Prioritized `NSSound` over `AVAudioPlayer` for better MP3 compatibility
- Accessibility API (`ApplicationServices`) powers the Lens feature
- Rate limiting with a 22-second cooldown prevents OpenAI quota exhaustion

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
- **ElevenLabs** for Speech-to-Text (`scribe_v1`) and Text-to-Speech (`eleven_multilingual_v2`) APIs
- **Ivanna** for the sassy voice that brings TalkBack to life
- **Google** for Gemini API (planned vision features)

## 💬 Questions or Feedback?

Open an issue or reach out! TalkBack loves to chat (obviously). 😉

---

**Made with 💻 and a lot of sass** by [@aran-yogesh](https://github.com/aran-yogesh)

