import os
import re

def clean_name(name: str, is_dir: bool = False) -> str:
    # Separate name and extension if it's a file
    if not is_dir:
        name_part, ext = os.path.splitext(name)
    else:
        name_part, ext = name, ""

    # Convert to lowercase
    name_part = name_part.lower()

    # Replace underscores, periods, and spaces with hyphens
    name_part = re.sub(r"[_. ]+", "-", name_part)

    # Replace any other non-alphanumeric characters (except hyphen) with hyphen
    name_part = re.sub(r"[^a-z0-9-]+", "-", name_part)

    # Remove resolution tags (1080p, 2160p, 720p) and everything after, unless they are at the start
    if not name_part.startswith(("1080p", "2160p", "720p")):
        name_part = re.split(r"-(1080p|2160p|720p)\b", name_part)[0]

    # Collapse multiple hyphens
    name_part = re.sub(r"-{2,}", "-", name_part)

    # Strip trailing and leading hyphens
    name_part = name_part.strip("-")

    # Reattach extension (lowercased)
    return f"{name_part}{ext.lower()}"
