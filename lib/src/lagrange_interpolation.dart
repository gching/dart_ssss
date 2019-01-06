/**
 * lagrange_interpolation.dart
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

import 'gf_256.dart';
import 'utils/byte_helper.dart';

/**
 * LagrangeInterpolation provides methods in calculating f(0) from a list of
 * points.
 */
class LagrangeInterpolation {
  /**
   * Given a list of tuple values, perform lagrange interpolation and return
   * back the constant value defined at f(0).
   */
  static int getConstantValue(List<List<int>> points) {
    if (!_isValidPoints(points)) {
      throw ArgumentError('The provided points needs to be valid.');
    }

    // Set x to be 0 as we want to find f(0);
    int xToFindY = 0;
    int constantY = 0;

    // Iterate through all the points and perform Lagrange Interpolation.
    for (int i = 0; i < points.length; i++) {
      // Get current x and y
      List<int> currentPoint = points[i];
      int currentX = currentPoint[0];
      int currentY = currentPoint[1];

      // Initialize lagrange function for the current point
      int lagrangeFunc = 1;

      // Iterate through all the points again.
      for (int j = 0; j < points.length; j++) {
        // Get the current x for the inner iteration.
        List<int> currentInnerPoint = points[j];
        int currentInnerX = currentInnerPoint[0];

        // For every point that is not equal to our current outer point,
        // calculate the function given Lagrange.
        if (i != j) {
          lagrangeFunc = GF256.multiply(
              lagrangeFunc,
              GF256.divide(GF256.sub(xToFindY, currentInnerX),
                  GF256.sub(currentX, currentInnerX)));
        }
      }

      // Add it to our y.
      constantY = GF256.add(constantY, GF256.multiply(currentY, lagrangeFunc));
    }

    return constantY;
  }

  /**
   * Helper method to ensure that the points are valid.
   */
  static bool _isValidPoints(List<List<int>> points) {
    if (points == null || points.length == 0) {
      return false;
    }

    for (int i = 0; i < points.length; i++) {
      List<int> currPoint = points[i];

      if (currPoint == null) {
        return false;
      }

      if (currPoint.length != 2) {
        return false;
      }

      int x = currPoint[0];
      int y = currPoint[1];

      if (ByteHelper.isNotByte(x) || ByteHelper.isNotByte(y)) {
        return false;
      }
    }

    return true;
  }
}
