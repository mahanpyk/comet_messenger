// import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/core/app_utils_mixin.dart';
import 'package:comet_messenger/app/models/list_user_wallets_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CreateMnemonicController extends GetxController with AppUtilsMixin {
  String mnemonicText = '';
  String avatar = '';
  String userName = '';
  RxList<String> mnemonicWordsList = RxList([]);
  ListUserWalletsModel? listUserWalletsModel;

  @override
  void onInit() {
    var wallets = UserStoreService.to.get(key: AppConstants.WALLETS);
    if (wallets != null) {
      listUserWalletsModel = ListUserWalletsModel.fromJson(wallets);
    }
    Map<String, dynamic>? data = Get.arguments;
    if (data != null) {
      userName = data['userName'] ?? '';
      avatar = data['avatar'].toString() ?? '';
    }
    generateMnemonic();
    super.onInit();
  }

  void onTapCopyAndNext() {
    Clipboard.setData(ClipboardData(text: mnemonicText));
    Get.snackbar(
      '',
      'Text copied',
      colorText: AppColors.tertiaryColor,
      snackPosition: SnackPosition.BOTTOM,
    );
    if (listUserWalletsModel != null &&
        listUserWalletsModel!.listWallets != null) {
      for (UserWalletModel element in listUserWalletsModel!.listWallets!) {
        element.isActive = false;
      }
    }
    ListUserWalletsModel newListWalletsModel =
        ListUserWalletsModel(listWallets: [
      UserWalletModel(
        id: (listUserWalletsModel?.listWallets?.length ?? 0) + 1,
        mnemonic: mnemonicText,
        isActive: true,
      ),
      ...?listUserWalletsModel?.listWallets
    ]);
    UserStoreService.to
        .save(key: AppConstants.WALLETS, value: newListWalletsModel.toJson());
    UserStoreService.to.saveMnemonic(mnemonicText);
    Get.offAllNamed(AppRoutes.PIN);
  }

  void generateMnemonic() async {
    // final mnemonic = await Mnemonic.create(WordCount.Words12);
    String randomMnemonic = bip39.generateMnemonic();
    mnemonicText = randomMnemonic;
    mnemonicWordsList(mnemonicText.split(' '));
    const platform = MethodChannel(AppConstants.PLATFORM_CHANNEL);
    try {
      final String result2 = await platform.invokeMethod('createAccount', {
        "userName": userName,
        "avatar": avatar,
        "mnemonicCode": mnemonicText,
      });

      Get.snackbar('Error', "Failed to receive data from server");
    } on PlatformException catch (e) {
      Get.snackbar('Error', "Failed to receive data from server");
      debugPrint('*****************************');
      debugPrint("Failed to encrypt data: '${e.message}'.");
      debugPrint('#############################');
    }
  }
}
