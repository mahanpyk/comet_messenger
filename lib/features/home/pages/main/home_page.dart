import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/home/pages/chat_list/chat_list_page.dart';
import 'package:comet_messenger/features/home/pages/main/home_controller.dart';
import 'package:comet_messenger/features/home/pages/settings/settings_page.dart';
import 'package:comet_messenger/features/home/pages/wallet/wallet_page.dart';
import 'package:comet_messenger/features/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomePage extends BaseView<HomeController> {
  const HomePage({super.key});

  @override
  Widget body() {
    return Column(children: [
      AppBarWidget(
        title: 'splash_title'.tr,
        showBackButton: false,
        balance: controller.balance.value,
        isLoading: controller.isLoading.value,
        userName: controller.userModel?.userName,
        avatar: controller.userModel?.avatar,
      ),
      Expanded(
        child: PageView(controller: controller.pageController, physics: const NeverScrollableScrollPhysics(), children: const [
          ChatListPage(),
          WalletPage(),
          SettingsPage(),
        ]),
      ),
      SnakeNavigationBar.color(
        height: 64,
        behaviour: SnakeBarBehaviour.floating,
        snakeShape: SnakeShape.circle,
        backgroundColor: AppColors.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        padding: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
        snakeViewColor: Colors.black,
        selectedItemColor: Colors.black,
        unselectedItemColor: AppColors.tertiaryColor,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        selectedLabelStyle: const TextStyle(color: AppColors.primaryColor),
        elevation: 4,
        currentIndex: controller.bottomNavigatorIndex.value,
        onTap: (index) => controller.onTapBottomNavigationItem(index: index),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.icChatInactive,
              color: AppColors.tertiaryColor,
              width: 24,
              height: 24,
            ),
            label: 'chat_title'.tr,
            activeIcon: SvgPicture.asset(
              AppIcons.icChatInactive,
              color: AppColors.primaryColor,
              width: 24,
              height: 24,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.icDashboardInactive,
              color: AppColors.tertiaryColor,
            ),
            label: 'assets_title'.tr,
            activeIcon: SvgPicture.asset(
              AppIcons.icDashboardActive,
              color: AppColors.primaryColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.icSettingsInactive,
              color: AppColors.tertiaryColor,
              height: 24,
            ),
            label: 'settings_title'.tr,
            activeIcon: SvgPicture.asset(
              AppIcons.icSettingsActive,
              color: AppColors.primaryColor,
              height: 24,
            ),
          ),
        ],
      ),
    ]);
  }
}
