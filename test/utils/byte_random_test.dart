/**
 * byte_random_test.dart
 *
 *
 */

import 'package:dart_ssss/src/utils/byte_random.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'dart:math';

import 'byte_random_test.mocks.dart';

@GenerateMocks([Random])

void main() {
  group('Instantiation', () {
    test('Should not throw if using default constructor', () {
      ByteRandom();
      expect(true, isTrue);
    });
  });

  group('Generating random value', () {
    Random mockRandom = MockRandom();
    when(mockRandom.nextInt(256)).thenReturn(0);
    ByteRandom byteRandom = ByteRandom.withGenerator(mockRandom);

    test('Should return the proper value', () {
      expect(byteRandom.nextByte(), equals(0));
      verify(mockRandom.nextInt(256)).called(1);
    });
  });
}
