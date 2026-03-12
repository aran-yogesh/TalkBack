# TalkBack - Annoying But Useful AI Companion 🤖

A mischievous macOS floating avatar that acts as your sassy, helpful (but pushy) productivity coach. TalkBack is an interactive AI companion that continuously listens to you, remembers your conversations, and responds with attitude-filled voice feedback — all while bouncing around your screen.

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

### 🎤 **Always-On Voice Interaction**
- **Continuous listening** — just start talking, no button press needed
- **ElevenLabs Speech-to-Text** (`scribe_v1`) for accurate voice recognition
- Automatic voice activity detection with silence-based segmentation
- Background noise filtering (ignores static, shuffling, and other non-speech sounds)
- Supports multiple languages (English, Bengali, Hindi, and more!)

### 🗣️ **Sassy AI Responses**
- **OpenAI GPT-4o** powered responses (temperature 0.9 for maximum sass)
- **ElevenLabs Text-to-Speech** with Ivanna's voice (`eleven_multilingual_v2`)
- Attitude-filled, personality-driven replies
- Short, snappy responses (max 80 tokens — 2 sentences)

### 🧠 **Conversational Memory**
- Remembers your chat history (last 12 messages / 6 exchanges)
- Maintains context across conversations
- Smart follow-ups based on previous interactions

### 🎨 **Custom Floating Avatar**
- Transparent floating window (always on top, joins all spaces)
- Custom purse/wallet icon design with animated eyes that follow your cursor
- Bouncing zigzag motion across the screen (~33 FPS)
- Dynamic expressions: listening, thinking, speaking, and recording states
- Draggable anywhere on your screen (pauses bouncing while dragging)
- Sassy idle messages after 60 seconds of inactivity

### 🗑️ **"The Great Escape" Feature**
- Drag avatar near the menu bar to reveal a trash can
- Drop in trash to quit (the only way to close it!)
- Shows a goodbye message before exiting

### 🔍 **TalkBack Lens** (Accessibility Overlay)
- Hover over any text on screen to get instant AI summaries
- Two actions: **Summarize** (main idea in ~40 words) and **Make Concise** (rewrite in ~35 words)
- Powered by **OpenAI GPT-4.1** with low temperature (0.3) for factual output
- Toggle via the menu bar icon or hold **⌥ Option** for temporary activation
- Results are cached per element to avoid redundant API calls
- Requires Accessibility permissions (System Settings → Privacy & Security → Accessibility)

### 👩‍🏫 **Coding Teacher Mode**
- Enabled by default — toggle via the menu bar
- Monitors terminal command results and provides teaching feedback
- On success: celebrates, explains the result, suggests a next step (max 3 sentences)
- On failure: diagnoses the error, teaches what went wrong, gives actionable fixes (max 4 sentences)
- Uses a supportive-but-sassy teaching persona

### 📬 **Assignment Email Monitoring**
- Monitors your macOS Mail.app inbox every 3 minutes for assignment-related emails
- Detects keywords: `assignment`, `homework`, `project`, `due`, `quiz`, `exam`, `paper`, `essay`, `lab`
- Detects sender domains: `edu`, `canvas`, `blackboard`
- Summarizes detected assignments via AI and speaks the summary aloud
- Toggle on/off (disabled by default)

### 🔥 **MCP Code Monitor** (Cursor IDE Integration)
- Watches `/tmp/talkback_message.json` for code execution results (polls every 0.5s)
- Auto-roasts you when you mess up:
  - 🔥 **2+ errors**: Full savage roast mode (max 40 words)
  - 😏 **1 error**: Light sass and sarcasm (max 30 words)
  - 💅 **Success**: Sassy compliment with attitude (max 30 words)
- Integrates with Cursor IDE workflow via MCP (Model Context Protocol)
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
- **Framework**: AppKit (native macOS)
- **AI & Voice Services**:
  - [OpenAI GPT-4o](https://platform.openai.com/) — Conversational AI, roasts, teaching feedback
  - [OpenAI GPT-4.1](https://platform.openai.com/) — Lens summarization
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) — Voice recognition (`scribe_v1`)
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) — Voice synthesis (`eleven_multilingual_v2`, Ivanna voice)
  - [Gemini](https://aistudio.google.com/) — Vision & behavior analysis *(planned)*
- **Audio**: AVFoundation (`AVAudioEngine` for continuous listening, `NSSound` for playback)
- **Accessibility**: macOS Accessibility API (for Lens text reading)
- **IPC**: JSON file polling (`/tmp/talkback_message.json`) for MCP integration

## 🚀 Quick Start

### Prerequisites

1. **macOS 13.0+** (developed on macOS 26.0.1 beta)
2. **Xcode Command Line Tools** installed
3. **API Keys**:
   - OpenAI API key ([Get one here](https://platform.openai.com/account/api-keys))
   - ElevenLabs API key ([Get one here](https://elevenlabs.io/))
   - *(Optional)* Gemini API key ([Get one here](https://aistudio.google.com/app/apikey)) — for future vision features

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
   - **Microphone** — required for continuous listening
   - **Accessibility** — required for TalkBack Lens (System Settings → Privacy & Security → Accessibility)

## 🎮 How to Use

### Basic Voice Chat

1. **Start the App**: Run `./ConversationalTalkBack`
2. **Just talk** — TalkBack continuously listens via your microphone. No button press needed.
3. **Listen**: TalkBack responds with Ivanna's voice and attitude
4. **Drag**: Move the avatar anywhere on your screen
5. **Quit**: Drag avatar near the menu bar → drop in the trash can

### 🔍 Using TalkBack Lens

1. Click the **viewfinder icon** in the menu bar and select **Lens Mode** (or hold **⌥ Option**)
2. Hover over any text on screen
3. Click **Summarize** or **Make Concise** in the overlay that appears
4. The AI-generated result appears inline

### 🔥 MCP Code Monitoring (Cursor IDE Integration)

TalkBack can watch your terminal and roast you when your code fails:

1. **Start TalkBack** (it automatically monitors `/tmp/talkback_message.json`)

2. **Run your code through the monitor**:
   ```bash
   # Test with a script that has errors (will trigger full roast 🔥)
   python3 cursor_code_monitor.py run 'python3 broken_code.py'

   # Test with successful code (will get sassy compliment 💅)
   python3 cursor_code_monitor.py run 'echo "Hello World"'

   # Test with any command
   python3 cursor_code_monitor.py run 'swift your_code.swift'
   ```

3. **Verify the IPC connection**:
   ```bash
   python3 test_mcp_connection.py
   ```

4. **TalkBack will roast you based on errors**:
   - ✅ **0 errors**: "Oh wow, it ACTUALLY worked? Color me shocked, darling! 💅✨"
   - 😏 **1 error**: "ONE error? Cute. At least you're almost there, sweetheart. 😏"
   - 🔥 **2+ errors**: "Oh HONEY, what is this hot mess? Did you code this with your eyes closed? 🔥💀"

### Menu Bar Controls

| Menu Item | Description |
|---|---|
| **Lens Mode** | Toggle the accessibility text overlay on/off |
| **Coding Teacher Mode** | Toggle teaching feedback for terminal commands (on by default) |
| **Hold ⌥ Option** | Temporarily activate Lens while the key is held |

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
| `MCP_INTEGRATION.md` | Detailed MCP architecture and integration guide |
| `MCP_SETUP.md` | Step-by-step MCP setup instructions |
| `MCP_SETUP_COMPLETE.md` | Post-setup verification guide |
| `QUICK_START.md` | Quick-start guide for MCP roasting |
| `API_KEY_SETUP.md` | API key configuration reference |
| `AGENTS.md` | Guidelines for AI coding agents working on this repo |

## 📋 API Endpoints Used

### ElevenLabs Speech-to-Text
- **Endpoint**: `https://api.elevenlabs.io/v1/speech-to-text`
- **Model**: `scribe_v1`
- **Input**: WAV audio (16kHz, mono, PCM16)
- **Output**: Transcribed text with language detection

### ElevenLabs Text-to-Speech
- **Endpoint**: `https://api.elevenlabs.io/v1/text-to-speech/{voice_id}`
- **Model**: `eleven_multilingual_v2`
- **Voice**: Ivanna (`cgSgspJ2msm6clMCkdW9`)
- **Settings**: stability 0.5, similarity_boost 0.5
- **Output**: MP3 audio

### OpenAI Chat Completions
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Models**:
  - `gpt-4o` — conversational chat, roasts, teaching feedback, assignment summaries
  - `gpt-4.1` — Lens summarization and concise rewrites
- **Parameters** (vary by context):

| Context | Temperature | Max Tokens |
|---|---|---|
| General chat | 0.9 | 80 |
| MCP roasts | 0.9 | 80 |
| Assignment summaries | 0.7 | 120 |
| Teaching feedback | 0.6 | 120 |
| Lens summaries | 0.3 | 120 |

### Gemini (Vision) — *Planned*
- A Gemini API key slot is included in `config.swift.template` for future vision-based behavior monitoring

## 🎭 Personality

TalkBack is designed to be:
- 😏 **Sassy**: Witty comebacks and attitude-filled responses
- 🎯 **Helpful**: Actually useful advice (hidden in the sass)
- 💁‍♀️ **Pushy**: Won't let you procrastinate
- 🧠 **Smart**: Remembers your conversations
- 🎤 **Talkative**: Loves to chat (maybe too much)
- 👩‍🏫 **Teacherly**: Supportive coding feedback with light sass

## 🐛 Troubleshooting

### No Voice Output?
- Check system volume and audio output device
- Verify ElevenLabs API key and voice ID in `config.swift`
- Look for `🎤 ElevenLabs TTS HTTP Status: 200` in terminal

### TalkBack Not Hearing You?
- Grant microphone permissions (System Settings → Privacy & Security → Microphone)
- TalkBack uses continuous listening — just speak normally, no button press needed
- Check terminal for audio engine errors
- Ensure no other app is exclusively using the microphone

### Lens Not Reading Text?
- Grant Accessibility permissions (System Settings → Privacy & Security → Accessibility)
- Restart TalkBack after granting permissions
- Some apps may not expose text via the Accessibility API

### Rate Limit Errors?
- OpenAI enforces rate limits — TalkBack has a built-in 22-second cooldown between calls
- If you hit 429 errors, TalkBack automatically backs off for 25 seconds
- Check your OpenAI account for current usage limits

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
- Continuous listening via `AVAudioEngine` with voice activity detection replaces the older click-to-record approach
- Prioritized `NSSound` over `AVAudioPlayer` for better MP3 compatibility
- Chat history is capped at 12 messages and trimmed to the last 6 for API calls to manage token usage

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
