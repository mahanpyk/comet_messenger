import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:comet_messenger/app/core/app_extension.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt_lib;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/export.dart';

mixin AppUtilsMixin {
  void removeFocus() => FocusManager.instance.primaryFocus!.unfocus();

  void logoutFromApp() {
    UserStoreService.to.deleteAll();
    Get.offAndToNamed(AppRoutes.LOGIN);
  }

  static Uint8List pad(Uint8List src, blockSize) {
    var pad = PKCS7Padding();
    pad.init(null);
    int padLength = src.length % blockSize == 0 ? 16 : blockSize - (src.length % blockSize);
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

  static String encryptAES256CBC(String message, String key) {
    var keyBytes = key.toUInt8List();
    var messageBytes = utf8.encode(message);
    var paddedMsg = pad(messageBytes, 16);
    var cipher = AESEngine();
    var params = KeyParameter(keyBytes);
    var iv = '325230323340642128326E23345F3640';
    var ivBytes = iv.toUInt8List();
    var cbcParams = ParametersWithIV(params, ivBytes);
    var cbcCipher = CBCBlockCipher(cipher);
    cbcCipher.init(true, cbcParams);
    var encrypted = _processBlocks(cbcCipher, paddedMsg);
    return base64Encode(encrypted);
  }

  static AsymmetricKeyPair<PublicKey, PrivateKey> generateKeys() {
    final secureRandom = FortunaRandom();
    secureRandom.seed(KeyParameter(
      Uint8List.fromList(
        List<int>.generate(32, (i) => Random.secure().nextInt(256)),
      ),
    ));

    var rsaKey = RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 12);
    var params = ParametersWithRandom(rsaKey, secureRandom);
    var keyGenerator = RSAKeyGenerator();
    keyGenerator.init(params);
    return keyGenerator.generateKeyPair();
  }

  AsymmetricKeyPair<PublicKey, PrivateKey> generateKeysFromSecure(Uint8List secure) {
    final secureRandom = FortunaRandom();
    secureRandom.seed(KeyParameter(
      Uint8List.fromList(
        List<int>.generate(32, (i) => Random.secure().nextInt(256)),
      ),
    ));

    var rsaKey = RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 12);
    var params = ParametersWithRandom(rsaKey, secureRandom);
    var keyGenerator = RSAKeyGenerator();
    keyGenerator.init(params);
    return keyGenerator.generateKeyPair();
  }

  //convert BigInt? to base64
  static String bigIntToBase64(BigInt? bigInt) {
    if (bigInt == null) return '';
    var bytes = bigIntToBytes(bigInt, (bigInt.bitLength + 7) >> 3);
    return base64.encode(bytes);
  }

  static Uint8List bigIntToBytes(BigInt number, int size) {
    var bytes = Uint8List(size);
    for (var i = 0; i < size; i++) {
      bytes[size - i - 1] = (number & BigInt.from(0xff)).toInt();
      number = number >> 8;
    }
    return bytes;
  }

  static String privateKeyToString(RSAPrivateKey privateKey) {
    return "${privateKey.modulus!.toRadixString(16)}########${privateKey.privateExponent!.toRadixString(16)}########${privateKey.p!.toRadixString(16)}########${privateKey.q!.toRadixString(16)}";
  }

  //convert String to private key
  static RSAPrivateKey stringToPrivateKey(String privateKeyString) {
    var lines = privateKeyString.split('########');
    RSAPrivateKey key = RSAPrivateKey(
      BigInt.parse(lines[0], radix: 16),
      BigInt.parse(lines[1], radix: 16),
      BigInt.parse(lines[2], radix: 16),
      BigInt.parse(lines[3], radix: 16),
    );
    return key;
  }

  Uint8List sha256Hash(Uint8List data) {
    return sha256.convert(data).bytes as Uint8List;
  }

  //region Convert Message To String
  static String getUniqueHash(String key) {
    var bytes = utf8.encode(key);
    var digest = sha256.convert(bytes);
    return digest.toString().substring(0, 16);
  }

  static String decrypt(List<int> encryptedData, String key) {
    String newKey = getUniqueHash(key);
    final keyBytes = encrypt_lib.Key.fromUtf8(newKey);
    final encrypter = encrypt_lib.Encrypter(encrypt_lib.AES(keyBytes));

    final decryptedData = encrypter.decrypt(
      encrypt_lib.Encrypted(Uint8List.fromList(encryptedData)),
      iv: encrypt_lib.IV.fromLength(16),
    );

    return decryptedData;
  }

  static List<int> hexToBytes(String hex) {
    int len = hex.length;
    List<int> bytes = List<int>.filled(len ~/ 2, 0);
    for (int i = 0; i < len; i += 2) {
      bytes[i ~/ 2] = (int.parse(hex[i], radix: 16) << 4) + int.parse(hex[i + 1], radix: 16);
    }
    return bytes;
  }

  static String generate32ByteKey() {
    final key = encrypt_lib.Key.fromSecureRandom(32);
    final keyBytes = key.bytes;
    String keyHex = bytesToHex(keyBytes);
    return keyHex;
  }

  static String bytesToHex(List<int> bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
  }

  // endregion

  //region Create KEY For Encryption

  static RSAPrivateKey parsePrivateKeyFromPem(String pem) {
    final keyData = base64.decode(pem);
    final asn1Parser = ASN1Parser(Uint8List.fromList(keyData));
    final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    final privateKeySeq = topLevelSeq.elements![2] as ASN1Sequence;

    final modulus = privateKeySeq.elements![1] as ASN1Integer;
    final privateExponent = privateKeySeq.elements![3] as ASN1Integer;
    final p = privateKeySeq.elements![4] as ASN1Integer;
    final q = privateKeySeq.elements![5] as ASN1Integer;

    return RSAPrivateKey(
      modulus.integer!,
      privateExponent.integer!,
      p.integer,
      q.integer,
    );
  }

  static String decryptForCipher(String data, String base64PrivateKey) {
    final privateKey = parsePrivateKeyFromPem(base64PrivateKey);
    final encrypter = encrypt_lib.Encrypter(encrypt_lib.RSA(privateKey: privateKey, encoding: encrypt_lib.RSAEncoding.OAEP));

    final decrypted = encrypter.decrypt64(data);
    return decrypted;
  }
// endregion
}
