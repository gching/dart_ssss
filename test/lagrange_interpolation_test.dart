/**
 * lagrange_interpolation_test.dart
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
import 'package:dart_ssss/src/lagrange_interpolation.dart';

void main() {
  group('Calculate constant from points', () {
    test('Should through if points are bad', () {
      List<List<int>> badPointNotBytes = [
        [-1, -1]
      ];

      expect(() => LagrangeInterpolation.getConstantValue(badPointNotBytes),
          throwsArgumentError);
    });

    test('Should return the proper results for the constant value', () {
      List<List<int>> pointsOne = [
        [1, 1],
        [2, 2],
        [3, 3]
      ];
      List<List<int>> pointsTwo = [
        [1, 80],
        [2, 90],
        [3, 20]
      ];
      List<List<int>> pointsThree = [
        [1, 43],
        [2, 22],
        [3, 86]
      ];

      expect(LagrangeInterpolation.getConstantValue(pointsOne), equals(0));
      expect(LagrangeInterpolation.getConstantValue(pointsTwo), equals(30));
      expect(LagrangeInterpolation.getConstantValue(pointsThree), equals(107));
    });
  });
}
