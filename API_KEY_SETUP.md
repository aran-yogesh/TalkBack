# 🔐 API Key Configuration Guide

This document explains how TalkBack handles API keys.

## 📍 Where Are API Keys Stored?

API keys are stored in a separate `config.swift` file (gitignored) that provides a `Config` struct.

### Config File:
- `config.swift.template` — Template with placeholder keys (committed to repo)
- `config.swift` — Your actual keys (gitignored, never committed)

## 🔧 How to Update Your API Keys

### 1. Copy the Template

```bash
cp config.swift.template config.swift
```

### 2. Edit `config.swift`

```swift
struct Config {
    static let openAIAPIKey = "YOUR_OPENAI_API_KEY_HERE"       // ← Replace this
    static let elevenLabsAPIKey = "YOUR_ELEVENLABS_API_KEY_HERE" // ← Replace this
    static let elevenLabsVoiceID = "cgSgspJ2msm6clMCkdW9"       // Ivanna's voice (keep this)
    static let geminiAPIKey = "YOUR_GEMINI_API_KEY_HERE"         // ← Replace this
}
```

### 2. Get Your API Keys

| Service | Where to Get It | Link |
|---------|----------------|------|
| **OpenAI** | Platform dashboard | [https://platform.openai.com/account/api-keys](https://platform.openai.com/account/api-keys) |
| **ElevenLabs** | Profile settings | [https://elevenlabs.io/](https://elevenlabs.io/) |
| **Gemini** | Google AI Studio | [https://aistudio.google.com/app/apikey](https://aistudio.google.com/app/apikey) |

### 4. Recompile After Changes

After updating your API keys, recompile:

```bash
swiftc -o ConversationalTalkBack config.swift ConversationalTalkBack.swift \
  -framework Cocoa -framework Foundation -framework AVFoundation \
  -target arm64-apple-macosx13.0
```

## 🚨 Security Warning

⚠️ **NEVER commit your actual API keys to GitHub!**

The current API keys in the codebase are **placeholders** (or belong to the original developer for testing).

### Before Committing to Git:

1. Replace all real API keys with `YOUR_*_API_KEY_HERE` placeholders
2. Or use a separate `config.swift` file (already added to `.gitignore`)

## 🎯 Current Setup

The repo uses a separate `config.swift` file (gitignored) for API keys:
- ✅ **`config.swift.template`** — committed template with placeholder keys
- ✅ **`config.swift`** — local file with real keys (gitignored)
- ✅ **`ConversationalTalkBack.swift`** — references `Config.keyName` from config.swift

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

