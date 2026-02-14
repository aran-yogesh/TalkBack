# TalkBack - Annoying But Useful AI Companion 🤖

A mischievous macOS floating avatar that acts as your sassy, helpful (but pushy) productivity coach. TalkBack is an interactive AI companion that listens to you, remembers your conversations, and responds with attitude-filled voice feedback.

![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 🎯 Features

### 🎤 **Continuous Voice Interaction**
- **Always-on listening** with voice activity detection — just start talking
- **ElevenLabs Speech-to-Text** for accurate voice recognition
- Supports multiple languages (English, Bengali, Hindi, and more!)
- Automatic silence detection to know when you're done speaking

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
- Animated floating/bouncing motion across the screen
- Animated eyes that react to your cursor
- Dynamic expressions based on mood
- Draggable anywhere on your screen

### 🗑️ **"The Great Escape" Feature**
- Drag avatar near the menu bar to reveal trash can
- Drop in trash to quit
- Adds a fun, mischievous interaction

### 🔍 **Lens Mode** (Accessibility Text Reader)
- **Menu bar icon** with toggle for Lens Mode and Coding Teacher Mode
- Hold the **⌥ Option** key to temporarily activate the Lens
- Reads text under your cursor using macOS Accessibility APIs
- Floating overlay with **Summarize** and **Make Concise** actions powered by OpenAI
- Caches summaries for previously seen text

### 👩‍🏫 **Coding Teacher Mode**
- Toggle via the menu bar status item
- Watches your code execution results and provides teaching feedback
- Helps you learn from your mistakes with AI-powered explanations

### 📧 **Assignment Email Monitoring**
- Integrates with Apple Mail via AppleScript
- Detects assignment-related emails (keywords: assignment, homework, project, due, etc.)
- Monitors educational domains (`.edu`, Canvas, Blackboard)
- Alerts you with AI-generated summaries of upcoming deadlines

### 🔥 **MCP Code Monitor** (Cursor IDE Integration)
- **Watches your terminal for code execution results**
- **Auto-roasts you when you mess up!**
  - 🔥 **2+ errors**: Full savage roast mode
  - 😏 **1 error**: Light sass and sarcasm
  - 💅 **Success**: Sassy compliment with attitude
- Integrates with Cursor IDE workflow
- Real-time feedback via Ivanna's voice

## 🛠️ Tech Stack

- **Language**: Swift 6.2
- **Framework**: AppKit (native macOS)
- **AI & Voice Services**:
  - [OpenAI GPT-4o](https://platform.openai.com/) - Conversational AI & text summarization
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) - Voice recognition
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) - Voice synthesis (Ivanna voice)
- **Audio**: AVFoundation (NSSound, AVAudioRecorder, AVAudioEngine)
- **Accessibility**: ApplicationServices (AXUIElement APIs for Lens Mode)

## 🚀 Quick Start

### Prerequisites

1. **macOS 13.0+**
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

   Copy the template and add your actual keys:
   ```bash
   cp config.swift.template config.swift
   ```

   Edit `config.swift` and replace the placeholder values:
   ```swift
   struct Config {
       static let openAIAPIKey = "YOUR_OPENAI_API_KEY_HERE"
       static let elevenLabsAPIKey = "YOUR_ELEVENLABS_API_KEY_HERE"
       static let elevenLabsVoiceID = "cgSgspJ2msm6clMCkdW9"  // Ivanna's voice
       static let geminiAPIKey = "YOUR_GEMINI_API_KEY_HERE"
   }
   ```

   > **Note**: `config.swift` is gitignored for security. Never commit your actual API keys.

3. **Compile the app**:
   ```bash
   swiftc -o ConversationalTalkBack config.swift ConversationalTalkBack.swift \
     -framework Cocoa -framework Foundation -framework AVFoundation \
     -framework ApplicationServices -target arm64-apple-macosx13.0
   ```

4. **Run TalkBack**:
   ```bash
   ./ConversationalTalkBack
   ```

## 🎮 How to Use

### Basic Usage

1. **Start the App**: Run `./ConversationalTalkBack`
2. **Grant Permissions**: Allow microphone and accessibility access when prompted
3. **Talk to TalkBack**: Just start speaking — TalkBack uses continuous voice activity detection and will automatically pick up your voice
4. **Listen**: TalkBack responds with Ivanna's voice and attitude
5. **Use Lens Mode**: Hold the **⌥ Option** key to activate the Lens, or toggle it via the menu bar icon. Hover over text to get AI-powered summaries.
6. **Drag**: Move the avatar anywhere on your screen
7. **Quit**: Drag avatar near the menu bar → drop in trash can

### 🔥 MCP Code Monitoring (Cursor IDE Integration)

TalkBack can watch your terminal and roast you when your code fails! Here's how:

1. **Start TalkBack** (it automatically monitors `/tmp/talkback_message.json`)

2. **Run your code with the code monitor**:
   ```bash
   python3 cursor_code_monitor.py run 'python3 your_script.py'
   ```

3. **TalkBack will roast you based on errors**:
   - ✅ **0 errors**: Sassy compliment with attitude 💅
   - 😏 **1 error**: Light sass and sarcasm
   - 🔥 **2+ errors**: Full savage roast mode 🔥💀

4. **Example**:
   ```bash
   python3 cursor_code_monitor.py run 'python3 broken_code.py'
   ```

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
- Verify ElevenLabs API key and voice ID
- Look for `🎤 ElevenLabs TTS HTTP Status: 200` in terminal

### Empty Transcriptions?
- Ensure you're speaking clearly within range of the microphone
- Check microphone permissions (System Settings → Privacy & Security → Microphone)
- Verify ElevenLabs API key is valid

### Lens Mode Not Working?
- Grant Accessibility permissions (System Settings → Privacy & Security → Accessibility)
- Try toggling Lens Mode from the menu bar icon
- Hold ⌥ Option key for temporary activation

### Rate Limit Errors?
- OpenAI usage limits: Check your account for current limits
- Add payment method or wait 20 seconds between requests

### Crashes on Launch?
- Compile with explicit target: `-target arm64-apple-macosx13.0`
- Check Swift version: `swift --version`

## 📝 Development Notes

This project was developed on **macOS 26.0.1 beta** with **Swift 6.2**, which required special handling:
- Explicit compilation target (`-target arm64-apple-macosx13.0`)
- Avoided unstable `SFSpeechRecognizer` framework
- Used ElevenLabs STT instead of macOS built-in speech recognition
- Prioritized `NSSound` over `AVAudioPlayer` for better MP3 compatibility
- Continuous listening via `AVAudioEngine` with voice activity detection

## 🔮 Future Features

- [ ] Vision-based behavior monitoring (Gemini integration)
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

- **OpenAI** for GPT-4o API
- **ElevenLabs** for Speech-to-Text and Text-to-Speech APIs
- **Ivanna** for the sassy voice that brings TalkBack to life

## 💬 Questions or Feedback?

Open an issue or reach out! TalkBack loves to chat (obviously). 😉

---

**Made with 💻 and a lot of sass** by [@aran-yogesh](https://github.com/aran-yogesh)
