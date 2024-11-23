
import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/home/pages/settings/settings_controller.dart';
import 'package:comet_messenger/features/home/widgets/settings_menu_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends BaseView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget body() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Image.asset(AppImages.imgAssetsPage),
          Offstage(
            offstage: true,
            child: Text(controller.test.value),
          ),
          const SizedBox(height: 48),
          SettingsMenuItemWidget(
            title: 'profile',
            icon: AppIcons.icProfileInactive,
            onTap: () => controller.onTapProfile(),
          ),
          SettingsMenuItemWidget(
            title: 'Security',
            icon: AppIcons.icLock,
            onTap: () => controller.onTapSecurity(),
          ), SettingsMenuItemWidget(
            title: 'Theme',
            icon: AppIcons.icLock,
            onTap: () => controller.onTapTheme(),
          ),
          const Divider(
            color: AppColors.whiteColor,
            height: 1,
          ),
          SettingsMenuItemWidget(
            title: 'settings_sign_out'.tr,
            icon: AppIcons.icSignOut,
            onTap: () => controller.onTapSignOut(),
          ),
        ],
      ),
    );
  }
}
