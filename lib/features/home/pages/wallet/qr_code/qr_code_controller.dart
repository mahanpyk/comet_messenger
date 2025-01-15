import 'package:comet_messenger/app/core/app_regex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeController extends GetxController {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  RxString title = RxString('QR Code');

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      if (result != null && result!.code != null) {
        final regexValid = AppRegex.checkValidField(result!.code!, AppRegex.solanaAddressRegex);
        if (regexValid) {
          Get.back(result: result!.code!);
          controller.dispose();
        }
      }
    });
  }

  void onPermissionSet(QRViewController ctrl, bool p) {
    debugPrint('${DateTime.now().toIso8601String()}_onPermissionSet $p');
  }
}
