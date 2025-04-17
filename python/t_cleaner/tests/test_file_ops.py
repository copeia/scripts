import unittest
import tempfile
import os
from pathlib import Path
from unittest.mock import patch
from file_ops import list_rename_and_cleanup, remove_rar_files, is_rar_file
from cleaner import clean_name


class TestFileOps(unittest.TestCase):
    def setUp(self):
        self.test_dir = tempfile.TemporaryDirectory()
        self.base_path = Path(self.test_dir.name)

    def tearDown(self):
        self.test_dir.cleanup()

    def test_rename_files_and_dirs(self):
        dirty_file = self.base_path / "Movie@#_1080p.xml"
        dirty_dir = self.base_path / "My Dir"
        dirty_dir.mkdir()
        nested_file = dirty_dir / "Movie@#_1080p.mkv"
        nested_file.write_text("movie content")
        dirty_file.write_text("delete me")

        renamed, deleted = list_rename_and_cleanup(self.base_path, dry_run=False)

        # Check deleted .xml file
        self.assertNotIn(dirty_file.name, os.listdir(self.base_path))
        self.assertIn(str(dirty_file), deleted)

        # Check renamed MKV file and parent dir
        expected_file = (
            self.base_path / clean_name(dirty_dir.name) / clean_name(nested_file.name)
        )
        expected_dir = self.base_path / clean_name(dirty_dir.name)
        self.assertTrue(expected_file.exists())

        # Confirm the rename operations were tracked
        renamed_paths = [Path(p[1]) for p in renamed]
        self.assertIn(expected_dir, renamed_paths)

        # Confirm the file was not directly renamed (only its parent dir was)
        self.assertNotIn(expected_file, renamed_paths)

    def test_dry_run(self):
        file = self.base_path / "keep_file.txt"
        file.write_text("content")
        renamed, deleted = list_rename_and_cleanup(self.base_path, dry_run=True)

        # File should still exist
        self.assertTrue(file.exists())

        # Should still track what would have been deleted
        self.assertIn(str(file), deleted)

    def test_no_action(self):
        file = self.base_path / "movie.mkv"
        file.write_text("content")
        renamed, deleted = list_rename_and_cleanup(self.base_path, dry_run=False)

        # File should remain unchanged
        self.assertTrue(file.exists())
        self.assertEqual(renamed, [])
        self.assertEqual(deleted, [])

    def test_is_rar_file_true(self):
        rar_file = self.base_path / "archive.rar"
        rar_file.write_bytes(b"Rar!\x1a\x07\x00more content")
        self.assertTrue(is_rar_file(rar_file))

    def test_is_rar_file_false(self):
        non_rar = self.base_path / "not_a_rar.rar"
        non_rar.write_text("just text")
        self.assertFalse(is_rar_file(non_rar))

    def test_remove_rar_files(self):
        rar_file = self.base_path / "archive.rar"
        rar_file.write_bytes(b"Rar!\x1a\x07\x00more content")

        deleted = remove_rar_files(self.base_path, dry_run=False)

        self.assertIn(str(rar_file), deleted)
        self.assertFalse(rar_file.exists())

    def test_remove_rar_files_dry_run(self):
        rar_file = self.base_path / "archive.rar"
        rar_file.write_bytes(b"Rar!\x1a\x07\x00more content")

        deleted = remove_rar_files(self.base_path, dry_run=True)

        self.assertIn(str(rar_file), deleted)
        self.assertTrue(rar_file.exists())


if __name__ == "__main__":
    unittest.main()
