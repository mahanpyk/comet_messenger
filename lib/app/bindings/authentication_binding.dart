import 'package:comet_messenger/features/authentication/pages/main/authentication_controller.dart';
import 'package:comet_messenger/features/authentication/repository/authentication_repository.dart';
import 'package:get/get.dart';

class AuthenticationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthenticationRepository>(() => AuthenticationRepositoryImpl());
    Get.lazyPut<AuthenticationController>(() =>
        AuthenticationController(
            Get.find<AuthenticationRepository>()
    ));
  }
}
