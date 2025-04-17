import os
import re

def clean_name(name):
    # Separate name and extension
    name_part, ext = os.path.splitext(name)

    # Remove unwanted strings unless they're at the start
    for prefix in ['1080p', '2160p', '720p']:
        if not name_part.startswith(prefix):
            name_part = re.sub(rf'{prefix}.*', '', name_part)

    # Replace characters using mapping
    replacements = {'_': '-', '.': '-', ' ': '-'}
    for old, new in replacements.items():
        name_part = name_part.lower().replace(old, new)

    # Remove non-alphanumeric (except hyphens)
    name_part = re.sub(r'[^a-z0-9\-]', '', name_part)

    # Strip trailing hyphens
    name_part = name_part.rstrip('-')

    return name_part + ext

def list_rename_and_cleanup(base_path, dry_run=False):
    renamed_items = []
    deleted_files = []

    # Extensions to delete
    delete_exts = {'.txt', '.nfo', '.png', '.jpeg', '.jpg'}

    for root, dirs, files in os.walk(base_path, topdown=False):
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

        for dirname in dirs:
            original_path = os.path.join(root, dirname)
            new_name = clean_name(dirname)
            new_path = os.path.join(root, new_name)
            if new_path != original_path:
                renamed_items.append((original_path, new_path))
                if not dry_run:
                    os.rename(original_path, new_path)

    return renamed_items, deleted_files

def is_rar_file(file_path):
    try:
        with open(file_path, 'rb') as f:
            header = f.read(8)
            return header.startswith(b'Rar!\x1a\x07')
    except Exception:
        return False

def remove_rar_files(base_path, dry_run=False):
    deleted_rar_files = []
    for root, dirs, files in os.walk(base_path):
        for filename in files:
            file_path = os.path.join(root, filename)
            if is_rar_file(file_path):
                deleted_rar_files.append(file_path)
                if not dry_run:
                    os.remove(file_path)
    return deleted_rar_files

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

        # Prompt to remove RAR files
        delete_rar_input = input("\nWould you like to remove any RAR archive files? (y/n): ").strip().lower()
        if delete_rar_input == 'y':
            rar_deleted = remove_rar_files(directory_path, dry_run)
            if rar_deleted:
                print("\nRAR archive files to be removed:" if dry_run else "\nRemoved RAR archive files:")
                for file in rar_deleted:
                    print(file)
            else:
                print("\nNo RAR archive files found to remove.")
