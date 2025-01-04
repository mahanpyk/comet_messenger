import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/home/pages/main/home_controller.dart';
import 'package:comet_messenger/features/profile/pages/profile_controller.dart';
import 'package:comet_messenger/features/widgets/fill_button_widget.dart';
import 'package:comet_messenger/features/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfilePage extends BaseView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: 64,
          width: Get.width,
          color: AppColors.primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(onPressed: () => Get.back()),
                Center(
                  child: Text(
                    'Profile',
                    style: Get.textTheme.titleLarge!.copyWith(color: AppColors.tertiaryColor),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondaryColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.tertiaryColor,
                          spreadRadius: 0.1,
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            '${AppIcons.icUserAvatar}${controller.userModel.value?.avatar != "" ? controller.userModel.value?.avatar ?? '0' : '0'}.svg',
                            height: 120,
                            width: 120,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            controller.userModel.value?.userName ?? '',
                            style: Get.textTheme.bodyMedium!.copyWith(
                              color: AppColors.tertiaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Balance',
                            style: Get.textTheme.bodyMedium!.copyWith(
                              color: AppColors.tertiaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${Get.find<HomeController>().balanceString}',
                            textAlign: TextAlign.center,
                            style: Get.textTheme.titleMedium!.copyWith(color: AppColors.tertiaryColor),
                          ),
                          const SizedBox(height: 24),
                          FillButtonWidget(
                            onTap: () => controller.airDropRequest(),
                            buttonTitle: 'AirDrop',
                            isLoading: controller.isLoading.value,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Text(
                                'Public Key',
                                style: Get.textTheme.bodyMedium!.copyWith(
                                  color: AppColors.tertiaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormFieldWidget(
                            controller: controller.publicKeyTEC,
                            readOnly: true,
                            onTap: () => controller.onTapPublicKey(),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),
                          QrImageView(
                            data: controller.publicKeyTEC.text,
                            version: QrVersions.auto,
                            size: 200,
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: FillButtonWidget(
            isLoading: false,
            onTap: () => controller.onTapShowMnemonicAndPrivate(),
            buttonTitle: 'Show Mnemonic And Private Key',
          ),
        ),
      ],
    );
  }
}
