import 'package:comet_messenger/app/core/app_dialog.dart';
import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:comet_messenger/app/models/request_model.dart';
import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/features/home/models/balance_response_model.dart';
import 'package:comet_messenger/features/home/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  HomeController(this._repo);

  final HomeRepository _repo;
  PageController pageController = PageController();
  RxInt bottomNavigatorIndex = 0.obs;
  UserModel? userModel;
  RxDouble balance = RxDouble(0.0);
  RxBool isLoading = RxBool(true);

  @override
  void onInit() async {
    Future.delayed(const Duration(seconds: 1)).then((value) => getBalance());
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

  void getBalance() {
    isLoading(true);
    _repo
        .getBalance(
            requestModel: RequestModel(
      method: "getBalance",
      params: [userModel?.basePublicKey ?? ""],
      jsonrpc: "2.0",
      id: "b75758de-e0b2-469b-bd9c-ef366ee1b35a",
    ))
        .then((BalanceResponseModel response) {
      isLoading(false);
      if (response.statusCode == 200) {
        double userBalance = response.data!.result!.value! / 1000000000;
        balance(userBalance);
        UserStoreService.to.saveBalance(balance.value);
      }
    });
  }

  void onTapBottomNavigationItem({required int index}) {
    bottomNavigatorIndex(index);
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }
}
