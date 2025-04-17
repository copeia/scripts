import os
import re


def clean_name(name: str, is_dir: bool = False) -> str:
    # Handle directories
    if is_dir:
        name_part, ext = name, ""
    else:
        # Temporarily remove extension for processing
        name_part, ext = os.path.splitext(name)

        # If the name has multiple dots (e.g. file.part.one.mkv), re-attach them
        if not ext and "." in name:
            # It's probably not a real extension — treat the whole thing as the name
            name_part, ext = name, ""

    # Lowercase
    name_part = name_part.lower()

    # Replace _, ., and spaces with hyphens
    name_part = re.sub(r"[_. ]+", "-", name_part)

    # Replace non-alphanumeric characters (except hyphen) with hyphen
    name_part = re.sub(r"[^a-z0-9-]+", "-", name_part)

    # Collapse multiple hyphens
    name_part = re.sub(r"-{2,}", "-", name_part)

    # Remove resolution tags and everything after (if not at the start)
    if not name_part.startswith(("1080p", "2160p", "720p")):
        name_part = re.split(r"-(1080p|2160p|720p)\b", name_part)[0]

    # Remove trailing hyphens and periods
    name_part = name_part.rstrip("-.")

    return f"{name_part}{ext.lower()}"
