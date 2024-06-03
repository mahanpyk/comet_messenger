import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/models/list_user_wallets_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ImportWalletController extends GetxController {
  TextEditingController importMnemonicTEC = TextEditingController();
  RxBool isLoading = RxBool(false);
  RxBool showError = RxBool(false);
  RxBool enableButton = RxBool(false);
  ListUserWalletsModel? listUserWalletsModel;

  @override
  void onInit() {
    var wallets = UserStoreService.to.get(key: AppConstants.WALLETS);
    if (wallets != null) {
      listUserWalletsModel = ListUserWalletsModel.fromJson(wallets);
    }
    super.onInit();
  }

  void checkMnemonic() {
    isLoading(true);
    // bool result = bip39.validateMnemonic(importMnemonicTEC.text);
    // if (result) {
      Get.snackbar(
        '',
        'import wallet success',
        colorText: AppColors.tertiaryColor,
        snackPosition: SnackPosition.BOTTOM,
      );
      if (listUserWalletsModel != null && listUserWalletsModel!.listWallets != null) {
        for (UserWalletModel element in listUserWalletsModel!.listWallets!) {
          element.isActive = false;
        }
      }
      ListUserWalletsModel newListWalletsModel = ListUserWalletsModel(listWallets: [
        UserWalletModel(
          id: (listUserWalletsModel?.listWallets?.length ?? 0) + 1,
          mnemonic: importMnemonicTEC.text,
          isActive: true,
        ),
        ...?listUserWalletsModel?.listWallets
      ]);
      UserStoreService.to.save(key: AppConstants.WALLETS, value: newListWalletsModel.toJson());
      UserStoreService.to.saveMnemonic(importMnemonicTEC.text);
      Get.offAllNamed(AppRoutes.HOME);
    // } else {
    //   showError(true);
    // }
    isLoading(false);
  }

  void onChanged(String text) {
    enableButton(importMnemonicTEC.text.length > 20);
  }
}
