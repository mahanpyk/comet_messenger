import 'package:comet_messenger/app/core/app_utils_mixin.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController with AppUtilsMixin {
  RxString test = RxString('');

  void onTapShowMnemonic() {
    // Get.toNamed(AppRoutes.SHOW_MNEMONIC);
  }

  void onTapSignOut() => logoutFromApp();

  void onTapProfile() => Get.toNamed(AppRoutes.PROFILE);
}
