# 🤝 Contributing to TalkBack 🗣️💥

> *"Oh, you want to contribute? How brave. How foolish. How... exciting!"* — TalkBack 💅✨

First off — THANK YOU for even considering contributing! 🎉🥳🫶
You're already cooler than 99% of people. *(TalkBack said that, not me.)* 😏

---
# Contributing to TalkBack 🤝💅✨

> *"Oh, you want to contribute? How delightfully ambitious of you."* — TalkBack 😏

First off, THANK YOU for even considering contributing! 🎉🥳 Whether you're fixing a bug 🐛, adding a feature 🚀, or just fixing a typo (we won't judge... much 😏), you're awesome and we appreciate you! ❤️🙌

## 📑 Table of Contents

- [🏁 Getting Started](#-getting-started)
- [🐛 Reporting Bugs](#-reporting-bugs)
- [💡 Suggesting Features](#-suggesting-features)
- [🔀 Submitting Pull Requests](#-submitting-pull-requests)
- [🧑‍💻 Development Setup](#-development-setup)
- [📏 Code Style](#-code-style)
- [🧪 Testing](#-testing)
- [📝 Documentation](#-documentation)
- [🎭 The Vibe Check](#-the-vibe-check)
- [💬 Need Help?](#-need-help)

## 🏁 Getting Started — Welcome to the Party 🎪🎊

1. 🍴 **Fork the repo** (hit that fork button like it owes you money 💰)
2. 📥 **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/TalkBack.git
   cd TalkBack
   ```
3. 🌿 **Create a branch** (name it something cool, not `fix-stuff` 😤):
   ```bash
   git checkout -b feat/my-awesome-feature
   ```
4. 🔧 **Make your changes** (the fun part! 🎨)
5. ✅ **Test your changes** (the less fun but very important part 🧪)
6. 🚀 **Push and open a PR** (see below for details 👇)

## 🐛 Reporting Bugs — Something Broke? Spill the Tea ☕🫖

Found a bug? Don't panic! 😱 (Okay, maybe panic a little 😅)

Open an issue and include:

- 📝 **What happened** (the drama 🎭)
- 🤔 **What you expected** (the dream ✨)
- 🖥️ **Your environment** (macOS version, Swift version, etc.)
- 📸 **Screenshots/logs** if possible (receipts! 🧾)
- 🔄 **Steps to reproduce** (so we can suffer too 💀)

**Bug report template:**
```
🐛 Bug: [Short description]
📍 Where: [Which file/feature]
🔄 Steps: [How to reproduce]
🤔 Expected: [What should happen]
😱 Actual: [What actually happened]
🖥️ Environment: [macOS version, Swift version]
```

## 💡 Suggesting Features — Got Ideas? We're All Ears 👂✨

Have a brilliant idea? 🧠💡 We love those! Open an issue with:

- 🎯 **What** you want (be specific, not "make it better" 😂)
- 🤷 **Why** it would be cool (convince us! 🎤)
- 🎨 **How** you envision it working (bonus points for mockups 🏆)
- 🌶️ **Sass level** — how sassy should this feature be? (the answer is always "very" 💅)

## 🔀 Submitting Pull Requests — Show Us What You Got 🎪🔥

### The PR Checklist ✅

Before you submit, make sure you've:

- [ ] 🌿 Created a branch from `main`
- [ ] 🧪 Tested your changes (seriously, please 🙏)
- [ ] 📝 Updated docs if needed
- [ ] 🔑 NOT committed any API keys (we WILL find you 🕵️)
- [ ] 🎨 Followed the existing code style
- [ ] ✍️ Written a clear PR description

### PR Title Format 📋

Use this format so we know what's up at a glance 👀:

```
feat: add laser eyes to avatar 🔴🔴
fix: stop TalkBack from roasting too hard 🔥➡️🕯️
docs: add more emojis because why not 🎉
chore: update dependencies 📦
```

### PR Description Template 📝

```markdown
## What does this PR do? 🤔
[Explain your changes — keep it short and sweet 🍬]

## Why? 💡
[Why is this needed? What problem does it solve?]

## How to test 🧪
[Steps to verify your changes work]

## Screenshots 📸 (if applicable)
[Show us the goods! 👀]
```

## 🧑‍💻 Development Setup — Get Your Hands Dirty 🔧🛠️

### Prerequisites 📋

- macOS 13.0+ 🍎
- Xcode Command Line Tools 🔨
- Swift 6.2 🦅
- Python 3.x 🐍 (for MCP tools)
- API keys (OpenAI, ElevenLabs) 🔑

### Setup Steps 🪜

```bash
# Clone and enter the repo 📥
git clone https://github.com/aran-yogesh/TalkBack.git
cd TalkBack

# Set up your config 🔐
cp config.swift.template config.swift
# Edit config.swift with your API keys ✏️

# Compile 🔨
swiftc -o ConversationalTalkBack ConversationalTalkBack.swift \
  -framework Cocoa -framework Foundation -framework AVFoundation \
  -target arm64-apple-macosx13.0

# Run it! 🚀
./ConversationalTalkBack
```

## 📏 Code Style — Keep It Clean, Keep It Sassy 🧹💅

- **Swift**: Follow standard Swift conventions 🦅
- **Python**: PEP 8 style guide 🐍
- **Comments**: Keep them useful, not obvious (no `// increment i by 1` please 🙄)
- **Naming**: Be descriptive! `handleVoiceInput()` > `doStuff()` 📛
- **Emojis in code comments**: Encouraged! (okay maybe not, but in docs? ABSOLUTELY 🎉)

## 🧪 Testing — Trust but Verify 🔍

- Test your changes before submitting 🧪
- Run the MCP connection test: `python3 test_mcp_connection.py` 🔌
- Run the test suite: `python3 -m pytest tests/` 🏃‍♂️
- If you add a new feature, add tests for it too! (we believe in you 💪)
- Manual testing is also valid — just describe what you tested in your PR 📝

## 📝 Documentation — Words Matter Too 📖✍️

- Update `README.md` if you change user-facing behavior 📄
- Keep docs fun and emoji-rich (you're reading the proof 😎)
- Make sure command snippets are copy-paste ready 📋
- If you add new files, update the Project Structure table 📂

## 🎭 The Vibe Check — Our Community Values 🌈🤗

We're building something fun here, so let's keep it that way! 🎪

- 🤝 **Be kind** — We're all here to learn and build cool stuff
- 🧠 **Be constructive** — Feedback should help, not hurt
- 🎉 **Have fun** — This is a sassy AI companion, not a tax return
- 💅 **Embrace the sass** — But keep it playful, never mean
- 🌍 **Be inclusive** — Everyone is welcome, no exceptions
- 🚫 **No jerks** — Seriously, don't be one. TalkBack has enough attitude for all of us 😏

## 💬 Need Help? — We Got You 🫂

Stuck? Confused? Existential crisis about your code? 😵‍💫

- 💬 Open an issue and ask! No question is too silly 🤪
- 📖 Check the [README](README.md) for setup guides
- 🔑 Check [API_KEY_SETUP.md](API_KEY_SETUP.md) for API key help
- 🔌 Check [MCP_SETUP.md](MCP_SETUP.md) for MCP integration help

---

*Thanks for contributing! You're officially cooler than 99% of developers 😎🏆. Now go make TalkBack even sassier! 💅🔥✨*
