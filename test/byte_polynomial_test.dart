/**
 * byte_polynomial_test.dart
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
import 'package:mockito/mockito.dart';
import 'package:dart_ssss/src/byte_polynomial.dart';
import 'package:dart_ssss/src/utils/byte_random.dart';

class MockByteRandom extends Mock implements ByteRandom {}

void main() {
  group('Base Constructor', () {
    BytePolynomial _poly = new BytePolynomial(0);

    test('Should have a degree of 0', () {
      expect(_poly.degree, equals(0));
    });

    test('Should not have generated coefficients', () {
      expect(_poly.isGenerated, isFalse);
    });

    test('Should be -1 for the constant', () {
      expect(_poly.constantAtZero, equals(-1));
    });
  });

  group('From Coefficients', () {
    List<int> zeroEles = [];
    List<int> badOneEles = [-1];
    List<int> oneEles = [0];
    List<int> middleEleNotZero = [5, 1, 0];
    List<int> allGood = [6, 1, 1];

    test('Should throw exception if the coefficients are bad', () {
      expect(() => new BytePolynomial.fromCoefficients(zeroEles),
          throwsArgumentError);
      expect(() => new BytePolynomial.fromCoefficients(badOneEles),
          throwsArgumentError);
    });

    test('Should be correct for one element', () {
      BytePolynomial _poly = new BytePolynomial.fromCoefficients(oneEles);

      expect(_poly.degree, equals(0));
      expect(_poly.isGenerated, isTrue);
      expect(_poly.constantAtZero, equals(0));
      expect(_poly.coefficientsList, equals(oneEles));
    });

    test('Should contain the correct polynomial represented by an end 0', () {
      BytePolynomial _poly =
          new BytePolynomial.fromCoefficients(middleEleNotZero);

      expect(_poly.degree, equals(1));
      expect(_poly.constantAtZero, equals(5));
    });

    test('Should be correct degree where last element isnt 0', () {
      BytePolynomial _poly = new BytePolynomial.fromCoefficients(allGood);

      expect(_poly.degree, equals(2));
      expect(_poly.constantAtZero, equals(6));
    });
  });

  group('Generating Coefficients', () {
    BytePolynomial _zeroDegreePoly = new BytePolynomial(0);
    BytePolynomial _oneDegreePoly = new BytePolynomial(1);
    ByteRandom secure = new MockByteRandom();

    test('Should throw an error if the arguements are not byte or null', () {
      expect(() => _zeroDegreePoly.generateCoefficientsDangerously(-1, secure),
          throwsArgumentError);
      expect(() => _zeroDegreePoly.generateCoefficientsDangerously(5, null),
          throwsArgumentError);
    });

    test('Should generate no coefficients if degree is 0', () {
      _zeroDegreePoly.generateCoefficientsDangerously(5, secure);
      expect(_zeroDegreePoly.coefficientsList.length, equals(1));
      expect(_zeroDegreePoly.constantAtZero, equals(5));
      expect(_zeroDegreePoly.isGenerated, isTrue);
      verifyNever(secure.nextByte());
    });

    test('Should generate coefficents if degree is 1', () {
      List<int> randomCoeff = [0, 1];
      when(secure.nextByte()).thenAnswer((_) => randomCoeff.removeAt(0));

      _oneDegreePoly.generateCoefficientsDangerously(5, secure);
      expect(_oneDegreePoly.coefficientsList.length, equals(2));
      expect(_oneDegreePoly.coefficientsList[1], equals(1));
      expect(_oneDegreePoly.constantAtZero, equals(5));
      expect(_oneDegreePoly.isGenerated, isTrue);
      expect(_oneDegreePoly.coefficientsList[1] > 0, isTrue);
      verify(secure.nextByte()).called(2);
    });
  });

  group('Fetching coordinates', () {
    // 3^x3 + 2x^2 + 1
    List<int> _coeff = [1, 0, 2, 3];
    BytePolynomial _poly = new BytePolynomial.fromCoefficients(_coeff);

    test('Should throw given a bad x coordinate', () {
      expect(() => _poly.evaluateAtX(-1), throwsArgumentError);
    });

    test('Should throw given that coefficients have not been generated', () {
      BytePolynomial _badPoly = new BytePolynomial(0);
      expect(() => _badPoly.evaluateAtX(5),
          throwsA(new isInstanceOf<NotGeneratedException>()));
    });

    test('Should return the constant value given x = 0', () {
      expect(_poly.evaluateAtX(0), equals(1));
    });

    test('Should return the proper Y value given x points', () {
      expect(_poly.evaluateAtX(2), equals(17));
    });
  });
}
