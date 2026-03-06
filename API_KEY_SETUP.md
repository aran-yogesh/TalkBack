# 🔐 API Key Configuration Guide

This document explains how TalkBack handles API keys.

## 📍 Where Are API Keys Stored?

API keys live in a separate `config.swift` file that is **gitignored** so your secrets never leave your machine. The repo ships a `config.swift.template` with placeholder values.

## 🔧 How to Set Up Your API Keys

### 1. Copy the template

```bash
cp config.swift.template config.swift
```

### 2. Edit `config.swift` with your real keys

```swift
struct Config {
    static let openAIAPIKey = "YOUR_OPENAI_API_KEY_HERE"
    static let elevenLabsAPIKey = "YOUR_ELEVENLABS_API_KEY_HERE"
    static let elevenLabsVoiceID = "cgSgspJ2msm6clMCkdW9"
    static let geminiAPIKey = "YOUR_GEMINI_API_KEY_HERE"
}
```

### 3. Get Your API Keys

| Service | Where to Get It | Link |
|---------|----------------|------|
| **OpenAI** | Platform dashboard | [https://platform.openai.com/account/api-keys](https://platform.openai.com/account/api-keys) |
| **ElevenLabs** | Profile settings | [https://elevenlabs.io/](https://elevenlabs.io/) |

### 4. Compile with both files

```bash
swiftc -o ConversationalTalkBack config.swift ConversationalTalkBack.swift \
  -framework Cocoa -framework Foundation -framework AVFoundation \
  -target arm64-apple-macosx13.0
```

## 🚨 Security Warning

⚠️ **NEVER commit your actual API keys to GitHub!**

`config.swift` is already in `.gitignore` — as long as you put your keys there (not in `ConversationalTalkBack.swift`), they will stay local.

## 🎯 Current Setup

- ✅ **`config.swift.template`** — checked-in template with placeholder values
- ✅ **`config.swift`** — your local copy with real keys (gitignored)
- ✅ **`.gitignore`** — excludes `config.swift`
- ✅ **`ConversationalTalkBack.swift`** — references `Config.*` at runtime

3. **.gitignore**
   - Added `.env`, `config.swift`

4. **README.md**
   - Updated installation instructions
   - Added Gemini API key requirement
   - Documented new vision monitoring features

5. **config.swift** (gitignored)
   - Standalone config file with actual keys (local only)

6. **config.swift.template**
   - Template for others to copy and fill in

---

**Last Updated**: October 19, 2025  
**Status**: ✅ All API keys properly configured

