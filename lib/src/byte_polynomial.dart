/**
 * byte_polynomial.dart
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
import 'gf_256.dart';
import 'utils/byte_helper.dart';

/**
 * Class that holds a polynomial represented by unsigned byte coefficients.
 */
class BytePolynomial {

  // Boolean that indicates if the coefficients have been generated.
  bool _coefficientsGenerated = false;

  // Holds the coefficients of the polynomial where index 0 is f(0) and index
  // index[coefficients.length - 1] is the highest degree coefficient.
  List<int> _coefficients = new List();

  // Holds the degree of the polynomial represented where 0 would mean just
  // a single value.
  int _degree;

  BytePolynomial(this._degree);

  BytePolynomial.fromCoefficients(List<int> coefficients){
    if (coefficients == null || coefficients.length == 0){
      throw new ArgumentError("Coefficients cannot be empty or null");
    }

    // Check to see if the coefficients are byte values.
    if (!_checkIfCoefficientsAreBytes(coefficients)){
      throw new ArgumentError("Coefficients must be represented in bytes");
    }

    // Valid coefficients, let's set the degree and the coefficients
    // Because we allow for coefficients to be zero, we have to
    // iterate through and find the last non-zero coefficient as that
    // represents the highest degree of the polynomial.
    this._degree = _getDegreeFromCoefficients(coefficients);

    // It is generated.
    this._coefficientsGenerated = true;

    // Make a copy of the coefficients.
    this._coefficients = new List.from(coefficients, growable: false);

  }

  // Getter for the degree represented by the polynomial
  int get degree => _degree;

  // Getter for seeing if the coefficients have been generated.
  bool get isGenerated => _coefficientsGenerated;

  // Getter for the element at f(0) of the polynomial (constant).
  int get constantAtZero {
    
    // If the coefficients have not been generated, then return -1.
    // If not, then return f(0) which is at index 0.
    // TODO - Perhaps throw an Exception, but -1 seems more easier to handle.
    return !_coefficientsGenerated ? -1 : _coefficients.first;

  }

  /**
   * Returns a copy of the coefficients of the current instance.
   */
  List<int> get coefficientsList => new List.from(_coefficients);

  /**
   * Assists in generating the coefficients for the current instance.
   * The constant value is the f(0) value to be inserted in.
   * Dangerously as it will override the current instances values and therefore,
   * the previous secret values will be lost.
   * The passed in random will be utilized to generate the values.
   */
  void generateCoefficientsDangerously(int constantVal, Random gen) {

    if (constantVal > 255 || constantVal < 0){
      throw new ArgumentError("The constant value must be byte representable");
    }

    if (gen == null){
      throw new ArgumentError("Gen cannot be null");
    }

    // Initialize our coefficients given the degree where the length is
    // degree + 1;
    _coefficients = new List(_degree + 1);

    // Now we set our constant value to be at index 0 (f(0)).
    _coefficients[0] = constantVal;
    
    // For each other coefficient, generate a random number between 0 - 255
    // given our generator.
    for (int i = 1; i < _coefficients.length; i++){
      _coefficients[i] = _generateRandomByteVal(gen);
    }

    // For the last element however, that coefficient cannot be 0 or else
    // it does not satisfy the secret sharing scheme because it will allow
    // for less shares to generate the polynomial.
    // Keep generating until we get a value that is not zero.
    while (_coefficients.last == 0){
      _coefficients[_coefficients.length - 1] = _generateRandomByteVal(gen);
    }

    // Completed everything. We have generated so set flag to true
    this._coefficientsGenerated = true;

  }

  /**
   * Returns the evaluated Y value given the current polynomal at the provided
   * X coordinate.
   */
  int evaluateAtX(int xCoord){

    if (xCoord > 255 || xCoord < 0){
      throw new ArgumentError("xCoord must be byte representable.");
    }

    // TODO - throw right error.
    if (_coefficientsGenerated == false){
      throw new NotGeneratedException();
    }

    // If x = 0, return constant value.
    if (xCoord == 0){
      return constantAtZero;
    }

    // Utilize Horner's method to evaluate the results.
    // https://www.geeksforgeeks.org/horners-method-polynomial-evaluation/
    int results = 0;
    for (int i = _coefficients.length - 1; i >= 0; i--){
      results = GF256.add(GF256.multiply(results, xCoord), _coefficients[i]);
    }

    // Results is the y value.
    return results;

  }

  /**
   * Returns true or false if the passed in list of coefficients cannot fit
   * in a byte (unsigned).
   */
  bool _checkIfCoefficientsAreBytes(List<int> coefficients) {

    if (coefficients == null || coefficients.length == 0) {
      return false;
    }

    return ByteHelper.isListAllBytes(coefficients);

  }

  /**
   * Returns the highest degree represented by the coefficients.
   * Returns -1 if the coefficients passed in are invalid.
   */
  int _getDegreeFromCoefficients(List<int> coefficients) {

    if (coefficients == null || coefficients.length == 0) {
      return -1;
    }

    if (!_checkIfCoefficientsAreBytes(coefficients)){
      return -1;
    }

    // Iterate through starting from the end + 1, and return the index,
    // which represents the degree of the polynomial.
    for (int i = coefficients.length - 1; i > 0; i--) {

      int currVal = coefficients[i];

      if (currVal > 0){
        return i;
      }

    }

    // All coefficients are 0 but the last, return a degree of 0.
    return 0;

  }

  /**
   * Returns a random value between 0 - 255.
   */
  int _generateRandomByteVal(Random gen){
    if (gen == null){
      throw new ArgumentError("Gen cannot be null");
    }

    return ByteHelper.generateRandomByte(gen);
  }

}

class NotGeneratedException implements Exception {
  String toString() => "NotGeneratedException: '$_s'";
  final String _s = 'The current instance has not been generated.';
}
