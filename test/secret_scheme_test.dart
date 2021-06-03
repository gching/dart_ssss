/**
 * secret_scheme_test.dart
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

import 'dart:collection';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:dart_ssss/src/secret_scheme.dart';
import 'package:dart_ssss/src/utils/byte_random.dart';
import 'shared_mocks.mocks.dart';

void main() {
  group('Instantiation', () {
    test('Should throw if improper values are passed in as arguments', () {
      expect(() => SecretScheme(1, 1), throwsArgumentError);
      expect(() => SecretScheme(256, 1), throwsArgumentError);
      expect(() => SecretScheme(2, 0), throwsArgumentError);
      expect(() => SecretScheme(2, 3), throwsArgumentError);
    });

    test('Should return back the proper values', () {
      SecretScheme ss = SecretScheme(3, 2);
      expect(ss.numOfParts, equals(3));
      expect(ss.threshold, equals(2));
    });
  });

  List<int> secret = [5, 3, 4, 2, 1];
  ByteRandom mockByteRandom = MockByteRandom();
  SecretScheme ss = SecretScheme.withGenerator(3, 2, mockByteRandom);

  List<int> fakeBytes = [0, 1, 2, 3];
  when(mockByteRandom.nextByte()).thenAnswer((_) {
    if (fakeBytes.length == 0) {
      return 5;
    }

    return fakeBytes.removeAt(0);
  });

  Map<int, List<int>> shares = ss.createShares(secret);

  group('Creating shares for secret', () {
    test('Should throw with bad secret', () {
      expect(() => ss.createShares([]), throwsArgumentError);
      expect(() => ss.createShares([256]), throwsArgumentError);
    });

    test('Should have the correct number of shares created', () {
      expect(shares.length, equals(3));
    });

    test('Should have the correct length of values in a share', () {
      for (List<int> share in shares.values) {
        expect(share.length, equals(secret.length));
      }
    });

    test('Should not ever generate a 0 x coordinate share', () {
      expect(shares.containsKey(0), isFalse);
    });
  });

  group('Joining secret', () {
    test('Should throw with bad shares', () {
      Map<int, List<int>> empty = HashMap();
      Map<int, List<int>> badXVal = HashMap();
      Map<int, List<int>> badYVal = HashMap();

      badXVal[256] = [];

      expect(() => ss.combineShares(empty), throwsArgumentError);
      expect(() => ss.combineShares(badXVal), throwsArgumentError);

      // Bad Y values
      badYVal[5] = [-1];
      expect(() => ss.combineShares(badYVal), throwsArgumentError);

      // Not same length.
      badYVal[5] = [5];
      badYVal[6] = [1, 2];
      expect(() => ss.combineShares(badYVal), throwsArgumentError);
    });

    test('Should have retrieved the original secret with all shares', () {
      List<int> retrievedSecret = ss.combineShares(shares);
      expect(secret, equals(retrievedSecret));
    });

    test('Should be able to retrieve the secret if we remove one more share',
        () {
      int lastX = 0;
      for (int x in shares.keys) {
        lastX = x;
      }

      shares.remove(lastX);

      List<int> retrievedSecret = ss.combineShares(shares);
      expect(secret, equals(retrievedSecret));
    });

    test('Should not be able to regenerate if we are below threshold', () {
      int lastX = 0;
      for (int x in shares.keys) {
        lastX = x;
      }

      shares.remove(lastX);

      List<int> retrievedSecret = ss.combineShares(shares);
      expect(secret, isNot(equals(retrievedSecret)));
    });
  });
}
