import 'package:comet_messenger/features/home/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  HomeController();

  PageController pageController = PageController();
  RxInt bottomNavigatorIndex = 0.obs;

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
