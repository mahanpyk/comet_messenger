import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/features/splash/repository/splash_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  SplashController(this._repo);

  final SplashRepository _repo;
  CrossFadeState showState = CrossFadeState.showFirst;
  UserModel? userModel;

  @override
  void onReady() {
    super.onReady();
    showState = CrossFadeState.showSecond;
    Future.delayed(const Duration(seconds: 3), () async {
      var json = await UserStoreService.to.getUserModel();
      if (json != null) {
        userModel = UserModel.fromJson(json);
      }

      if (userModel != null && userModel!.basePublicKey != null) {
        Get.toNamed(AppRoutes.HOME);
      } else {
        Get.toNamed(AppRoutes.INTRO);
      }
    });
  }
}
