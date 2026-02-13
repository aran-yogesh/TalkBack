# TalkBack - Annoying But Useful AI Companion 🤖

A mischievous macOS floating avatar that acts as your sassy, helpful (but pushy) productivity coach. TalkBack is an interactive AI companion that continuously listens to you, remembers your conversations, and responds with attitude-filled voice feedback.

![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 🎯 Features

### 🎤 **Continuous Voice Interaction**
- **Always-on microphone** with automatic voice activity detection
- **ElevenLabs Speech-to-Text** for accurate voice recognition
- Supports multiple languages (English, Bengali, Hindi, and more!)
- Natural conversation flow — just speak and TalkBack responds when you pause

### 🗣️ **Sassy AI Responses**
- **OpenAI GPT-4o** powered responses
- **ElevenLabs Text-to-Speech** with Ivanna's voice
- Attitude-filled, personality-driven replies
- Short, snappy responses that pack a punch

### 🧠 **Conversational Memory**
- Remembers your chat history (last 6 exchanges)
- Maintains context across conversations
- Smart follow-ups based on previous interactions

### 🎨 **Custom Floating Avatar**
- Transparent floating window (always on top)
- Custom purse/wallet icon design
- Animated eyes that follow your cursor
- Dynamic expressions based on mood (listening, thinking, speaking)
- Bouncing zigzag motion around the screen when idle
- Draggable anywhere on your screen

### 🗑️ **"The Great Escape" Feature**
- Drag avatar near the menu bar to reveal trash can
- Drop in trash to quit (the only way to close it!)
- Adds a fun, mischievous interaction

### 🔍 **TalkBack Lens** (Accessibility Summarizer)
- Reads on-screen text under your cursor using macOS Accessibility APIs
- **Summarize** or **Make Concise** any text element on screen
- Toggle via menu bar icon or hold ⌥ Option for temporary activation
- Results cached per element to avoid redundant API calls
- Requires Accessibility permission (System Settings → Privacy & Security → Accessibility)

### 👩‍🏫 **Teaching Assistant Mode**
- Toggleable teacher personality mode
- Adjusts response style for educational contexts
- Integrated with the Lens summarizer for study assistance

### 📬 **Assignment Email Monitoring**
- Monitors your macOS Mail inbox for assignment-related emails
- Detects keywords like "assignment", "homework", "due", "exam", etc.
- Detects emails from `.edu`, Canvas, and Blackboard domains
- Alerts you with a sassy summary when a new assignment email arrives
- Checks every 3 minutes when enabled

### 🔥 **MCP Code Monitor** (Cursor IDE Integration)
- Watches your terminal for code execution results via `/tmp/talkback_message.json`
- Auto-roasts you when you mess up!
  - 🔥 **2+ errors**: Full savage roast mode
  - 😏 **1 error**: Light sass and sarcasm
  - 💅 **Success**: Sassy compliment with attitude
- Includes an MCP server (`cursor_mcp_server.py`) for deeper Cursor IDE integration
- Standalone monitor (`cursor_code_monitor.py`) using filesystem watching
- Real-time feedback via Ivanna's voice

## 🛠️ Tech Stack

- **Language**: Swift 6.2
- **Framework**: AppKit (native macOS)
- **AI & Voice Services**:
  - [OpenAI GPT-4o](https://platform.openai.com/) - Conversational AI & Lens summarization
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) - Voice recognition
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) - Voice synthesis (Ivanna voice)
- **Audio**: AVFoundation (AVAudioEngine for continuous listening, NSSound/AVAudioPlayer for playback)
- **Accessibility**: ApplicationServices (AX APIs for Lens feature)

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
       static let elevenLabsVoiceID = "cgSgspJ2msm6clMCkdW9"  // Ivanna's voice
       static let geminiAPIKey = "YOUR_GEMINI_API_KEY_HERE"     // Reserved for future use
   }
   ```

   > **Note**: `config.swift` is gitignored to keep your keys safe. Never commit it.

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
2. **Grant Microphone Permission**: Allow microphone access when prompted (required for continuous listening)
3. **Talk to TalkBack**: Just speak naturally — TalkBack is always listening and will respond after you pause for ~2 seconds
4. **Listen**: TalkBack responds with Ivanna's voice and attitude
5. **Idle Prompts**: If you go quiet for 60+ seconds, TalkBack will pester you with sassy messages
6. **Drag**: Move the avatar anywhere on your screen (it will resume floating after 5 seconds)
7. **Quit**: Drag avatar near the menu bar → drop in trash can

### 🔍 TalkBack Lens

1. **Enable**: Click the menu bar icon → toggle Lens Mode (or hold ⌥ Option for temporary use)
2. **Grant Accessibility Permission**: System Settings → Privacy & Security → Accessibility
3. **Hover** over any text element on screen
4. **Click "Summarize"** or **"Make Concise"** in the overlay popup
5. TalkBack uses GPT-4o to process the text and displays results inline

### 🔥 MCP Code Monitoring (Cursor IDE Integration)

TalkBack watches `/tmp/talkback_message.json` for messages from your IDE:

1. **Start TalkBack** (MCP monitoring activates automatically)

2. **Test the connection**:
   ```bash
   python3 test_mcp_connection.py
   ```

3. **Use with Cursor IDE**: Configure the MCP server in your IDE settings (see `mcp_config.json` for reference)

4. **Use the standalone monitor**:
   ```bash
   python3 cursor_code_monitor.py
   ```

5. **TalkBack roasts you based on errors**:
   - ✅ **0 errors**: Sassy compliment 💅
   - 😏 **1 error**: Light sass and sarcasm
   - 🔥 **2+ errors**: Full savage roast mode

## 📋 API Endpoints Used

### ElevenLabs Speech-to-Text
- **Endpoint**: `https://api.elevenlabs.io/v1/speech-to-text`
- **Model**: `scribe_v1`
- **Input**: WAV audio (PCM, native sample rate)
- **Output**: Transcribed text with language detection

### ElevenLabs Text-to-Speech
- **Endpoint**: `https://api.elevenlabs.io/v1/text-to-speech/{voice_id}`
- **Model**: `eleven_multilingual_v2`
- **Voice**: Ivanna (`cgSgspJ2msm6clMCkdW9`)
- **Output**: MP3 audio

### OpenAI GPT-4o
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Model**: `gpt-4o`
- **Temperature**: 0.9 (for sassy responses)
- **Max Tokens**: 80 (short, snappy replies)

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
- Verify ElevenLabs API key and voice ID in `config.swift`
- Look for `🎤 ElevenLabs TTS HTTP Status: 200` in terminal

### Not Hearing Me?
- Check microphone permissions (System Settings → Privacy & Security → Microphone)
- Verify ElevenLabs API key is valid in `config.swift`
- Look for `✅ Continuous listening started!` in terminal output
- Speak clearly — voice detection threshold filters out background noise

### Lens Not Working?
- Grant Accessibility permission (System Settings → Privacy & Security → Accessibility)
- Verify OpenAI API key is configured
- Ensure Lens Mode is toggled on via the menu bar icon

### Rate Limit Errors?
- OpenAI usage limits: Check your account for current limits
- Built-in cooldown of ~22 seconds between OpenAI calls
- Add payment method or wait for rate limit to reset

### Crashes on Launch?
- Compile with explicit target: `-target arm64-apple-macosx13.0`
- Make sure `config.swift` exists (copy from `config.swift.template`)
- Check Swift version: `swift --version`
- Beta macOS can be unstable with Speech framework

## 📝 Development Notes

This project was developed on **macOS 26.0.1 beta** with **Swift 6.2**, which required special handling:
- Explicit compilation target (`-target arm64-apple-macosx13.0`)
- Avoided unstable `SFSpeechRecognizer` framework
- Used ElevenLabs STT instead of macOS built-in speech recognition
- Prioritized `NSSound` over `AVAudioPlayer` for better MP3 compatibility
- Uses `AVAudioEngine` for continuous real-time audio capture

## 🔮 Future Features

- [ ] Vision-based behavior monitoring (webcam + Gemini)
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

- **OpenAI** for the GPT-4o API
- **ElevenLabs** for Speech-to-Text and Text-to-Speech APIs
- **Ivanna** for the sassy voice that brings TalkBack to life

## 💬 Questions or Feedback?

Open an issue or reach out! TalkBack loves to chat (obviously). 😉

---

**Made with 💻 and a lot of sass** by [@aran-yogesh](https://github.com/aran-yogesh)

