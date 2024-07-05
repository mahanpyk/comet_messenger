import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ShowMnemonicController extends GetxController {
  RxList<String> mnemonicWordsList = RxList([]);
  String? mnemonicText;

  @override
  void onInit() {
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
}
