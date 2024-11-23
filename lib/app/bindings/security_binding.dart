import 'package:comet_messenger/features/security/pages/security_controller.dart';
import 'package:get/get.dart';

class SecurityBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SecurityController>(() => SecurityController());
  }
}
