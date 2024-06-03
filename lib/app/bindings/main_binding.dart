import 'package:comet_messenger/app/services/storage_service.dart';
import 'package:comet_messenger/app/store/localize_store_service.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:get/get.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocalStorage>(() => StorageService());
    Get.put<LocalizeStoreService>(
      LocalizeStoreService(Get.find<LocalStorage>()),
      permanent: true,
    );
    Get.put<UserStoreService>(
      UserStoreService(Get.find<LocalStorage>()),
      permanent: true,
    );
  }
}
