import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ShowMnemonicController extends GetxController {
  RxList<String> mnemonicWordsList = RxList([]);
  String? mnemonicText;
  TextEditingController privateKeyTEC = TextEditingController();
  Rxn<UserModel> userModel = Rxn();

  @override
  void onInit() async {
    var json = await UserStoreService.to.getUserModel();
    if (json != null) {
      userModel(UserModel.fromJson(json));
      privateKeyTEC.text = userModel.value?.privateKey ?? "private Key Not Found";
    }
    getMnemonic();
    super.onInit();
  }

  void getMnemonic() async {
    mnemonicText = await UserStoreService.to.getMnemonic();
    mnemonicWordsList(mnemonicText!.split(' '));
  }

  void onTapCopyAndNext() {
    Clipboard.setData(ClipboardData(text: mnemonicText!));
    Get.snackbar(
      'Copied',
      'Public key copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onTapPrivateKey() {
    Clipboard.setData(ClipboardData(text: privateKeyTEC.text));
    Get.snackbar(
      'Copied',
      'Public key copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
