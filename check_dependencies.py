#!/usr/bin/env python3
"""Verify that all project dependencies are installed correctly."""

import importlib
import json
import os
import shutil
import subprocess
import sys


def check_command(name):
    """Check if a CLI command is available."""
    path = shutil.which(name)
    if path:
        try:
            result = subprocess.run(
                [name, "--version"], capture_output=True, text=True, timeout=10
            )
            version = result.stdout.strip() or result.stderr.strip()
            return True, version
        except Exception:
            return True, "version unknown"
    return False, None


def check_python_package(package_name, import_name=None):
    """Check if a Python package is importable."""
    mod = import_name or package_name
    try:
        m = importlib.import_module(mod)
        version = getattr(m, "__version__", "installed")
        return True, version
    except ImportError:
        return False, None


def check_node_modules(project_dir):
    """Check if node_modules exists and key packages are installed."""
    node_modules = os.path.join(project_dir, "node_modules")
    if not os.path.isdir(node_modules):
        return False, 0

    package_json_path = os.path.join(project_dir, "package.json")
    with open(package_json_path, "r") as f:
        pkg = json.load(f)

    all_deps = list(pkg.get("dependencies", {}).keys()) + list(
        pkg.get("devDependencies", {}).keys()
    )
    installed = 0
    missing = []
    for dep in all_deps:
        dep_path = os.path.join(node_modules, dep)
        if os.path.isdir(dep_path):
            installed += 1
        else:
            missing.append(dep)

    return installed, len(all_deps), missing


def main():
    project_dir = os.path.dirname(os.path.abspath(__file__))
    all_passed = True

    print("=" * 60)
    print("  TalkBack Dependency Checker")
    print("=" * 60)

    print("\n--- System Tools ---")
    for tool in ["node", "npm", "python3"]:
        ok, version = check_command(tool)
        status = f"OK ({version})" if ok else "MISSING"
        symbol = "✅" if ok else "❌"
        print(f"  {symbol} {tool}: {status}")
        if not ok:
            all_passed = False

    print("\n--- Python Packages ---")
    python_deps = [
        ("mcp", "mcp"),
        ("watchdog", "watchdog"),
    ]
    for pkg_name, import_name in python_deps:
        ok, version = check_python_package(pkg_name, import_name)
        status = f"OK ({version})" if ok else "MISSING"
        symbol = "✅" if ok else "❌"
        print(f"  {symbol} {pkg_name}: {status}")
        if not ok:
            all_passed = False

    print("\n--- Node.js Packages ---")
    installed, total, missing = check_node_modules(project_dir)
    pct = (installed / total * 100) if total else 0
    symbol = "✅" if not missing else "⚠️"
    print(f"  {symbol} {installed}/{total} packages installed ({pct:.0f}%)")
    if missing:
        print(f"  Missing ({len(missing)}):")
        for m in missing[:10]:
            print(f"    - {m}")
        if len(missing) > 10:
            print(f"    ... and {len(missing) - 10} more")
        all_passed = False

    print("\n" + "=" * 60)
    if all_passed:
        print("  ✅ All dependencies are installed!")
    else:
        print("  ⚠️  Some dependencies are missing. See above.")
    print("=" * 60)

    return 0 if all_passed else 1


if __name__ == "__main__":
    sys.exit(main())
