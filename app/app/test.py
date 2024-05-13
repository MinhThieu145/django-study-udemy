from django.test import SimpleTestCase

from app import calc

class CalcTests(SimpleTestCase):

    def test_add(self):
        self.assertEqual(calc.add(2, 3), 5)

    def test_subtract(self):
        self.assertEqual(calc.subtract(5, 3), 2)

    def test_multiply(self):
        self.assertEqual(calc.multiply(3, 3), 9)

    def test_divide(self):
        self.assertEqual(calc.divide(8, 4), 2)