# 🔐 API Key Configuration Guide

This document explains how TalkBack handles API keys.

## 📍 Where Are API Keys Stored?

API keys are stored in a separate `config.swift` file that is loaded at compile time. This file is gitignored to keep your keys safe.

### Files with Config:
- `config.swift` - Your local API key configuration (gitignored)
- `config.swift.template` - Template to copy and fill in
- `ConversationalTalkBack.swift` - Main avatar app (references `Config` struct)

> **Note**: Vision features (Gemini-based) are planned for a future release.

## 🔧 How to Update Your API Keys

### 1. Edit the Config Struct

Copy the template and edit your `config.swift`:

```bash
cp config.swift.template config.swift
```

Then edit `config.swift` with your real keys:

```swift
struct Config {
    // OpenAI API Key (for GPT-4o chat responses)
    static let openAIAPIKey = "YOUR_OPENAI_API_KEY_HERE"  // ← Replace this
    
    // ElevenLabs API Key (for voice synthesis and speech-to-text)
    static let elevenLabsAPIKey = "YOUR_ELEVENLABS_API_KEY_HERE"  // ← Replace this
    
    // ElevenLabs Voice ID (Ivanna's voice)
    static let elevenLabsVoiceID = "cgSgspJ2msm6clMCkdW9"  // Keep this
    
    // Gemini API Key (for vision/behavior monitoring)
    static let geminiAPIKey = "YOUR_GEMINI_API_KEY_HERE"  // ← Replace this
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

## 🎯 Current Setup (as of latest commit)

The repo currently has:
- ✅ **Config struct** in separate `config.swift` file (loaded at compile time)
- ✅ **config.swift** and **config.swift.template** files
- ✅ **Updated .gitignore** to exclude `config.swift`
- ✅ **README.md** with setup instructions

## 📚 Files Modified

1. **ConversationalTalkBack.swift**
   - Added `Config` struct at the top
   - Replaced hardcoded keys with `Config.keyName`

2. **Vision features** (planned)
   - Gemini-based vision monitoring is planned for a future release

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

