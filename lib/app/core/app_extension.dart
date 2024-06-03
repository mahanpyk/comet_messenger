import 'dart:typed_data';

extension IntegerList on Uint8List {
  String toHex() {
    return map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
  }
}

extension StringExtensions on String {

  Uint8List toAscii() => Uint8List.fromList(codeUnits);

  Uint8List toUInt8List() {
    if (length % 2 != 0) {
      throw 'Odd number of hex digits';
    }
    var l = length ~/ 2;
    var result = Uint8List(l);
    for (var i = 0; i < l; ++i) {
      var x = int.parse(substring(2 * i, 2 * (i + 1)), radix: 16);
      if (x.isNaN) {
        throw 'Expected hex string';
      }
      result[i] = x;
    }
    return result;
  }
}