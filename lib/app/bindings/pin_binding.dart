import 'package:comet_messenger/features/login/pages/pin/pin_controller.dart';
import 'package:get/get.dart';

class PinBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PinController>(() => PinController());
  }
}
