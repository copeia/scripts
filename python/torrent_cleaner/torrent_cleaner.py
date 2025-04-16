import os
import re

def clean_name(name):
    # Separate name and extension
    name_part, ext = os.path.splitext(name)

    # List of strings to remove if they appear (unless the name starts with them) and everything following
    remove_prefixes = ['1080p', '2160p', '720p']
    
    # Condense the removal logic into a loop
    for prefix in remove_prefixes:
        if not name_part.startswith(prefix):
            name_part = re.sub(rf'{prefix}.*', '', name_part)

    # Define the replacement rules for characters
    replacements = {
        '_': '-',
        '.': '-',
        ' ': '-'
    }

    # Make lower and apply all replacements in a single loop
    for old, new in replacements.items():
        name_part = name_part.lower().replace(old, new)

    # Remove all characters except a-z, 0-9, and hyphens
    name_part = re.sub(r'[^a-z0-9\-]', '', name_part)

    # Remove any trailing hyphens
    name_part = name_part.rstrip('-')

    return name_part + ext  # Keep extension as-is for now

def list_rename_and_cleanup(base_path, dry_run=False):
    renamed_items = []
    deleted_files = []

    # Extensions to delete (lowercase), including .jpg
    delete_exts = {'.txt', '.nfo', '.png', '.jpeg', '.jpg'}

    for root, dirs, files in os.walk(base_path, topdown=False):
        # Handle files
        for filename in files:
            ext = os.path.splitext(filename)[1].lower()
            file_path = os.path.join(root, filename)

            if ext in delete_exts:
                deleted_files.append(file_path)
                if not dry_run:
                    os.remove(file_path)
            else:
                new_name = clean_name(filename)
                new_path = os.path.join(root, new_name)
                if new_path != file_path:
                    renamed_items.append((file_path, new_path))
                    if not dry_run:
                        os.rename(file_path, new_path)

        # Handle directories
        for dirname in dirs:
            original_path = os.path.join(root, dirname)
            new_name = clean_name(dirname)
            new_path = os.path.join(root, new_name)
            if new_path != original_path:
                renamed_items.append((original_path, new_path))
                if not dry_run:
                    os.rename(original_path, new_path)

    return renamed_items, deleted_files

if __name__ == "__main__":
    directory_path = input("Enter the full path to the directory you want to process: ").strip()

    if not os.path.isdir(directory_path):
        print("Invalid directory. Please try again with a valid path.")
    else:
        dry_run_input = input("Would you like to perform a dry run? (y/n): ").strip().lower()
        dry_run = dry_run_input == 'y'

        renamed, deleted = list_rename_and_cleanup(directory_path, dry_run)

        print("\n--- DRY RUN ---" if dry_run else "\n--- CHANGES MADE ---")

        if renamed:
            print("\nRenamed items:")
            for before, after in renamed:
                print(f"{before} -> {after}")
        else:
            print("\nNo files or folders needed renaming.")

        if deleted:
            print("\nFiles to be deleted:" if dry_run else "\nDeleted files:")
            for file in deleted:
                print(file)
        else:
            print("\nNo .txt, .nfo, .png, .jpeg, or .jpg files found to delete.")
