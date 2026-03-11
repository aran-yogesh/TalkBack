SWIFTFORMAT_VERSION := 0.59.1
SWIFTFORMAT := ./bin/swiftformat
SWIFT_SOURCES := $(shell find . -name '*.swift' -not -path './.build/*' -not -path './bin/*')
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

ifeq ($(UNAME_S),Linux)
    ifeq ($(UNAME_M),aarch64)
        SWIFTFORMAT_ZIP := swiftformat_linux_aarch64.zip
        SWIFTFORMAT_BIN := swiftformat_linux_aarch64
    else
        SWIFTFORMAT_ZIP := swiftformat_linux.zip
        SWIFTFORMAT_BIN := swiftformat_linux
    endif
    SWIFTFORMAT_URL := https://github.com/nicklockwood/SwiftFormat/releases/download/$(SWIFTFORMAT_VERSION)/$(SWIFTFORMAT_ZIP)
else
    SWIFTFORMAT_ZIP := swiftformat.zip
    SWIFTFORMAT_BIN := swiftformat
    SWIFTFORMAT_URL := https://github.com/nicklockwood/SwiftFormat/releases/download/$(SWIFTFORMAT_VERSION)/$(SWIFTFORMAT_ZIP)
endif

.PHONY: install format lint clean help

help:
	@echo "Usage:"
	@echo "  make install  - Install dependencies (swiftformat + node modules)"
	@echo "  make format   - Format all Swift source files"
	@echo "  make lint     - Check Swift formatting without making changes"
	@echo "  make clean    - Remove installed tools"

install: $(SWIFTFORMAT) .deps-installed

$(SWIFTFORMAT):
	@mkdir -p bin
	@echo "Downloading SwiftFormat $(SWIFTFORMAT_VERSION)..."
	@curl -sL -o /tmp/$(SWIFTFORMAT_ZIP) $(SWIFTFORMAT_URL)
	@unzip -o /tmp/$(SWIFTFORMAT_ZIP) -d bin/ > /dev/null
	@if [ -f bin/$(SWIFTFORMAT_BIN) ] && [ "$(SWIFTFORMAT_BIN)" != "swiftformat" ]; then \
		mv bin/$(SWIFTFORMAT_BIN) bin/swiftformat; \
	fi
	@chmod +x bin/swiftformat
	@rm -f /tmp/$(SWIFTFORMAT_ZIP)
	@echo "SwiftFormat $(SWIFTFORMAT_VERSION) installed to bin/swiftformat"

.deps-installed: package.json
	@echo "Installing Node.js dependencies..."
	@yarn install
	@touch .deps-installed

format: $(SWIFTFORMAT)
	@echo "Formatting Swift files..."
	@$(SWIFTFORMAT) $(SWIFT_SOURCES)
	@echo "Done."

lint: $(SWIFTFORMAT)
	@echo "Checking Swift formatting..."
	@$(SWIFTFORMAT) --lint $(SWIFT_SOURCES)
	@echo "All files formatted correctly."

clean:
	@rm -rf bin/
	@echo "Cleaned up tools."
