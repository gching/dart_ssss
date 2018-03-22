/**
 *  lagrange_interpolation_test.dart
 */

import 'package:test/test.dart';
import 'package:dart_ssss/src/lagrange_interpolation.dart';



void main() {
  group('Calculate constant from points', () {
    test('Should through if points are bad', () {
      List<List<int>> badPointNull = [null];
      List<List<int>> badPointNotVector = [[null]];
      List<List<int>> badPointNotBytes = [[-1, -1]];

      expect(() => LagrangeInterpolation.getConstantValue(null),
          throwsArgumentError);
      expect(() => LagrangeInterpolation.getConstantValue(badPointNull),
        throwsArgumentError);
      expect(() => LagrangeInterpolation.getConstantValue(badPointNotVector),
        throwsArgumentError);
      expect(() => LagrangeInterpolation.getConstantValue(badPointNotBytes),
        throwsArgumentError);
    });

    test('Should return the proper results for the constant value', () {
      List<List<int>> pointsOne = [[1, 1], [2, 2], [3, 3]];
      List<List<int>> pointsTwo = [[1, 80], [2, 90], [3, 20]];
      List<List<int>> pointsThree = [[1, 43], [2, 22], [3, 86]];
      
      expect(LagrangeInterpolation.getConstantValue(pointsOne), equals(0));
      expect(LagrangeInterpolation.getConstantValue(pointsTwo), equals(30));
      expect(LagrangeInterpolation.getConstantValue(pointsThree), equals(107));

    });
  });
}