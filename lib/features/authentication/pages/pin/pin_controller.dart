import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PinController extends GetxController {
  Rx<PageController> pageViewController = Rx(PageController());
  String? firstPin, secondPin, savePin;
  RxInt currentIndex = RxInt(0);
  RxBool showError = RxBool(false);
  RxBool incorrectPassword = RxBool(false);
  final FocusNode focusNode = FocusNode();
  final TextEditingController pinTEC = TextEditingController();
  RxBool fingerPrintEnabled = RxBool(false);
  // final LocalAuthentication auth = LocalAuthentication();
  bool deviceHasFingerPrint = false;

  @override
  void onInit() async {
    savePin = await UserStoreService.to.getPin();
    // fingerPrintEnabled(await UserStoreService.to.get(key: AppConstants.FINGER_PRINT) ?? false);
/*    checkBiometrics().then((isAvailable) {
      if (isAvailable) {
        deviceHasFingerPrint = true;
        print('Fingerprint authentication is supported.');
      } else {
        print('Fingerprint authentication not available.');
      }
    });*/
    super.onInit();
  }

/*  Future<bool> checkBiometrics() async {
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
  }*/

  @override
  void onReady() {
    // if (fingerPrintEnabled.value) {
    //   fingerPrintAuth();
    // } else {
      onTapPage();
    // }
    super.onReady();
  }

  Future<void> fingerPrintAuth() async {
    bool authenticated = false;
/*    try {
      authenticated = await auth.authenticate(
        localizedReason: 'لطفاً اثر انگشت خود را مطابقت دهید تا وارد شوید',
        options: const AuthenticatxionOptions(
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
    }*/
    if (authenticated) {
      if (await UserStoreService.to.getMnemonic() != null) {
        Get.offAndToNamed(AppRoutes.HOME);
      } else {
        Get.offAndToNamed(AppRoutes.AUTHENTICATION);
      }
    } else {
      onTapPage();
    }
  }

  void onTapPage() {
    const Duration(milliseconds: 200).delay(() {
      SystemChannels.textInput.invokeListMethod('TextInput.show');
      focusNode.requestFocus();
    });
  }

  void onChanged(String value) async {
    if (pageViewController.value.page == 0) {
      incorrectPassword(false);
      firstPin = value;
      currentIndex(value.length);
      if (value.length == 4) {
        if (savePin != null) {
          if (firstPin == savePin) {
            if (await UserStoreService.to.getMnemonic() != null) {
              Get.offAndToNamed(AppRoutes.HOME);
            } else {
              Get.offAndToNamed(AppRoutes.AUTHENTICATION);
            }
          } else {
            incorrectPassword(true);
            currentIndex(0);
            pinTEC.text = '';
          }
        } else {
          animatedToPage(1);
          currentIndex(0);
          pinTEC.text = '';
        }
      }
    } else {
      showError(false);
      secondPin = value;
      currentIndex(value.length);
      if (value.length == 4) {
        if (firstPin == secondPin) {
          UserStoreService.to.savePin(secondPin!);
          // if (deviceHasFingerPrint) {
          //   Get.offAndToNamed(AppRoutes.FINGER_PRINT);
          // } else {
            Get.offAndToNamed(AppRoutes.HOME);
          // }
        } else {
          showError(true);
          pinTEC.text = '';
          secondPin = '';
          currentIndex(0);
        }
      }
    }
  }

  void onTapBack() {
    animatedToPage(0);
    pinTEC.text = '';
    firstPin = '';
    secondPin = '';
    currentIndex(0);
    showError(false);
  }

  void animatedToPage(int pageNumber) {
    pageViewController.value.animateToPage(
      pageNumber,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }
}

class AuthenticationOptions {
  const AuthenticationOptions();
}
