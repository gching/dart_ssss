/**
 * byte_helper.dart
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

import 'dart:math';

/**
 * Class that provides methods to help with bytes.
 */
class ByteHelper {
  /**
   * Returns true if all values in the provided list is representable as an
   * unsigned byte value (0-255).
   */
  static bool isListAllBytes(List<int> vals) {
    // If it is null, return false.
    if (vals == null) {
      return false;
    }

    // If any of the values in the list is not a byte, return false.
    if (vals.any(isNotByte)) {
      return false;
    }

    // All values are bytes, return true.
    return true;
  }

  /**
   * Returns true if the val is representable as an unsigned byte value (0-255).
   */
  static bool isByte(int val) {
    return val >= 0 && val <= 255;
  }

  /**
   * Returns true if the val is NOT representable as an unsigned byte value
   * (0-255).
   */
  static bool isNotByte(int val) {
    return !isByte(val);
  }

  /**
   * Returns a random value between 0 - 255.
   */
  static int generateRandomByte(Random generator) {
    if (generator == null) {
      throw new ArgumentError('Generator cannot be null');
    }

    // We set 256 to be the max as it is exclusive
    // https://api.dartlang.org/stable/1.24.3/dart-math/Random/nextInt.html
    return generator.nextInt(256);
  }
}
