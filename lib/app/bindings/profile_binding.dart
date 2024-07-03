import 'package:comet_messenger/features/constacts/pages/main/contacts_controller.dart';
import 'package:comet_messenger/features/constacts/repository/contacts_repository.dart';
import 'package:comet_messenger/features/profile/pages/profile_controller.dart';
import 'package:get/get.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
