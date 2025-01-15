import 'package:comet_messenger/features/home/pages/wallet/qr_code/qr_code_controller.dart';
import 'package:get/get.dart';

class QRCodeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QRCodeController>(() => QRCodeController());
  }
}
