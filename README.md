# TalkBack - Annoying But Useful AI Companion 🤖

A mischievous macOS floating avatar that acts as your sassy, helpful (but pushy) productivity coach. TalkBack is an interactive AI companion that continuously listens to you, remembers your conversations, and responds with attitude-filled voice feedback. It floats around your screen, bouncing off edges, and can even summarize text under your cursor, monitor your code execution, alert you about assignment emails, and teach you what went wrong when your builds fail.

![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 🎯 Features

### 🎤 **Always-On Voice Interaction**
- **Continuous listening** via `AVAudioEngine` — just start talking, no button press needed
- **Voice activity detection** automatically captures speech and ignores silence
- **ElevenLabs Speech-to-Text** (`scribe_v1`) for accurate voice recognition
- **Background noise filtering** to ignore non-speech sounds
- Built-in rate limiting and cooldown to prevent API spam

### 🗣️ **Sassy AI Responses**
- **OpenAI GPT-4o** powered conversational responses
- **ElevenLabs Text-to-Speech** with Ivanna's voice (`eleven_multilingual_v2`)
- Attitude-filled, personality-driven replies (temperature 0.9)
- Short, snappy responses capped at 80 tokens

### 🧠 **Conversational Memory**
- Maintains a rolling chat history (last 6 exchanges)
- Context-aware follow-ups based on previous interactions
- Idle nudges when you ignore TalkBack for too long

### 🎨 **Custom Floating Avatar**
- Transparent, borderless floating window (always on top)
- Custom purse/wallet icon with animated eyes that follow your cursor
- **Bouncing zigzag motion** — the avatar floats around and bounces off screen edges
- Dynamic mouth expressions based on state (listening, thinking, speaking)
- Draggable anywhere on your screen; resumes floating after 5 seconds of inactivity

### 🗑️ **"The Great Escape" Feature**
- Drag avatar near the menu bar to reveal a trash can
- Drop in trash to quit (the only way to close it!)

### 🔍 **TalkBack Lens** (Text Summarization Overlay)
- **Menu bar icon** to toggle Lens mode on/off, or hold **⌥ Option** for temporary activation
- Hovers over any UI text using **macOS Accessibility APIs** and reads it
- Two actions: **Summarize** or **Make Concise**
- Powered by **OpenAI GPT-4.1** with result caching per element
- Requires Accessibility permission (System Settings → Privacy & Security → Accessibility)

### 👩‍🏫 **Coding Teacher Mode**
- Enabled by default (toggle from the menu bar)
- When a command finishes via MCP, TalkBack reviews the output with GPT-4o
- On **success**: celebrates and suggests a productive next step
- On **failure**: diagnoses likely causes, teaches what went wrong, and gives actionable fixes
- Supportive tone with a sprinkle of sass

### 📬 **Assignment Email Alerts**
- Toggle from code to monitor your **Apple Mail** inbox every 3 minutes
- Uses AppleScript to fetch the latest email and check for assignment keywords (homework, due, quiz, exam, etc.) or `.edu`/Canvas/Blackboard sender domains
- When an assignment email is detected, GPT-4o summarizes the email and speaks the summary aloud

### 🔥 **MCP Code Monitor** (Cursor IDE Integration)
- Watches `/tmp/talkback_message.json` for code execution events
- Supports `command_started` and `command_finished` events with exit codes, output, and duration
- **Auto-roasts you when you mess up!**
  - 🔥 **2+ errors**: Full savage roast mode
  - 😏 **1 error**: Light sass and sarcasm
  - 💅 **Success**: Sassy compliment with attitude
- Integrates with the `cursor_code_monitor.py` script and `cursor_mcp_server.py` MCP server
- Real-time feedback via Ivanna's voice

## 🛠️ Tech Stack

- **Language**: Swift 6.2
- **Frameworks**: AppKit, AVFoundation, ApplicationServices (Accessibility)
- **AI & Voice Services**:
  - [OpenAI GPT-4o](https://platform.openai.com/) — Conversational AI, code teaching, roasts, and email summaries
  - [OpenAI GPT-4.1](https://platform.openai.com/) — Lens text summarization
  - [ElevenLabs Speech-to-Text](https://elevenlabs.io/) — Voice recognition (`scribe_v1`)
  - [ElevenLabs Text-to-Speech](https://elevenlabs.io/) — Voice synthesis (`eleven_multilingual_v2`, Ivanna voice)
- **Audio**: AVFoundation (`AVAudioEngine`, `AVAudioPlayer`)
- **Accessibility**: ApplicationServices (`AXUIElement`) for Lens text extraction

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
       static let geminiAPIKey = "YOUR_GEMINI_API_KEY_HERE"
   }
   ```

   > **Note**: `config.swift` is gitignored to keep your keys safe.

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

5. **Grant permissions** when prompted:
   - **Microphone** — required for continuous voice listening
   - **Accessibility** — required for Lens text extraction (System Settings → Privacy & Security → Accessibility)

## 🎮 How to Use

### Basic Voice Chat

1. **Start the App**: Run `./ConversationalTalkBack`
2. **Just talk**: TalkBack listens continuously — speak naturally and it will detect your voice
3. **Wait for silence**: After 2 seconds of silence, your speech is transcribed and sent to GPT-4o
4. **Listen**: TalkBack responds with Ivanna's voice and plenty of attitude
5. **Drag**: Move the avatar anywhere on your screen (it resumes floating after 5 seconds)
6. **Quit**: Drag the avatar near the menu bar → drop it in the trash can

### 🔍 Using TalkBack Lens

1. Click the **viewfinder icon** in the menu bar and enable **Lens Mode**, or hold **⌥ Option**
2. Hover your cursor over any text on screen
3. A floating overlay appears with a preview of the text
4. Click **Summarize** or **Make Concise** to get an AI-powered summary
5. Results are cached per element for fast re-access

### 👩‍🏫 Coding Teacher Mode

Teacher mode is enabled by default. When TalkBack receives a `command_finished` MCP event:
- **Success**: TalkBack celebrates, explains the result, and suggests a next step
- **Failure**: TalkBack diagnoses the error, teaches what went wrong, and gives fixes

Toggle it from the **menu bar → Coding Teacher Mode**.

### 🔥 MCP Code Monitoring (Cursor IDE Integration)

TalkBack watches `/tmp/talkback_message.json` for code execution events. To integrate with your workflow:

1. **Start TalkBack** (MCP monitoring starts automatically)

2. **Use the code monitor script**:
   ```bash
   python3 cursor_code_monitor.py run 'python3 your_script.py'
   ```

3. **Or test the connection directly**:
   ```bash
   python3 test_mcp_connection.py
   ```

4. **TalkBack roasts you based on errors**:
   - ✅ **0 errors**: "Oh wow, it ACTUALLY worked? Color me shocked, darling! 💅✨"
   - 😏 **1 error**: "ONE error? Cute. At least you're almost there, sweetheart. 😏"
   - 🔥 **2+ errors**: "Oh HONEY, what is this hot mess? Did you code this with your eyes closed? 🔥💀"

5. **Example with the included broken script**:
   ```bash
   python3 cursor_code_monitor.py run 'python3 broken_code.py'
   ```

## 📋 API Endpoints Used

### ElevenLabs Speech-to-Text
- **Endpoint**: `https://api.elevenlabs.io/v1/speech-to-text`
- **Model**: `scribe_v1`
- **Input**: WAV audio (PCM16, native sample rate)
- **Output**: Transcribed text

### ElevenLabs Text-to-Speech
- **Endpoint**: `https://api.elevenlabs.io/v1/text-to-speech/{voice_id}`
- **Model**: `eleven_multilingual_v2`
- **Voice**: Ivanna (`cgSgspJ2msm6clMCkdW9`)
- **Output**: MP3 audio

### OpenAI Chat Completions
- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Model**: `gpt-4o` (conversation, roasts, teaching, email summaries)
- **Model**: `gpt-4.1` (Lens summarization)
- **Temperature**: 0.9 for conversation/roasts, 0.6 for teaching, 0.3 for Lens
- **Max Tokens**: 80 (conversation/roasts), 120 (teaching/summaries)

## 🎭 Personality

TalkBack is designed to be:
- 😏 **Sassy**: Witty comebacks and attitude-filled responses
- 🎯 **Helpful**: Actually useful advice (hidden in the sass)
- 💁‍♀️ **Pushy**: Won't let you procrastinate — nudges you after 60 seconds of silence
- 🧠 **Smart**: Remembers your conversations and teaches you when code fails
- 🎤 **Always listening**: Continuous voice detection, no buttons needed

## 🐛 Troubleshooting

### No Voice Output?
- Check system volume and audio output device
- Verify ElevenLabs API key and voice ID
- Look for `🎤 ElevenLabs TTS HTTP Status: 200` in terminal

### Not Detecting My Voice?
- Check microphone permissions (System Settings → Privacy & Security → Microphone)
- Verify ElevenLabs API key is valid
- Look for `✅ Continuous listening started!` in terminal
- Speak at a normal volume — the voice activity threshold filters out quiet ambient noise

### Lens Not Working?
- Grant Accessibility permission (System Settings → Privacy & Security → Accessibility)
- Enable Lens Mode from the menu bar icon or hold ⌥ Option
- Text must be at least 12 characters long to trigger analysis

### Rate Limit Errors?
- OpenAI requests are rate-limited to ~3 per minute with a 22-second cooldown
- If you see "Cooling off... 😴", wait a moment — queued requests retry automatically
- Check your OpenAI account for current tier limits

### Crashes on Launch?
- Compile with explicit target: `-target arm64-apple-macosx13.0`
- Ensure `config.swift` exists (copy from `config.swift.template`)
- Check Swift version: `swift --version`

## 📝 Development Notes

This project was developed on **macOS 26.0.1 beta** with **Swift 6.2**, which required special handling:
- Explicit compilation target (`-target arm64-apple-macosx13.0`)
- Avoided unstable `SFSpeechRecognizer` framework
- Used ElevenLabs STT instead of macOS built-in speech recognition
- Continuous listening via `AVAudioEngine` instead of click-to-record
- `config.swift` is gitignored — copy `config.swift.template` and add your keys

## 🔮 Future Features

- [ ] Gemini vision-based behavior monitoring (webcam)
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

- **OpenAI** for GPT-4o and GPT-4.1 APIs
- **ElevenLabs** for Speech-to-Text and Text-to-Speech APIs
- **Ivanna** for the sassy voice that brings TalkBack to life

## 💬 Questions or Feedback?

Open an issue or reach out! TalkBack loves to chat (obviously). 😉

---

**Made with 💻 and a lot of sass** by [@aran-yogesh](https://github.com/aran-yogesh)

