/**
 *  byte_helper.dart
 */

import 'package:dart_ssss/src/utils/byte_helper.dart';
import 'package:test/test.dart';

void main() {

  group('Byte Checking', () {

    test('Should return the proper booleans for byte checking', () {
      expect(ByteHelper.isByte(0), isTrue);
      expect(ByteHelper.isNotByte(0), isFalse);

      expect(ByteHelper.isByte(-1), isFalse);
      expect(ByteHelper.isNotByte(-1), isTrue);
    });


    test('Should return the proper boolean values for byte checking on a list',
    () {

      List<int> bytes = [1, 2, 3, 4, 5];
      List<int> notBytes = [-1, 5, -1, 256];

      expect(ByteHelper.isListAllBytes(bytes), isTrue);
      expect(ByteHelper.isListAllBytes(notBytes), isFalse);

    });


  });

}