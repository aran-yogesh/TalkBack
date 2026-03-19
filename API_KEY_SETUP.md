# 🔐 API Key Configuration Guide

This document explains how TalkBack handles API keys.

## 📍 Where Are API Keys Stored?

API keys live in a separate `config.swift` file that is **gitignored** so your secrets never get committed. The app loads keys from a `Config` struct defined in that file.

## 🔧 How to Update Your API Keys

### 1. Copy the Template

```bash
cp config.swift.template config.swift
```

### 2. Edit `config.swift`

Open `config.swift` and replace the placeholders with your real keys:

```swift
struct Config {
    static let openAIAPIKey = "YOUR_OPENAI_API_KEY_HERE"      // ← Replace this
    static let elevenLabsAPIKey = "YOUR_ELEVENLABS_API_KEY_HERE"  // ← Replace this
    static let elevenLabsVoiceID = "cgSgspJ2msm6clMCkdW9"    // Ivanna's voice (keep this)
    static let geminiAPIKey = "YOUR_GEMINI_API_KEY_HERE"      // ← Replace this
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
swiftc -O -target arm64-apple-macosx13.0 ConversationalTalkBack.swift -o ConversationalTalkBack
```

## 🚨 Security Warning

⚠️ **NEVER commit your actual API keys to GitHub!**

The current API keys in the codebase are **placeholders** (or belong to the original developer for testing).

### Before Committing to Git:

1. Replace all real API keys with `YOUR_*_API_KEY_HERE` placeholders
2. Or use a separate `config.swift` file (already added to `.gitignore`)

## 📝 Alternative: Using config.swift (Recommended for Development)

For local development, you can create a separate `config.swift` file:

1. **Copy the template**:
   ```bash
   cp config.swift.template config.swift
   ```

2. **Edit `config.swift`** with your real keys

3. **This file is gitignored** - it won't be committed to GitHub

4. **Compile with both files**:
   ```bash
   swiftc -O -target arm64-apple-macosx13.0 config.swift ConversationalTalkBack.swift -o ConversationalTalkBack
   ```

## 🎯 Current Setup

The repo currently has:
- ✅ **`config.swift.template`** — checked-in template with placeholder values
- ✅ **`config.swift`** — your local copy with real keys (gitignored)
- ✅ **`.gitignore`** excludes `config.swift` so secrets stay local
- ✅ **`ConversationalTalkBack.swift`** references `Config.*` for all API keys

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

