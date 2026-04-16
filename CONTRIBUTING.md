# 🤝 Contributing to TalkBack 🗣️💥

> _"Oh, you want to contribute? How brave. How foolish. How... exciting!"_ — TalkBack 😏💅

First off — **THANK YOU** for even considering contributing! 🎉🥳🫶 You're already cooler than 99% of developers out there. (TalkBack would never admit that, but we will. 🤫)

---

## 📑 Table of Contents

- [🌟 Why Contribute?](#-why-contribute)
- [🚀 Getting Started](#-getting-started)
- [🐛 Reporting Bugs](#-reporting-bugs)
- [💡 Suggesting Features](#-suggesting-features)
- [🔀 Submitting Pull Requests](#-submitting-pull-requests)
- [📏 Code Style Guide](#-code-style-guide)
- [🧪 Testing](#-testing)
- [📝 Documentation](#-documentation)
- [🎭 The Vibe Check](#-the-vibe-check)
- [💬 Need Help?](#-need-help)

---

## 🌟 Why Contribute?

Because... 👇

- 🏆 You'll be part of the sassiest open-source project ever
- 🧠 You'll learn cool stuff (Swift, AI APIs, macOS dev)
- 😈 You can make TalkBack even MORE annoying (the world needs this)
- ⭐ Your name goes in the contributors hall of fame
- 💅 Bragging rights. Unlimited bragging rights.

---

## 🚀 Getting Started — _Let's Get You Set Up_ 🏗️

### 1️⃣ Fork the Repo 🍴

Hit that **Fork** button like it owes you money 💰

### 2️⃣ Clone Your Fork 📥

```bash
git clone https://github.com/YOUR_USERNAME/TalkBack.git
cd TalkBack
```

### 3️⃣ Create a Branch 🌿

```bash
git checkout -b feature/my-awesome-feature
```

Name it something fun! Examples:
- `feature/even-sassier-responses` 😏
- `fix/stop-crashing-please` 🙏
- `feature/add-beatbox-mode` 🎵

### 4️⃣ Set Up API Keys 🔑

```bash
cp config.swift.template config.swift
```

Add your API keys (don't worry, `config.swift` is gitignored — your secrets are safe 🔒🤐)

### 5️⃣ Build & Run 🏃‍♂️💨

```bash
swiftc -o ConversationalTalkBack ConversationalTalkBack.swift \
  -framework Cocoa -framework Foundation -framework AVFoundation \
  -target arm64-apple-macosx13.0

./ConversationalTalkBack
```

If it works: 🎉🥳🎊
If it doesn't: Welcome to the club 😂🔥

---

## 🐛 Reporting Bugs — _Found a Bug? Spill the Tea_ 🍵🐞

Found something broken? We want to hear about it! 🗣️

### How to Report 📋

1. 🔍 **Search existing issues** first (maybe someone already found it!)
2. 📝 **Open a new issue** with:
   - 🏷️ A clear, descriptive title
   - 📖 Steps to reproduce (be specific — we can't read minds... yet 🔮)
   - 🤔 What you expected to happen
   - 💥 What actually happened
   - 🖥️ Your macOS version and Swift version
   - 📸 Screenshots if applicable (we love receipts 🧾)

### Bug Report Template 📄

```
🐛 Bug: [Short description]

📋 Steps to Reproduce:
1. Do this thing
2. Then this thing
3. Watch it explode 💥

🤔 Expected: [What should happen]
💥 Actual: [What actually happened]
🖥️ Environment: macOS XX.X, Swift X.X
```

---

## 💡 Suggesting Features — _Got Ideas? We're All Ears_ 👂✨

Have a brilliant idea? 🧠💡 We love those!

### The Sassier, The Better 💅

We especially love features that:
- 😈 Make TalkBack more annoying (in a fun way)
- 🎭 Add new personality traits
- 🔥 Create new roast opportunities
- 🎤 Enhance voice interactions
- 👁️ Expand vision capabilities

### How to Suggest 📝

1. Open an issue with the `✨ Feature Request` label
2. Describe your idea (bonus points for humor 😂)
3. Explain why it would be awesome 🌟
4. Include mockups or examples if you can 🎨

---

## 🔀 Submitting Pull Requests — _Show Us What You Got_ 💪🔥

### The PR Checklist ✅

Before submitting, make sure:

- [ ] 🧪 Your code actually works (please 🙏)
- [ ] 📝 You've updated docs if needed
- [ ] 🎨 Your code follows the existing style
- [ ] 🔑 No API keys or secrets committed (we WILL find them 🕵️)
- [ ] 💬 Your PR description explains what and why
- [ ] 🧹 No unnecessary files (looking at you, `.DS_Store` 👀)

### PR Title Format 📋

```
✨ feat: add beatbox mode
🐛 fix: stop avatar from following you to the bathroom
📝 docs: add more emojis (always a valid PR)
🔧 chore: update dependencies
```

### The Review Process 🔍

1. 📬 Submit your PR
2. 🧐 We'll review it (with sass, obviously)
3. 💬 We might request changes (don't take it personally 😘)
4. ✅ Once approved, we'll merge it! 🎉
5. 🏆 You're officially a TalkBack contributor! 🥳

---

## 📏 Code Style Guide — _Keep It Clean, Keep It Sassy_ 🧹✨

### Swift Code 🦅

- 📐 Use 4-space indentation
- 📛 Use descriptive variable names (no `x`, `temp`, or `asdf` please 😤)
- 💬 Add comments for complex logic (future you will thank present you 🙏)
- 🏗️ Follow existing patterns in the codebase
- 🚫 No force unwrapping unless absolutely necessary (we like our apps crash-free 🛡️)

### Python Code 🐍

- 🐍 Follow PEP 8 (the Python style bible 📖)
- 📐 Use 4-space indentation
- 📝 Add docstrings to functions
- 🧹 Keep it clean and readable

### General Rules 📜

- 🎯 Keep changes focused and minimal
- 🔒 Never commit secrets or API keys
- 📖 Update docs when behavior changes
- 🧪 Test your changes before submitting

---

## 🧪 Testing — _Make Sure It Actually Works_ 🔬😅

### Running Tests 🏃‍♂️

```bash
# Run the MCP connection test 🔌
python3 test_mcp_connection.py

# Run the test suite 🧪
python3 -m pytest tests/ -v

# Test the code monitor with a broken script 💣
python3 cursor_code_monitor.py run 'python3 broken_code.py'
```

### What to Test 🎯

- ✅ Your new feature works as expected
- ✅ Existing features still work (don't break stuff please 🙏)
- ✅ Edge cases are handled (what happens when things go wrong? 🤔)
- ✅ Error messages are helpful (and sassy, if applicable 😏)

---

## 📝 Documentation — _Words Matter Too_ ✍️📖

Good docs = happy developers = more contributors = world domination 🌍👑

### When to Update Docs 📋

- 🆕 Adding a new feature? Document it!
- 🔄 Changing behavior? Update the docs!
- 🐛 Found a doc bug? Fix it!
- 😂 Found a place that needs more emojis? DEFINITELY fix it!

---

## 🎭 The Vibe Check — _What We're About_ 🌈✨

This project is all about:

- 🎉 **Fun** — If it's not fun, what's the point?
- 💅 **Sass** — The more attitude, the better
- 🤝 **Inclusivity** — Everyone is welcome here
- 🧠 **Learning** — We're all figuring it out together
- 🚀 **Innovation** — Push boundaries, try weird stuff

### Code of Conduct 🤝

Be cool. Be kind. Be sassy (but never mean). 💖

- 🚫 No harassment, discrimination, or toxicity
- ✅ Constructive feedback only
- 🤗 Help newcomers feel welcome
- 😂 Humor is encouraged (dad jokes included 👨)

---

## 💬 Need Help? — _We Got You_ 🫂

Stuck? Confused? Lost in the sauce? 🫠

- 💬 **Open an issue** — We'll help you out!
- 🗣️ **Start a discussion** — Let's brainstorm together!
- 📧 **Reach out** — We don't bite (TalkBack might, though 🦷😈)

---

## 🏆 Contributors Hall of Fame 🌟

Every contributor gets a special place in our hearts 💖 and in this section! ✨

_Your name could be here! Just submit a PR and join the squad! 🫡🔥_

---

**Thanks for reading this far! You're already a legend. 🏅**

Now go forth and make TalkBack even more gloriously annoying! 🗣️💥🚀

_May your code compile on the first try and your roasts be ever savage._ 🔥💅✨
