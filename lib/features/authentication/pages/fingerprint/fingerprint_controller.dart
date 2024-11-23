import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:get/get.dart';

class FingerprintController extends GetxController {
  RxBool isLoading = RxBool(false);

  void enableFingerPrint() {
    UserStoreService.to.saveFingerprint(true);
    Get.offAndToNamed(
      AppRoutes.HOME,
      arguments: {'showAirDropDialog': true},
    );
  }
}
