# 🤝 Contributing to TalkBack 🗣️💥

> _"So you want to contribute? Bold move. I respect that."_ — TalkBack 💅

First off — **THANK YOU** for even considering contributing! 🎉🥳🫶 Whether you're fixing a typo or adding a whole new feature, you're officially part of the chaos now. Welcome aboard! 🚀🎪
# 🤝💥 Contributing to TalkBack — *Welcome to the Sass Squad!*

> *"Oh, you want to contribute? How delightfully ambitious of you."* — TalkBack 💅

First off — **THANK YOU** for even thinking about contributing! 🎉🫶 Whether you're fixing a typo or adding a whole new feature, you're officially one of us now. No take-backs. 😈

---

## 📑 Table of Contents

- [🧭 Code of Conduct](#-code-of-conduct)
- [🏁 Getting Started](#-getting-started)
- [🐛 Reporting Bugs](#-reporting-bugs)
- [💡 Suggesting Features](#-suggesting-features)
- [🔀 Pull Requests](#-pull-requests)
- [🎨 Code Style](#-code-style)
- [🧪 Testing](#-testing)
- [📝 Documentation](#-documentation)
- [🏷️ Commit Messages](#️-commit-messages)
- [🎖️ Recognition](#️-recognition)
- [❓ Questions?](#-questions)

---

## 🧭 Code of Conduct — Don't Be a Jerk 🙅‍♂️

It's simple:
- 🤝 Be respectful and kind
- 🧠 Assume good intentions
- 💬 Communicate clearly
- 🚫 No harassment, trolling, or general tomfoolery (the bad kind)
- 🎉 Have fun! This is a sassy AI project, not a courtroom

> TalkBack may be rude, but *we* are not. Keep it classy, folks. 🎩✨

---

## 🏁 Getting Started — Your Adventure Begins Here 🗺️

### 1. Fork the Repo 🍴

Click that shiny **Fork** button at the top right. You know you want to. 😏

### 2. Clone Your Fork 📥
- [🌟 Why Contribute?](#-why-contribute)
- [🚀 Getting Started](#-getting-started)
- [🔀 How to Submit Changes](#-how-to-submit-changes)
- [🐛 Reporting Bugs](#-reporting-bugs)
- [💡 Suggesting Features](#-suggesting-features)
- [📏 Code Style Guide](#-code-style-guide)
- [🧪 Testing](#-testing)
- [📝 Documentation](#-documentation)
- [🏷️ Commit Messages](#️-commit-messages)
- [🎭 The Vibe Check](#-the-vibe-check)
- [🏆 Hall of Fame](#-hall-of-fame)

---

## 🌟 Why Contribute?

- 🦸 Become a hero in the TalkBack universe
- 🧠 Learn cool stuff (Swift, AI APIs, macOS dev)
- 😂 Work on a project that's actually *fun*
- 💅 Add "contributed to a sassy AI companion" to your resume
- 🫂 Join a community that doesn't take itself too seriously

---

## 🚀 Getting Started — *Suit Up, Bestie!*

### 1. 🍴 Fork the Repo

Hit that **Fork** button like it owes you money 💸

### 2. 📦 Clone Your Fork

```bash
git clone https://github.com/YOUR_USERNAME/TalkBack.git
cd TalkBack
```

### 3. 🌿 Create a Branch

```bash
git checkout -b feat/your-awesome-feature
```

> 🎨 Branch naming convention:
> - `feat/description` — new features ✨
> - `fix/description` — bug fixes 🐛
> - `docs/description` — documentation 📝
> - `chore/description` — maintenance 🧹

### 4. 🔑 Set Up API Keys

```bash
cp config.swift.template config.swift
```

Add your API keys to `config.swift`. *And for the love of all things holy, don't commit them.* 🙏🔐

### 5. 🔨 Build & Test

```bash
swiftc -o ConversationalTalkBack ConversationalTalkBack.swift \
  -framework Cocoa -framework Foundation -framework AVFoundation \
  -target arm64-apple-macosx13.0
```

---

## 🔀 How to Submit Changes — *Show Us What You Got!*

1. ✅ Make sure your code works (please 🥺)
2. 📝 Write clear commit messages (see [Commit Messages](#️-commit-messages))
3. 🔀 Push to your fork:
   ```bash
   git push origin feat/your-awesome-feature
   ```
4. 🎯 Open a Pull Request against `main`
5. 📋 Fill out the PR template with:
   - What you changed 🔧
   - Why you changed it 🤔
   - How to test it 🧪
6. 🍿 Sit back and wait for review *(we're fast, promise!)*

---

## 🐛 Reporting Bugs — *Snitch on Those Bugs!*

Found a bug? 🪲 Don't be shy — report it!

### 📝 Bug Report Template

When opening an issue, include:

- 🏷️ **Title**: Short and descriptive
- 📖 **Description**: What happened vs. what you expected
- 🔄 **Steps to Reproduce**: How can we see the bug?
- 💻 **Environment**: macOS version, Swift version, etc.
- 📸 **Screenshots**: If applicable *(a picture is worth a thousand words 🖼️)*
- 🤔 **Additional Context**: Anything else that might help

> 💡 **Pro tip**: The more detail you give, the faster we can squash it! 🔨🪲

---

## 💡 Suggesting Features — *Dream Big, Bestie!*

Got an idea? 🧠✨ We LOVE ideas! Open an issue with:

- 🏷️ **Title**: `[Feature Request] Your Amazing Idea`
- 🎯 **Problem**: What problem does this solve?
- 💡 **Solution**: How do you envision it working?
- 🎨 **Mockups**: Bonus points for visuals! 🖌️
- 🤪 **Sass Level**: How sassy should this feature be? *(Important metric!)*

---

## 📏 Code Style Guide — *Keep It Clean, Keep It Sassy*

### 🦅 Swift
- Follow standard Swift conventions
- Use descriptive variable names *(no `x`, `temp`, or `asdf` please 😤)*
- Keep functions focused and concise
- Comment only when the code isn't self-explanatory

### 🐍 Python
- Follow PEP 8 *(the Python fashion police 👮)*
- Use type hints where possible
- Keep it readable — *if you can't read it tomorrow, rewrite it today*

### 📝 General Rules
- 🚫 No hardcoded API keys — *EVER* 🔐
- ✅ Test your changes before submitting
- 🧹 Clean up debug prints and commented-out code
- 💬 Write meaningful commit messages

---

## 🧪 Testing — *Trust, But Verify*

### 🏃 Running Tests

```bash
# Run Python tests
python3 -m pytest tests/ -v

# Test MCP connection
python3 test_mcp_connection.py

# Test with intentionally broken code (for roast testing 🔥)
python3 cursor_code_monitor.py run 'python3 broken_code.py'
```

### ✅ Before Submitting

- [ ] 🔨 Code compiles without errors
- [ ] 🧪 Existing tests still pass
- [ ] 🆕 New features have tests (if applicable)
- [ ] 📝 Documentation is updated
- [ ] 🔑 No API keys committed *(we will find you 👀)*

---

## 📝 Documentation — *Words Matter Too!*

- 📖 Update `README.md` when adding features or changing behavior
- 📋 Keep code comments concise and helpful
- 🔄 Update the Table of Contents when adding new sections
- ✍️ Use clear, actionable language

---

## 🏷️ Commit Messages — *Tell Us a Story (a Short One)*

Format: `type: short description`

| Type | Emoji | When to Use |
|------|-------|-------------|
| `feat` | ✨ | New feature |
| `fix` | 🐛 | Bug fix |
| `docs` | 📝 | Documentation |
| `style` | 🎨 | Formatting, no code change |
| `refactor` | ♻️ | Code restructuring |
| `test` | 🧪 | Adding tests |
| `chore` | 🧹 | Maintenance tasks |

### Examples:
```
✨ feat: add custom voice selection
🐛 fix: resolve crash on macOS 13
📝 docs: update Quick Start guide
🧪 test: add MCP connection tests
```

---

## 🎭 The Vibe Check — *Our Community Values*

### ✅ DO:
- 🤝 Be kind and respectful
- 💬 Communicate clearly
- 🎉 Celebrate others' contributions
- 😂 Have fun — this is a sassy AI project after all!
- 🧠 Ask questions — no question is too silly

### ❌ DON'T:
- 🚫 Be rude or dismissive
- 🙅 Submit untested code
- 🔐 Commit secrets or API keys
- 😤 Take feedback personally — we're all learning!
- 🍝 Write spaghetti code *(TalkBack has standards, darling 💅)*

---

## 🏆 Hall of Fame — *Legends Only*

Every contributor gets a shoutout! 🎊 Once your PR is merged, you'll be immortalized here.

| Contributor | Contribution | Vibe |
|---|---|---|
| 🏆 **Yogesh Mahendran** | Created the whole thing | Absolute legend 👑 |
| 🫵 **You?** | *Your amazing contribution* | *TBD — make it count!* ✨ |

---

> 🗣️ *"Contributing to open source is like talking to TalkBack — sometimes scary, always rewarding, and you'll definitely learn something."*

**Now go forth and code, you beautiful human!** 🚀💅✨
