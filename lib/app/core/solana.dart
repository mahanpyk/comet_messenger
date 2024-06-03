import 'dart:convert';
import 'dart:typed_data';
import 'package:bs58/bs58.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:bip39/bip39.dart' as bip39;

class PublicKey {

  factory PublicKey.fromBase58(String base58Str) {
    return PublicKey(base58.decode(base58Str));
  }

  PublicKey(this.pubkey) {
    if (pubkey.length > PUBLIC_KEY_LENGTH) {
      throw ArgumentError('Invalid public key input');
    }
  }

  PublicKey.fromString(String pubkeyString)
      : pubkey = base58.decode(pubkeyString);
  final Uint8List pubkey;
  static const int PUBLIC_KEY_LENGTH = 32;

  Uint8List toByteArray() {
    return pubkey;
  }

  String toBase58() {
    return base58.encode(pubkey);
  }

/*  bool equals(PublicKey other) {
    return const ListEquality().equals(pubkey, other.toByteArray());
  }

  @override
  int get hashCode {
    return const ListEquality().hash(pubkey);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PublicKey) return false;
    return equals(other);
  }*/

  @override
  String toString() {
    return toBase58();
  }

  static PublicKey readPubkey(Uint8List bytes, int offset) {
    final buf = bytes.sublist(offset, offset + PUBLIC_KEY_LENGTH);
    return PublicKey(buf);
  }

  static Future<PublicKey> createWithSeed(
      PublicKey account, String seed, PublicKey programId) async {
    final buffer = BytesBuilder();
    buffer.add(account.toByteArray());
    buffer.add(utf8.encode(seed));
    buffer.add(programId.toByteArray());
    final hash = sha256.convert(buffer.toBytes()).bytes;
    return PublicKey(Uint8List.fromList(hash));
  }

  static Future<PublicKey> createProgramAddress(
      List<Uint8List> seeds, PublicKey programId) async {
    final buffer = BytesBuilder();
    for (var seed in seeds) {
      if (seed.length > 32) throw ArgumentError('Max seed length exceeded');
      buffer.add(seed);
    }
    buffer.add(programId.toByteArray());
    buffer.add(utf8.encode('ProgramDerivedAddress'));
    final hash = sha256.convert(buffer.toBytes()).bytes;
    // Assuming isOnCurve() is implemented or available in some package
    if (isOnCurve(Uint8List.fromList(hash))) {
      throw ArgumentError('Invalid seeds, address must fall off the curve');
    }
    return PublicKey(Uint8List.fromList(hash));
  }

  static Future<ProgramDerivedAddress> findProgramAddress(
      List<Uint8List> seeds, PublicKey programId) async {
    int nonce = 255;
    while (nonce != 0) {
      try {
        final seedsWithNonce = List<Uint8List>.from(seeds)
          ..add(Uint8List.fromList([nonce]));
        final address = await createProgramAddress(seedsWithNonce, programId);
        return ProgramDerivedAddress(address, nonce);
      } catch (e) {
        nonce--;
      }
    }
    throw Exception('Unable to find a viable program address nonce');
  }

  static Future<ProgramDerivedAddress> associatedTokenAddress(
      PublicKey walletAddress, PublicKey tokenMintAddress) async {
    return findProgramAddress(
      [
        walletAddress.toByteArray(),
        TokenProgram.PROGRAM_ID.toByteArray(),
        tokenMintAddress.toByteArray(),
      ],
      PublicKey.fromString('ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL'),
    );
  }

  static PublicKey valueOf(String publicKey) {
    return PublicKey.fromString(publicKey);
  }
}

class ProgramDerivedAddress {

  ProgramDerivedAddress(this.address, this.nonce);
  final PublicKey address;
  final int nonce;
}

// Placeholder for the TokenProgram.PROGRAM_ID
class TokenProgram {
  static PublicKey PROGRAM_ID = PublicKey.fromString('SomeTokenProgramID');
}

// Placeholder function to simulate the curve check, replace with actual implementation
bool isOnCurve(Uint8List hash) {
  // Implement the actual curve check logic here
  return false; // Assuming this returns false if not on curve
}



class Account {


  Account._(this.keyPair);
  final KeyData keyPair;

  static Future<Account> create() async {
    final mnemonic = bip39.generateMnemonic();
    final seed = bip39.mnemonicToSeed(mnemonic);
    final keyPair = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    return Account._(keyPair);
  }

  static Future<Account> fromSecretKey(Uint8List secretKey) async {
    final keyPair = await ED25519_HD_KEY.getMasterKeyFromSeed(secretKey);
    return Account._(keyPair);
  }

  static Future<Account> fromPublicKey(Uint8List publicKey) async {
    return Account._(KeyData(key: publicKey, chainCode: Uint8List(0)));
  }
  Uint8List get publicKey => Uint8List.fromList(keyPair.key);
  Uint8List get secretKey => Uint8List.fromList(keyPair.chainCode);

  static Future<Account> fromMnemonic(List<String> words, String passphrase) async {
    final mnemonic = words.join(' ');
    final seed = bip39.mnemonicToSeedHex(mnemonic, passphrase: passphrase);
    final keyPair = await ED25519_HD_KEY.getMasterKeyFromSeed(Uint8List.fromList(hex.decode(seed)));
    return Account._(keyPair);
  }
}
