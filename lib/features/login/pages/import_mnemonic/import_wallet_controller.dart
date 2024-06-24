import 'dart:typed_data';

import 'package:base_x/base_x.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/models/request_model.dart';
import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/login/repository/import_wallet_repository.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ImportWalletController extends GetxController {
  ImportWalletController(this._repo);

  final ImportWalletRepository _repo;
  TextEditingController importMnemonicTEC = TextEditingController();
  RxBool isLoading = RxBool(false);
  RxBool enableButton = RxBool(false);
  UserModel? userModel;

  void checkMnemonic() async {
    // isLoading(true);
    bool result = bip39.validateMnemonic(importMnemonicTEC.text);
    if (result) {
      UserStoreService.to.saveMnemonic(importMnemonicTEC.text);

      /// mnemonic obtained from the input
      /// neck seat salt cotton credit flower first alpha inject hammer unit shield

      // read user info
      var json = UserStoreService.to.get(key: AppConstants.USER_ACCOUNT);
      userModel = UserModel.fromJson(json);
      // Convert mnemonic phrase to seed
      final seed2 = bip39.mnemonicToSeed(importMnemonicTEC.text);

      // Use the first 32 bytes of the seed as the secret key
      final secretKeyBytes = seed2.sublist(0, 32);

      // Generate a keypair using the secret key
      final algorithm = Ed25519();
      final keyPair = await algorithm.newKeyPairFromSeed(secretKeyBytes);

      // Extract the public key
      final publicKey = await keyPair.extractPublicKey();
      final privateKey = await keyPair.extractPrivateKeyBytes();

      // Convert publicKey to base58
      var base58 = BaseXCodec(AppConstants.BASE58_CODEC);
      String publicKeyBase58 =
          base58.encode(Uint8List.fromList(publicKey.bytes));
      String privateKeyBase58 = base58.encode(Uint8List.fromList(privateKey));
      if (userModel!.basePubKey == publicKeyBase58) {
        var newUserModel = UserModel(
          avatar: userModel!.avatar,
          basePubKey: publicKeyBase58,
          privateKey: privateKeyBase58,
          login: userModel!.login,
          userName: userModel!.userName,
          modalCreate: userModel!.modalCreate,
          id: publicKeyBase58,
        );
        _repo
            .getBalance(
                requestModel: RequestModel(
              method: "getBalance",
              params: [base58.decode(publicKeyBase58)],
              jsonrpc: "2.0",
              id: "b75758de-e0b2-469b-bd9c-ef366ee1b35a",
            ))
            .then((response) {});

        UserStoreService.to
            .save(key: AppConstants.USER_ACCOUNT, value: newUserModel.toJson());
        // Get.offAllNamed(AppRoutes.HOME);
      } else {
        Get.snackbar(
          'Error import wallet',
          'mnemonic does not match with private key and public key',
          colorText: AppColors.tertiaryColor,
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.errorColor,
        );
      }
    } else {
      Get.snackbar(
        'Error import wallet',
        'import wallet failed',
        colorText: AppColors.tertiaryColor,
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.errorColor,
      );
    }
    isLoading(false);
  }

  void onChanged(String text) {
    enableButton(importMnemonicTEC.text.length > 20);
  }
}
