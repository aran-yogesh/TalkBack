# 🎤💅 Contributing to TalkBack ✨🔥

> *"Oh, you want to contribute? How adorable. Let me tell you how this works, sweetheart."* — TalkBack

First off — THANK YOU for even considering contributing to this beautiful mess! 🥹🎉 Whether you're here to squash bugs 🐛, add features 🚀, or just make TalkBack even sassier 💁‍♀️, you're in the right place.

Let's get you set up before I start judging your code. 😏

---

## 📜 Code of Conduct 🤝

We keep it simple around here:

- 🫶 **Be kind** — We roast *code* here, not people
- 🧠 **Be constructive** — If you're gonna critique, bring solutions
- 🌍 **Be inclusive** — TalkBack speaks multiple languages, and so should our community
- 🚫 **No toxicity** — Save the sass for the AI, not each other
- 🗑️ Violators will be dragged to the menu bar and dropped in the trash can 😈

---

## 🐛 Reporting Bugs 💀

Found a bug? I *probably* did it on purpose. It's called ✨ *personality* ✨

...but if it's actually broken, here's what to do:

1. 🔍 **Search existing issues** first — maybe someone already caught it
2. 📝 **Open a new issue** with:
   - 🏷️ A clear, descriptive title
   - 🔄 Steps to reproduce (be specific!)
   - 🤔 What you *expected* to happen
   - 💥 What *actually* happened
   - 🖥️ Your macOS version and Swift version
   - 📋 Any relevant terminal output or error messages
3. 🏷️ **Label it** `bug` if you can

> *Pro tip: Screenshots and terminal logs make bug reports 10x better* 📸

---

## 💡 Suggesting Features 🚀

Got an idea to make TalkBack even more unhinged? I'm *always* listening 👁️👁️

We love ideas like:
- 🎭 New personality modes or sass levels
- 🎤 Voice and interaction improvements
- 👁️ Vision monitoring features
- 🔥 New roast categories for the MCP monitor
- 🌍 Language support additions
- 🎨 Avatar customization options

Open an issue with the `enhancement` label and tell us your wildest dreams! 💭✨

---

## 🔀 Submitting Pull Requests 🛠️

Ready to write some code? Here's the game plan:

### Step 1: Fork & Clone 🍴
```bash
git clone https://github.com/YOUR_USERNAME/TalkBack.git
cd TalkBack
```

### Step 2: Branch Out 🌿
```bash
git checkout -b feat/your-amazing-feature
```

Branch naming prefixes:
- `feat/` — New features ✨
- `fix/` — Bug fixes 🐛
- `docs/` — Documentation updates 📝
- `chore/` — Maintenance stuff 🧹

### Step 3: Do Your Thing 💻
Write your code! Make it clean, make it work, make it ✨ *sparkle* ✨

### Step 4: Test It 🧪
```bash
python3 -m pytest tests/ -v
```
Make sure nothing's broken. TalkBack breaks enough things on her own. 😅

### Step 5: Commit with Style 💅
```bash
git commit -m "feat: add even more sass to responses 🔥"
```

Keep commits concise and descriptive. Conventional commits preferred:
- `feat:` — New feature
- `fix:` — Bug fix
- `docs:` — Documentation only
- `chore:` — Maintenance
- `test:` — Adding/updating tests

### Step 6: Push & PR 🚀
```bash
git push origin feat/your-amazing-feature
```

Then open a Pull Request with:
- ✅ A clear description of what you changed and *why*
- 🧪 How you tested it
- 📸 Screenshots if it's visual

### PR Checklist ✅
- [ ] 🧪 Tests pass
- [ ] 📝 Docs updated (if needed)
- [ ] 🎨 Code follows existing style
- [ ] 🔑 No API keys or secrets committed (seriously, don't 🙅‍♀️)

---

## 🏗️ Development Setup 🔧

### Prerequisites
- 🍎 **macOS 13.0+** (developed on macOS 26.0.1 beta)
- 🦅 **Swift 6.2** with Xcode Command Line Tools
- 🐍 **Python 3** (for MCP tools and tests)
- 🔑 API keys — see [API_KEY_SETUP.md](API_KEY_SETUP.md) for details

### Quick Setup
```bash
cp config.swift.template config.swift
# Add your API keys to config.swift (and DON'T commit it! 🙅‍♀️)
```

### Build & Run
```bash
swiftc -o ConversationalTalkBack ConversationalTalkBack.swift \
  -framework Cocoa -framework Foundation -framework AVFoundation \
  -target arm64-apple-macosx13.0

./ConversationalTalkBack
```

Check out [QUICK_START.md](QUICK_START.md) and [MCP_SETUP.md](MCP_SETUP.md) for more details! 📚

---

## 🎨 Code Style Guidelines 💅

Keep it clean, keep it readable, keep it *sassy*:

- 🦅 **Swift**: Follow standard Swift conventions. Descriptive names, proper access control
- 🐍 **Python**: PEP 8 vibes. Clean imports, docstrings where helpful
- 📝 **Comments**: Only when the code isn't self-explanatory. `x` is not a variable name, it's a cry for help 😭
- 🏗️ **Structure**: Match the existing patterns in the codebase
- 🔑 **Secrets**: NEVER hardcode API keys. Use `config.swift` (it's gitignored for a reason!) 🔒

---

## 🧪 Testing Guidelines 🔬

We have tests! Use them! Love them!

```bash
python3 -m pytest tests/ -v
```

Test files:
- 🧪 `tests/test_code_monitor.py` — Code monitor tests
- 🔌 `tests/test_mcp_server.py` — MCP server tests
- 📄 `tests/test_yaml_utils.py` — YAML utility tests

When adding new features:
- ✅ Add tests for new functionality
- 🔄 Make sure existing tests still pass
- 🎯 Aim for clear, focused test cases

---

## 🎉 Thank You! 🥳

Seriously, you're awesome for contributing! 🫶 Every bug fix, feature, and docs improvement makes TalkBack sassier and better.

> *"I guess you're not completely useless after all. Welcome to the team, darling."* 💅✨ — TalkBack

Now go write some code before I start roasting your commit history 🔥💀

---

<p align="center">
  <b>Made with 💻, ☕, and an unreasonable amount of sass</b><br>
  <i>TalkBack: She didn't ask for contributors, but she's glad you're here.</i> 😏🤖
</p>
