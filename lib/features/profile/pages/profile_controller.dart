import 'dart:io';
import 'dart:ui';

import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/core/app_utils_mixin.dart';
import 'package:comet_messenger/app/models/request_model.dart';
import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/features/authentication/models/balance_response_model.dart';
import 'package:comet_messenger/features/profile/repository/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ProfileController extends GetxController with AppUtilsMixin {
  ProfileController(this._repo);

  final ProfileRepository _repo;
  Rxn<UserModel> userModel = Rxn();
  TextEditingController publicKeyTEC = TextEditingController();
  RxBool showQRCode = true.obs;
  RxBool qrAddress = false.obs;
  RxDouble balance = RxDouble(0.0);

  @override
  void onInit() async {
    var json = await UserStoreService.to.getUserModel();
    if (json != null) {
      userModel(UserModel.fromJson(json));
      publicKeyTEC.text = userModel.value?.publicKey ?? "public Key Not Found";
    }
    getBalance();
    super.onInit();
  }

  void onTapShowMnemonicAndPrivate() => Get.toNamed(AppRoutes.SHOW_MNEMONIC);

  void onTapSignOut() => logoutFromApp();

  void onTapProfile() => Get.toNamed(AppRoutes.PROFILE);

  void onTapPublicKey() {
    Clipboard.setData(ClipboardData(text: publicKeyTEC.text));
    Get.snackbar(
      'Copied',
      'Public key copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void showQrCode({required bool isPublicKey}) {
    showQRCode(false);
    qrAddress(isPublicKey);
  }

  void sharedQRCode() async {
    showQRCode(true);
    final qrCode = await QrPainter(
      data: publicKeyTEC.text,
      version: QrVersions.auto,
      eyeStyle: const QrEyeStyle(
        color: Colors.white,
        eyeShape: QrEyeShape.square,
      ),
      dataModuleStyle: const QrDataModuleStyle(
        color: Colors.white,
        dataModuleShape: QrDataModuleShape.square,
      ),
    ).toImage(200);

    // Save QR Code image to device
    ByteData? byteData = await qrCode.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(pngBytes);

    if (Platform.isAndroid) {
      Share.shareXFiles([XFile(file.path)], text: 'Share QR Code');
    } else {
      Share.shareXFiles([XFile(file.path)], subject: 'Share QR Code');
    }
  }

  void getBalance() {
    _repo
        .getBalance(
            requestModel: RequestModel(
      method: "getBalance",
      params: [userModel.value?.basePublicKey ?? ""],
      jsonrpc: "2.0",
      id: "b75758de-e0b2-469b-bd9c-ef366ee1b35a",
    ))
        .then((BalanceResponseModel response) {
      if (response.statusCode == 200) {
        double userBalance = response.data!.result!.value! / 1000000000;
        balance(userBalance);

        UserStoreService.to
            .save(key: AppConstants.BALANCE, value: balance.value);
      }
    });
  }
}
