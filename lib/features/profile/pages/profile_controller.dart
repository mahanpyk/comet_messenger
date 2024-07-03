import 'package:comet_messenger/app/core/app_utils_mixin.dart';
import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController with AppUtilsMixin {
  RxString test = RxString('');
  Rxn<UserModel> userModel = Rxn();
  TextEditingController publicKeyTEC = TextEditingController();

  @override
  void onInit() async {
    var json = await UserStoreService.to.getUserModel();
    if (json != null) {
      userModel(UserModel.fromJson(json));
      publicKeyTEC.text = userModel.value?.publicKey ?? "public Key Not Found";
    }
    super.onInit();
  }

  void onTapShowMnemonic() {
    // Get.toNamed(AppRoutes.SHOW_MNEMONIC);
  }

  void onTapSignOut() => logoutFromApp();

  void onTapProfile() => Get.toNamed(AppRoutes.PROFILE);

  void onTapPublicKey() {
    Clipboard.setData(ClipboardData(text: publicKeyTEC.text));
    Get.snackbar(
      'Copied',
      'Public key copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
