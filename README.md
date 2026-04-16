# 🗣️💥 TalkBack — The Annoying (But Lowkey Genius) AI Companion 🤖✨

> _"You didn't ask for my opinion, but here it is anyway."_ — TalkBack, probably

A mischievous macOS floating avatar that acts as your sassy, helpful (but pushy) productivity coach. 🎭💅 TalkBack is an interactive AI companion that listens to you 👂, remembers your conversations 🧠, and responds with attitude-filled voice feedback 🔊🫢. Think of it as that one friend who roasts you but also helps you get your life together. 🫶🔥

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

## 🎯 Features — _aka Why You Need This in Your Life_

### 🎤 **Real Voice Interaction** 🗣️🎙️
- 👆 **Click and Hold** the avatar to speak your mind
- 🔍 **ElevenLabs Speech-to-Text** for accurate voice recognition
- 🌍 Supports multiple languages (English, Bengali, Hindi, and more!) 🗺️
- 💬 Natural conversation flow with real-time transcription ⚡

### 🗣️ **Sassy AI Responses** 💅✨
- 🤖 **OpenAI GPT-4o** powered responses — big brain energy 🧠💡
- 🎙️ **ElevenLabs Text-to-Speech** with Ivanna's voice
- 😏 Attitude-filled, personality-driven replies
- 💥 Short, snappy responses that pack a punch 👊

### 🧠 **Conversational Memory** 🐘💭
- 📝 Remembers your chat history (yes, even that embarrassing thing you said)
- 🔗 Maintains context across conversations
- 🎯 Smart follow-ups based on previous interactions

### 🎨 **Custom Floating Avatar** 👻🪟
- 🪄 Transparent floating window (always on top — you can't escape it 😈)
- 👛 Custom purse/wallet icon design
- 👀 Animated eyes that follow your cursor (creepy? maybe. cool? absolutely.)
- 🎭 Dynamic expressions based on mood
- 🖱️ Draggable anywhere on your screen

### 🗑️ **"The Great Escape" Feature** 🏃‍♂️💨
- ⬆️ Drag avatar near the menu bar to reveal trash can
- 🫳 Drop in trash to quit (the only way to close it! good luck! 😂)
- 🎪 Adds a fun, mischievous interaction

### 👁️ **Vision-Based Behavior Monitoring** *(Planned)* 🔮🧿
- 🔑 Gemini API key slot is included in the config for future vision features
- 🚀 Planned capabilities:
  - 👀 Detecting when you look away from the screen (_busted!_ 🚨)
  - 😊😤😐 Emotion recognition (happy, frustrated, confused)
  - 🧐 Focus level tracking (_are you even trying?_ 💀)
  - 📱 Phone usage detection (_put. the. phone. down._ 📵)

### 🔥 **MCP Code Monitor** (Cursor IDE Integration) 🆕🚨
- 👁️‍🗨️ **Watches your terminal for code execution results**
- 🎯 **Auto-roasts you when you mess up!** No mercy! 😤
  - 🔥🔥 **2+ errors**: Full savage roast mode 💀☠️
  - 😏 **1 error**: Light sass and sarcasm 💁‍♀️
  - 💅 **Success**: Sassy compliment with attitude ✨🎉
- 🔌 Integrates with Cursor IDE workflow
- ⚡ Real-time feedback via Ivanna's voice 🗣️

## 🛠️ Tech Stack — _The Secret Sauce_ 🧪🍳

| 🏷️ | 🔧 Tech | 📝 What It Does |
|---|---|---|
| 🦅 | **Swift 6.2** | The language that makes it all fly |
| 🖥️ | **AppKit** | Native macOS goodness |
| 🧠 | [**OpenAI GPT-4o**](https://platform.openai.com/) | The brain behind the sass |
| 👁️ | [**Gemini**](https://aistudio.google.com/) | Vision & behavior analysis *(planned)* 🔮 |
| 👂 | [**ElevenLabs STT**](https://elevenlabs.io/) | Hears every word you say 🫣 |
| 🗣️ | [**ElevenLabs TTS**](https://elevenlabs.io/) | Ivanna's iconic voice 🎤 |
| 🎵 | **AVFoundation** | Audio & video magic ✨ |

## 🚀 Quick Start — _Let's Get This Party Started_ 🎉🥳

### 📋 Prerequisites

1. 🍎 **macOS 13.0+** (developed on macOS 26.0.1 beta)
2. 🔨 **Xcode Command Line Tools** installed
3. 🔑 **API Keys** (gotta pay to play 💸):
   - 🧠 OpenAI API key ([Get one here](https://platform.openai.com/account/api-keys))
   - 🎙️ ElevenLabs API key ([Get one here](https://elevenlabs.io/))
   - 👁️ Gemini API key ([Get one here](https://aistudio.google.com/app/apikey))

### 🏗️ Installation

1. 📥 **Clone the repository**:
   ```bash
   git clone https://github.com/aran-yogesh/TalkBack.git
   cd TalkBack
   ```

2. 🔐 **Configure API Keys**:
   
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
   
   > ⚠️ **Note**: `config.swift` is gitignored so your keys stay local. Never commit real API keys! 🙅‍♂️🔒

3. 🔧 **Compile the app**:
   ```bash
   swiftc -o ConversationalTalkBack ConversationalTalkBack.swift \
     -framework Cocoa -framework Foundation -framework AVFoundation \
     -target arm64-apple-macosx13.0
   ```

4. 🏃‍♂️ **Run TalkBack** (and brace yourself 😬):
   ```bash
   ./ConversationalTalkBack
   ```

## 🎮 How to Use — _It's Easier Than You Think_ 🧩

### 🕹️ Basic Usage

1. 🟢 **Start the App**: Run `./ConversationalTalkBack`
2. 📸 **Grant Camera Permission**: Allow camera access when prompted (required for vision monitoring)
3. 🗣️ **Talk to TalkBack**:
   - 👆 **Click and HOLD** the avatar
   - 🎤 **Speak** your message
   - ✋ **Release** to send
4. 👂 **Listen**: TalkBack responds with Ivanna's voice and attitude 💅
5. 🖱️ **Drag**: Move the avatar anywhere on your screen
6. 🗑️ **Quit**: Drag avatar near the menu bar → drop in trash can (bye bye! 👋😭)

### 🔥 MCP Code Monitoring (Cursor IDE Integration) — _Prepare to Get Roasted_ 🍖😈

TalkBack can watch your terminal and roast you when your code fails! 💀 Here's how:

1. 🟢 **Start TalkBack** (it automatically monitors `/tmp/talkback_message.json`)

2. 🧪 **Run your code through the monitor**:
   ```bash
   # Test with a script that has errors (will trigger full roast 🔥🔥🔥)
   python3 cursor_code_monitor.py run 'python3 your_broken_script.py'
   
   # Test with successful code (will get sassy compliment 💅👑)
   python3 cursor_code_monitor.py run 'python3 your_working_script.py'
   
   # Test with any command 🧑‍💻
   python3 cursor_code_monitor.py run 'swift your_code.swift'
   ```

3. 🎰 **TalkBack will roast you based on errors**:
   - ✅ **0 errors**: _"Oh wow, it ACTUALLY worked? Color me shocked, darling! 💅✨"_ 🥳🎊
   - 😏 **1 error**: _"ONE error? Cute. At least you're almost there, sweetheart. 😏"_ 🤏
   - 🔥 **2+ errors**: _"Oh HONEY, what is this hot mess? Did you code this with your eyes closed? 🔥💀"_ ☠️🪦

4. 🧪 **Example test**:
   ```bash
   # This will trigger a savage roast 🌶️🌶️🌶️
   python3 cursor_code_monitor.py run 'python3 broken_code.py'
   
   # TalkBack will speak the roast with Ivanna's voice! 🗣️🔊
   ```

## 📂 Project Structure — _What's Under the Hood_ 🔍🏎️

| 📄 File | 🎯 Purpose |
|---|---|
| `ConversationalTalkBack.swift` | 🏠 Main app — floating avatar, voice chat, MCP polling |
| `config.swift.template` | 🔑 API key template (copy to `config.swift` and add your keys) |
| `cursor_code_monitor.py` | 🕵️ Standalone code monitor — wraps commands and writes roast triggers |
| `cursor_mcp_server.py` | 🔌 MCP server for Cursor IDE integration (stdio transport) |
| `test_mcp_connection.py` | 🧪 Quick test to verify `/tmp/talkback_message.json` IPC works |
| `broken_code.py` | 💣 Intentionally broken script for testing roast triggers |
| `start_talkback_mcp.sh` | 🚀 Compiles and launches TalkBack with MCP support |
| `start_integration.sh` | ⚙️ Sets up venv and verifies MCP connection |
| `mcp_config.json` | 📋 Cursor IDE MCP server configuration |

## 📋 API Endpoints Used — _The Nerdy Bits_ 🤓📡

### 👂 ElevenLabs Speech-to-Text
- 🌐 **Endpoint**: `https://api.elevenlabs.io/v1/speech-to-text`
- 🧬 **Model**: `scribe_v1`
- 🎵 **Input**: WAV audio (16kHz, mono, PCM)
- 📝 **Output**: Transcribed text with language detection

### 🗣️ ElevenLabs Text-to-Speech
- 🌐 **Endpoint**: `https://api.elevenlabs.io/v1/text-to-speech/{voice_id}`
- 🧬 **Model**: `eleven_multilingual_v2`
- 🎤 **Voice**: Ivanna (`cgSgspJ2msm6clMCkdW9`) — the queen herself 👑
- 🔊 **Output**: MP3 audio

### 🧠 OpenAI GPT-4o
- 🌐 **Endpoint**: `https://api.openai.com/v1/chat/completions`
- 🧬 **Model**: `gpt-4o`
- 🌡️ **Temperature**: 0.9 (cranked up for maximum sass 🌶️)
- 📏 **Max Tokens**: 80 (short, snappy replies — ain't nobody got time for essays 💅)

### 👁️ Gemini (Vision) — *Planned* 🔮
- 🌐 **Endpoint**: `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent`
- 🔑 A Gemini API key slot is included in `config.swift.template` for future vision-based behavior monitoring 🧿

## 🎭 Personality — _Who IS She?_ 💃🌟

TalkBack is designed to be:
- 😏 **Sassy**: Witty comebacks and attitude-filled responses — she woke up and chose violence 🗡️
- 🎯 **Helpful**: Actually useful advice (hidden in the sass like veggies in a smoothie 🥬🥤)
- 💁‍♀️ **Pushy**: Won't let you procrastinate — your mom but make it AI 👩‍💻
- 🧠 **Smart**: Remembers your conversations (yes, ALL of them 😳)
- 🎤 **Talkative**: Loves to chat (maybe too much... okay definitely too much 🙊)

## 🐛 Troubleshooting — _When Things Go Wrong (And They Will)_ 😅🔧

### 🔇 No Voice Output?
- 🔊 Check system volume and audio output device
- 🔑 Verify ElevenLabs API key and voice ID
- 🔍 Look for `🎤 ElevenLabs TTS HTTP Status: 200` in terminal

### 🤫 Empty Transcriptions?
- 👆 Ensure you're holding the mouse button while speaking
- 🎙️ Check microphone permissions (System Settings → Privacy & Security → Microphone)
- ✅ Verify ElevenLabs API key is valid

### 🚦 Rate Limit Errors?
- 💳 OpenAI usage limits: Check your account for current limits
- 💰 Add payment method or wait 20 seconds between requests (patience, grasshopper 🧘)

### 📄 Missing `config.swift`?
- 📋 Copy the template: `cp config.swift.template config.swift`
- 🔑 Add your API keys to `config.swift`

### 🤐 MCP Roasts Not Triggering?
- 🟢 Ensure TalkBack is running (it polls `/tmp/talkback_message.json` every 0.5s)
- 🏃 Run commands through the monitor: `python3 cursor_code_monitor.py run "YOUR_COMMAND"`
- 📦 Check that `watchdog` is installed: `pip3 install watchdog`

### 💥 Crashes on Launch?
- 🎯 Compile with explicit target: `-target arm64-apple-macosx13.0`
- 🦅 Check Swift version: `swift --version`
- ⚠️ Beta macOS can be unstable with Speech framework (blame Apple, not us 🍎😤)

## 📝 Development Notes — _The War Stories_ ⚔️📖

This project was developed on **macOS 26.0.1 beta** with **Swift 6.2** 🦅, which required special handling (read: suffering 😩):
- 🎯 Explicit compilation target (`-target arm64-apple-macosx13.0`)
- 🚫 Avoided unstable `SFSpeechRecognizer` framework (it betrayed us 🗡️)
- 🔄 Used ElevenLabs STT instead of macOS built-in speech recognition
- 🔊 Prioritized `NSSound` over `AVAudioPlayer` for better MP3 compatibility

## 🔮 Future Features — _The Roadmap of Dreams_ 🗺️✨

- [ ] 👁️ Gemini vision-based behavior monitoring (webcam gaze/emotion detection) 🧿
- [ ] 🖥️ Screen monitoring (detect what user is doing — _we see you, Netflix_ 🍿👀)
- [ ] 💡 Context-aware productivity tips
- [ ] 🎙️ Custom voice selection (pick your own roaster! 🎤)
- [ ] 🎭 Multiple personality modes (nice mode? nah, who needs that 😈)
- [ ] ⏰ Scheduled check-ins (alarm clock but make it sassy 💅)
- [ ] 📅 Integration with calendar/reminders (she'll remind you... aggressively 📢)

## 🤝 Contributing — _Join the Chaos_ 🎪🤹

Contributions are welcome! 🎉🥳 Feel free to:
- 🐛 Report bugs (there are none... just kidding 😂)
- 💡 Suggest new features (the sassier the better 💅)
- 🔀 Submit pull requests (we don't bite... much 🦷)
- 📝 Improve documentation (you're reading it, so clearly it needs help 😏)

Check out our [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide! 📖✨

## 📄 License — _The Legal Stuff_ ⚖️

MIT License - feel free to use, modify, and distribute. 🆓🎁 Go wild! 🐺

## 🙏 Acknowledgments — _Shoutouts to the Real MVPs_ 🏆🫡

- 🧠 **OpenAI** for GPT-4o API (the brain behind the beauty 💅)
- 👁️ **Google** for Gemini API (planned vision features — coming soon™ 🔮)
- 🎙️ **ElevenLabs** for Speech-to-Text and Text-to-Speech APIs (the voice of sass 🗣️)
- 👑 **Ivanna** for the sassy voice that brings TalkBack to life (queen behavior 💃✨)

## ✍️ Authors — _The Masterminds_ 🧑‍🔬🦸

- 🧑‍💻 **Yogesh Mahendran** — Creator & Lead Developer (the one who unleashed this upon the world 🌍😈)

## 💬 Questions or Feedback? 🤔💭

Open an issue or reach out! TalkBack loves to chat (obviously). 😉💬 We promise we'll respond with less sass than TalkBack does... probably. 🤷‍♂️😂

---

**Made with 💻, ☕, sleepless nights 🌙, and a LOT of sass 💅** by [@aran-yogesh](https://github.com/aran-yogesh) 🚀✨

_⭐ Star this repo if TalkBack has ever roasted you into being a better developer! ⭐_
