import 'dart:convert';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:comet_messenger/app/core/app_extension.dart';
import 'package:pointycastle/export.dart';

class RSAUtil {
  static RSAPublicKey getPublicKey(String pem) {
    final parser = RSAKeyParser();
    return parser._parsePublicKey(base64Decode(pem)) as RSAPublicKey;
  }

  static RSAPrivateKey getPrivateKey(String pem) {
    final parser = RSAKeyParser();
    return parser._parsePrivateKey(base64Decode(pem)) as RSAPrivateKey;
  }

  // static Uint8List encrypt(String data, String publicKeyPem) {
  //   final publicKey = getPublicKey(publicKeyPem);
  //   final encryptor = OAEPEncoding(RSAEngine())
  //     ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
  //   return _processBlocks(encryptor, Uint8List.fromList(data.codeUnits));
  // }

  static (String key, String iv) generateKey(
      {required RSAPrivateKey privateKey}) {
    String key =
        base64Decode("N86+96oqX3zoicuKe+ZhASqfDjQT4LVKwyqAwoyk/3k=").toHex();
    DateTime now = DateTime.now().toUtc();
    var seed = BigInt.parse(
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}');
    Uint8List seedByteArray = Uint8List.fromList([
      ...[0, 0, 0, 0],
      ...seed.toRadixString(16).toUInt8List()
    ]);
    String iv = base64Encode([...seedByteArray, ...seedByteArray]);
    return (key, iv);
  }

  static String decrypt(String data, String privateKeyPem) {
    final privateKey = getPrivateKey(privateKeyPem);
    var (key, iv) = generateKey(privateKey: privateKey);
    var keyBytes = key.toUInt8List();
    var messageBytes = utf8.encode(data);
    var paddedMsg = pad(messageBytes, 16);
    var cipher = AESEngine();
    var params = KeyParameter(keyBytes);
    // var iv = '325230323340642128326E23345F3640';
    var ivBytes = base64Decode(iv);
    var cbcParams = ParametersWithIV(params, ivBytes);
    var cbcCipher = CBCBlockCipher(cipher);
    cbcCipher.init(true, cbcParams);
    var encrypted = _processBlocks(cbcCipher, paddedMsg);
    return base64Encode(encrypted);
  }

  static Uint8List pad(Uint8List src, blockSize) {
    var pad = PKCS7Padding();
    pad.init(null);
    int padLength =
        src.length % blockSize == 0 ? 16 : blockSize - (src.length % blockSize);
    var out = Uint8List(src.length + padLength)..setAll(0, src);
    if (padLength != 0) {
      pad.addPadding(out, src.length);
    }
    return out;
  }

  static Uint8List _processBlocks(BlockCipher cipher, Uint8List inp) {
    var out = Uint8List(inp.lengthInBytes);
    for (var offset = 0; offset < inp.lengthInBytes;) {
      var len = cipher.processBlock(inp, offset, out, offset);
      offset += len;
    }
    return out;
  }
}

class RSAKeyParser {
  RSAAsymmetricKey _parsePublicKey(Uint8List bytes) {
    final asn1Parser = ASN1Parser(bytes);
    final asn1Seq = asn1Parser.nextObject() as ASN1Sequence;
    final modulus = asn1Seq.elements[0] as ASN1Integer;
    final exponent = asn1Seq.elements[1] as ASN1Integer;
    return RSAPublicKey(modulus.valueAsBigInteger, exponent.valueAsBigInteger);
  }

  RSAAsymmetricKey _parsePrivateKey(Uint8List bytes) {
    var asn1Parser = ASN1Parser(bytes);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    var privateKey = topLevelSeq.elements[2];

    asn1Parser = ASN1Parser(privateKey.contentBytes());
    var pkSeq = asn1Parser.nextObject() as ASN1Sequence;

    var modulus = pkSeq.elements[1] as ASN1Integer;
    var privateExponent = pkSeq.elements[3] as ASN1Integer;
    var p = pkSeq.elements[4] as ASN1Integer;
    var q = pkSeq.elements[5] as ASN1Integer;

    RSAPrivateKey rsaPrivateKey = RSAPrivateKey(
      modulus.valueAsBigInteger,
      privateExponent.valueAsBigInteger,
      p.valueAsBigInteger,
      q.valueAsBigInteger,
    );

    return rsaPrivateKey;
  }
}
