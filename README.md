# TalkBack - Annoying But Useful AI Companion 🤖

A mischievous macOS floating avatar that acts as your sassy, helpful (but pushy) productivity coach. TalkBack is an interactive AI companion that continuously listens to you, remembers your conversations, and responds with attitude-filled voice feedback. It also includes a **Lens** overlay for summarizing on-screen text, a **Coding Teacher** mode that gives educational feedback on your terminal output, and **Assignment Alerts** that monitor your Apple Mail inbox for school-related emails.

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
- **Always-on microphone** with voice activity detection — just start talking
- **ElevenLabs Speech-to-Text** for accurate voice recognition
- Automatic silence detection (2 s threshold) triggers transcription
- Built-in noise filtering to ignore background sounds
- Supports multiple languages (English, Bengali, Hindi, and more!)

### 🗣️ **Sassy AI Responses**
- **OpenAI GPT-4o** powered responses
- **ElevenLabs Text-to-Speech** with Ivanna's voice
- Attitude-filled, personality-driven replies
- Short, snappy responses (max 2 sentences) that pack a punch

### 🧠 **Conversational Memory**
- Remembers your chat history (last 6 messages for context)
- Maintains context across conversations
- Smart follow-ups based on previous interactions

### 🎨 **Custom Floating Avatar**
- Transparent floating window (always on top)
- Custom purse/wallet icon design
- Animated eyes that follow your cursor
- Bouncing zigzag floating motion
- Draggable anywhere on your screen

### 🗑️ **"The Great Escape" Feature**
- Drag avatar near the menu bar to reveal trash can
- Drop in trash to quit (the only way to close it!)
- Adds a fun, mischievous interaction

### 🔍 **TalkBack Lens** (Accessibility Overlay)
- **Menu bar icon** (🔍) with toggle for persistent Lens mode
- **Hold ⌥ Option** for temporary Lens activation
- Hover over any on-screen text to see a floating overlay with:
  - **Summarize** — condenses the text into 1–2 sentences
  - **Make Concise** — rewrites the text in fewer words
- Uses macOS Accessibility APIs (`AXUIElement`) to read text under the cursor
- Results are cached per element to avoid redundant API calls
- Requires **Accessibility** permission (System Settings → Privacy & Security → Accessibility)

### 👩‍🏫 **Coding Teacher Mode**
- Enabled by default; toggle from the Lens menu bar dropdown
- When a command finishes via MCP monitoring, TalkBack provides **educational feedback**:
  - ✅ **Success**: celebrates briefly, explains the result, suggests a next step
  - ❌ **Failure**: diagnoses likely causes, teaches what went wrong, gives actionable fixes
- Responses are concise (3–4 sentences) with a supportive but playful tone

### 📬 **Assignment Email Alerts**
- Toggle from the right-click context menu on the avatar
- Polls **Apple Mail** inbox every 3 minutes via AppleScript
- Detects assignment-related emails by scanning for keywords (`assignment`, `homework`, `due`, `quiz`, `exam`, etc.) and educational domains (`edu`, `canvas`, `blackboard`)
- Summarizes matching emails with GPT-4o and displays the summary on the avatar

### 👁️ **Vision-Based Behavior Monitoring** *(Planned)*
- Gemini API key slot is included in the config for future vision features
- Planned capabilities:
  - 👀 Detecting when you look away from the screen
  - 😊😤😐 Emotion recognition (happy, frustrated, confused)
  - 🧐 Focus level tracking
  - 📱 Phone usage detection

### 🔥 **MCP Code Monitor** (Cursor IDE Integration)
- **Watches your terminal for code execution results** via `/tmp/talkback_message.json`
- **Auto-roasts you when you mess up!**
  - 🔥 **2+ errors**: Full savage roast mode
  - 😏 **1 error**: Light sass and sarcasm
  - 💅 **Success**: Sassy compliment with attitude
- Integrates with Cursor and Cline IDE workflows
- Real-time feedback via Ivanna's voice

## 🛠️ Tech Stack

- **Language**: Swift 6.2
- **Frameworks**: AppKit, AVFoundation, ApplicationServices (Accessibility)
- **AI & Voice Services**:
  - [OpenAI GPT-4o](https://platform.openai.com/) — Conversational AI, Lens summarization, teaching feedback
  - [Gemini](https://aistudio.google.com/) — Vision & behavior analysis *(planned)*
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) — Voice recognition
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) — Voice synthesis (Ivanna voice)
- **Audio**: AVFoundation (AVAudioEngine for continuous listening, NSSound for playback)
- **Accessibility**: ApplicationServices (`AXUIElement`) for TalkBack Lens
- **IPC**: Apple Mail via AppleScript; Cursor/Cline via JSON file polling

## 🚀 Quick Start

### Prerequisites

1. **macOS 13.0+** (developed on macOS 26.0.1 beta)
2. **Xcode Command Line Tools** installed
3. **API Keys**:
   - OpenAI API key ([Get one here](https://platform.openai.com/account/api-keys)) — required for chat, Lens, and teaching feedback
   - ElevenLabs API key ([Get one here](https://elevenlabs.io/)) — required for voice input/output
   - Gemini API key ([Get one here](https://aistudio.google.com/app/apikey)) — reserved for planned vision features

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
     -framework ApplicationServices \
     -target arm64-apple-macosx13.0
   ```

4. **Run TalkBack**:
   ```bash
   ./ConversationalTalkBack
   ```

## 🎮 How to Use

### Basic Usage

1. **Start the App**: Run `./ConversationalTalkBack`
2. **Grant Permissions** when prompted:
   - **Microphone** — required for continuous voice listening
   - **Accessibility** — required for TalkBack Lens (System Settings → Privacy & Security → Accessibility)
3. **Talk to TalkBack**: Just speak — the always-on microphone detects your voice automatically. After ~2 seconds of silence, your speech is transcribed and sent to GPT-4o.
4. **Listen**: TalkBack responds with Ivanna's voice and attitude
5. **Drag**: Move the avatar anywhere on your screen
6. **Quit**: Drag avatar near the menu bar → drop in trash can

### 🔍 TalkBack Lens

1. Click the **🔍 Lens** icon in the menu bar
2. Toggle **Lens Mode** on, or hold **⌥ Option** for temporary activation
3. Hover over any text on screen — a floating overlay appears with **Summarize** and **Make Concise** buttons
4. Click an action to get an AI-powered summary

### 👩‍🏫 Coding Teacher Mode

Enabled by default. Toggle it from the Lens menu bar dropdown → **Coding Teacher Mode**.

When a command finishes (via MCP monitoring), TalkBack gives educational feedback instead of just roasting you.

### 📬 Assignment Email Alerts

Toggle from the avatar's right-click context menu. When enabled, TalkBack checks your Apple Mail inbox every 3 minutes for assignment-related emails and summarizes them.

### 🔥 MCP Code Monitoring (Cursor IDE Integration)

TalkBack can watch your terminal and roast you when your code fails! Here's how:

1. **Start TalkBack** (it automatically monitors `/tmp/talkback_message.json`)

2. **Run your code through the monitor**:
   ```bash
   python3 cursor_code_monitor.py run 'python3 your_broken_script.py'
   python3 cursor_code_monitor.py run 'python3 your_working_script.py'
   python3 cursor_code_monitor.py run 'swift your_code.swift'
   ```

3. **TalkBack will respond based on errors**:
   - ✅ **0 errors**: Sassy compliment — "Oh wow, it ACTUALLY worked? Color me shocked, darling! 💅✨"
   - 😏 **1 error**: Light sass — "ONE error? Cute. At least you're almost there, sweetheart. 😏"
   - 🔥 **2+ errors**: Full roast — "Oh HONEY, what is this hot mess? Did you code this with your eyes closed? 🔥💀"

4. **Quick test**:
   ```bash
   python3 cursor_code_monitor.py run 'python3 broken_code.py'
   ```

## 📂 Project Structure

| File | Purpose |
|---|---|
| `ConversationalTalkBack.swift` | Main app — floating avatar, continuous voice chat, Lens overlay, teaching mode, assignment alerts, MCP polling |
| `config.swift.template` | API key template (copy to `config.swift` and add your keys) |
| `cursor_code_monitor.py` | Standalone code monitor — wraps commands and writes roast triggers to `/tmp/talkback_message.json` |
| `cursor_mcp_server.py` | MCP server for Cursor IDE integration (stdio transport) |
| `test_mcp_connection.py` | Quick test — writes a sample message to `/tmp/talkback_message.json` to verify IPC |
| `broken_code.py` | Intentionally broken script for testing roast triggers |
| `start_talkback_mcp.sh` | Helper script to compile and launch TalkBack with MCP support |
| `start_integration.sh` | Sets up Python venv and verifies MCP connection |
| `mcp_config.json` | Cursor IDE MCP server configuration |
| `cline_mcp_settings.json` | Cline (VS Code extension) MCP server configuration |

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
- **Chat** — Model: `gpt-4o`, Temperature: 0.9, Max Tokens: 80
- **Teaching feedback** — Model: `gpt-4o`, Temperature: 0.6, Max Tokens: 120
- **Assignment summaries** — Model: `gpt-4o`, Temperature: 0.7, Max Tokens: 120
- **Lens summarization** — Model: `gpt-4.1`, Temperature: 0.3, Max Tokens: 120

### Gemini (Vision) — *Planned*
- **Endpoint**: `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent`
- A Gemini API key slot is included in `config.swift.template` for future vision-based behavior monitoring

## 🎭 Personality

TalkBack adapts its tone depending on context:

- 😏 **Sassy** (default chat): Witty comebacks, max 2 sentences, heavy emoji usage
- 🔥 **Savage** (code roasts): No mercy when your code fails — dramatic, funny burns
- 👩‍🏫 **Supportive Teacher** (coding teacher mode): Encouraging but playful; diagnoses errors and suggests next steps
- 📬 **Enthusiastic Assistant** (assignment alerts): Friendly, concise email summaries with actionable next steps
- 🔍 **Neutral Summarizer** (Lens): Objective, plain-text summaries of on-screen content

## 🐛 Troubleshooting

### No Voice Output?
- Check system volume and audio output device
- Verify ElevenLabs API key and voice ID
- Look for `🎤 ElevenLabs TTS HTTP Status: 200` in terminal

### Not Hearing My Voice?
- Check microphone permissions (System Settings → Privacy & Security → Microphone)
- Verify ElevenLabs API key is valid
- Look for `✅ Continuous listening started!` in terminal output
- Speak clearly — the voice activity threshold filters out low-amplitude sounds

### Lens Overlay Not Appearing?
- Grant **Accessibility** permission (System Settings → Privacy & Security → Accessibility)
- Toggle Lens Mode on from the 🔍 menu bar icon, or hold **⌥ Option**
- Ensure the text under the cursor is longer than ~12 characters

### Rate Limit Errors?
- OpenAI has a 22-second cooldown built in; requests that arrive too fast are queued automatically
- Check your OpenAI account for current usage limits

### Missing `config.swift`?
- Copy the template: `cp config.swift.template config.swift`
- Add your API keys to `config.swift`

### MCP Roasts Not Triggering?
- Ensure TalkBack is running (it polls `/tmp/talkback_message.json` every 0.5 s)
- Run commands through the monitor: `python3 cursor_code_monitor.py run "YOUR_COMMAND"`
- Check that `watchdog` is installed: `pip3 install watchdog`

### Compilation Errors?
- Include `config.swift` in the compile command (see [Quick Start](#-quick-start))
- Compile with explicit target: `-target arm64-apple-macosx13.0`
- Ensure `-framework ApplicationServices` is included
- Check Swift version: `swift --version`

## 📝 Development Notes

This project was developed on **macOS 26.0.1 beta** with **Swift 6.2**, which required special handling:
- Explicit compilation target (`-target arm64-apple-macosx13.0`)
- Avoided unstable `SFSpeechRecognizer` framework
- Used ElevenLabs STT instead of macOS built-in speech recognition
- Prioritized `NSSound` over `AVAudioPlayer` for better MP3 compatibility
- Continuous listening uses `AVAudioEngine` with a tap on the input node; voice activity is detected by amplitude threshold (`0.015`)
- TalkBack Lens reads on-screen text via `AXUIElementCopyElementAtPosition` and related Accessibility APIs
- Assignment monitoring uses `osascript` to query Apple Mail via AppleScript

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

- **OpenAI** for GPT-4o API (chat, Lens, teaching feedback)
- **Google** for Gemini API (planned vision features)
- **ElevenLabs** for Speech-to-Text and Text-to-Speech APIs
- **Apple** for Accessibility and AppleScript frameworks
- **Ivanna** for the sassy voice that brings TalkBack to life

## 💬 Questions or Feedback?

Open an issue or reach out! TalkBack loves to chat (obviously). 😉

---

**Made with 💻 and a lot of sass** by [@aran-yogesh](https://github.com/aran-yogesh)

