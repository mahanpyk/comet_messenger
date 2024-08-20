import 'package:comet_messenger/features/authentication/pages/import_mnemonic/import_mnemonic_controller.dart';
import 'package:get/get.dart';

class ImportWalletBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImportMnemonicController>(() => ImportMnemonicController());
  }
}
