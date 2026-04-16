# 🤝 Contributing to TalkBack 🗣️💥

> _"So you want to contribute? Bold move. I respect that."_ — TalkBack 💅

First off — **THANK YOU** for even considering contributing! 🎉🥳🫶 Whether you're fixing a typo or adding a whole new feature, you're officially part of the chaos now. Welcome aboard! 🚀🎪

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

```bash
git clone https://github.com/YOUR_USERNAME/TalkBack.git
cd TalkBack
```

### 3. Create a Branch 🌿

```bash
git checkout -b feat/your-awesome-feature
```

Name it something descriptive. `fix-stuff` is not descriptive. We believe in you. 💪

### 4. Set Up the Project ⚙️

```bash
cp config.swift.template config.swift
# Add your API keys to config.swift (don't commit them! 🚫🔑)
```

### 5. Make Your Changes 🔨

Go wild (but like, responsibly wild 🦁).

### 6. Test Your Changes 🧪

```bash
# Run the Python tests
python3 -m pytest tests/ -v

# If you touched Swift code, compile and test
swiftc -o ConversationalTalkBack ConversationalTalkBack.swift \
  -framework Cocoa -framework Foundation -framework AVFoundation \
  -target arm64-apple-macosx13.0
```

### 7. Push & Open a PR 🚀

```bash
git add .
git commit -m "feat: add something awesome"
git push origin feat/your-awesome-feature
```

Then open a Pull Request! 🎉

---

## 🐛 Reporting Bugs — Found a Bug? Squash It! 🪲🔨

Found something broken? We're not surprised (just kidding... mostly 😅).

### How to Report 📋

1. 🔍 **Search existing issues** first — maybe someone already found it
2. 📝 **Open a new issue** with:
   - 🏷️ A clear, descriptive title
   - 📖 Steps to reproduce (be specific — we can't read minds... yet 🔮)
   - ✅ Expected behavior
   - ❌ Actual behavior
   - 💻 Your environment (macOS version, Swift version, etc.)
   - 📸 Screenshots if applicable (we love pictures 🖼️)

### Bug Report Template 🐛

```
**Description**: What happened?
**Steps to Reproduce**: 1. ... 2. ... 3. ... 💥
**Expected**: What should have happened
**Actual**: What actually happened (the betrayal 🗡️)
**Environment**: macOS XX, Swift X.X
**Screenshots**: (if applicable)
```

---

## 💡 Suggesting Features — Got Ideas? Spill the Tea! 🍵

We LOVE new ideas! The weirder, the better. 🤪

### How to Suggest 📋

1. 🔍 Check if someone already suggested it
2. 📝 Open an issue with the `enhancement` label
3. Include:
   - 🎯 **What** you want
   - 🤔 **Why** it would be awesome
   - 💭 **How** you imagine it working
   - 🎨 Mockups/sketches if you're feeling fancy

### Feature Ideas We'd Love 🌟

- 🎭 New personality modes (nice mode? chaotic evil mode? 😈)
- 🌍 More language support
- 🎵 Custom voice packs
- 🖥️ New IDE integrations
- 🤖 More roast templates (the people demand sass! 💅)

---

## 🔀 Pull Requests — Show Us What You Got 💪🔥

### PR Checklist ✅

Before submitting, make sure:

- [ ] 🌿 Your branch is up to date with `main`
- [ ] 🧪 Tests pass (don't break things, please 🙏)
- [ ] 📝 You've updated docs if needed
- [ ] 🎨 Code follows the project style
- [ ] 💬 PR description explains **what** and **why**
- [ ] 🔑 No API keys or secrets committed (seriously, we will find you 🕵️)

### PR Title Format 🏷️

```
<type>: <short description>
```

Types:
- `feat` ✨ — New feature
- `fix` 🐛 — Bug fix
- `docs` 📝 — Documentation
- `style` 🎨 — Formatting, no code change
- `refactor` ♻️ — Code restructuring
- `test` 🧪 — Adding tests
- `chore` 🔧 — Maintenance

### Example PRs 📋

- ✅ `feat: add custom voice selection for avatar`
- ✅ `fix: resolve crash when microphone permission denied`
- ✅ `docs: add MCP setup troubleshooting guide`
- ❌ `fixed stuff` (no. just... no. 😤)
- ❌ `update` (update WHAT?! 🤯)

---

## 🎨 Code Style — Keep It Clean, Keep It Sassy 🧹💅

### Swift 🦅
- Follow standard Swift conventions
- Use descriptive variable names (not `x`, `temp`, or `asdf` 😑)
- Keep functions focused and small
- Comment complex logic (but don't over-comment — the code should speak for itself 🗣️)

### Python 🐍
- Follow PEP 8 (your linter is your friend 🤝)
- Use type hints where possible
- Docstrings for public functions
- Keep it readable — future you will thank present you 🙏

### General Rules 📏
- 🚫 No hardcoded API keys (we cannot stress this enough 😤🔑)
- ✅ Use meaningful commit messages
- 🧹 Clean up debug prints before submitting
- 📁 Put files in the right place

---

## 🧪 Testing — Trust but Verify 🔍

### Running Tests 🏃‍♂️

```bash
# Python tests
python3 -m pytest tests/ -v

# Test MCP connection
python3 test_mcp_connection.py

# Test with intentionally broken code (for roast testing 🔥)
python3 cursor_code_monitor.py run 'python3 broken_code.py'
```

### Writing Tests ✍️

- Add tests for new features (no tests = no merge, sorry not sorry 💅)
- Put test files in the `tests/` directory
- Name them `test_*.py`
- Cover edge cases (TalkBack judges you if you don't 👀)

---

## 📝 Documentation — Words Matter Too! ✍️📖

Good docs = happy contributors = better project = world peace 🌍✌️ (okay maybe not that last one)

- Update `README.md` when you change user-facing behavior
- Add docstrings to new functions
- Keep examples up to date and copy-paste ready
- If you add a new file, update the Project Structure table in README

---

## 🏷️ Commit Messages — Tell Us a Story 📖

### Format

```
<type>: <description>
```

### Examples ✅

- `feat: add Bengali language support 🌍`
- `fix: prevent crash on empty audio input 🐛`
- `docs: update Quick Start with new API setup 📝`
- `test: add unit tests for code monitor 🧪`

### Anti-Examples ❌

- `fix` (fix WHAT 😭)
- `wip` (we're all work in progress, be specific 😤)
- `asdfasdf` (we've all been there, but please don't 🙈)

---

## 🎖️ Recognition — Hall of Fame 🏆✨

All contributors get:
- 🌟 Their name in the contributors list
- 💖 Our eternal gratitude
- 🔥 The satisfaction of making TalkBack even sassier
- 🏅 Bragging rights (use them wisely)

---

## ❓ Questions? — We Got You! 🤗

- 💬 Open an issue with the `question` label
- 🐛 Found a bug? See [Reporting Bugs](#-reporting-bugs--found-a-bug-squash-it-)
- 💡 Have an idea? See [Suggesting Features](#-suggesting-features--got-ideas-spill-the-tea-)

Don't be shy! There are no dumb questions (TalkBack might disagree, but ignore her 😏).

---

<p align="center">
  <b>Now go forth and contribute!</b> 🚀🔥💅
  <br>
  <i>TalkBack is watching... and judging... but mostly cheering you on 📣🎉</i>
</p>
