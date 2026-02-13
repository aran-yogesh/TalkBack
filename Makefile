SWIFTFORMAT_VERSION := 0.59.1
SWIFTFORMAT := ./bin/swiftformat
SWIFT_FILES := $(wildcard *.swift)

OS := $(shell uname -s)
ARCH := $(shell uname -m)

ifeq ($(OS),Darwin)
    SWIFTFORMAT_ZIP := swiftformat.zip
    SWIFTFORMAT_BIN_NAME := swiftformat
else ifeq ($(ARCH),aarch64)
    SWIFTFORMAT_ZIP := swiftformat_linux_aarch64.zip
    SWIFTFORMAT_BIN_NAME := swiftformat_linux_aarch64
else
    SWIFTFORMAT_ZIP := swiftformat_linux.zip
    SWIFTFORMAT_BIN_NAME := swiftformat_linux
endif

SWIFTFORMAT_URL := https://github.com/nicklockwood/SwiftFormat/releases/download/$(SWIFTFORMAT_VERSION)/$(SWIFTFORMAT_ZIP)

.PHONY: install format lint clean help

help:
	@echo "Usage:"
	@echo "  make install   - Install all dependencies (node modules + SwiftFormat)"
	@echo "  make format    - Format Swift source files"
	@echo "  make lint      - Check Swift formatting without modifying files"
	@echo "  make clean     - Remove installed tooling"

install: node_modules $(SWIFTFORMAT)

node_modules: package.json
	yarn install --frozen-lockfile || yarn install
	@touch node_modules

$(SWIFTFORMAT):
	@mkdir -p bin tmp
	@echo "Downloading SwiftFormat $(SWIFTFORMAT_VERSION)..."
	@curl -sL $(SWIFTFORMAT_URL) -o tmp/$(SWIFTFORMAT_ZIP)
	@unzip -o tmp/$(SWIFTFORMAT_ZIP) -d tmp
	@mv tmp/$(SWIFTFORMAT_BIN_NAME) $(SWIFTFORMAT)
	@chmod +x $(SWIFTFORMAT)
	@rm -rf tmp

format: $(SWIFTFORMAT)
	$(SWIFTFORMAT) $(SWIFT_FILES)

lint: $(SWIFTFORMAT)
	$(SWIFTFORMAT) --lint $(SWIFT_FILES)

clean:
	rm -rf bin tmp node_modules
