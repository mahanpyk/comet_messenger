import 'package:comet_messenger/features/login/pages/create_mnemonic/create_mnemonic_controller.dart';
import 'package:get/get.dart';

class CreateMnemonicBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateMnemonicController>(() => CreateMnemonicController());
  }
}
