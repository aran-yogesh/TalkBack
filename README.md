# TalkBack - Annoying But Useful AI Companion 🤖

A mischievous macOS floating avatar that acts as your sassy, helpful (but pushy) productivity coach. TalkBack is an interactive AI companion that continuously listens to you, remembers your conversations, and responds with attitude-filled voice feedback.

![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 🎯 Features

### 🎤 **Continuous Voice Interaction**
- **Always-on listening** — TalkBack hears you automatically, no button press needed
- **ElevenLabs Speech-to-Text** for accurate voice recognition
- Voice activity detection with automatic silence cutoff (2 seconds)
- Supports multiple languages (English, Bengali, Hindi, and more!)

### 🗣️ **Sassy AI Responses**
- **OpenAI GPT-4o** powered responses
- **ElevenLabs Text-to-Speech** with Ivanna's voice
- Attitude-filled, personality-driven replies
- Short, snappy responses that pack a punch

### 🧠 **Conversational Memory**
- Remembers your chat history
- Maintains context across conversations
- Smart follow-ups based on previous interactions

### 🎨 **Custom Floating Avatar**
- Transparent floating window (always on top)
- Custom purse/wallet icon design
- Animated eyes that follow your cursor
- Dynamic expressions based on mood (listening, thinking, speaking)
- Bouncing zigzag motion when idle
- Draggable anywhere on your screen

### 🗑️ **"The Great Escape" Feature**
- Drag avatar near the menu bar to reveal trash can
- Drop in trash to quit (the only way to close it!)
- Adds a fun, mischievous interaction

### 🔍 **TalkBack Lens** (Text Summarizer)
- **Menu bar icon** to toggle Lens mode on/off
- **Hold ⌥ Option** for temporary Lens activation
- Hover over any text on screen to get a floating overlay with:
  - **Summarize** — condense long text into key points
  - **Make Concise** — rewrite text more succinctly
- Uses macOS Accessibility APIs to read text under your cursor
- Powered by **OpenAI GPT-4.1** with result caching
- Requires Accessibility permission (System Settings → Privacy & Security → Accessibility)

### 👩‍🏫 **Coding Teacher Mode**
- Enabled by default (toggle via the menu bar icon)
- Watches terminal command results from the MCP monitor
- On **success**: celebrates briefly, explains the result, and suggests a next step
- On **failure**: diagnoses the error, teaches what went wrong, and gives actionable fixes
- Supportive tone with a sprinkle of sass

### 📬 **Assignment Email Monitoring**
- Toggle via right-click context menu on the avatar
- Polls Apple Mail every 3 minutes for new emails
- Detects assignment-related emails by keywords (assignment, homework, due, exam, etc.) and educational domains
- Summarizes the email and announces it with Ivanna's voice

### 🔥 **MCP Code Monitor** (Cursor IDE Integration)
- Watches `/tmp/talkback_message.json` for code execution events
- Supports `command_started` and `command_finished` events
- Roasts you based on error count:
  - 🔥 **2+ errors**: Full savage roast mode
  - 😏 **1 error**: Light sass and sarcasm
  - 💅 **Success**: Sassy compliment with attitude
- Integrates with Cursor IDE via the included MCP server
- Real-time feedback via Ivanna's voice

## 🛠️ Tech Stack

- **Language**: Swift 6.2
- **Framework**: AppKit (native macOS)
- **AI & Voice Services**:
  - [OpenAI GPT-4o](https://platform.openai.com/) — conversational AI and coding teacher
  - [OpenAI GPT-4.1](https://platform.openai.com/) — TalkBack Lens summarization
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) — voice recognition
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) — voice synthesis (Ivanna voice)
- **Audio**: AVFoundation (AVAudioEngine for continuous listening, NSSound for playback)
- **Accessibility**: ApplicationServices (AX APIs for Lens text extraction)

## 🚀 Quick Start

### Prerequisites

1. **macOS 13.0+** (developed on macOS 26.0.1 beta)
2. **Xcode Command Line Tools** installed
3. **API Keys**:
   - OpenAI API key ([Get one here](https://platform.openai.com/account/api-keys))
   - ElevenLabs API key ([Get one here](https://elevenlabs.io/))

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
       static let elevenLabsVoiceID = "cgSgspJ2msm6clMCkdW9"
       static let geminiAPIKey = "YOUR_GEMINI_API_KEY_HERE"
   }
   ```

   > **Note**: `config.swift` is gitignored so your keys stay private.

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
   - **Accessibility** — required for TalkBack Lens text extraction

## 🎮 How to Use

### Basic Interaction

1. **Start the App**: Run `./ConversationalTalkBack`
2. **Just Talk**: TalkBack is always listening — speak naturally and it will respond
3. **Listen**: TalkBack responds with Ivanna's voice and attitude
4. **Drag**: Move the avatar anywhere on your screen
5. **Quit**: Drag avatar near the menu bar → drop in trash can

### 🔍 Using TalkBack Lens

1. Click the **viewfinder icon** in the menu bar
2. Enable **Lens Mode** from the dropdown
3. Hover over any text on screen — a floating overlay appears
4. Click **Summarize** or **Make Concise** to process the text
5. Alternatively, **hold ⌥ Option** for temporary Lens activation without toggling the menu

### 👩‍🏫 Coding Teacher Mode

Teacher mode is enabled by default. Toggle it from the menu bar icon dropdown.

When active, TalkBack watches terminal output from the MCP monitor and provides teaching feedback on command results.

### 🔥 MCP Code Monitoring (Cursor IDE Integration)

TalkBack monitors `/tmp/talkback_message.json` for code execution events. Set up the integration:

1. **Start TalkBack** (MCP monitoring starts automatically)

2. **Test the connection**:
   ```bash
   python3 test_mcp_connection.py
   ```

3. **Use the code monitor** to run commands and trigger feedback:
   ```bash
   python3 cursor_code_monitor.py
   ```

4. **Or use the MCP server** for Cursor IDE integration:
   ```bash
   python3 cursor_mcp_server.py
   ```

5. **TalkBack responds based on results**:
   - ✅ **Success**: Sassy compliment + teaching moment
   - ❌ **Failure**: Diagnosis, explanation, and actionable next steps

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
- **Model**: `gpt-4o` (chat, teacher mode) / `gpt-4.1` (Lens)
- **Temperature**: 0.9 (chat) / 0.6 (teacher)
- **Max Tokens**: 50 (chat) / 120 (teacher)

## 🎭 Personality

TalkBack is designed to be:
- 😏 **Sassy**: Witty comebacks and attitude-filled responses
- 🎯 **Helpful**: Actually useful advice (hidden in the sass)
- 💁‍♀️ **Pushy**: Won't let you procrastinate
- 🧠 **Smart**: Remembers your conversations
- 🎤 **Talkative**: Loves to chat (maybe too much)

## 📁 Project Structure

```
TalkBack/
├── ConversationalTalkBack.swift   # Main app (avatar, voice, AI, Lens, teacher, MCP)
├── config.swift.template          # API key template (copy to config.swift)
├── cursor_code_monitor.py         # Terminal output monitor for code execution
├── cursor_mcp_server.py           # MCP server for Cursor IDE integration
├── test_mcp_connection.py         # Test script for MCP message file
├── broken_code.py                 # Intentionally broken code for testing roasts
├── start_talkback_mcp.sh          # Shell script to start TalkBack + MCP
├── start_integration.sh           # Shell script for integration setup
├── mcp_config.json                # MCP server configuration
├── cline_mcp_settings.json        # Cline MCP settings
├── API_KEY_SETUP.md               # Detailed API key setup guide
├── MCP_SETUP.md                   # MCP integration setup guide
├── MCP_INTEGRATION.md             # MCP integration details
├── MCP_SETUP_COMPLETE.md          # MCP setup completion checklist
├── QUICK_START.md                 # Quick start guide
└── README.md                      # This file
```

## 🐛 Troubleshooting

### No Voice Output?
- Check system volume and audio output device
- Verify ElevenLabs API key and voice ID in `config.swift`
- Look for `🎤 ElevenLabs TTS HTTP Status: 200` in terminal

### Not Hearing Me?
- Check microphone permissions (System Settings → Privacy & Security → Microphone)
- Verify ElevenLabs API key is valid
- Look for continuous listening logs in the terminal

### TalkBack Lens Not Working?
- Grant Accessibility permission (System Settings → Privacy & Security → Accessibility)
- Ensure Lens Mode is enabled via the menu bar icon
- Check that your OpenAI API key is configured

### Rate Limit Errors?
- OpenAI has a default cooldown of ~22 seconds between requests
- Add payment method or wait between requests

### Crashes on Launch?
- Ensure `config.swift` exists (copy from `config.swift.template`)
- Compile with explicit target: `-target arm64-apple-macosx13.0`
- Check Swift version: `swift --version`

## 📝 Development Notes

This project was developed on **macOS 26.0.1 beta** with **Swift 6.2**, which required special handling:
- Explicit compilation target (`-target arm64-apple-macosx13.0`)
- Avoided unstable `SFSpeechRecognizer` framework
- Used ElevenLabs STT instead of macOS built-in speech recognition
- Prioritized `NSSound` over `AVAudioPlayer` for better MP3 compatibility
- Single-file Swift architecture (`ConversationalTalkBack.swift` + `config.swift`)

## 🔮 Future Features

- [ ] Custom voice selection
- [ ] Multiple personality modes
- [ ] Scheduled check-ins
- [ ] Integration with calendar/reminders
- [ ] Vision-based behavior monitoring via webcam

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
- **ElevenLabs** for Speech-to-Text and Text-to-Speech APIs
- **Ivanna** for the sassy voice that brings TalkBack to life

## 💬 Questions or Feedback?

Open an issue or reach out! TalkBack loves to chat (obviously). 😉

---

**Made with 💻 and a lot of sass** by [@aran-yogesh](https://github.com/aran-yogesh)

