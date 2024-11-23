import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/authentication/pages/fingerprint/fingerprint_controller.dart';
import 'package:comet_messenger/features/widgets/fill_button_widget.dart';
import 'package:comet_messenger/features/widgets/outline_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FingerprintPage extends BaseView<FingerprintController> {
  const FingerprintPage({super.key});

  @override
  Widget body() {
    return PopScope(
      canPop: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            controller.isLoading.value ? const SizedBox() : const SizedBox(),
            const SizedBox(height: 40),
            Text(
              'Do you want to enable fingerprint?',
              style: Get.textTheme.headlineSmall,
            ),
            const SizedBox(height: 80),
            const Icon(
              Icons.fingerprint,
              size: 120,
            ),
            const Spacer(),
            OutlineButtonWidget(
              onTap: () => Get.offAndToNamed(AppRoutes.HOME),
              buttonTitle: 'No',
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 16),
            FillButtonWidget(
              onTap: () => controller.enableFingerPrint(),
              buttonTitle: 'YES',
            ),
            const SizedBox(height: 24)
          ],
        ),
      ),
    );
  }
}
