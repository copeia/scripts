import unittest
from cleaner import clean_name


class TestCleaner(unittest.TestCase):
    def test_basic_cleanup(self):
        self.assertEqual(clean_name("Some File Name.txt"), "some-file-name.txt")

    def test_removes_special_chars(self):
        self.assertEqual(clean_name("Crazy@#Name!$%.jpg"), "crazy-name.jpg")

    def test_replaces_all(self):
        self.assertEqual(clean_name("hello_world.test.name"), "hello-world-test-name")

    def test_removes_quality_and_preserves_ext(self):
        self.assertEqual(clean_name("my.movie.1080p.abc.mp4"), "my-movie.mp4")
        self.assertEqual(clean_name("my.movie.2160p-xyz.mkv"), "my-movie.mkv")
        self.assertEqual(clean_name("my.movie.720p.final.avi"), "my-movie.avi")

    def test_keeps_prefix_quality(self):
        self.assertEqual(clean_name("1080pMovieName.mkv"), "1080pmoviename.mkv")

    def test_trailing_hyphen_removed(self):
        self.assertEqual(clean_name("something.... "), "something")

    def test_full_cleanup(self):
        self.assertEqual(clean_name("Some File Name-1990.$2@_-.mp4"), "some-file-name-1990-2.mp4")
        self.assertEqual(clean_name("Some File Name-1990.$2._.mp4"), "some-file-name-1990-2.mp4")


if __name__ == "__main__":
    unittest.main()
