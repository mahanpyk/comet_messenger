import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/core/app_utils_mixin.dart';
import 'package:comet_messenger/app/models/list_user_wallets_model.dart';
import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CreateMnemonicController extends GetxController with AppUtilsMixin {
  String avatar = '';
  String userName = '';
  RxString mnemonic = RxString('');
  RxString privateKey = RxString('');
  ListUserWalletsModel? listUserWalletsModel;
  RxBool isLoading = RxBool(true);
  RxBool showQRCode = RxBool(false);
  String basePubKey = '';

  @override
  void onInit() {
    var wallets = UserStoreService.to.get(key: AppConstants.WALLETS);
    if (wallets != null) {
      listUserWalletsModel = ListUserWalletsModel.fromJson(wallets);
    }
    Map<String, dynamic>? data = Get.arguments;
    if (data != null) {
      userName = data['userName'] ?? '';
      avatar = (data['avatar'] ?? '').toString();
    }
    generateMnemonic();
    super.onInit();
  }

  void onTapCopyAndNext() {
    Clipboard.setData(ClipboardData(
      text: '''
Phrase:
${mnemonic.value}

Private key:
${privateKey.value}
''',
    ));
    Get.snackbar(
      '',
      'Text copied',
      colorText: AppColors.tertiaryColor,
      snackPosition: SnackPosition.BOTTOM,
    );
    if (listUserWalletsModel != null && listUserWalletsModel!.listWallets != null) {
      for (UserWalletModel element in listUserWalletsModel!.listWallets!) {
        element.isActive = false;
      }
    }
    UserStoreService.to.saveMnemonic(mnemonic.value);
    Get.offAllNamed(AppRoutes.PIN);
  }

  void generateMnemonic() async {
    // final mnemonic = await Mnemonic.create(WordCount.Words12);
    const MethodChannel platform = MethodChannel(AppConstants.PLATFORM_CHANNEL);
    try {
      final String result = await platform.invokeMethod('createAccount', {
        "userName": userName,
        "avatar": avatar,
      });
      debugPrint('*****************');
      debugPrint(result);
      debugPrint('-----------------');
      var splitResult = result.split('*********');
      mnemonic(splitResult[0]);
      String publicKeyBase58 = '';

      publicKeyBase58 = splitResult[1];
      privateKey(splitResult[2]);
      basePubKey = splitResult[3];
      isLoading(false);
      var newUserModel = UserModel(
        avatar: avatar,
        basePublicKey: publicKeyBase58,
        publicKey: basePubKey,
        privateKey: privateKey.value,
        login: false,
        userName: userName,
        modalCreate: '',
        id: basePubKey,
      );
      UserStoreService.to.saveUserModel(newUserModel.toJson());
    } on PlatformException catch (e) {
      debugPrint('*****************************');
      debugPrint("Failed to encrypt data: '${e.message}'.");
      debugPrint('#############################');
    }
  }
}
