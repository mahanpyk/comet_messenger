import 'package:comet_messenger/features/splash/pages/splash_controller.dart';
import 'package:comet_messenger/features/splash/repository/splash_repository.dart';
import 'package:get/get.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SplashRepository>(SplashRepositoryImpl());
    Get.put<SplashController>(SplashController(Get.find<SplashRepository>()));
  }
}
