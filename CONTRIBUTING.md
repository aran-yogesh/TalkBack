# 🤝 Contributing to TalkBack 🗣️💥

> *"Oh, you want to contribute? How brave. How foolish. How... exciting!"* — TalkBack 💅✨

First off — THANK YOU for even considering contributing! 🎉🥳🫶
You're already cooler than 99% of people. *(TalkBack said that, not me.)* 😏

---

## 📑 Table of Contents

- [🏁 Getting Started](#-getting-started)
- [🍴 Fork & Clone](#-fork--clone)
- [🌿 Branching Strategy](#-branching-strategy)
- [💻 Making Changes](#-making-changes)
- [🧪 Testing Your Changes](#-testing-your-changes)
- [📬 Submitting a Pull Request](#-submitting-a-pull-request)
- [🐛 Reporting Bugs](#-reporting-bugs)
- [💡 Suggesting Features](#-suggesting-features)
- [📏 Code Style Guide](#-code-style-guide)
- [🚫 What NOT to Do](#-what-not-to-do)
- [🏷️ Labels We Use](#️-labels-we-use)
- [💬 Need Help?](#-need-help)

---

## 🏁 Getting Started

Before you dive in headfirst *(we respect the enthusiasm)* 🏊‍♂️, make sure you have:

- ✅ **macOS 13.0+** *(sorry Windows folks, this is an Apple-only party)* 🍎
- ✅ **Xcode Command Line Tools** installed 🔧
- ✅ **Python 3.8+** for the MCP scripts 🐍
- ✅ **A sense of humor** *(mandatory)* 😂
- ✅ **Thick skin** *(TalkBack WILL roast your code)* 🔥

---

## 🍴 Fork & Clone

1. 🍴 **Fork** this repo *(hit that fork button like it owes you money)* 💰
2. 📥 **Clone** your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/TalkBack.git
   cd TalkBack
   ```
3. 🔗 **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/aran-yogesh/TalkBack.git
   ```
4. 🔑 **Set up your API keys**:
   ```bash
   cp config.swift.template config.swift
   ```
   Then add your keys to `config.swift`. *(And for the love of all things holy, don't commit them.)* 🙅‍♂️🚫

---

## 🌿 Branching Strategy

Create a branch for your work — don't commit directly to `main`! 🚨

```bash
git checkout -b feat/your-awesome-feature
```

Branch naming conventions 🏷️:
- `feat/description` — New features ✨
- `fix/description` — Bug fixes 🐛
- `docs/description` — Documentation updates 📝
- `refactor/description` — Code refactoring 🔄
- `test/description` — Adding tests 🧪

---

## 💻 Making Changes

### Swift Changes 🦅

1. Make your changes to `ConversationalTalkBack.swift` (or add new files)
2. Compile to make sure it builds:
   ```bash
   swiftc -o ConversationalTalkBack ConversationalTalkBack.swift \
     -framework Cocoa -framework Foundation -framework AVFoundation \
     -target arm64-apple-macosx13.0
   ```
3. If it compiles, you're already doing better than most of us on the first try 😂🎉

### Python Changes 🐍

1. Make your changes to the relevant `.py` files
2. Test them:
   ```bash
   python3 -m pytest tests/ -v
   ```
3. Make sure nothing is on fire 🔥 *(figuratively... hopefully)*

### Documentation Changes 📝

- Update `README.md` whenever you change features or setup steps 📖
- Keep the Table of Contents in sync with headings *(AGENTS.md says so, and we don't argue with AGENTS.md)* 🤖
- Emojis are encouraged. Actually, emojis are *required*. 😤✨

---

## 🧪 Testing Your Changes

Before submitting, please verify:

- [ ] 🔨 Swift code compiles without errors
- [ ] 🐍 Python tests pass (`python3 -m pytest tests/ -v`)
- [ ] 🔑 No API keys or secrets in your commits *(we will find them and we will judge you)* 👀
- [ ] 📝 Docs are updated if you changed behavior
- [ ] 🧹 No leftover debug prints or `TODO` comments

---

## 📬 Submitting a Pull Request

1. 📤 **Push** your branch:
   ```bash
   git push origin feat/your-awesome-feature
   ```

2. 🔀 **Open a Pull Request** against `main`

3. 📝 **Fill out the PR template** with:
   - **What** you changed 🔍
   - **Why** you changed it 🤔
   - **How** to test it 🧪
   - **Screenshots** if it's a UI change 📸

4. ⏳ **Wait for review** *(we promise we're faster than TalkBack's comebacks)* ⚡

### PR Tips 💡🌟

- 🎯 Keep PRs focused — one feature/fix per PR
- 📏 Smaller PRs get reviewed faster *(nobody wants to review 500 files)* 😵
- 💬 Respond to review comments promptly
- 🔄 Rebase on `main` if your branch falls behind

---

## 🐛 Reporting Bugs

Found a bug? *(We prefer "undocumented feature" but okay)* 🤷‍♂️

Open an issue with:
- 🏷️ **Title**: Clear, concise description
- 📝 **Description**: What happened vs. what you expected
- 🔄 **Steps to reproduce**: How to trigger the bug
- 💻 **Environment**: macOS version, Swift version, etc.
- 📸 **Screenshots/logs**: If applicable

**Template** 📋:
```
### 🐛 Bug Report

**What happened?** 😱
[Describe the bug]

**What should have happened?** 🤔
[Describe expected behavior]

**Steps to reproduce** 🔄
1. Do this
2. Then this
3. Watch it explode 💥

**Environment** 💻
- macOS version:
- Swift version:
- Python version:
```

---

## 💡 Suggesting Features

Got a brilliant idea? 🧠💡 We love those!

Open an issue with the `enhancement` label and tell us:
- 🎯 **What** the feature does
- 🤔 **Why** it's useful *(convince us!)*
- 🎨 **How** you envision it working
- 🌶️ **Bonus**: How sassy should TalkBack be about it?

---

## 📏 Code Style Guide

### Swift 🦅
- Follow standard Swift conventions 📐
- Use descriptive variable names *(no `x`, `temp`, or `asdf` please)* 🙄
- Keep functions focused and reasonably sized
- Add comments only when the code isn't self-explanatory

### Python 🐍
- Follow PEP 8 *(the Python style bible)* 📖
- Use type hints where possible 🏷️
- Docstrings for public functions 📝
- Keep it clean, keep it readable ✨

### General 🌐
- 🚫 No hardcoded API keys *(seriously, we cannot stress this enough)*
- 🧹 Clean up after yourself — no debug prints in production
- 📝 Update docs when you change things
- 🎨 Consistency > cleverness

---

## 🚫 What NOT to Do

Please don't 🙏:
- ❌ Commit API keys or secrets *(instant roast from TalkBack AND the maintainers)* 🔥
- ❌ Push directly to `main` 🚨
- ❌ Submit massive PRs with unrelated changes 😵‍💫
- ❌ Remove the sass from TalkBack *(that's literally the whole point)* 💅
- ❌ Make TalkBack nice *(we tried. it refused.)* 😈
- ❌ Use destructive git commands without asking first 💣

---

## 🏷️ Labels We Use

| Label | Meaning |
|---|---|
| 🐛 `bug` | Something's broken *(surprise feature!)* |
| ✨ `enhancement` | New feature request |
| 📝 `documentation` | Docs need love |
| 🆘 `help wanted` | We need your big brain |
| 🟢 `good first issue` | Perfect for newcomers! |
| 🔥 `priority: high` | Fix this ASAP |
| 💅 `sass-approved` | TalkBack approves this change |

---

## 💬 Need Help?

Stuck? Confused? Existential crisis about your code? 🤯

- 💬 Open an issue and ask! No question is too silly *(okay maybe some are, but we'll answer anyway)* 😂
- 🔍 Check existing issues — someone might have had the same problem
- 📖 Read the [README](README.md) — it's actually pretty helpful *(and funny, if we do say so ourselves)* 😏

---

## 🎉 Thank You! 🙏✨

Every contribution makes TalkBack sassier, better, and more chaotic. And that's beautiful. 🥲💖

Whether you're fixing a typo, adding a feature, or just giving us a star ⭐ — you're awesome and TalkBack appreciates you.

*(It won't SAY it appreciates you, but deep down... maybe.)* 😏💅

---

**Now go forth and code!** 🚀💻🔥

*May your builds compile and your tests pass on the first try.* 🍀✨
*(They won't, but it's nice to dream.)* 😂
