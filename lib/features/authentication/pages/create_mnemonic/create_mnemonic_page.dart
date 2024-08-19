
import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/authentication/pages/create_mnemonic/create_mnemonic_controller.dart';
import 'package:comet_messenger/features/widgets/fill_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateMnemonicPage extends BaseView<CreateMnemonicController> {
  const CreateMnemonicPage({super.key});

  @override
  Widget body() {
    return Column(children: [
      IgnorePointer(
        ignoring: true,
        child: controller.isLoading.value ? SizedBox() : SizedBox(),
      ),
      Expanded(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(children: [
              Text(
                'Please copy your mnemonic words and store them in a safe place',
                style: Get.textTheme.titleLarge!.copyWith(color: AppColors.tertiaryColor),
              ),
              const SizedBox(height: 16),
              const Divider(
                height: 1,
                color: AppColors.tertiaryColor,
              ),
              const SizedBox(height: 24),
              // SizedBox(
              //   child: ListView.builder(
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     itemCount: controller.mnemonicWordsList.length,
              //     itemBuilder: (context, index) {
              //       return Text(
              //         '${index + 1} ${controller.mnemonicWordsList[index]}',
              //         style: Get.textTheme.titleMedium!.copyWith(color: AppColors.tertiaryColor),
              //       );
              //     },
              //   ),
              // ),
            ]),
          ),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.all(16),
        child: FillButtonWidget(
          buttonTitle: 'save and next',
          onTap: () => controller.onTapCopyAndNext(),
          isLoading: false,
          enable: true,
        ),
      ),
    ]);
  }
}
