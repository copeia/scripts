import unittest
import os
import tempfile
from file_ops import list_rename_and_cleanup, is_rar_file, remove_rar_files


class TestFileOps(unittest.TestCase):
    def setUp(self):
        self.test_dir = tempfile.TemporaryDirectory()
        self.base_path = self.test_dir.name
        # Create test files
        self.test_files = {
            "keep_me.mp4": b"regular content",
            "delete_me.txt": b"to be deleted",
            "delete_me.jpeg": b"also delete",
            "movie.1080p.mkv": b"rename test",
        }
        for name, content in self.test_files.items():
            with open(os.path.join(self.base_path, name), "wb") as f:
                f.write(content)

        # Create RAR file
        self.rar_file_path = os.path.join(self.base_path, "archive_no_ext")
        with open(self.rar_file_path, "wb") as f:
            f.write(b"Rar!\x1a\x07\x00extra")

    def tearDown(self):
        self.test_dir.cleanup()

    def test_list_rename_and_cleanup(self):
        renamed, deleted = list_rename_and_cleanup(self.base_path, dry_run=False)
        deleted_files = [os.path.basename(f) for f in deleted]
        self.assertIn("delete_me.txt", deleted_files)
        self.assertIn("delete_me.jpeg", deleted_files)

        renamed_files = [os.path.basename(a) for _, a in renamed]
        self.assertIn("movie.mkv", renamed_files)

    def test_is_rar_file(self):
        self.assertTrue(is_rar_file(self.rar_file_path))

    def test_remove_rar_files(self):
        removed = remove_rar_files(self.base_path, dry_run=False)
        self.assertIn(self.rar_file_path, removed)
        self.assertFalse(os.path.exists(self.rar_file_path))


if __name__ == "__main__":
    unittest.main()
