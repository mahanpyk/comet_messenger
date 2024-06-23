import 'dart:convert';
import 'dart:typed_data';

import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/login/repository/import_wallet_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:solana/solana.dart';
import 'package:hex/hex.dart';
import 'package:bip32/bip32.dart';
import 'package:base_x/base_x.dart';

class ImportWalletController extends GetxController {
  ImportWalletController(this._repo);

  final ImportWalletRepository _repo;
  TextEditingController importMnemonicTEC = TextEditingController();
  RxBool isLoading = RxBool(false);
  RxBool enableButton = RxBool(false);

  void checkMnemonic() async {
    // isLoading(true);
    bool result = bip39.validateMnemonic(importMnemonicTEC.text);
    if (result) {
      UserStoreService.to.saveMnemonic(importMnemonicTEC.text);
      Get.snackbar(
        '',
        'import wallet success',
        colorText: AppColors.tertiaryColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.successColor,
      );

      /// mnemonic obtained from the input
      /// neck seat salt cotton credit flower first alpha inject hammer unit shield

      // read user info
      var json = UserStoreService.to.get(key: AppConstants.USER_ACCOUNT);
      var user = userResponseModelFromJson(json);

      //create seed from mnemonic
      Uint8List seed = bip39.mnemonicToSeed(importMnemonicTEC.text);

      //create keyPair with bip32 Package
      BIP32 masterKey = BIP32.fromSeed(seed);

      //create keyPair with Solana Package
      Ed25519HDKeyPair solanaWallet = await Wallet.fromMnemonic(importMnemonicTEC.text);

      List<int> intList = seed.toList();
      List<int> intList2 = List<int>.from(seed);
      List<int> androidList = [123, 38, 39, -91, 50, -94, -10, -107, -20, -108, -96, 54, -56, -25, -41, -31, -23, -48, 74, 50, -106, -70, -23, -87, -126, -79, 111, -18, 74, 48, 45, 23, -46, -26, -33, 63, 80, -22, 12, -20, -70, -21, 124, 11, -67, 100, -121, 102, -82, -34, 110, 96, -6, -106, 75, -106, -2, -105, 89, 107, -121, -126, 4, -98];

      List<int> flutterList = androidList.map((value) => value < 0 ? value + 256 : value).toList();
      List<int> backToAndroid = flutterList.map((value) => value > 127 ? value - 256 : value).toList();
      var masterKey2 = BIP32.fromSeed(Uint8List.fromList(backToAndroid));


      /// The byte array is ready from seed creation in Android
      ///[123, 38, 39, -91, 50, -94, -10, -107, -20, -108, -96, 54, -56, -25, -41, -31, -23, -48, 74, 50, -106, -70, -23, -87, -126, -79, 111, -18, 74, 48, 45, 23, -46, -26, -33, 63, 80, -22, 12, -20, -70, -21, 124, 11, -67, 100, -121, 102, -82, -34, 110, 96, -6, -106, 75, -106, -2, -105, 89, 107, -121, -126, 4, -98]


      // RpcClient rpcClient = RpcClient(AppConstants.BASE_URL);
      // var solanaBalance = await rpcClient.getBalance(solanaWallet.address);
      String solub = base64Encode(solanaWallet.publicKey.bytes);
      String publicKeyString = base64Encode(masterKey.publicKey);
      String publicKeyString2 = base64Encode(masterKey2.publicKey);
      var base58 = BaseXCodec('123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz');

      ///
      ///2VtbMeIP9et9F5L7j3zgxG5wwpq50kBvsZNfV8OHr7Y=


      debugPrint('*****************************');
      debugPrint('asUint8List ${masterKey.publicKey.buffer.asUint8List()}');
      debugPrint('asInt8List ${masterKey.publicKey.buffer.asInt8List()}');
      debugPrint('#############################');

      debugPrint('*****************************');
      debugPrint('Master Key base58 encode: ${base58.encode(masterKey.publicKey)}');
      debugPrint('Master Key HEX encode: ${HEX.encode(masterKey.publicKey)}');
      debugPrint('#############################');


      ///
      ///[3, 4, -55, -42, -117, 64, -116, -30, 99, 64, -36, -44, -93, 94, -79, -65, -50, 65, -98, -119, 125, -120, -18, 99, 81, 114, 4, -3, -63, -113, 97, -16, -7]
      ///
      ///
      ///[-39, 91, 91, 49, -30, 15, -11, -21, 125, 23, -110, -5, -113, 124, -32, -60, 110, 112, -62, -102, -71, -46, 64, 111, -79, -109, 95, 87, -61, -121, -81, -74]
      List<int> androidListAndroid = [-39, 91, 91, 49, -30, 15, -11, -21, 125, 23, -110, -5, -113, 124, -32, -60, 110, 112, -62, -102, -71, -46, 64, 111, -79, -109, 95, 87, -61, -121, -81, -74];
      List<int> flutterListAndroid = androidListAndroid.map((value) => value < 0 ? value + 256 : value).toList();
      debugPrint('*****************************');
      debugPrint(flutterListAndroid.toString());
      debugPrint('#############################');
      // Get.offAllNamed(AppRoutes.HOME);

    } else {
      Get.snackbar(
        '',
        'import wallet failed',
        colorText: AppColors.tertiaryColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorColor,
      );
    }
    isLoading(false);
  }

  void onChanged(String text) {
    enableButton(importMnemonicTEC.text.length > 20);
  }
}
