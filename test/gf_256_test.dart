/**
 * GF256Test.dart
 */

import 'package:test/test.dart';
import 'package:dart_ssss/src/gf_256.dart';

void main(){

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