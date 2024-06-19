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


/*  PublicKey createWithSeed(PublicKey account, String seed, PublicKey programId) {
    final buffer = BytesBuilder();
    buffer.add(account.toByteArray());
    buffer.add(utf8.encode(seed));
    buffer.add(programId.toByteArray());

    final hash = sha256Hash(buffer.toBytes());
    return PublicKey(hash);
  }*/
}

/*class PublicKey {
  PublicKey(this.bytes) {
    if (bytes.length != AppConstants.PUBLIC_KEY_LENGTH) {
      throw ArgumentError("Invalid public key length");
    }
  }

  factory PublicKey.fromBase58(String base58Str) {
    return PublicKey(base58.decode(base58Str));
  }

  final Uint8List bytes;

  String toBase58() {
    return base58.encode(bytes);
  }

  Uint8List toByteArray() {
    return bytes;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PublicKey) return false;
    return bytes == other.bytes;
  }

  @override
  int get hashCode {
    return bytes.hashCode;
  }

  @override
  String toString() {
    return toBase58();
  }

  static Uint8List sha256Hash(Uint8List data) {
    return sha256.convert(data).bytes as Uint8List;
  }

  static PublicKey createWithSeed(PublicKey account, String seed, PublicKey programId) {
    final buffer = BytesBuilder();
    buffer.add(account.toByteArray());
    buffer.add(utf8.encode(seed));
    buffer.add(programId.toByteArray());

    final hash = sha256Hash(buffer.toBytes());
    return PublicKey(hash);
  }

  static PublicKey createProgramAddress(List<Uint8List> seeds, PublicKey programId) {
    final buffer = BytesBuilder();
    for (final seed in seeds) {
      if (seed.length > 32) {
        throw ArgumentError("Max seed length exceeded");
      }
      buffer.add(seed);
    }
    buffer.add(programId.toByteArray());
    buffer.add(utf8.encode("ProgramDerivedAddress"));

    final hash = sha256Hash(buffer.toBytes());
    if (TweetNaclFast.isOnCurve(hash)) {
      throw ArgumentError("Invalid seeds, address must fall off the curve");
    }
    return PublicKey(hash);
  }

  static Future<ProgramDerivedAddress> findProgramAddress(List<Uint8List> seeds, PublicKey programId) async {
    int nonce = 255;
    while (nonce != 0) {
      try {
        final seedsWithNonce = List<Uint8List>.from(seeds)..add(Uint8List.fromList([nonce]));
        final address = createProgramAddress(seedsWithNonce, programId);
        return ProgramDerivedAddress(address, nonce);
      } catch (_) {
        nonce--;
      }
    }
    throw Exception("Unable to find a viable program address nonce");
  }

  static Future<ProgramDerivedAddress> associatedTokenAddress(PublicKey walletAddress, PublicKey tokenMintAddress) async {
    return findProgramAddress(
        [walletAddress.toByteArray(), TokenProgram.PROGRAM_ID.toByteArray(), tokenMintAddress.toByteArray()], PublicKey.fromBase58("ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL"));
  }
}

class ProgramDerivedAddress {
  ProgramDerivedAddress(this.address, this.nonce);

  final PublicKey address;
  final int nonce;
}

class TokenProgram {
  static final PROGRAM_ID = PublicKey.fromBase58("TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA");
}

class TweetNaclFast {
  static bool isOnCurve(Uint8List point) {
    // Implement the isOnCurve check
    throw UnimplementedError();
  }
}*/
