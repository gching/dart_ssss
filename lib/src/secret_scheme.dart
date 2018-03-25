/**
 * secret_scheme.dart
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
import 'dart:collection';
import 'lagrange_interpolation.dart';
import 'byte_polynomial.dart';
import 'utils/byte_helper.dart';

/**
 * Public facing class that implements the logic for secret sharing,
 * specifically with Shamir's Secret Sharing Scheme over GF(256).
 */
class SecretScheme {
  /**
   * Random generator parameter
   */
  Random _generator;

  /**
   * Indicates the number of parts to generate when splitting a secret.
   */
  int _numOfParts;

  /**
   * Threshold parameter to indicate how many shares are needed to regenerate
   * the secret.
   */
  int _threshold;

  /**
   * Sets the number of parts and the threshold.
   *
   * Important - we instantiate the secure random generator here and it will
   * throw an error if the current device does not support a secure way of
   * generating random values.
   */
  SecretScheme(this._numOfParts, this._threshold) {
    if (_numOfParts < 2 || _numOfParts > 255) {
      throw new ArgumentError('The number of parts cannot ' +
          'be smaller than 2 or greater than 255');
    }

    if (_threshold < 1) {
      throw new ArgumentError('The threshold must be greater than 1');
    }

    if (_threshold > _numOfParts) {
      throw new ArgumentError('The threshold must be equal or smaller than ' +
          'the number of parts');
    }

    _generator = new Random.secure();
  }

  /**
   * The number of parts for the current instance.
   */
  int get numOfParts => _numOfParts;

  /**
   * The threshold for the current instance.
   */
  int get threshold => _threshold;

  /**
   * Given the passed in secret, generates shares according to the instance
   * parameters.
   *
   * The returned value is a mapping of the X values and their corresponding Y
   * values for each byte value in the secret.
   *
   * {
   *  x1 : [y1, y2, y3, y4],
   *  x2 : [y5, y6, y7, y8]
   * }
   *
   * If the number of shares to generate is 2 and the secret is of length 4.
   */
  Map<int, List<int>> createShares(List<int> secret) {
    if (secret == null || secret.length == 0) {
      throw new ArgumentError('Secret needs to have a length greater than 0.');
    }

    // Ensure that all of secret are byte values
    if (!ByteHelper.isListAllBytes(secret)) {
      throw new ArgumentError('Secret needs to contain byte values 0-255.');
    }

    // Valid secret, lets start creating our shares.
    // Let's start generating x values for our shares.
    Map<int, List<int>> shares = new HashMap();

    // Generate random x values, and ensure that we do not collide with another
    // x value and is not zero. The number of x values we generate are according
    // to the number of shares we want to generate.
    List<int> randomXCoords = _generateNonCollidingValuesNotZero(numOfParts);

    // Insert all x coordinates into the shares map.
    for (int x in randomXCoords) {
      shares[x] = new List(secret.length);
    }

    // Now for each byte value in the secret, generate a polynomial
    // and evaluate each x value and insert into their corresponding lists.
    // In addition, the degree for the polynomial is our threshold - 1.
    int degree = threshold - 1;
    for (int i = 0; i < secret.length; i++) {
      int currSecretVal = secret[i];

      // Instantiate the polynomial.
      BytePolynomial currPoly = new BytePolynomial(degree);

      // Generate random coefficients for the polynomial with our
      // currSecretVal to be the constant.
      currPoly.generateCoefficientsDangerously(currSecretVal, _generator);

      // Now iterate each x value, and get the corresponding y value and insert
      // into the list in the map.
      for (int x in randomXCoords) {
        shares[x][i] = currPoly.evaluateAtX(x);
      }
    }

    // We are done, return the map.
    return shares;
  }

  /**
   * Given the shares of x and y coordinates, combine and retrieve the
   * secret.
   *
   * Important thing to note is that we do not know if the results is indeed
   * the original secret. If the shares are malformed or the threshold is not
   * met, the returned values are just gibberish.
   */
  List<int> combineShares(Map<int, List<int>> shares) {
    if (shares == null) {
      throw new ArgumentError('Shares cannot be null.');
    }

    if (shares.isEmpty) {
      throw new ArgumentError('Shares cannot be empty.');
    }

    // Check if x coordinates of the shares are bytes.
    for (int xCoord in shares.keys) {
      if (ByteHelper.isNotByte(xCoord)) {
        throw new ArgumentError('Shares need to contain proper x coordinates.');
      }
    }

    // Check if y coords are bytes.
    // Also save the length of the last y coords
    int lengthOfYCoords = 0;
    for (List<int> yCoords in shares.values) {
      if (yCoords == null || !ByteHelper.isListAllBytes(yCoords)) {
        throw new ArgumentError('Shares need to contain proper y coordiantes.');
      }

      lengthOfYCoords = yCoords.length;
    }

    // Ensure all yCoords have the same length.
    for (List<int> yCoords in shares.values) {
      if (yCoords.length != lengthOfYCoords) {
        throw new ArgumentError(
            'Shares y coordinates need to have the same ' + 'length');
      }
    }

    // Done all the checks, now let's start reconstructing our secret.
    // Generate a list to store the secret, and this is the length
    // of a share, being the length of the y coordinates.
    List<int> secret = new List(lengthOfYCoords);

    for (int i = 0; i < secret.length; i++) {
      // Generate the points needed to lagrange interpolation.
      List<List<int>> pointsForCurrIdx = new List();

      // Go through each share and push the current point.
      for (int x in shares.keys) {
        List<int> currPoint = new List(2);

        // X coord
        currPoint[0] = x;

        // Y coord
        currPoint[1] = shares[x][i];

        pointsForCurrIdx.add(currPoint);
      }

      // Generate the current idx secret val.
      secret[i] = LagrangeInterpolation.getConstantValue(pointsForCurrIdx);
    }

    // Generated secret, return.
    return secret;
  }

  /**
   * Generates `amountToGenerate` distinct random byte values and returning
   * those. However, none of the distinct random byte values can be zero.
   */
  List<int> _generateNonCollidingValuesNotZero(int amountToGenerate) {
    List<int> randomValues = new List(amountToGenerate);

    // Keep generating until we hit the count of 0.
    int randomVal;
    int currIdx = 0;
    while (amountToGenerate > 0) {
      randomVal = ByteHelper.generateRandomByte(_generator);

      // If we already have it, continue and regenerate.
      if (randomValues.contains(randomVal)) {
        continue;
      }

      // If the value is equal to 0, continue and regenerate.
      // TODO - test this.
      if (randomVal == 0) {
        continue;
      }

      randomValues[currIdx] = randomVal;

      amountToGenerate--;
      currIdx++;
    }

    return randomValues;
  }
}
