import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroController extends GetxController {
  final PageController pageController = PageController();

  RxInt index = RxInt(0);

  void onChangeIndex({required int value}) {
    index.value = value;
  }

  void onTapLoginAppButton() {
    Get.toNamed(AppRoutes.LOGIN);
  }
}
