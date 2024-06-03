import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/home/pages/chat/chat_page.dart';
import 'package:comet_messenger/features/home/pages/main/home_controller.dart';
import 'package:comet_messenger/features/home/pages/settings/settings_page.dart';
import 'package:comet_messenger/features/home/pages/wallet/wallet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomePage extends BaseView<HomeController> {
  const HomePage({super.key});

  @override
  Widget body() {
    return Column(children: [
      Container(
        height: 64,
        width: Get.width,
        color: AppColors.primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Center(
            child: Text(
              'splash_title'.tr,
              style: Get.textTheme.titleLarge!.copyWith(color: AppColors.tertiaryColor),
            ),
          ),
        ),
      ),
      Expanded(
        child: PageView(controller: controller.pageController, physics: const NeverScrollableScrollPhysics(), children: const [
          ChatPage(),
          ChatPage(),
          WalletPage(),
          SettingsPage(),
        ]),
      ),
/*      BottomNavigationBar(
          currentIndex: controller.bottomNavigatorIndex.value,
          selectedIconTheme: const IconThemeData(
            color: AppColors.primaryColor,
          ),
          unselectedIconTheme: const IconThemeData(color: AppColors.tertiaryColor),
          onTap: (index) => controller.onTapBottomNavigationItem(index: index),
          showUnselectedLabels: true,
          unselectedItemColor: AppColors.tertiaryColor,
          selectedItemColor: AppColors.primaryColor,
          selectedLabelStyle: Get.textTheme.labelSmall,
          unselectedLabelStyle: Get.textTheme.labelSmall,
          enableFeedback: false,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppIcons.icDashboardInactive),
              label: 'assets_title'.tr,
              activeIcon: SvgPicture.asset(AppIcons.icDashboardActive),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.icChatInactive,
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
              icon: SvgPicture.asset(AppIcons.icProfileInactive),
              label: 'profile_title',
              activeIcon: SvgPicture.asset(AppIcons.icProfileActive),
            ),
          ])*/
      SnakeNavigationBar.color(
        height: 64,
        behaviour: SnakeBarBehaviour.floating,
        snakeShape: SnakeShape.circle,
        backgroundColor: AppColors.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(16),
        snakeViewColor: Colors.black,
        selectedItemColor: Colors.black,
        unselectedItemColor: AppColors.tertiaryColor,
        showUnselectedLabels: false,
        showSelectedLabels: false,
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
              AppIcons.icProfileInactive,
              color: AppColors.tertiaryColor,
            ),
            label: 'profile_title',
            activeIcon: SvgPicture.asset(
              AppIcons.icProfileActive,
              color: AppColors.primaryColor,
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
              AppIcons.icProfileInactive,
              color: AppColors.tertiaryColor,
            ),
            label: 'profile_title',
            activeIcon: SvgPicture.asset(
              AppIcons.icProfileActive,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    ]);
  }
}
