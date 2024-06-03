import 'package:comet_messenger/features/login/pages/main/login_controller.dart';
import 'package:comet_messenger/features/login/repository/login_repository.dart';
import 'package:get/get.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginRepository>(() => LoginRepositoryImpl());
    Get.lazyPut<LoginController>(() => LoginController(
        Get.find<LoginRepository>()
    ));
  }
}
