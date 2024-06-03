import 'package:comet_messenger/features/intro/pages/intro_controller.dart';
import 'package:get/get.dart';

class IntroBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntroController>(() => IntroController());
  }
}
