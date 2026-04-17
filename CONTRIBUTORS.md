# Contributors

Thanks to everyone who has contributed to TalkBack! 🎉

## Core Team

- **Yogesh Mahendran** ([@aran-yogesh](https://github.com/aran-yogesh)) — Creator & Lead Developer

## Contributors

<!-- Add new contributors in alphabetical order by GitHub handle. -->

- [@aran-yogesh](https://github.com/aran-yogesh)

## How to Become a Contributor

We welcome contributions of all kinds — bug fixes, new features, documentation,
tests, and ideas. To get started:

1. Fork the repository and create a feature branch from `main`.
2. Make your changes, keeping them focused and minimal (see [AGENTS.md](AGENTS.md)).
3. Run the build and any relevant tests to make sure nothing is broken:
   ```bash
   swiftc -o ConversationalTalkBack ConversationalTalkBack.swift \
       -framework Cocoa -framework Foundation -framework AVFoundation \
       -target arm64-apple-macosx13.0
   python3 test_mcp_connection.py
   ```
4. Open a pull request describing what you changed and why.
5. Once your PR is merged, add yourself to the list above in a follow-up PR.

## Recognition

All contributors — whether they submit code, docs, issues, or feedback — are
valued members of the TalkBack community. Thank you for helping make TalkBack
better! 💜
