/**
 * byte_helper_test.dart
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

import 'package:dart_ssss/src/utils/byte_helper.dart';
import 'package:test/test.dart';

void main() {
  group('Byte Checking', () {
    test('Should return the proper booleans for byte checking', () {
      expect(ByteHelper.isByte(0), isTrue);
      expect(ByteHelper.isNotByte(0), isFalse);

      expect(ByteHelper.isByte(-1), isFalse);
      expect(ByteHelper.isNotByte(-1), isTrue);
    });

    test('Should return the proper boolean values for byte checking on a list',
        () {
      List<int> bytes = [1, 2, 3, 4, 5];
      List<int> notBytes = [-1, 5, -1, 256];

      expect(ByteHelper.isListAllBytes(bytes), isTrue);
      expect(ByteHelper.isListAllBytes(notBytes), isFalse);
    });
  });

  group('Random generation', () {
    test('Should throw if generator is null', () {
      expect(() => ByteHelper.generateRandomByte(null), throwsArgumentError);
    });
  });
}
