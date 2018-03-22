/**
 * GF256Test.dart
 *
 * Copyright 2018 Gavin Ching
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR I
 * MPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import 'package:test/test.dart';
import 'package:dart_ssss/src/gf_256.dart';

void main() {
  group('Adding and Subtracting', () {
    test('Adding two zeroes should return zero', () {
      expect(GF256.add(0, 0), equals(0));
    });

    test('Adding / Subtracting zero and one should return one', () {
      expect(GF256.add(0, 1), equals(1));
      expect(GF256.sub(0, 1), equals(1));
    });

    test('Adding / Subtracting 255 and 255 should return zero', () {
      expect(GF256.add(255, 255), equals(0));
      expect(GF256.sub(255, 255), equals(0));
    });
  });

  group('Multiplication', () {
    test('Multiplying two zeroes should return zero', () {
      expect(GF256.multiply(0, 0), equals(0));
    });

    test('Multiplying one with one should return one', () {
      expect(GF256.multiply(1, 1), equals(1));
    });

    test('Multiplying with multiple operands should return the correct results',
        () {
      expect(GF256.multiply(0xb6, 0x53), equals(0x36));
    });
  });

  group('Division', () {
    test('Dividing should return the correct results', () {
      expect(GF256.divide(90, 21), equals(189));
      expect(GF256.divide(6, 55), equals(151));
      expect(GF256.divide(22, 192), equals(138));
      expect(GF256.divide(0, 192), equals(0));
    });
  });
}
