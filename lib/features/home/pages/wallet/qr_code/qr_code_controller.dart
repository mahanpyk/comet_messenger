import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QRCodeController extends GetxController {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // Barcode? result;
  // QRViewController? controller;
  RxString title = RxString('QR Code');

// void onQRViewCreated(QRViewController controller) {
//   this.controller = controller;
//   controller.scannedDataStream.listen((scanData) {
//     result = scanData;
//     if (result != null && result!.code != null) {
//       final regexValid = AppRegex.checkValidField(result!.code!, AppRegex.solanaAddressRegex);
//       if (regexValid) {
//         Get.back(result: result!.code!);
//         controller.dispose();
//       }
//     }
//   });
// }
//
// void onPermissionSet(QRViewController ctrl, bool p) {
//   debugPrint('${DateTime.now().toIso8601String()}_onPermissionSet $p');
// }
}
