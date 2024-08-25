import 'package:bip39/bip39.dart' as bip39;
import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ImportMnemonicController extends GetxController {
  ImportMnemonicController();

  TextEditingController importMnemonicTEC = TextEditingController();
  RxBool isLoading = RxBool(false);
  RxBool enableButton = RxBool(false);
  UserModel? userModel;

  void checkMnemonic() async {
    isLoading(true);
    bool result = bip39.validateMnemonic(importMnemonicTEC.text);
    if (result) {
      UserStoreService.to.saveMnemonic(importMnemonicTEC.text);

      /// mnemonic obtained from the input
      /// MainNet moshtagh2
      /// neck seat salt cotton credit flower first alpha inject hammer unit shield
      /// MainNet lasemi
      /// picnic canyon worth distance wash blur cancel laundry alien fit prepare unlock
      /// DevNet test-1
      /// allow online pass size blush nephew festival myth behave gift recycle tomato
      const platform = MethodChannel(AppConstants.PLATFORM_CHANNEL);
      String publicKeyBase58 = '', privateKeyBase58 = '';
      try {
        final String result = await platform.invokeMethod('keypairFromPhrase', {
          'phrase': importMnemonicTEC.text,
        });

        var splitResult = result.split('*********');
        publicKeyBase58 = splitResult[0];
        privateKeyBase58 = splitResult[1];
        debugPrint('*****************************');
        debugPrint(result.toString());
        debugPrint('#############################');
      } on PlatformException catch (e) {
        debugPrint('*****************************');
        debugPrint("Failed to encrypt data: '${e.message}'.");
        debugPrint('#############################');
      }

      // read user info
      var json = await UserStoreService.to.getUserModel();
      userModel = UserModel.fromJson(json!);
/*      // Convert mnemonic phrase to seed
      final seed = bip39.mnemonicToSeed(importMnemonicTEC.text);

      // Use the first 32 bytes of the seed as the secret key
      final secretKeyBytes = seed.sublist(0, 32);

      // Generate a keypair using the secret key
      final algorithm = Ed25519();
      final keyPair = await algorithm.newKeyPairFromSeed(secretKeyBytes);

      // Extract the public key
      final publicKey = await keyPair.extractPublicKey();
      final privateKey = await keyPair.extractPrivateKeyBytes();*/

      // Convert publicKey to base58
      if (userModel!.basePublicKey == publicKeyBase58) {
        var newUserModel = UserModel(
          avatar: userModel!.avatar,
          basePublicKey: publicKeyBase58,
          publicKey: userModel!.publicKey,
          privateKey: privateKeyBase58,
          login: userModel!.login,
          userName: userModel!.userName,
          modalCreate: userModel!.modalCreate,
          id: userModel!.publicKey,
        );
        UserStoreService.to.saveUserModel(newUserModel.toJson());
        Get.offAllNamed(AppRoutes.HOME);
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
