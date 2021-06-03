/**
 * byte_random.dart
 *
 *
 */

import 'dart:math';

/**
 * Helper class for generating a random byte value from 0 - 255.
 */
class ByteRandom {
  /**
   * Random instance.
   */
  final Random _generator;

  /**
   * Default constructor.
   */
  ByteRandom() : _generator = Random.secure() {}

  /**
   * Constructor for setting the generator.
   */
  ByteRandom.withGenerator(Random _generator) : _generator = _generator {
  }

  /**
   * Returns a random value from 0 - 255.
   */
  int nextByte() {
    // We set 256 to be the max as it is exclusive
    // https://api.dartlang.org/stable/1.24.3/dart-math/Random/nextInt.html
    return _generator.nextInt(256);
  }
}
