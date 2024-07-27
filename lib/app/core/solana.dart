import 'dart:convert';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/export.dart';

/*class RSAUtil {
  static const String publicKeyPem = """
  -----BEGIN PUBLIC KEY-----
  MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCgFGVfrY4jQSoZQWWygZ83roKX
  WD4YeT2x2p41dGkPixe73rT2IW04glagN2vgoZoHuOPqa5and6kAmK2ujmCHu6D1
  auJhE2tXP+yLkpSiYMQucDKmCsWMnW9XlC5K7OSL77TXXcfvTvyZcjObEz6LIBRz
  s6+FqpFbUO9SJEfh6wIDAQAB
  -----END PUBLIC KEY-----
  """;

  static const String privateKeyPem = """
  -----BEGIN PRIVATE KEY-----
  MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAKAUZV+tjiNBKhlB
  ZbKBnzeugpdYPhh5PbHanjV0aQ+LF7vetPYhbTiCVqA3a+Chmge44+prlqd3qQCY
  ra6OYIe7oPVq4mETa1c/7IuSlKJgxC5wMqYKxYydb1eULkrs5IvvtNddx+9O/Jly
  M5sTPosgFHOzr4WqkVtQ71IkR+HrAgMBAAECgYAkQLo8kteP0GAyXAcmCAkA2Tql
  /8wASuTX9ITD4lsws/VqDKO64hMUKyBnJGX/91kkypCDNF5oCsdxZSJgV8owViYW
  ZPnbvEcNqLtqgs7nj1UHuX9S5yYIPGN/mHL6OJJ7sosOd6rqdpg6JRRkAKUV+tmN
  /7Gh0+GFXM+ug6mgwQJBAO9/+CWpCAVoGxCA+YsTMb82fTOmGYMkZOAfQsvIV2v6
  DC8eJrSa+c0yCOTa3tirlCkhBfB08f8U2iEPS+Gu3bECQQCrG7O0gYmFL2RX1O+3
  7ovyyHTbst4s4xbLW4jLzbSoimL235lCdIC+fllEEP96wPAiqo6dzmdH8KsGmVoz
  sVRbAkB0ME8AZjp/9Pt8TDXD5LHzo8mlruUdnCBcIo5TMoRG2+3hRe1dHPonNCjg
  bdZCoyqjsWOiPfnQ2Brigvs7J4xhAkBGRiZUKC92x7QKbqXVgN9xYuq7oIanIM0n
  z/wq190uq0dh5Qtow7hshC/dSK3kmIEHe8z++tpoLWvQVgM538apAkBoSNfaTkDZ
  hFavuiVl6L8cWCoDcJBItip8wKQhXwHp0O3HLg10OEd14M58ooNfpgt+8D8/8/2O
  OFaR0HzA+2Dm
  -----END PRIVATE KEY-----
  """;

  static RSAPublicKey getPublicKey(String pem) {
    final parser = RSAKeyParser();
    return parser.parse(pem) as RSAPublicKey;
  }

  static RSAPrivateKey getPrivateKey(String pem) {
    final parser = RSAKeyParser();
    return parser.parse(pem) as RSAPrivateKey;
  }

  static Uint8List encrypt(String data, String publicKeyPem) {
    final publicKey = getPublicKey(publicKeyPem);
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
    return _processInBlocks(encryptor, Uint8List.fromList(data.codeUnits));
  }

  static String decrypt(Uint8List data, String privateKeyPem) {
    final privateKey = getPrivateKey(privateKeyPem);
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    return String.fromCharCodes(_processInBlocks(decryptor, data));
  }

  static Uint8List _processInBlocks(
      AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks =
        (input.length + engine.inputBlockSize - 1) ~/ engine.inputBlockSize;
    final output = BytesBuilder();
    for (var i = 0; i < numBlocks; i++) {
      final start = i * engine.inputBlockSize;
      final end = start + engine.inputBlockSize < input.length
          ? start + engine.inputBlockSize
          : input.length;
      output.add(engine.process(input.sublist(start, end)));
    }
    return output.toBytes();
  }

  static String encryptData(String data) {
    final encryptedData = encrypt(data, publicKeyPem);
    return base64Encode(encryptedData);
  }

  static String decryptData(String encryptedData) {
    final decryptedData = decrypt(base64Decode(encryptedData), privateKeyPem);
    return decryptedData;
  }
}

class RSAKeyParser {
  /// Parse PEM file
  RSAAsymmetricKey parse(String pemString) {
    final bytes = base64.decode(pemString);
    if (pemString.contains('PUBLIC KEY')) {
      return _parsePublicKey(bytes);
    } else if (pemString.contains('PRIVATE KEY')) {
      return _parsePrivateKey(bytes);
    } else {
      throw ArgumentError('Invalid key format.');
    }
  }

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
        q.valueAsBigInteger);

    return rsaPrivateKey;
  }
}*/

class RSAUtil {
  static RSAPublicKey getPublicKey(String pem) {
    final parser = RSAKeyParser();
    return parser._parsePublicKey(base64Decode(pem)) as RSAPublicKey;
  }

  static RSAPrivateKey getPrivateKey(String pem) {
    final parser = RSAKeyParser();
    return parser._parsePrivateKey(base64Decode(pem)) as RSAPrivateKey;
  }

  static Uint8List encrypt(String data, String publicKeyPem) {
    final publicKey = getPublicKey(publicKeyPem);
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
    return _processInBlocks(encryptor, Uint8List.fromList(data.codeUnits));
  }

  static String decrypt(Uint8List data, String privateKeyPem) {
    final privateKey = getPrivateKey(privateKeyPem);
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    return String.fromCharCodes(_processInBlocks(decryptor, data));
  }

  static Uint8List _processInBlocks(
      AsymmetricBlockCipher engine, Uint8List input) {
    final inputBlockSize = engine.inputBlockSize;
    final numBlocks = (input.length + inputBlockSize - 1) ~/ inputBlockSize;
    final output = BytesBuilder();

    for (var i = 0; i < numBlocks; i++) {
      final start = i * inputBlockSize;
      final end = start + inputBlockSize < input.length
          ? start + inputBlockSize
          : input.length;
      final block = input.sublist(start, end);

      // Ensure the block is of the correct length by padding it with zeroes if necessary
      final paddedBlock = Uint8List(inputBlockSize);
      paddedBlock.setRange(0, block.length, block);
      paddedBlock.fillRange(
          block.length, inputBlockSize, 0); // Fill remaining space with zeroes

      try {
        output.add(engine.process(paddedBlock));
      } catch (e) {
        throw Exception('Error processing block: $e');
      }
    }

    return output.toBytes();
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
    var publicExponent = pkSeq.elements[2] as ASN1Integer;
    var privateExponent = pkSeq.elements[3] as ASN1Integer;
    var p = pkSeq.elements[4] as ASN1Integer;
    var q = pkSeq.elements[5] as ASN1Integer;

    RSAPrivateKey rsaPrivateKey = RSAPrivateKey(
      modulus.valueAsBigInteger,
      privateExponent.valueAsBigInteger,
      p.valueAsBigInteger,
      q.valueAsBigInteger,
      publicExponent.valueAsBigInteger,
    );

    return rsaPrivateKey;
  }
}
