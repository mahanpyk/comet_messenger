
import 'dart:convert';

import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/login/repository/import_wallet_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:solana/solana.dart';
import 'package:hex/hex.dart';
import 'package:bip32/bip32.dart';

class ImportWalletController extends GetxController {
  ImportWalletController(this._repo);

  final ImportWalletRepository _repo;
  TextEditingController importMnemonicTEC = TextEditingController();
  RxBool isLoading = RxBool(false);
  RxBool enableButton = RxBool(false);

  void checkMnemonic() async{
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


      var json=UserStoreService.to.get(key: AppConstants.USER_ACCOUNT);
      var user=userResponseModelFromJson(json);
      var seed = bip39.mnemonicToSeed(importMnemonicTEC.text);
      // var seedBasePub = bip39.mnemonicToSeed(json['base_pubkey']);
      // var seedPubKey = bip39.mnemonicToSeed(json['public_key']);
      var masterKey = BIP32.fromSeed(seed);
      // var seedPubKey = BIP32.fromBase58(json['base_pubkey']);
      // var checkBasePub = BIP32.fromPublicKey(seedBasePub, masterKey.chainCode,);
      // var checkPubKey = BIP32.fromPublicKey(seedPubKey, masterKey.chainCode,);
      var test = HEX.encode(masterKey.privateKey??[]);
      var solanaWallet = await Wallet.fromMnemonic(importMnemonicTEC.text);
      // RpcClient rpcClient = RpcClient(AppConstants.BASE_URL);
      // var solanaBalance = await rpcClient.getBalance(solanaWallet.address);
      String publicKeyString = base64Encode(masterKey.publicKey);

      debugPrint('*****************');
      debugPrint('Master Key: ${HEX.encode(masterKey.privateKey??[])}');
      debugPrint('Master Key: ${HEX.encode(masterKey.publicKey)}');
      debugPrint('-----------------');

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
