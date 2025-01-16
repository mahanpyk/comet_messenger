import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/features/home/pages/wallet/qr_code/qr_code_controller.dart';
import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodePage extends BaseView<QRCodeController> {
  const QRCodePage({super.key});

  @override
  Widget body() {
    return Column(
      children: [
        Offstage(offstage: true, child: Text(controller.title.value)),
        // Expanded(
        //   child: QRView(
        //     key: controller.qrKey,
        //     onQRViewCreated: (p0) => controller.onQRViewCreated(p0),
        //     overlay: QrScannerOverlayShape(
        //       borderColor: AppColors.primaryColor,
        //       borderRadius: 10,
        //       borderLength: 30,
        //       borderWidth: 10,
        //       cutOutSize: 300,
        //     ),
        //     onPermissionSet: (ctrl, p) => controller.onPermissionSet(ctrl, p),
        //   ),
        // ),
      ],
    );
  }
}
