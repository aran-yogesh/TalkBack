# 🔐 API Key Configuration Guide

This document explains how TalkBack handles API keys.

## 📍 Where Are API Keys Stored?

API keys live in a separate `config.swift` file (gitignored) that is compiled alongside `ConversationalTalkBack.swift`. The repo ships a `config.swift.template` you copy and fill in.

## 🔧 How to Update Your API Keys

### 1. Create Your Config File

```bash
cp config.swift.template config.swift
```

Edit `config.swift` with your actual keys:

```swift
struct Config {
    static let openAIAPIKey = "YOUR_OPENAI_API_KEY_HERE"
    static let elevenLabsAPIKey = "YOUR_ELEVENLABS_API_KEY_HERE"
    static let elevenLabsVoiceID = "cgSgspJ2msm6clMCkdW9"
    static let geminiAPIKey = "YOUR_GEMINI_API_KEY_HERE"
}
```

### 2. Get Your API Keys

| Service | Where to Get It | Link |
|---------|----------------|------|
| **OpenAI** | Platform dashboard | [https://platform.openai.com/account/api-keys](https://platform.openai.com/account/api-keys) |
| **ElevenLabs** | Profile settings | [https://elevenlabs.io/](https://elevenlabs.io/) |
| **Gemini** | Google AI Studio | [https://aistudio.google.com/app/apikey](https://aistudio.google.com/app/apikey) |

### 3. Recompile After Changes

After updating your API keys, recompile:

```bash
swiftc -o ConversationalTalkBack config.swift ConversationalTalkBack.swift \
  -framework Cocoa -framework Foundation -framework AVFoundation \
  -target arm64-apple-macosx13.0
```

## 🚨 Security Warning

⚠️ **NEVER commit your actual API keys to GitHub!**

`config.swift` is already in `.gitignore` so your keys stay local. The repo only ships `config.swift.template` with placeholder values.

## 🎯 Current Setup

- ✅ **`config.swift.template`** — checked-in template with placeholder keys
- ✅ **`config.swift`** — your local copy with real keys (gitignored)
- ✅ **`.gitignore`** — excludes `config.swift` and `.env`

