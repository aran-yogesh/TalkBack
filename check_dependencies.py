#!/usr/bin/env python3
"""Check all TalkBack project dependencies and report their status."""

import importlib
import json
import os
import shutil
import subprocess
import sys


BOLD = "\033[1m"
GREEN = "\033[92m"
RED = "\033[91m"
YELLOW = "\033[93m"
CYAN = "\033[96m"
RESET = "\033[0m"
CHECK = f"{GREEN}\u2713{RESET}"
CROSS = f"{RED}\u2717{RESET}"
WARN = f"{YELLOW}!{RESET}"


def section(title):
    print(f"\n{BOLD}{CYAN}{'=' * 50}{RESET}")
    print(f"{BOLD}{CYAN}  {title}{RESET}")
    print(f"{BOLD}{CYAN}{'=' * 50}{RESET}")


def check_python_package(package_name, import_name=None):
    """Return True if a Python package is importable."""
    name = import_name or package_name
    try:
        importlib.import_module(name)
        return True
    except ImportError:
        return False


def check_command(cmd):
    """Return True if a command-line tool is available on PATH."""
    return shutil.which(cmd) is not None


def get_command_version(cmd, flag="--version"):
    """Return version string for a command, or None on failure."""
    try:
        result = subprocess.run(
            [cmd, flag],
            capture_output=True,
            text=True,
            timeout=10,
        )
        output = (result.stdout.strip() or result.stderr.strip())
        return output.splitlines()[0] if output else None
    except Exception:
        return None


def check_node_modules():
    """Return (installed_count, missing list) for package.json dependencies."""
    pkg_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "package.json")
    if not os.path.exists(pkg_path):
        return None, None, None

    with open(pkg_path, "r") as f:
        data = json.load(f)

    deps = list(data.get("dependencies", {}).keys())
    dev_deps = list(data.get("devDependencies", {}).keys())
    all_deps = deps + dev_deps

    node_modules = os.path.join(os.path.dirname(pkg_path), "node_modules")
    if not os.path.isdir(node_modules):
        return all_deps, [], all_deps

    installed = []
    missing = []
    for dep in all_deps:
        dep_dir = os.path.join(node_modules, dep)
        if os.path.isdir(dep_dir):
            installed.append(dep)
        else:
            missing.append(dep)

    return all_deps, installed, missing


def check_api_key_env(name):
    """Return True if the environment variable is set and non-empty."""
    val = os.environ.get(name, "")
    return bool(val and val not in ("YOUR_OPENAI_API_KEY_HERE", "YOUR_ELEVENLABS_API_KEY_HERE", "YOUR_GEMINI_API_KEY_HERE"))


def check_config_swift():
    """Return True if config.swift exists (API keys file)."""
    base = os.path.dirname(os.path.abspath(__file__))
    return os.path.exists(os.path.join(base, "config.swift"))


def main():
    installed_count = 0
    missing_count = 0
    warning_count = 0

    def mark_installed(name, detail=""):
        nonlocal installed_count
        installed_count += 1
        extra = f"  ({detail})" if detail else ""
        print(f"  {CHECK}  {name}{extra}")

    def mark_missing(name, detail=""):
        nonlocal missing_count
        missing_count += 1
        extra = f"  ({detail})" if detail else ""
        print(f"  {CROSS}  {name}{extra}")

    def mark_warning(name, detail=""):
        nonlocal warning_count
        warning_count += 1
        extra = f"  ({detail})" if detail else ""
        print(f"  {WARN}  {name}{extra}")

    print(f"\n{BOLD}🤖 TalkBack Dependency Checker{RESET}")
    print(f"Checking all dependencies for the TalkBack project...\n")

    section("Python Environment")
    py_version = get_command_version("python3")
    if check_command("python3"):
        mark_installed("python3", py_version or "found")
    else:
        mark_missing("python3", "required to run monitoring scripts")

    pip_version = get_command_version("pip3")
    if check_command("pip3"):
        mark_installed("pip3", pip_version or "found")
    else:
        mark_missing("pip3", "required to install Python packages")

    section("Python Packages")
    python_deps = [
        ("mcp", "mcp", "MCP server SDK — pip install mcp"),
        ("watchdog", "watchdog", "file system monitoring — pip install watchdog"),
    ]
    for pkg_name, import_name, description in python_deps:
        if check_python_package(pkg_name, import_name):
            mark_installed(pkg_name, description.split("—")[0].strip())
        else:
            mark_missing(pkg_name, description)

    section("Python Standard Library (used by project)")
    stdlib_modules = ["asyncio", "json", "os", "subprocess", "sys", "time", "re", "pathlib"]
    for mod in stdlib_modules:
        if check_python_package(mod):
            mark_installed(mod, "standard library")
        else:
            mark_missing(mod, "standard library — unexpected failure")

    section("Swift / macOS Toolchain")
    swift_version = get_command_version("swift")
    if check_command("swift"):
        mark_installed("swift", swift_version or "found")
    else:
        mark_missing("swift", "required to compile TalkBack — install Xcode Command Line Tools")

    swiftc_version = get_command_version("swiftc")
    if check_command("swiftc"):
        mark_installed("swiftc", swiftc_version or "found")
    else:
        mark_missing("swiftc", "Swift compiler — install Xcode Command Line Tools")

    swift_frameworks = ["Cocoa", "AppKit", "Foundation", "AVFoundation", "ApplicationServices"]
    print(f"\n  {BOLD}macOS Frameworks (compile-time):{RESET}")
    for fw in swift_frameworks:
        print(f"    - {fw}  (checked at compile time, macOS only)")

    section("System Tools")
    tools = [
        ("git", "version control"),
        ("bash", "shell scripts"),
    ]
    for tool, description in tools:
        ver = get_command_version(tool)
        if check_command(tool):
            mark_installed(tool, ver or description)
        else:
            mark_missing(tool, description)

    section("Node.js / npm (for package.json dependencies)")
    node_ver = get_command_version("node")
    if check_command("node"):
        mark_installed("node", node_ver or "found")
    else:
        mark_missing("node", "required for JS/TS dependencies — install from https://nodejs.org")

    npm_ver = get_command_version("npm")
    if check_command("npm"):
        mark_installed("npm", npm_ver or "found")
    else:
        mark_missing("npm", "Node package manager")

    yarn_ver = get_command_version("yarn")
    if check_command("yarn"):
        mark_installed("yarn", yarn_ver or "found")
    else:
        mark_warning("yarn", "optional — used for some workflows")

    all_deps, node_installed, node_missing = check_node_modules()
    if all_deps is None:
        print(f"\n  {WARN}  package.json not found — skipping npm dependency check")
    else:
        total = len(all_deps)
        inst = len(node_installed) if node_installed else 0
        miss = len(node_missing) if node_missing else 0
        print(f"\n  {BOLD}npm packages:{RESET} {inst}/{total} installed, {miss} missing")
        if miss > 0 and miss <= 20:
            for dep in node_missing:
                mark_missing(dep, "npm package")
        elif miss > 20:
            print(f"  {CROSS}  {miss} npm packages missing — run: npm install")
            missing_count += 1
        if inst == total:
            print(f"  {CHECK}  All {total} npm packages installed")
            installed_count += 1

    section("API Keys & Configuration")
    if check_config_swift():
        mark_installed("config.swift", "API keys configuration file exists")
    else:
        mark_warning("config.swift", "not found — copy config.swift.template to config.swift and add your keys")

    api_keys = [
        ("OPENAI_API_KEY", "OpenAI GPT-4o — https://platform.openai.com/account/api-keys"),
        ("ELEVENLABS_API_KEY", "ElevenLabs TTS/STT — https://elevenlabs.io/"),
        ("GEMINI_API_KEY", "Google Gemini Vision — https://aistudio.google.com/app/apikey"),
    ]
    print(f"\n  {BOLD}Environment variables (optional, keys can also be in config.swift):{RESET}")
    for key, description in api_keys:
        if check_api_key_env(key):
            mark_installed(key, "set in environment")
        else:
            mark_warning(key, f"not set — {description}")

    section("Project Files")
    base = os.path.dirname(os.path.abspath(__file__))
    required_files = [
        "ConversationalTalkBack.swift",
        "cursor_mcp_server.py",
        "cursor_code_monitor.py",
        "test_mcp_connection.py",
        "start_talkback_mcp.sh",
        "start_integration.sh",
        "config.swift.template",
        "package.json",
        "README.md",
    ]
    for fname in required_files:
        fpath = os.path.join(base, fname)
        if os.path.exists(fpath):
            mark_installed(fname, "present")
        else:
            mark_missing(fname, "project file missing")

    section("Summary")
    print(f"  {GREEN}{BOLD}Installed:{RESET}  {installed_count}")
    print(f"  {RED}{BOLD}Missing:{RESET}    {missing_count}")
    print(f"  {YELLOW}{BOLD}Warnings:{RESET}   {warning_count}")
    print()

    if missing_count == 0:
        print(f"  {GREEN}{BOLD}🎉 All required dependencies are installed!{RESET}")
    else:
        print(f"  {RED}{BOLD}⚠️  Some dependencies are missing. Install them to use all features.{RESET}")
        print()
        print(f"  {BOLD}Quick fixes:{RESET}")
        print(f"    Python packages:  pip3 install mcp watchdog")
        print(f"    Node packages:    npm install")
        print(f"    Swift toolchain:  xcode-select --install")
        print(f"    API keys:         cp config.swift.template config.swift")
    print()

    return 1 if missing_count > 0 else 0


if __name__ == "__main__":
    sys.exit(main())
