# 🔐 API Key Configuration Guide

This document explains how TalkBack loads API keys at runtime.

## 📍 Where Are API Keys Stored?

Keys live in a **separate `config.swift` file** (gitignored) that is compiled
alongside the main source. Each key can also be supplied via an **environment
variable**; when set, the environment variable takes precedence.

| Key | Environment Variable | Default Fallback |
|-----|---------------------|-----------------|
| OpenAI | `OPENAI_API_KEY` | placeholder in `config.swift` |
| ElevenLabs | `ELEVENLABS_API_KEY` | placeholder in `config.swift` |
| ElevenLabs Voice ID | `ELEVENLABS_VOICE_ID` | `cgSgspJ2msm6clMCkdW9` |
| Gemini | `GEMINI_API_KEY` | placeholder in `config.swift` |

## 🔧 Setup

### Option A — Config file (recommended)

1. Copy the template:
   ```bash
   cp config.swift.template config.swift
   ```
2. Open `config.swift` and replace the `YOUR_*_HERE` placeholders with your
   real keys.
3. The file is already in `.gitignore` — it will never be committed.

### Option B — Environment variables

```bash
export OPENAI_API_KEY="sk-..."
export ELEVENLABS_API_KEY="..."
export GEMINI_API_KEY="..."
```

You can put these in your shell profile (`~/.zshrc`, `~/.bashrc`) or in a
`.env` file sourced before launching the app.

### Where to Get Keys

| Service | Link |
|---------|------|
| **OpenAI** | <https://platform.openai.com/account/api-keys> |
| **ElevenLabs** | <https://elevenlabs.io/> |
| **Gemini** | <https://aistudio.google.com/app/apikey> |

## 🔨 Compile

Always compile `config.swift` together with the main source:

```bash
swiftc -O -target arm64-apple-macosx13.0 \
  config.swift ConversationalTalkBack.swift \
  -o ConversationalTalkBack
```

## 🚨 Security Warning

⚠️ **NEVER commit your actual API keys to GitHub!**

- `config.swift` is gitignored by default.
- If you use environment variables there is nothing to commit.
- The template file (`config.swift.template`) only contains placeholders.

