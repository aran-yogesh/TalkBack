# 🗣️💥 TalkBack — Your Annoying (But Ridiculously Useful) AI Companion 🤖✨

> *"Oh, you thought you could procrastinate in peace? Think again, sweetheart."* — TalkBack

A mischievous macOS floating avatar that acts as your sassy, helpful (but oh-so-pushy) productivity coach. 💅 TalkBack is an interactive AI companion that listens to you, remembers your conversations, and responds with attitude-filled voice feedback — whether you asked for it or not. 😏🔥

## 📑 Table of Contents

- [🎯 Features](#-features)
- [🛠️ Tech Stack](#️-tech-stack)
- [🚀 Quick Start](#-quick-start)
- [🎮 How to Use](#-how-to-use)
- [📂 Project Structure](#-project-structure)
- [📋 API Endpoints Used](#-api-endpoints-used)
- [🎭 Personality](#-personality)
- [🐛 Troubleshooting (a.k.a. "Why Is It Broken?!")](#-troubleshooting-aka-why-is-it-broken)
- [📝 Development Notes](#-development-notes)
- [🔮 Future Features](#-future-features)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)
- [🙏 Acknowledgments](#-acknowledgments)
- [✍️ Authors](#️-authors)
- [💬 Questions or Feedback?](#-questions-or-feedback)


![macOS](https://img.shields.io/badge/macOS-26.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 🎯 Features

> *Buckle up, buttercup — TalkBack does A LOT.* 💅

### 🎤 **Real Voice Interaction** 🎙️
- 🖱️ **Click and Hold** the avatar to speak your mind
- 🔊 **ElevenLabs Speech-to-Text** for accurate voice recognition
- 🌍 Supports multiple languages (English, Bengali, Hindi, and more!)
- 💬 Natural conversation flow with real-time transcription

### 🗣️ **Sassy AI Responses** 💁‍♀️
- 🤖 **OpenAI GPT-4o** powered responses
- 🎧 **ElevenLabs Text-to-Speech** with Ivanna's voice
- 😏 Attitude-filled, personality-driven replies
- ⚡ Short, snappy responses that pack a punch

### 🧠 **Conversational Memory** 🐘
- 📝 Remembers your chat history (yes, *everything*)
- 🔗 Maintains context across conversations
- 🎯 Smart follow-ups based on previous interactions — she doesn't forget!

### 🎨 **Custom Floating Avatar** 👻
- 🪟 Transparent floating window (always on top — you can't hide from her)
- 👛 Custom purse/wallet icon design
- 👀 Animated eyes that follow your cursor (*creepy? maybe. cool? absolutely.*)
- 🎭 Dynamic expressions based on mood
- 🖐️ Draggable anywhere on your screen

### 🗑️ **"The Great Escape" Feature** 🏃‍♂️💨
- ⬆️ Drag avatar near the menu bar to reveal trash can
- 🪦 Drop in trash to quit (the *only* way to close it — good luck!)
- 😈 Adds a fun, mischievous interaction

### 👁️ **Vision-Based Behavior Monitoring** *(Planned)* 🔮
- 🔑 Gemini API key slot is included in the config for future vision features
- 🚧 Planned capabilities:
  - 👀 Detecting when you look away from the screen (*busted!*)
  - 😊😤😐 Emotion recognition (happy, frustrated, confused)
  - 🧐 Focus level tracking
  - 📱 Phone usage detection (*put it DOWN*)

### 🔥 **MCP Code Monitor** (Cursor IDE Integration) 🆕✨
- 👁️‍🗨️ **Watches your terminal for code execution results**
- 💀 **Auto-roasts you when you mess up!**
  - 🔥 **2+ errors**: Full savage roast mode 🫠
  - 😏 **1 error**: Light sass and sarcasm
  - 💅 **Success**: Sassy compliment with attitude ✨
- ⚙️ Integrates with Cursor IDE workflow
- 🗣️ Real-time feedback via Ivanna's voice

---

## 🛠️ Tech Stack

> *Only the finest ingredients for maximum sass.* 🧑‍🍳👨‍🍳

- 🦅 **Language**: Swift 6.2
- 🖥️ **Framework**: AppKit (native macOS — no Electron here, we have *standards*)
- 🤖 **AI & Voice Services**:
  - [OpenAI GPT-4o](https://platform.openai.com/) — Conversational AI (the brain 🧠)
  - [Gemini](https://aistudio.google.com/) — Vision & behavior analysis *(planned)* 🔮
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) — Voice recognition (the ears 👂)
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) — Voice synthesis / Ivanna voice (the mouth 👄)
- 🎵 **Audio & Video**: AVFoundation (NSSound, AVAudioRecorder, AVCaptureSession)

---

## 🚀 Quick Start

> *Let's get this show on the road!* 🏎️💨

### 📋 Prerequisites

1. 🍎 **macOS 13.0+** (developed on macOS 26.0.1 beta)
2. 🔧 **Xcode Command Line Tools** installed
3. 🔑 **API Keys** (gotta pay to play, darling):
   - OpenAI API key ([Get one here](https://platform.openai.com/account/api-keys)) 🤖
   - ElevenLabs API key ([Get one here](https://elevenlabs.io/)) 🎙️
   - Gemini API key ([Get one here](https://aistudio.google.com/app/apikey)) 👁️

### 💾 Installation

1. **Clone the repository** (you know the drill):
   ```bash
   git clone https://github.com/aran-yogesh/TalkBack.git
   cd TalkBack
   ```

2. **Configure API Keys** 🔐:
   
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
   
   > ⚠️ **Note**: `config.swift` is gitignored so your keys stay local. Never commit real API keys. *Seriously. Don't.* 🙅‍♀️

3. **Compile the app** 🏗️:
   ```bash
   swiftc -o ConversationalTalkBack ConversationalTalkBack.swift \
     -framework Cocoa -framework Foundation -framework AVFoundation \
     -target arm64-apple-macosx13.0
   ```

4. **Run TalkBack** 🎉:
   ```bash
   ./ConversationalTalkBack
   ```
   > *Congratulations, you've unleashed her. No take-backs.* 😈

---

## 🎮 How to Use

### 🕹️ Basic Usage

1. 🟢 **Start the App**: Run `./ConversationalTalkBack`
2. 📸 **Grant Camera Permission**: Allow camera access when prompted (required for vision monitoring)
3. 🗣️ **Talk to TalkBack**:
   - 🖱️ **Click and HOLD** the avatar
   - 🎤 **Speak** your message
   - ✋ **Release** to send
4. 👂 **Listen**: TalkBack responds with Ivanna's voice and *maximum attitude*
5. 🖐️ **Drag**: Move the avatar anywhere on your screen (she'll follow you anyway 👀)
6. 🗑️ **Quit**: Drag avatar near the menu bar → drop in trash can (*if you dare*)

### 🔥 MCP Code Monitoring (Cursor IDE Integration) 💻🫡

TalkBack can watch your terminal and **roast you into oblivion** when your code fails! 🍳 Here's how:

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

4. **Example test** 🧪:
   ```bash
   # This will trigger a savage roast 🔥💀
   python3 cursor_code_monitor.py run 'python3 broken_code.py'
   
   # TalkBack will speak the roast with Ivanna's voice! 🗣️😈
   ```

---

## 📂 Project Structure

> *Here's what's under the hood, nosy.* 🔍

| File | Purpose |
|---|---|
| `ConversationalTalkBack.swift` | 🧠 Main app — floating avatar, voice chat, MCP polling |
| `config.swift.template` | 🔑 API key template (copy to `config.swift` and add your keys) |
| `cursor_code_monitor.py` | 🔥 Standalone code monitor — wraps commands and writes roast triggers |
| `cursor_mcp_server.py` | 🔌 MCP server for Cursor IDE integration (stdio transport) |
| `test_mcp_connection.py` | 🧪 Quick test to verify `/tmp/talkback_message.json` IPC works |
| `broken_code.py` | 💀 Intentionally broken script for testing roast triggers |
| `start_talkback_mcp.sh` | 🚀 Compiles and launches TalkBack with MCP support |
| `start_integration.sh` | ⚙️ Sets up venv and verifies MCP connection |
| `mcp_config.json` | 📋 Cursor IDE MCP server configuration |

---

## 📋 API Endpoints Used

> *The secret sauce recipes.* 🍝🤌

### 👂 ElevenLabs Speech-to-Text
- **Endpoint**: `https://api.elevenlabs.io/v1/speech-to-text`
- **Model**: `scribe_v1`
- **Input**: WAV audio (16kHz, mono, PCM) 🎵
- **Output**: Transcribed text with language detection 📝

### 👄 ElevenLabs Text-to-Speech
- **Endpoint**: `https://api.elevenlabs.io/v1/text-to-speech/{voice_id}`
- **Model**: `eleven_multilingual_v2`
- **Voice**: Ivanna (`cgSgspJ2msm6clMCkdW9`) 🎤✨
- **Output**: MP3 audio 🔊

### 🧠 OpenAI GPT-4o
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Model**: `gpt-4o`
- **Temperature**: 0.9 (cranked up for *maximum sass* 🌶️)
- **Max Tokens**: 80 (short, snappy replies — she doesn't ramble 💅)

### 👁️ Gemini (Vision) — *Planned* 🔮
- **Endpoint**: `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent`
- A Gemini API key slot is included in `config.swift.template` for future vision-based behavior monitoring 🚧

---

## 🎭 Personality

> *She's not just an AI. She's a whole MOOD.* 💃

TalkBack is designed to be:
- 😏 **Sassy**: Witty comebacks and attitude-filled responses — she *invented* shade 🕶️
- 🎯 **Helpful**: Actually useful advice (hidden under layers of sass) 🎁
- 💁‍♀️ **Pushy**: Won't let you procrastinate — she's your accountability bestie whether you like it or not 📣
- 🧠 **Smart**: Remembers your conversations — *every. single. one.* 🐘
- 🎤 **Talkative**: Loves to chat (maybe too much… okay, *definitely* too much) 🗣️💬

---

## 🐛 Troubleshooting (a.k.a. "Why Is It Broken?!")

> *Don't panic. Okay, panic a little. Then read below.* 😅

### 🔇 No Voice Output? *(She's giving you the silent treatment)*
- 🔊 Check system volume and audio output device
- 🔑 Verify ElevenLabs API key and voice ID
- 🔍 Look for `🎤 ElevenLabs TTS HTTP Status: 200` in terminal

### 🤐 Empty Transcriptions? *(She can't hear you, bestie)*
- 🖱️ Ensure you're holding the mouse button while speaking
- 🎙️ Check microphone permissions (System Settings → Privacy & Security → Microphone)
- 🔑 Verify ElevenLabs API key is valid

### 🚦 Rate Limit Errors? *(Slow down, speed racer)*
- 💳 OpenAI usage limits: Check your account for current limits
- ⏳ Add payment method or wait 20 seconds between requests

### 📁 Missing `config.swift`? *(Classic rookie move)*
- 📋 Copy the template: `cp config.swift.template config.swift`
- 🔑 Add your API keys to `config.swift`

### 🤫 MCP Roasts Not Triggering? *(She's on break, apparently)*
- ✅ Ensure TalkBack is running (it polls `/tmp/talkback_message.json` every 0.5s)
- 🏃 Run commands through the monitor: `python3 cursor_code_monitor.py run "YOUR_COMMAND"`
- 📦 Check that `watchdog` is installed: `pip3 install watchdog`

### 💥 Crashes on Launch? *(Oof, that's rough)*
- 🎯 Compile with explicit target: `-target arm64-apple-macosx13.0`
- 🔢 Check Swift version: `swift --version`
- ⚠️ Beta macOS can be unstable with Speech framework

---

## 📝 Development Notes

> *A peek behind the curtain for the nerds (said with love 🤓💕).*

This project was developed on **macOS 26.0.1 beta** with **Swift 6.2**, which required some ✨special✨ handling:
- 🎯 Explicit compilation target (`-target arm64-apple-macosx13.0`)
- 🚫 Avoided unstable `SFSpeechRecognizer` framework (*it was NOT cooperating*)
- 🎙️ Used ElevenLabs STT instead of macOS built-in speech recognition
- 🔊 Prioritized `NSSound` over `AVAudioPlayer` for better MP3 compatibility

---

## 🔮 Future Features

> *She's only getting more powerful. Be afraid. Be very afraid.* 😈⚡

- [ ] 👁️ Gemini vision-based behavior monitoring (webcam gaze/emotion detection)
- [ ] 🖥️ Screen monitoring (detect what user is doing — *no more slacking!*)
- [ ] 💡 Context-aware productivity tips
- [ ] 🎤 Custom voice selection (more voices, more sass)
- [ ] 🎭 Multiple personality modes (nice mode? *unlikely, but possible*)
- [ ] ⏰ Scheduled check-ins (she WILL find you)
- [ ] 📅 Integration with calendar/reminders

---

## 🤝 Contributing

> *Wanna make TalkBack even sassier? We're here for it.* 💅🔥

Contributions are welcome! Check out [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide 📖, or just dive in:
- 🐛 Report bugs (she has *quirks*, okay?)
- 💡 Suggest new features
- 🔀 Submit pull requests
- 📖 Improve documentation

---

## 📄 License

MIT License — feel free to use, modify, and distribute. Sass responsibly. ⚖️💅

---

## 🙏 Acknowledgments

> *Credit where credit is due, darling.* 🏆

- 🤖 **OpenAI** for GPT-4o API (the brains behind the sass)
- 👁️ **Google** for Gemini API (planned vision features — *she'll be watching* 👀)
- 🎙️ **ElevenLabs** for Speech-to-Text and Text-to-Speech APIs (the voice of chaos)
- 👑 **Ivanna** for the sassy voice that brings TalkBack to life — the real MVP ✨

---

## ✍️ Authors

- 🧑‍💻 **Yogesh Mahendran** — Creator & Lead Developer (a.k.a. the person who unleashed this upon the world 🌍😈)

---

## 💬 Questions or Feedback?

Open an issue or reach out! TalkBack loves to chat (obviously). 😉💬

Got a feature idea? A bug report? Just wanna say hi? *She's always listening.* 👂✨

---

<p align="center">
  <b>Made with 💻, ☕, and an unreasonable amount of sass</b><br>
  by <a href="https://github.com/aran-yogesh">@aran-yogesh</a> 🔥💅✨
</p>

<p align="center">
  <i>TalkBack: Because you didn't ask for an AI with attitude, but you're getting one anyway.</i> 😏🤖
</p>
