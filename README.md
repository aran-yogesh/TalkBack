# TalkBack - Annoying But Useful AI Companion 🤖

A mischievous macOS floating avatar that acts as your sassy, helpful (but pushy) productivity coach. TalkBack is an interactive AI companion that listens to you, remembers your conversations, and responds with attitude-filled voice feedback.

**Author:** [yogesh-mahendran](https://github.com/aran-yogesh)

![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## Table of Contents

- [Features](#features)
  - [Continuous Voice Interaction](#-continuous-voice-interaction)
  - [Sassy AI Responses](#️-sassy-ai-responses)
  - [Conversational Memory](#-conversational-memory)
  - [Custom Floating Avatar](#-custom-floating-avatar)
  - [The Great Escape](#️-the-great-escape-feature)
  - [TalkBack Lens](#-talkback-lens-new)
  - [Coding Teacher Mode](#-coding-teacher-mode-new)
  - [Assignment Email Alerts](#-assignment-email-alerts-new)
  - [MCP Code Monitor](#-mcp-code-monitor-cursor-ide-integration)
  - [Vision-Based Behavior Monitoring](#️-vision-based-behavior-monitoring-planned)
- [Tech Stack](#tech-stack)
- [Quick Start](#quick-start)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [How to Use](#how-to-use)
  - [Basic Usage](#basic-usage)
  - [TalkBack Lens](#talkback-lens)
  - [Coding Teacher Mode](#coding-teacher-mode)
  - [Assignment Email Alerts](#assignment-email-alerts)
  - [MCP Code Monitoring](#mcp-code-monitoring-cursor-ide-integration)
- [Project Structure](#project-structure)
- [API Endpoints Used](#api-endpoints-used)
- [Personality](#personality)
- [Troubleshooting](#troubleshooting)
- [Development Notes](#development-notes)
- [Future Features](#future-features)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)
- [Questions or Feedback?](#questions-or-feedback)

## Features

### 🎤 **Continuous Voice Interaction**
- **Always-on listening** — TalkBack continuously monitors your microphone for speech
- Automatic voice activity detection with silence thresholds
- **ElevenLabs Speech-to-Text** (`scribe_v1`) for accurate voice recognition
- Built-in noise filtering to ignore background sounds
- Supports multiple languages (English, Bengali, Hindi, and more!)

### 🗣️ **Sassy AI Responses**
- **OpenAI GPT-4o** powered responses with personality-driven system prompts
- **ElevenLabs Text-to-Speech** with Ivanna's voice (`eleven_multilingual_v2`)
- Attitude-filled, short, snappy replies (max 80 tokens)
- Rate-limited to stay within API quotas (22s cooldown between calls)

### 🧠 **Conversational Memory**
- Remembers your chat history (last 6 exchanges)
- Maintains context across conversations
- Smart follow-ups based on previous interactions

### 🎨 **Custom Floating Avatar**
- Transparent floating window (always on top)
- Custom purse/wallet icon design with animated eyes that follow your cursor
- Bouncing zigzag motion across the screen
- Dynamic expressions based on mood (listening, thinking, speaking)
- Draggable anywhere on your screen

### 🗑️ **"The Great Escape" Feature**
- Drag avatar near the menu bar to reveal trash can
- Drop in trash to quit (the only way to close it!)

### 🔍 **TalkBack Lens** *(NEW!)*
- **Hover-to-summarize** any text on screen using macOS Accessibility APIs
- Powered by **OpenAI GPT-4.1** for fast, accurate results
- Two actions: **Summarize** and **Make Concise**
- Toggle via the menu bar icon or hold **⌥ Option** for temporary activation
- Floating overlay displays results near your cursor
- Built-in caching to avoid redundant API calls
- Requires Accessibility permission (System Settings → Privacy & Security → Accessibility)

### 👩‍🏫 **Coding Teacher Mode** *(NEW!)*
- Watches your terminal command results via MCP monitoring
- On **success**: celebrates and suggests a productive next step
- On **failure**: diagnoses likely causes, teaches what went wrong, and gives actionable fixes
- Toggle on/off from the menu bar (enabled by default)

### 📬 **Assignment Email Alerts** *(NEW!)*
- Monitors Apple Mail inbox for assignment-related emails
- Detects keywords like "assignment", "homework", "due", "exam", etc.
- Detects `.edu`, Canvas, and Blackboard sender domains
- Summarizes assignment emails with GPT-4o and reads them aloud
- Checks every 3 minutes; toggle on/off from the menu bar

### 🔥 **MCP Code Monitor** (Cursor IDE Integration)
- **Watches your terminal for code execution results**
- **Auto-roasts you when you mess up!**
  - 🔥 **2+ errors**: Full savage roast mode
  - 😏 **1 error**: Light sass and sarcasm
  - 💅 **Success**: Sassy compliment with attitude
- Supports `command_started` and `command_finished` events with duration tracking
- Integrates with Cursor IDE workflow via MCP server (stdio transport)
- Real-time feedback via Ivanna's voice

### 👁️ **Vision-Based Behavior Monitoring** *(Planned)*
- Gemini API key slot is included in the config for future vision features
- Planned capabilities:
  - 👀 Detecting when you look away from the screen
  - 😊😤😐 Emotion recognition (happy, frustrated, confused)
  - 🧐 Focus level tracking
  - 📱 Phone usage detection

## Tech Stack

- **Language**: Swift 6.2
- **Framework**: AppKit (native macOS)
- **AI & Voice Services**:
  - [OpenAI GPT-4o](https://platform.openai.com/) — Conversational AI & teacher feedback
  - [OpenAI GPT-4.1](https://platform.openai.com/) — Lens summarization
  - [Gemini](https://aistudio.google.com/) — Vision & behavior analysis *(planned)*
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) — Voice recognition (`scribe_v1`)
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) — Voice synthesis (`eleven_multilingual_v2`, Ivanna voice)
- **Audio**: AVFoundation (AVAudioEngine for continuous listening, AVAudioPlayer for playback)
- **Accessibility**: ApplicationServices (AXUIElement APIs for Lens feature)
- **MCP Integration**: Python (`mcp` SDK, `watchdog` for file monitoring)

## Quick Start

### Prerequisites

1. **macOS 13.0+** (developed on macOS 26.0.1 beta)
2. **Xcode Command Line Tools** installed
3. **API Keys**:
   - OpenAI API key ([Get one here](https://platform.openai.com/account/api-keys))
   - ElevenLabs API key ([Get one here](https://elevenlabs.io/))
   - Gemini API key ([Get one here](https://aistudio.google.com/app/apikey)) *(optional, for future vision features)*

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

5. **Grant permissions** when prompted:
   - **Microphone** — required for continuous voice listening
   - **Accessibility** — required for Lens feature (System Settings → Privacy & Security → Accessibility)

## How to Use

### Basic Usage

1. **Start the App**: Run `./ConversationalTalkBack`
2. **Talk to TalkBack**: Just speak — continuous listening is always active
3. **Listen**: TalkBack responds with Ivanna's voice and attitude
4. **Drag**: Move the avatar anywhere on your screen
5. **Quit**: Drag avatar near the menu bar → drop in trash can

### TalkBack Lens

Hover over any text on screen and get AI-powered summaries:

1. **Enable Lens**: Click the viewfinder icon in the menu bar → toggle "Lens Mode" on, or hold **⌥ Option**
2. **Hover** over any text element on screen
3. **Choose an action**: Click "Summarize" or "Make Concise" in the floating overlay
4. **View results** in the overlay near your cursor

> **Requires**: Accessibility permission. Grant it in System Settings → Privacy & Security → Accessibility.

### Coding Teacher Mode

Enabled by default. When TalkBack detects a command finishing (via MCP monitoring), it provides educational feedback:

- **Success**: Celebrates and suggests a next step
- **Failure**: Diagnoses the error and gives actionable fixes

Toggle via the menu bar: click the viewfinder icon → "Coding Teacher Mode".

### Assignment Email Alerts

Monitor your Apple Mail inbox for assignment-related emails:

1. Toggle "Assignment Alerts" from the menu bar
2. TalkBack checks your inbox every 3 minutes
3. When an assignment email is detected, TalkBack summarizes it and reads it aloud

> **Requires**: Apple Mail to be running. Detects emails with keywords like "assignment", "homework", "due", "exam" or from `.edu`/Canvas/Blackboard domains.

### MCP Code Monitoring (Cursor IDE Integration)

TalkBack can watch your terminal and roast you when your code fails:

1. **Start TalkBack** (it automatically monitors `/tmp/talkback_message.json`)

2. **Run your code through the monitor**:
   ```bash
   python3 cursor_code_monitor.py run 'python3 your_script.py'
   ```

3. **TalkBack responds based on errors**:
   - ✅ **0 errors**: Sassy compliment 💅
   - 😏 **1 error**: Light sass 😏
   - 🔥 **2+ errors**: Full savage roast 🔥

4. **Example test** (triggers a roast):
   ```bash
   python3 cursor_code_monitor.py run 'python3 broken_code.py'
   ```

5. **Test MCP connection**:
   ```bash
   python3 test_mcp_connection.py
   ```

#### MCP Python Dependencies

```bash
pip3 install mcp watchdog
```

## Project Structure

| File | Purpose |
|---|---|
| `ConversationalTalkBack.swift` | Main app — floating avatar, voice chat, Lens, teacher mode, assignment alerts, MCP polling |
| `config.swift.template` | API key template (copy to `config.swift` and add your keys) |
| `cursor_code_monitor.py` | Standalone code monitor — wraps commands and writes roast triggers to `/tmp/talkback_message.json` |
| `cursor_mcp_server.py` | MCP server for Cursor IDE integration (stdio transport) |
| `test_mcp_connection.py` | Quick test to verify `/tmp/talkback_message.json` IPC works |
| `broken_code.py` | Intentionally broken script for testing roast triggers |
| `start_talkback_mcp.sh` | Compiles and launches TalkBack with MCP support, installs Python deps |
| `start_integration.sh` | Sets up venv and verifies MCP connection |
| `mcp_config.json` | Cursor IDE MCP server configuration |
| `cline_mcp_settings.json` | Cline MCP server configuration (alternative IDE setup) |
| `package.json` | Node.js package metadata |

## API Endpoints Used

### ElevenLabs Speech-to-Text
- **Endpoint**: `https://api.elevenlabs.io/v1/speech-to-text`
- **Model**: `scribe_v1`
- **Input**: WAV audio (PCM16, native sample rate)
- **Output**: Transcribed text with language detection

### ElevenLabs Text-to-Speech
- **Endpoint**: `https://api.elevenlabs.io/v1/text-to-speech/{voice_id}`
- **Model**: `eleven_multilingual_v2`
- **Voice**: Ivanna (`cgSgspJ2msm6clMCkdW9`)
- **Output**: MP3 audio

### OpenAI GPT-4o (Chat & Roasts)
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Model**: `gpt-4o`
- **Temperature**: 0.9 (sassy responses), 0.6 (teacher feedback), 0.7 (assignment summaries)
- **Max Tokens**: 80 (chat/roasts), 120 (teacher/assignment)

### OpenAI GPT-4.1 (Lens)
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Model**: `gpt-4.1`
- **Temperature**: 0.3
- **Max Tokens**: 120

### Gemini (Vision) — *Planned*
- **Endpoint**: `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent`
- A Gemini API key slot is included in `config.swift.template` for future vision-based behavior monitoring

## Personality

TalkBack is designed to be:
- 😏 **Sassy**: Witty comebacks and attitude-filled responses
- 🎯 **Helpful**: Actually useful advice (hidden in the sass)
- 💁‍♀️ **Pushy**: Won't let you procrastinate
- 🧠 **Smart**: Remembers your conversations
- 🎤 **Talkative**: Loves to chat (maybe too much)
- 👩‍🏫 **Educational**: Teaches you when your code fails (teacher mode)

## Troubleshooting

### No Voice Output?
- Check system volume and audio output device
- Verify ElevenLabs API key and voice ID in `config.swift`
- Look for `🎤 ElevenLabs TTS HTTP Status: 200` in terminal

### Not Hearing Me?
- Check microphone permissions (System Settings → Privacy & Security → Microphone)
- Verify ElevenLabs API key is valid
- Look for `✅ Continuous listening started!` in terminal output
- Ensure you're speaking loud enough (amplitude threshold is 0.015)

### Lens Not Working?
- Grant Accessibility permission: System Settings → Privacy & Security → Accessibility
- Enable Lens Mode from the menu bar icon, or hold **⌥ Option**
- Verify your OpenAI API key is set in `config.swift`

### Rate Limit Errors?
- OpenAI usage limits: Check your account for current limits
- TalkBack has a built-in 22-second cooldown between OpenAI calls
- Add payment method or wait for cooldown to expire

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
- Make sure `config.swift` exists and is included in the compile command

## Development Notes

This project was developed on **macOS 26.0.1 beta** with **Swift 6.2**, which required special handling:
- Explicit compilation target (`-target arm64-apple-macosx13.0`)
- Avoided unstable `SFSpeechRecognizer` framework
- Used ElevenLabs STT instead of macOS built-in speech recognition
- Prioritized `AVAudioPlayer` for MP3 playback
- Uses `AVAudioEngine` for continuous microphone input with voice activity detection

## Future Features

- [ ] Gemini vision-based behavior monitoring (webcam gaze/emotion detection)
- [ ] Screen monitoring (detect what user is doing)
- [ ] Context-aware productivity tips
- [ ] Custom voice selection
- [ ] Multiple personality modes
- [ ] Scheduled check-ins
- [ ] Integration with calendar/reminders

## Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Submit pull requests
- Improve documentation

## License

MIT License - feel free to use, modify, and distribute.

## Acknowledgments

- **OpenAI** for GPT-4o and GPT-4.1 APIs
- **Google** for Gemini API (planned vision features)
- **ElevenLabs** for Speech-to-Text and Text-to-Speech APIs
- **Ivanna** for the sassy voice that brings TalkBack to life

## Questions or Feedback?

Open an issue or reach out! TalkBack loves to chat (obviously). 😉

---

**Made with 💻 and a lot of sass** by [yogesh-mahendran](https://github.com/aran-yogesh)
