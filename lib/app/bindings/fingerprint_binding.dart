import 'package:comet_messenger/features/authentication/pages/fingerprint/fingerprint_controller.dart';
import 'package:get/get.dart';

class FingerprintBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FingerprintController>(() => FingerprintController());
  }
}
