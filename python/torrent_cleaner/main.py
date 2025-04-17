import os
from file_ops import list_rename_and_cleanup, remove_rar_files

if __name__ == "__main__":
    path = input("Enter directory path: ").strip()
    if not os.path.isdir(path):
        print("Invalid path.")
        exit()
    dry = input("Dry run? (y/n): ").strip().lower() == 'y'

    renamed, deleted = list_rename_and_cleanup(path, dry)
    print("\n--- DRY RUN ---" if dry else "\n--- CHANGES MADE ---")
    for b, a in renamed: print(f"{b} -> {a}")
    for d in deleted: print(f"Deleted: {d}")

    if input("\nRemove RAR files? (y/n): ").strip().lower() == 'y':
        rars = remove_rar_files(path, dry)
        for r in rars: print(f"RAR Deleted: {r}")
