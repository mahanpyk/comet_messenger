import 'dart:io';

import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class SecurityController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();

  RxBool fingerprintState = RxBool(false);
  RxBool deviceHasFingerPrint = RxBool(false);

  @override
  void onInit() async {
    var fingerprint = await UserStoreService.to.getFingerPrint() ?? false;
    fingerprintState(fingerprint);
    checkBiometrics().then((isAvailable) {
      if (isAvailable) {
        deviceHasFingerPrint(true);
      } else {
        deviceHasFingerPrint(false);
      }
    });
    super.onInit();
  }

  void onChangeFingerprint(bool value) async {
    if (value) {
      bool auth = await fingerPrintAuth();
      if (auth) {
        fingerprintState(value);
        UserStoreService.to.saveFingerprint(value);
      }
    } else {
      fingerprintState(value);
      UserStoreService.to.saveFingerprint(value);
    }
  }

  void onTapChangePin() => Get.toNamed(AppRoutes.PIN, arguments: true);

  Future<bool> checkBiometrics() async {
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      debugPrint('*****************');
      debugPrint(e.message);
      debugPrint('-----------------');
    }
    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

      if (availableBiometrics.contains(BiometricType.strong) && Platform.isAndroid) {
        return true;
      }
    }
    return false;
  }

  Future<bool> fingerPrintAuth() async {
    bool authenticated;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to proceed.',
        options: const AuthenticationOptions(
          sensitiveTransaction: false,
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint('*****************');
      debugPrint(e.message);
      debugPrint('-----------------');
      authenticated = false;
    }
    return authenticated;
  }
}
