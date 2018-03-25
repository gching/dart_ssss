/**
 * byte_random_test.dart
 *
 *
 */

import 'package:dart_ssss/src/utils/byte_random.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'dart:math';

class MockRandom extends Mock implements Random {}

void main() {
  group('Instantiation', () {
    test('Should not throw if using default constructor', () {
      ByteRandom byteRandom = new ByteRandom();
      expect(true, isTrue);
    });

    test('Should throw error if a null generator is passed in.', () {
      expect(() => new ByteRandom.withGenerator(null), throwsArgumentError);
    });
  });

  group('Generating random value', () {
    Random mockRandom = new MockRandom();
    when(mockRandom.nextInt(256)).thenReturn(0);
    ByteRandom byteRandom = new ByteRandom.withGenerator(mockRandom);

    test('Should return the proper value', () {
      expect(byteRandom.nextByte(), equals(0));
      verify(mockRandom.nextInt(256)).called(1);
    });
  });
}
