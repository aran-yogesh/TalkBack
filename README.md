# 🤖 TalkBack — Your Annoying (But Lovable) AI Companion 💅

> *"Oh, you thought you could code in peace? That's adorable."* — TalkBack

A mischievous macOS floating avatar that acts as your sassy, helpful (but *extremely* pushy) productivity coach. TalkBack listens to you, remembers your conversations, judges your code, and responds with attitude-filled voice feedback. You didn't ask for it. You can't close it normally. You're welcome. 😘

## 📑 Table of Contents

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
- [✍️ Authors](#️-authors)
- [💬 Questions or Feedback?](#-questions-or-feedback)

![macOS](https://img.shields.io/badge/macOS-26.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Sass Level](https://img.shields.io/badge/sass%20level-over%209000-ff69b4.svg)

---

## 🎯 Features

### 🎤 **Real Voice Interaction** — *Talk to it. It talks back. Shocking, right?*
- 🖱️ **Click and Hold** the avatar to speak your mind (it's judging you already)
- 🧏 **ElevenLabs Speech-to-Text** for accurate voice recognition
- 🌍 Supports multiple languages (English, Bengali, Hindi, and more!)
- 💬 Natural conversation flow with real-time transcription

### 🗣️ **Sassy AI Responses** — *GPT-4o with an attitude problem*
- 🧠 **OpenAI GPT-4o** powered responses
- 🎙️ **ElevenLabs Text-to-Speech** with Ivanna's iconic voice
- 💁‍♀️ Attitude-filled, personality-driven replies
- ⚡ Short, snappy responses that pack a punch

### 🧠 **Conversational Memory** — *It remembers EVERYTHING. Good luck.*
- 📝 Remembers your chat history
- 🔗 Maintains context across conversations
- 🕵️ Smart follow-ups based on previous interactions

### 🎨 **Custom Floating Avatar** — *It's always watching. Always.*
- 👻 Transparent floating window (always on top — you can't hide)
- 👛 Custom purse/wallet icon design
- 👀 Animated eyes that follow your cursor (creepy? maybe. fun? absolutely.)
- 🎭 Dynamic expressions based on mood
- 🖐️ Draggable anywhere on your screen

### 🗑️ **"The Great Escape" Feature** — *The ONLY way out*
- ⬆️ Drag avatar near the menu bar to reveal the trash can
- 🪦 Drop in trash to quit (seriously, it's the *only* way to close it)
- 😈 Adds a fun, mischievous interaction

### 👁️ **Vision-Based Behavior Monitoring** *(Planned — be afraid)* 🔮
- 🔑 Gemini API key slot is included in the config for future vision features
- 🗺️ Planned capabilities:
  - 👀 Detecting when you look away from the screen (*"Eyes up here, bestie!"*)
  - 😊😤😐 Emotion recognition (happy, frustrated, confused)
  - 🧐 Focus level tracking (*"Are you even trying?"*)
  - 📱 Phone usage detection (*"Put. The phone. DOWN."*)

### 🔥 **MCP Code Monitor** (Cursor IDE Integration) — *NEW & SAVAGE!* 🆕
- 🖥️ **Watches your terminal for code execution results**
- 💀 **Auto-roasts you when you mess up!**
  - 🔥 **2+ errors**: Full savage roast mode — *"Oh HONEY, what is this hot mess?"*
  - 😏 **1 error**: Light sass and sarcasm — *"ONE error? Cute."*
  - 💅 **Success**: Sassy compliment with attitude — *"Oh wow, it ACTUALLY worked?"*
- 🔌 Integrates with Cursor IDE workflow
- 🎙️ Real-time feedback via Ivanna's voice

---

## 🛠️ Tech Stack

| Layer | Tech | Notes |
|---|---|---|
| 🖥️ **Language** | Swift 6.2 | Because we're fancy |
| 🪟 **Framework** | AppKit (native macOS) | Floating window magic |
| 🤖 **Chat AI** | [OpenAI GPT-4o](https://platform.openai.com/) | The brain behind the sass |
| 👁️ **Vision AI** | [Gemini](https://aistudio.google.com/) | *(planned)* — behavior analysis |
| 🧏 **Speech-to-Text** | [ElevenLabs STT](https://elevenlabs.io/) | Hears every word |
| 🗣️ **Text-to-Speech** | [ElevenLabs TTS](https://elevenlabs.io/) | Ivanna's iconic voice |
| 🔊 **Audio/Video** | AVFoundation | NSSound, AVAudioRecorder, AVCaptureSession |

---

## 🚀 Quick Start

### 📋 Prerequisites

1. 🍎 **macOS 13.0+** (developed on macOS 26.0.1 beta)
2. 🔨 **Xcode Command Line Tools** installed
3. 🔑 **API Keys** (yes, all three — TalkBack is high-maintenance):
   - 🤖 OpenAI API key → [Get one here](https://platform.openai.com/account/api-keys)
   - 🎙️ ElevenLabs API key → [Get one here](https://elevenlabs.io/)
   - 👁️ Gemini API key → [Get one here](https://aistudio.google.com/app/apikey)

### 🏗️ Installation

**Step 1 — Clone the repo** 📦
```bash
git clone https://github.com/aran-yogesh/TalkBack.git
cd TalkBack
```

**Step 2 — Configure API Keys** 🔐

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

> ⚠️ **Important**: `config.swift` is gitignored so your keys stay local. Never commit real API keys. TalkBack will judge you if you do. 🫣

**Step 3 — Compile the app** 🔨
```bash
swiftc -o ConversationalTalkBack ConversationalTalkBack.swift \
  -framework Cocoa -framework Foundation -framework AVFoundation \
  -target arm64-apple-macosx13.0
```

**Step 4 — Run TalkBack** 🚀
```bash
./ConversationalTalkBack
```

> 🎉 *Congratulations, you now have an AI that won't leave you alone. Enjoy!*

---

## 🎮 How to Use

### 🕹️ Basic Usage

| Step | Action | Details |
|---|---|---|
| 1️⃣ | **Start the App** | Run `./ConversationalTalkBack` |
| 2️⃣ | **Grant Camera Permission** | Allow camera access when prompted 📸 |
| 3️⃣ | **Talk to TalkBack** | 🖱️ **Click and HOLD** → 🗣️ **Speak** → ✋ **Release** to send |
| 4️⃣ | **Listen** | TalkBack responds with Ivanna's voice and *maximum attitude* 💅 |
| 5️⃣ | **Drag** | Move the avatar anywhere on your screen 🖐️ |
| 6️⃣ | **Quit** | Drag avatar near the menu bar → 🗑️ drop in trash can *(the ONLY way!)* |

### 🔥 MCP Code Monitoring (Cursor IDE Integration)

TalkBack can watch your terminal and roast you when your code fails! 🍿 Here's how:

**1. Start TalkBack** — it automatically monitors `/tmp/talkback_message.yaml`

**2. Run your code through the monitor:**
```bash
# 💥 Test with a script that has errors (will trigger full roast 🔥)
python3 cursor_code_monitor.py run 'python3 your_broken_script.py'

# ✨ Test with successful code (will get sassy compliment 💅)
python3 cursor_code_monitor.py run 'python3 your_working_script.py'

# 🧪 Test with any command
python3 cursor_code_monitor.py run 'swift your_code.swift'
```

**3. TalkBack will roast you based on errors:**

| Errors | Vibe | Example Response |
|---|---|---|
| ✅ **0** | Sassy compliment 💅 | *"Oh wow, it ACTUALLY worked? Color me shocked, darling! 💅✨"* |
| 😏 **1** | Light sass 😏 | *"ONE error? Cute. At least you're almost there, sweetheart. 😏"* |
| 🔥 **2+** | FULL SAVAGE MODE 💀 | *"Oh HONEY, what is this hot mess? Did you code this with your eyes closed? 🔥💀"* |

**4. Example test** — *brace yourself:*
```bash
# 🔥 This will trigger a savage roast
python3 cursor_code_monitor.py run 'python3 broken_code.py'

# 🎙️ TalkBack will speak the roast with Ivanna's voice!
```

---

## 📂 Project Structure

| File | Purpose |
|---|---|
| 🏠 `ConversationalTalkBack.swift` | Main app — floating avatar, voice chat, MCP polling |
| 🔐 `config.swift.template` | API key template (copy to `config.swift` and add your keys) |
| 🔍 `cursor_code_monitor.py` | Standalone code monitor — wraps commands and writes roast triggers |
| 🔌 `cursor_mcp_server.py` | MCP server for Cursor IDE integration (stdio transport) |
| 🧪 `test_mcp_connection.py` | Quick test to verify `/tmp/talkback_message.yaml` IPC works |
| 💥 `broken_code.py` | Intentionally broken script for testing roast triggers |
| 🚀 `start_talkback_mcp.sh` | Compiles and launches TalkBack with MCP support |
| ⚙️ `start_integration.sh` | Sets up venv and verifies MCP connection |
| 📋 `mcp_config.json` | Cursor IDE MCP server configuration |
| 📋 `cline_mcp_settings.json` | Cline MCP server configuration |
| 🧪 `tests/` | Unit tests for code monitor, MCP server, and YAML utilities |

---

## 📋 API Endpoints Used

### 🧏 ElevenLabs Speech-to-Text
- 🌐 **Endpoint**: `https://api.elevenlabs.io/v1/speech-to-text`
- 🤖 **Model**: `scribe_v1`
- 📥 **Input**: WAV audio (16kHz, mono, PCM)
- 📤 **Output**: Transcribed text with language detection

### 🗣️ ElevenLabs Text-to-Speech
- 🌐 **Endpoint**: `https://api.elevenlabs.io/v1/text-to-speech/{voice_id}`
- 🤖 **Model**: `eleven_multilingual_v2`
- 🎙️ **Voice**: Ivanna (`cgSgspJ2msm6clMCkdW9`)
- 📤 **Output**: MP3 audio

### 🧠 OpenAI GPT-4o
- 🌐 **Endpoint**: `https://api.openai.com/v1/chat/completions`
- 🤖 **Model**: `gpt-4o`
- 🌡️ **Temperature**: 0.9 (cranked up for maximum sass 🌶️)
- 📏 **Max Tokens**: 80 (short, snappy replies — ain't nobody got time for essays)

### 👁️ Gemini (Vision) — *Planned* 🔮
- 🌐 **Endpoint**: `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent`
- 🔑 A Gemini API key slot is included in `config.swift.template` for future vision-based behavior monitoring

---

## 🎭 Personality

TalkBack is designed to be your worst best friend:

| Trait | Description |
|---|---|
| 😏 **Sassy** | Witty comebacks and attitude-filled responses |
| 🎯 **Helpful** | Actually useful advice *(hidden under layers of sass)* |
| 💁‍♀️ **Pushy** | Won't let you procrastinate — *"Did I SAY you could take a break?"* |
| 🧠 **Smart** | Remembers your conversations *(yes, even that embarrassing one)* |
| 🎤 **Talkative** | Loves to chat *(maybe too much… definitely too much)* |
| 😈 **Unkillable** | You literally have to drag it to the trash to close it |

---

## 🐛 Troubleshooting

### 🔇 No Voice Output?
- 🔊 Check system volume and audio output device
- 🔑 Verify ElevenLabs API key and voice ID
- 🔍 Look for `🎤 ElevenLabs TTS HTTP Status: 200` in terminal

### 📝 Empty Transcriptions?
- 🖱️ Ensure you're holding the mouse button while speaking
- 🔒 Check microphone permissions (System Settings → Privacy & Security → Microphone)
- 🔑 Verify ElevenLabs API key is valid

### ⏱️ Rate Limit Errors?
- 💳 OpenAI usage limits: Check your account for current limits
- 💰 Add payment method or wait 20 seconds between requests

### 📄 Missing `config.swift`?
- 📋 Copy the template: `cp config.swift.template config.swift`
- 🔑 Add your API keys to `config.swift`

### 🔥 MCP Roasts Not Triggering?
- ✅ Ensure TalkBack is running (it polls `/tmp/talkback_message.yaml` every 0.5s)
- 🖥️ Run commands through the monitor: `python3 cursor_code_monitor.py run "YOUR_COMMAND"`
- 📦 Check that `watchdog` is installed: `pip3 install watchdog`

### 💥 Crashes on Launch?
- 🎯 Compile with explicit target: `-target arm64-apple-macosx13.0`
- 🔍 Check Swift version: `swift --version`
- ⚠️ Beta macOS can be unstable with Speech framework

---

## 📝 Development Notes

This project was developed on **macOS 26.0.1 beta** with **Swift 6.2**, which required some creative workarounds 🛠️:

- 🎯 Explicit compilation target (`-target arm64-apple-macosx13.0`)
- 🚫 Avoided unstable `SFSpeechRecognizer` framework
- 🎙️ Used ElevenLabs STT instead of macOS built-in speech recognition
- 🔊 Prioritized `NSSound` over `AVAudioPlayer` for better MP3 compatibility

---

## 🔮 Future Features

*TalkBack's world domination roadmap:*

- [ ] 👁️ Gemini vision-based behavior monitoring (webcam gaze/emotion detection)
- [ ] 🖥️ Screen monitoring (detect what user is doing)
- [ ] 💡 Context-aware productivity tips
- [ ] 🎙️ Custom voice selection
- [ ] 🎭 Multiple personality modes *(nice mode? never heard of her)*
- [ ] ⏰ Scheduled check-ins
- [ ] 📅 Integration with calendar/reminders

---

## 🤝 Contributing

Contributions are welcome! Feel free to:
- 🐛 Report bugs
- 💡 Suggest new features
- 🔧 Submit pull requests
- 📖 Improve documentation

> *TalkBack promises not to roast your PRs… much.* 😏

---

## 📄 License

MIT License — feel free to use, modify, and distribute. TalkBack is free, just like unsolicited advice. 💅

---

## 🙏 Acknowledgments

- 🤖 **OpenAI** for GPT-4o API
- 👁️ **Google** for Gemini API (planned vision features)
- 🎙️ **ElevenLabs** for Speech-to-Text and Text-to-Speech APIs
- 💅 **Ivanna** for the sassy voice that brings TalkBack to life

---

## ✍️ Authors

- 👨‍💻 **Yogesh Mahendran** — Creator & Lead Developer

---

## 💬 Questions or Feedback?

Open an issue or reach out! TalkBack loves to chat (obviously). 😉

*Pro tip: If TalkBack is being too sassy, that's a feature, not a bug.* 🐛✨

---

**Made with 💻, ☕, and a LOT of sass** by [@aran-yogesh](https://github.com/aran-yogesh) 💅🔥
