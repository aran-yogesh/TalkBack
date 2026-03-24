# 🔐 API Key Configuration Guide

This document explains how TalkBack handles API keys.

## 📍 Where Are API Keys Stored?

API keys live in a separate `config.swift` file that is **gitignored** so your secrets never get committed.

## 🔧 How to Set Up Your API Keys

### 1. Copy the Template

```bash
cp config.swift.template config.swift
```

### 2. Edit `config.swift`

Open `config.swift` and replace the placeholders with your real keys:

```swift
struct Config {
    static let openAIAPIKey = "YOUR_OPENAI_API_KEY_HERE"
    static let elevenLabsAPIKey = "YOUR_ELEVENLABS_API_KEY_HERE"
    static let elevenLabsVoiceID = "cgSgspJ2msm6clMCkdW9"  // Ivanna's voice
    static let geminiAPIKey = "YOUR_GEMINI_API_KEY_HERE"
}
```

### 3. Get Your API Keys

| Service | What It Powers | Link |
|---------|---------------|------|
| **OpenAI** | Chat responses, Lens, teacher mode, assignment summaries | [platform.openai.com/account/api-keys](https://platform.openai.com/account/api-keys) |
| **ElevenLabs** | Voice recognition (STT) and voice synthesis (TTS) | [elevenlabs.io](https://elevenlabs.io/) |
| **Gemini** | Vision & behavior analysis *(planned — optional for now)* | [aistudio.google.com/app/apikey](https://aistudio.google.com/app/apikey) |

### 4. Compile

After updating your API keys, compile the app:

```bash
swiftc -o ConversationalTalkBack ConversationalTalkBack.swift \
  -framework Cocoa -framework Foundation -framework AVFoundation \
  -target arm64-apple-macosx13.0
```

## 🚨 Security Warning

⚠️ **NEVER commit your actual API keys to GitHub!**

- `config.swift` is listed in `.gitignore` — it will not be committed
- Only `config.swift.template` (with placeholder values) is tracked in the repo
- If you accidentally commit keys, rotate them immediately
