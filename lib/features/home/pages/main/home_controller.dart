import 'package:comet_messenger/app/core/app_dialog.dart';
import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/features/home/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  HomeController(this._repo);

  final HomeRepository _repo;
  PageController pageController = PageController();
  RxInt bottomNavigatorIndex = 0.obs;
  UserModel? userModel;

  @override
  void onInit() async {
    var arguments = Get.arguments;
    if (arguments != null) {
      if (arguments['showAirDropDialog']) {
        AppDialog dialog = AppDialog(
          title: 'Offer',
          subTitle: 'Do you want to claim your air drop?',
          mainButtonTitle: 'Claim',
          icon: AppIcons.icTwoCoins,
          mainButtonOnTap: () => Get.toNamed(AppRoutes.PROFILE),
          otherTask: () => Get.back(),
          otherTaskTitle: 'Cancel',
        );
        dialog.showAppDialog();
      }
    }
    super.onInit();
    var json = await UserStoreService.to.getUserModel();
    userModel = UserModel.fromJson(json!);
  }

  void onTapBack() {}

  void onTapBottomNavigationItem({required int index}) {
    bottomNavigatorIndex(index);
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }
}
