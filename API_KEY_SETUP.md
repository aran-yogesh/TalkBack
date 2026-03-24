# 🔐 API Key Configuration Guide

This document explains how TalkBack handles API keys.

## 📍 Where Are API Keys Stored?

API keys are stored in a separate `config.swift` file that is **gitignored** for security. The main app (`ConversationalTalkBack.swift`) loads keys from the `Config` struct defined in `config.swift`.

## 🔧 How to Set Up Your API Keys

### 1. Copy the Template

```bash
cp config.swift.template config.swift
```

### 2. Edit `config.swift` with Your Keys

```swift
struct Config {
    static let openAIAPIKey = "YOUR_OPENAI_API_KEY_HERE"
    static let elevenLabsAPIKey = "YOUR_ELEVENLABS_API_KEY_HERE"
    static let elevenLabsVoiceID = "cgSgspJ2msm6clMCkdW9"  // Ivanna's voice
    static let geminiAPIKey = "YOUR_GEMINI_API_KEY_HERE"
}
```

### 3. Get Your API Keys

| Service | Where to Get It | Link |
|---------|----------------|------|
| **OpenAI** | Platform dashboard | [https://platform.openai.com/account/api-keys](https://platform.openai.com/account/api-keys) |
| **ElevenLabs** | Profile settings | [https://elevenlabs.io/](https://elevenlabs.io/) |
| **Gemini** | Google AI Studio | [https://aistudio.google.com/app/apikey](https://aistudio.google.com/app/apikey) |

### 4. Recompile After Changes

After updating your API keys, recompile:

```bash
swiftc -o ConversationalTalkBack ConversationalTalkBack.swift \
  -framework Cocoa -framework Foundation -framework AVFoundation \
  -target arm64-apple-macosx13.0
```

## 🚨 Security Warning

⚠️ **NEVER commit your actual API keys to GitHub!**

- `config.swift` is already in `.gitignore` — it won't be committed
- Only `config.swift.template` (with placeholder values) is tracked in git
- Never paste real keys into `ConversationalTalkBack.swift` directly
