.PHONY: deps format lint build clean

SWIFT_FILES := $(shell find . -name '*.swift' -not -path './.build/*')

deps:
	@if ! command -v swiftformat >/dev/null 2>&1; then \
		echo "Installing swiftformat via Homebrew..."; \
		brew install swiftformat; \
	else \
		echo "swiftformat already installed: $$(swiftformat --version)"; \
	fi

format: deps
	swiftformat $(SWIFT_FILES)

lint: deps
	swiftformat --lint $(SWIFT_FILES)

build:
	swiftc -o ConversationalTalkBack ConversationalTalkBack.swift \
		-framework Cocoa -framework Foundation -framework AVFoundation \
		-target arm64-apple-macosx13.0

clean:
	rm -f ConversationalTalkBack
	rm -rf *.dSYM
