import unittest
from unittest.mock import patch
import Split

class SinifTestleri:
    def test_in_install_function(self):
        Inputs = [
        '1'
        'www.google.com'
        '3'
        ]
        Outputs = [
        'Your link should be www.example.com'
        'Found the web page'
        '--2019-03-23 17:52:30--  http://www.google.com/'
        ]

        with patch('builtins.input', side_effect=Input):
            stacks = Split
        self.assertEqual(stacks, Outputs)


if __name__ == '__main__':
    unittest.main()
