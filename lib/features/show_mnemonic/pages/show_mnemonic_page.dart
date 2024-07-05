import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/show_mnemonic/pages/show_mnemonic_controller.dart';
import 'package:comet_messenger/features/widgets/fill_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowMnemonicPage extends BaseView<ShowMnemonicController> {
  const ShowMnemonicPage({super.key});

  @override
  Widget body() {
    return Column(children: [
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
                  'Mnemonic',
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
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(children: [
                Text(
                  'Please save this phrase in a safe place:',
                  style: Get.textTheme.titleLarge!.copyWith(color: AppColors.tertiaryColor),
                ),
                const SizedBox(height: 16),
                const Divider(
                  height: 1,
                  color: AppColors.tertiaryColor,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.mnemonicWordsList.length,
                    itemBuilder: (context, index) {
                      return Text(
                        '${index + 1} ${controller.mnemonicWordsList[index]}',
                        style: Get.textTheme.titleMedium!.copyWith(color: AppColors.tertiaryColor),
                      );
                    },
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16),
        child: FillButtonWidget(
          buttonTitle: 'Save to ClipBoard',
          onTap: () => controller.onTapCopyAndNext(),
          isLoading: false,
          enable: true,
        ),
      ),
    ]);
  }
}
