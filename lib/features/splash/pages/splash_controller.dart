import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/features/splash/repository/splash_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  SplashController(this._repo);

  final SplashRepository _repo;
  CrossFadeState showState = CrossFadeState.showFirst;

  @override
  void onReady() {
    super.onReady();
    showState = CrossFadeState.showSecond;
    Future.delayed(const Duration(seconds: 3), () {
      Get.toNamed(AppRoutes.INTRO);
    });
  }
}
