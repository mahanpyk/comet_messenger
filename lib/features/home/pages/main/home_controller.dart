import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/models/request_model.dart';
import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/features/home/repository/home_repository.dart';
import 'package:comet_messenger/features/authentication/models/balance_response_model.dart';
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
