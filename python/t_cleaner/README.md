# 🧹 File Cleaner & Renamer Utility

[![Python](https://img.shields.io/badge/python-3.7%2B-blue.svg)](https://www.python.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Tests](https://github.com/copeia/scripts/actions/workflows/t_cleaner.yml/badge.svg)](https://github.com/copeia/scripts/actions)
[![Coverage Status](https://coveralls.io/repos/github/copeia/scripts:python/t_cleaner/badge.svg?branch=master)](https://coveralls.io/github/copeia/scripts:python/t_cleaner?branch=master)

> A command-line tool to recursively clean, rename, and tidy up your files and folders.

# 🧹 File Cleaner & Renamer Utility

A Python utility to recursively clean and rename files and folders in a directory, delete unwanted file types, and optionally remove RAR archive files based on file signature — not just file extension.

---

## ✨ Features

- Convert names to lowercase
- Replace spaces, underscores, and periods with hyphens
- Remove special characters (non-alphanumeric, excluding hyphens)
- Remove trailing hyphens
- Remove certain quality strings (`1080p`, `2160p`, `720p`) and everything after (unless at start)
- Delete unwanted files: `.txt`, `.nfo`, `.png`, `.jpeg`, `.jpg`
- Detect and delete RAR files using **file signature**, not just `.rar` extension
- Interactive prompts
- Dry-run mode to preview changes

---

## 🏁 Getting Started

### 🔧 Requirements

- Python 3.7+

### 📦 Install dependencies (optional)

This project uses only the Python standard library — no external dependencies required.

---

## 🚀 Usage

```bash
python main.py
```

You'll be prompted for:

- The path to the directory you want to process
- Whether to run in dry-run mode
- Whether to remove RAR archive files after all other operations

## 🧪 Running Tests

This project includes unit tests for the cleaner and file operations modules.

✅ Run all tests

```bash
python -m unittest discover -s tests
```

You should see output showing passed or failed tests.

## 🧱 Project Structure

```bash
main.py              # Entry point: handles user input and orchestration
cleaner.py           # String-cleaning and renaming logic
file_ops.py          # File traversal, deletion, and RAR detection
tests/
├── test_cleaner.py  # Tests for name cleaning
└── test_file_ops.py # Tests for file operations and RAR detection
```

## Makefile ✅ What Each Target Does
# make run: 
    Launches your main script.

# make test: 
    Runs all unit tests.

# make coverage: 
    Runs tests with coverage.py, shows a report, and generates HTML output.

# make clean: 
    Deletes Python cache files and coverage data.

## 🔒 Safety

The script is safe to run in dry-run mode (y at the prompt).

No changes will be made to your files unless you confirm.

📜 License

MIT License — free to use, modify, and distribute.