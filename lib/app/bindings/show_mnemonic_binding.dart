import 'package:comet_messenger/features/show_mnemonic/pages/show_mnemonic_controller.dart';
import 'package:get/get.dart';

class ShowMnemonicBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShowMnemonicController>(() => ShowMnemonicController());
  }
}
