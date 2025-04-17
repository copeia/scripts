import re
import os

prefix_list = ['1080p', '2160p', '720p']

def clean_name(name):
    name_part, ext = os.path.splitext(name)

    # Get names and remove prefix and all text following if the name does not start with said prefix.
    for prefix in prefix_list:
        if not name_part.startswith(prefix):
            name_part = re.sub(rf'{prefix}.*', '', name_part)

    # Replace these characters with hyphons
    replacements = {'_': '-', '.': '-', ' ': '-'}

    for old, new in replacements.items():
        name_part = name_part.lower().replace(old, new)
        
    # Remove any trailing hyphons
    name_part = re.sub(r'[^a-z0-9\-]', '', name_part).rstrip('-')
    return name_part + ext

