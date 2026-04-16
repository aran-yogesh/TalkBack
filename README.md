# 🗣️💥 TalkBack — The Annoying (But Lowkey Genius) AI Companion 🤖✨

> _"Did I ask for your opinion? No. Am I giving it anyway? Absolutely."_ — TalkBack, probably

A mischievous macOS floating avatar that acts as your sassy, helpful (but pushy) productivity coach. TalkBack is an interactive AI companion that listens to you 👂, remembers your conversations 🧠, and responds with attitude-filled voice feedback 🎤🔥. Think of it as that one friend who roasts you but also won't let you fail. 💅

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

## 🎯 Features — aka Why You Need This in Your Life

### 🎤 **Real Voice Interaction** 🗣️🎙️
- **Click and Hold** the avatar to speak your mind (yes, it actually listens — unlike your ex 💔)
- **ElevenLabs Speech-to-Text** for accurate voice recognition 🎯
- Supports multiple languages (English, Bengali, Hindi, and more!) 🌍🗺️
- Natural conversation flow with real-time transcription ⚡

### 🗣️ **Sassy AI Responses** 💁‍♀️🔥
- **OpenAI GPT-4o** powered responses 🧠⚡
- **ElevenLabs Text-to-Speech** with Ivanna's voice 🎵
- Attitude-filled, personality-driven replies 😤💅
- Short, snappy responses that pack a punch 👊💥

### 🧠 **Conversational Memory** 🐘
- Remembers your chat history (it never forgets, just like your mom 😂)
- Maintains context across conversations 🔗
- Smart follow-ups based on previous interactions 🕵️‍♀️

### 🎨 **Custom Floating Avatar** 👻✨
- Transparent floating window (always on top — it's clingy like that 🫠)
- Custom purse/wallet icon design 👛
- Animated eyes that follow your cursor 👀👀👀
- Dynamic expressions based on mood 😊😤😐🤯
- Draggable anywhere on your screen 🖱️💨

### 🗑️ **"The Great Escape" Feature** 🏃‍♂️💨
- Drag avatar near the menu bar to reveal trash can 🗑️
- Drop in trash to quit (the only way to close it! Good luck escaping 😈)
- Adds a fun, mischievous interaction 🎪

### 👁️ **Vision-Based Behavior Monitoring** *(Planned)* 🔮
- Gemini API key slot is included in the config for future vision features 🔑
- Planned capabilities:
  - 👀 Detecting when you look away from the screen (busted! 🚨)
  - 😊😤😐 Emotion recognition (happy, frustrated, confused)
  - 🧐 Focus level tracking (are you even trying? 📉)
  - 📱 Phone usage detection (put. the. phone. DOWN. 🙅‍♀️)

### 🔥 **MCP Code Monitor** (Cursor IDE Integration) 🆕🚨
- **Watches your terminal for code execution results** 🖥️👁️
- **Auto-roasts you when you mess up!** 💀
  - 🔥🔥🔥 **2+ errors**: Full savage roast mode — no mercy
  - 😏 **1 error**: Light sass and sarcasm — you're almost there, champ
  - 💅✨ **Success**: Sassy compliment with attitude — don't let it go to your head
- Integrates with Cursor IDE workflow 🔌
- Real-time feedback via Ivanna's voice 🗣️💬

## 🛠️ Tech Stack — The Secret Sauce 🧪🍳

- **Language**: Swift 6.2 🦅
- **Framework**: AppKit (native macOS — keeping it classy 🎩)
- **AI & Voice Services** 🤖🎙️:
  - [OpenAI GPT-4o](https://platform.openai.com/) — Conversational AI (the brain 🧠)
  - [Gemini](https://aistudio.google.com/) — Vision & behavior analysis *(planned)* 🔮
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) — Voice recognition (the ears 👂)
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) — Voice synthesis / Ivanna voice (the mouth 👄)
- **Audio & Video**: AVFoundation (NSSound, AVAudioRecorder, AVCaptureSession) 🎬🔊

## 🚀 Quick Start — Let's Get This Party Started 🎉

### Prerequisites 📋

1. **macOS 13.0+** (developed on macOS 26.0.1 beta) 🍎
2. **Xcode Command Line Tools** installed 🔧
3. **API Keys** 🔑🔑🔑 (gotta collect 'em all):
   - OpenAI API key ([Get one here](https://platform.openai.com/account/api-keys)) 🧠
   - ElevenLabs API key ([Get one here](https://elevenlabs.io/)) 🎙️
   - Gemini API key ([Get one here](https://aistudio.google.com/app/apikey)) 👁️

### Installation 🏗️

1. **Clone the repository** (welcome to the chaos 🫡):
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
   
   > ⚠️ **Note**: `config.swift` is gitignored so your keys stay local. Never commit real API keys. Seriously. Don't. 🙅‍♂️🚫

3. **Compile the app** 🔨⚡:
   ```bash
   swiftc -o ConversationalTalkBack ConversationalTalkBack.swift \
     -framework Cocoa -framework Foundation -framework AVFoundation \
     -target arm64-apple-macosx13.0
   ```

4. **Run TalkBack** 🏁🎬:
   ```bash
   ./ConversationalTalkBack
   ```
   > 🎉 Congrats, you now have an AI that won't shut up. You're welcome.

## 🎮 How to Use — The User Manual Nobody Reads 📖😏

### Basic Usage 🕹️

1. 🟢 **Start the App**: Run `./ConversationalTalkBack`
2. 📸 **Grant Camera Permission**: Allow camera access when prompted (required for vision monitoring — it's not being creepy, promise 😇)
3. 🗣️ **Talk to TalkBack**:
   - **Click and HOLD** the avatar 🖱️⬇️
   - **Speak** your message 🎤
   - **Release** to send 🚀
4. 👂 **Listen**: TalkBack responds with Ivanna's voice and attitude (brace yourself 😤)
5. 🖱️ **Drag**: Move the avatar anywhere on your screen
6. 🗑️ **Quit**: Drag avatar near the menu bar → drop in trash can (it's the only way out 😈🔒)

### 🔥 MCP Code Monitoring (Cursor IDE Integration) — The Roast Zone 🍖😈

TalkBack can watch your terminal and roast you when your code fails! Here's how to get absolutely destroyed 💀:

1. 🟢 **Start TalkBack** (it automatically monitors `/tmp/talkback_message.json`)

2. 🏃‍♂️ **Run your code through the monitor**:
   ```bash
   # Test with a script that has errors (will trigger full roast 🔥🔥🔥)
   python3 cursor_code_monitor.py run 'python3 your_broken_script.py'
   
   # Test with successful code (will get sassy compliment 💅✨)
   python3 cursor_code_monitor.py run 'python3 your_working_script.py'
   
   # Test with any command 🧪
   python3 cursor_code_monitor.py run 'swift your_code.swift'
   ```

3. 🎭 **TalkBack will roast you based on errors**:
   - ✅ **0 errors**: _"Oh wow, it ACTUALLY worked? Color me shocked, darling! 💅✨"_
   - 😏 **1 error**: _"ONE error? Cute. At least you're almost there, sweetheart. 😏"_
   - 🔥💀 **2+ errors**: _"Oh HONEY, what is this hot mess? Did you code this with your eyes closed? 🔥💀"_

4. 🧪 **Example test**:
   ```bash
   # This will trigger a savage roast 🔥🔥🔥
   python3 cursor_code_monitor.py run 'python3 broken_code.py'
   
   # TalkBack will speak the roast with Ivanna's voice! 🗣️💥
   ```

## 📂 Project Structure — What's in the Box? 📦🤔

| File | Purpose |
|---|---|
| `ConversationalTalkBack.swift` 🦅 | Main app — floating avatar, voice chat, MCP polling |
| `config.swift.template` 🔑 | API key template (copy to `config.swift` and add your keys) |
| `cursor_code_monitor.py` 🕵️ | Standalone code monitor — wraps commands and writes roast triggers |
| `cursor_mcp_server.py` 🔌 | MCP server for Cursor IDE integration (stdio transport) |
| `test_mcp_connection.py` 🧪 | Quick test to verify `/tmp/talkback_message.json` IPC works |
| `broken_code.py` 💥 | Intentionally broken script for testing roast triggers |
| `start_talkback_mcp.sh` 🚀 | Compiles and launches TalkBack with MCP support |
| `start_integration.sh` ⚙️ | Sets up venv and verifies MCP connection |
| `mcp_config.json` 📋 | Cursor IDE MCP server configuration |

## 📋 API Endpoints Used — The Plumbing Behind the Sass 🔧💬

### 👂 ElevenLabs Speech-to-Text
- **Endpoint**: `https://api.elevenlabs.io/v1/speech-to-text`
- **Model**: `scribe_v1`
- **Input**: WAV audio (16kHz, mono, PCM) 🎵
- **Output**: Transcribed text with language detection 📝

### 👄 ElevenLabs Text-to-Speech
- **Endpoint**: `https://api.elevenlabs.io/v1/text-to-speech/{voice_id}`
- **Model**: `eleven_multilingual_v2`
- **Voice**: Ivanna (`cgSgspJ2msm6clMCkdW9`) 🎤👑
- **Output**: MP3 audio 🔊

### 🧠 OpenAI GPT-4o
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Model**: `gpt-4o`
- **Temperature**: 0.9 (cranked up for maximum sass 🌶️)
- **Max Tokens**: 80 (short, snappy replies — ain't nobody got time for essays 💅)

### 🔮 Gemini (Vision) — *Planned*
- **Endpoint**: `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent`
- A Gemini API key slot is included in `config.swift.template` for future vision-based behavior monitoring 👁️🔮

## 🎭 Personality — Who Even IS She? 💃

TalkBack is designed to be:
- 😏 **Sassy**: Witty comebacks and attitude-filled responses — she woke up and chose violence
- 🎯 **Helpful**: Actually useful advice (hidden under 17 layers of sass 🧅)
- 💁‍♀️ **Pushy**: Won't let you procrastinate — your deadlines are her deadlines now
- 🧠 **Smart**: Remembers your conversations (and will use them against you 😈)
- 🎤 **Talkative**: Loves to chat (maybe too much — you've been warned ⚠️)

## 🐛 Troubleshooting — When Things Go Sideways 🫠

### 🔇 No Voice Output?
- Check system volume and audio output device 🔊
- Verify ElevenLabs API key and voice ID 🔑
- Look for `🎤 ElevenLabs TTS HTTP Status: 200` in terminal ✅

### 🤫 Empty Transcriptions?
- Ensure you're holding the mouse button while speaking (don't be shy 🫣)
- Check microphone permissions (System Settings → Privacy & Security → Microphone) 🎙️
- Verify ElevenLabs API key is valid 🔑

### 🚦 Rate Limit Errors?
- OpenAI usage limits: Check your account for current limits 📊
- Add payment method or wait 20 seconds between requests ⏳ (patience, grasshopper 🦗)

### 🔑 Missing `config.swift`?
- Copy the template: `cp config.swift.template config.swift`
- Add your API keys to `config.swift` (we literally just told you this 😤)

### 🤖 MCP Roasts Not Triggering?
- Ensure TalkBack is running (it polls `/tmp/talkback_message.json` every 0.5s) ⏱️
- Run commands through the monitor: `python3 cursor_code_monitor.py run "YOUR_COMMAND"` 🏃
- Check that `watchdog` is installed: `pip3 install watchdog` 🐕

### 💥 Crashes on Launch?
- Compile with explicit target: `-target arm64-apple-macosx13.0` 🎯
- Check Swift version: `swift --version` 🦅
- Beta macOS can be unstable with Speech framework (blame Apple, not us 🍎🤷)

## 📝 Development Notes — The War Stories 🪖📜

This project was developed on **macOS 26.0.1 beta** with **Swift 6.2** 🦅, which required special handling (read: suffering 😭):
- Explicit compilation target (`-target arm64-apple-macosx13.0`) 🎯
- Avoided unstable `SFSpeechRecognizer` framework (it betrayed us 🗡️)
- Used ElevenLabs STT instead of macOS built-in speech recognition 🎙️✨
- Prioritized `NSSound` over `AVAudioPlayer` for better MP3 compatibility 🔊👍

## 🔮 Future Features — The Roadmap of Chaos 🗺️🌪️

- [ ] 👁️ Gemini vision-based behavior monitoring (webcam gaze/emotion detection — Big Sister is watching 👀)
- [ ] 🖥️ Screen monitoring (detect what user is doing — no more secret Netflix 🍿)
- [ ] 💡 Context-aware productivity tips (actually helpful, we promise 🤞)
- [ ] 🎵 Custom voice selection (pick your own tormentor 😈)
- [ ] 🎭 Multiple personality modes (nice mode? maybe. probably not. 😏)
- [ ] ⏰ Scheduled check-ins (she WILL find you 🔍)
- [ ] 📅 Integration with calendar/reminders (your meetings are her business now 💼)

## 🤝 Contributing — Join the Chaos 🎪🤹

Contributions are welcome! We don't bite (TalkBack might though 😈). Feel free to:
- 🐛 Report bugs (there are none... just kidding, please help 😅)
- 💡 Suggest new features (the wilder the better 🤪)
- 🔀 Submit pull requests (we love free labor— er, collaboration 🫶)
- 📝 Improve documentation (you're reading it, so clearly it needs work 😂)

Check out [CONTRIBUTIONS.md](CONTRIBUTIONS.md) for the full guide! 📖✨

## 📄 License — The Legal Stuff 📜⚖️

MIT License — feel free to use, modify, and distribute. Go wild. We're not your parents. 🤷‍♂️🎉

## 🙏 Acknowledgments — Shoutouts to the Real Ones 🫡💖

- **OpenAI** for GPT-4o API 🧠 (the brains behind the sass)
- **Google** for Gemini API 🔮 (planned vision features — soon™)
- **ElevenLabs** for Speech-to-Text and Text-to-Speech APIs 🎙️🔊 (the voice of chaos)
- **Ivanna** for the sassy voice that brings TalkBack to life 👑💅 (the real MVP)
- **Coffee** ☕ for making all of this possible (the unsung hero)

## ✍️ Authors — The Masterminds 🧑‍💻🦹

- **Yogesh Mahendran** — Creator & Lead Developer & Chief Chaos Officer 🎩🔥

## 💬 Questions or Feedback? 🤔💭

Open an issue or reach out! TalkBack loves to chat (obviously) 😉. We promise we'll respond faster than TalkBack roasts your code 🔥💀.

> _"You miss 100% of the issues you don't open."_ — Wayne Gretzky — Michael Scott — TalkBack 🏒😂

---

<p align="center">
  Made with ❤️, ☕, and an unhealthy amount of sass 💅✨
</p>

**Made with 💻 and a lot of sass** by [@aran-yogesh](https://github.com/aran-yogesh)
