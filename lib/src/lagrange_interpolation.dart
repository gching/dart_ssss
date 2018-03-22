/**
 *  lagrange_interpolation.dart
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
  static int getConstantValue(List<List<int>> points){
    if (!_isValidPoints(points)){
      throw new ArgumentError('The provided points needs to be valid.');
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
            lagrangeFunc, GF256.divide(
              GF256.sub(xToFindY, currentInnerX),
              GF256.sub(currentX, currentInnerX)
            )
          );
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
    if (points == null || points.length == 0){
      return false;
    }

    for (int i = 0; i < points.length; i++){
      List<int> currPoint = points[i];

      if (currPoint == null){
        return false;
      }

      if (currPoint.length != 2){
        return false;
      }

      int x = currPoint[0];
      int y = currPoint[1];

      if (ByteHelper.isNotByte(x) || ByteHelper.isNotByte(y)){
        return false;
      }

    }

    return true;
  }

}