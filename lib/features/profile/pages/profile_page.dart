import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/profile/pages/profile_controller.dart';
import 'package:comet_messenger/features/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProfilePage extends BaseView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget body() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 64,
            width: Get.width,
            color: AppColors.primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const SizedBox(width: 24),
                  Center(
                    child: Text(
                      'Profile',
                      style: Get.textTheme.titleLarge!
                          .copyWith(color: AppColors.tertiaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondaryColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.tertiaryColor,
                    spreadRadius: 0.1,
                    blurRadius: 8,
                  )
                ],
              ),
              child: Column(
                children: [
                  SvgPicture.asset(
                    '${AppIcons.icUserAvatar}${controller.userModel.value?.avatar ?? '0'}.svg',
                    height: 120,
                    width: 120,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.userModel.value?.userName ?? '',
                    style: Get.textTheme.bodyMedium!
                        .copyWith(color: AppColors.tertiaryColor),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Public Key',
                    style: Get.textTheme.bodyMedium!
                        .copyWith(color: AppColors.tertiaryColor),
                  ),
                  TextFormFieldWidget(
                    controller: controller.publicKeyTEC,
                    readOnly: true,
                    onTap: () => controller.onTapPublicKey(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
