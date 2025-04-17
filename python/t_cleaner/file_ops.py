import os
from cleaner import clean_name


def list_rename_and_cleanup(base_path, dry_run=False):

    renamed_items, deleted_files = [], []
    delete_exts = {".txt", ".nfo", ".png", ".jpeg", ".jpg"}

    for root, dirs, files in os.walk(base_path, topdown=False):

        # Get all files in path
        for filename in files:
            path = os.path.join(root, filename)
            ext = os.path.splitext(filename)[1].lower()

            # Delete files in list delete_exists
            if ext in delete_exts:
                deleted_files.append(path)
                if not dry_run:
                    os.remove(path)
            else:
                # Rename file per cleaner rules
                new_path = os.path.join(root, clean_name(filename))
                if new_path != path:
                    renamed_items.append((path, new_path))
                    if not dry_run:
                        os.rename(path, new_path)

        # Rename dirs as defined by cleaner rules
        for dirname in dirs:
            orig = os.path.join(root, dirname)
            new_path = os.path.join(root, clean_name(dirname))
            if new_path != orig:
                renamed_items.append((orig, new_path))
                if not dry_run:
                    os.rename(orig, new_path)
    return renamed_items, deleted_files


# Verify if any tar files exist
def is_rar_file(file_path):
    try:
        with open(file_path, "rb") as f:
            return f.read(8).startswith(b"Rar!\x1a\x07")
    except:
        return False


# Remove tar files
def remove_rar_files(base_path, dry_run=False):
    deleted = []
    for root, _, files in os.walk(base_path):
        for file in files:
            path = os.path.join(root, file)
            if is_rar_file(path):
                deleted.append(path)
                if not dry_run:
                    os.remove(path)
    return deleted
