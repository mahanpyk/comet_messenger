import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:comet_messenger/app/core/app_extension.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointycastle/export.dart' as pointycastle;
import 'package:pointycastle/export.dart';
import 'package:solana_web3/solana_web3.dart';

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

  static String rsaSigner(String msg, PrivateKey key) {
    final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
    signer.init(true, PrivateKeyParameter<RSAPrivateKey>(key));
    final sig = signer.generateSignature(base64Decode(msg));
    return base64Encode(sig.bytes);
  }

  static bool rsaSignVerifier(pointycastle.PublicKey publicKey, String msg, String signature) {
    var sig = RSASignature(base64Decode(signature));
    var verifier = RSASigner(SHA256Digest(), '0609608648016503040201');
    verifier.init(false, PublicKeyParameter<RSAPublicKey>(publicKey));
    return verifier.verifySignature(base64Decode(msg), sig);
  }

  static AsymmetricKeyPair<pointycastle.PublicKey, PrivateKey> generateKeys() {
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

   AsymmetricKeyPair<pointycastle.PublicKey, PrivateKey> generateKeysFromSecure(Uint8List secure) {
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

  //convert BigInt? to String
  static void importedWalletFromSecretKey(Uint8List bigInt) async{
    Keypair keypair = await Keypair.fromSeckey(bigInt);
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

  // convert hex to bytes
  static Uint8List hexToBytes(String hex) {
    var bytes = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return Uint8List.fromList(bytes);
  }

  // convert bytes to hex
  static String bytesToHex(Uint8List bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  // convert Uint8List to string
  static String bytesToString(Uint8List bytes) {
    var chars = bytes.toList();
    return String.fromCharCodes(bytes);
  }
}