import 'package:comet_messenger/features/profile/pages/profile_controller.dart';
import 'package:comet_messenger/features/profile/repository/profile_repository.dart';
import 'package:get/get.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRepository>(() => WalletRepositoryImpl());
    Get.lazyPut<ProfileController>(
        () => ProfileController(Get.find<ProfileRepository>()));
  }
}
