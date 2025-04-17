import os
import re

# Optional: define a set of known/allowed extensions
KNOWN_EXTENSIONS = {
    ".jpg",
    ".jpeg",
    ".png",
    ".mkv",
    ".mp4",
    ".avi",
    ".mov",
    ".srt",
    ".rar",
    ".txt",
    ".nfo",
    ".zip",
}


def clean_name(name: str, is_dir: bool = False) -> str:
    original_name = name

    if is_dir:
        name_part, ext = name, ""
    else:
        name_part, ext = os.path.splitext(name)
        if ext.lower() not in KNOWN_EXTENSIONS:
            # Treat it all as name if extension is not known
            name_part, ext = name, ""

    # Lowercase
    name_part = name_part.lower()

    # Replace _, ., and spaces with hyphens
    name_part = re.sub(r"[_. ]+", "-", name_part)

    # Replace all other non-alphanum except hyphen with hyphen
    name_part = re.sub(r"[^a-z0-9-]+", "-", name_part)

    # Collapse multiple hyphens
    name_part = re.sub(r"-{2,}", "-", name_part)

    # Remove resolution tags (if not prefix)
    if not name_part.startswith(("1080p", "2160p", "720p")):
        name_part = re.split(r"-(1080p|2160p|720p)\b", name_part)[0]

    # Final cleanup: remove trailing hyphens, periods, whitespace
    name_part = name_part.strip("- .")

    return f"{name_part}{ext.lower()}"
