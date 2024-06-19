import 'package:comet_messenger/features/login/pages/import_mnemonic/import_wallet_controller.dart';
import 'package:comet_messenger/features/login/repository/import_wallet_repository.dart';
import 'package:get/get.dart';

class ImportWalletBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImportWalletRepository>(() => ImportWalletRepositoryImpl());
    Get.lazyPut<ImportWalletController>(() => ImportWalletController(Get.find<ImportWalletRepository>()));
  }
}
