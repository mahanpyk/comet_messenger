import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/widgets/fill_button_widget.dart';
import 'package:comet_messenger/features/widgets/outline_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AppDialog {
  AppDialog({
    required this.title,
    required this.subTitle,
    this.icon = AppIcons.icWarning,
    this.mainButtonOnTap,
    this.otherTask,
    this.otherTaskTitle,
    this.mainButtonTitle,
  });

  String title;
  String subTitle;
  String icon;
  VoidCallback? mainButtonOnTap;
  VoidCallback? otherTask;
  String? mainButtonTitle;
  String? otherTaskTitle;

  Future<void> showAppDialog() async {
    return Get.dialog(
      barrierDismissible: true,
      PopScope(
        canPop: false,
        child: AlertDialog(
          content: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SvgPicture.asset(icon),
              const SizedBox(height: 10),
              Text(
                title,
                style: Get.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                subTitle,
                style: Get.textTheme.bodyMedium!.copyWith(color: AppColors.tertiaryColor),
              ),
            ]),
          ),
          actions: [
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(
                width: double.infinity,
                height: 48,
              ),
              child: otherTask != null
                  ? Row(children: [
                      Expanded(
                        child: OutlineButtonWidget(
                          height: 36,
                          color: AppColors.tertiaryColor,
                          onTap: () => otherTask!(),
                          child: Text(
                            otherTaskTitle!,
                            style: Get.textTheme.labelLarge,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FillButtonWidget(
                          height: 36,
                          isLoading: false,
                          onTap: () => mainButtonOnTap == null ? Get.back() : mainButtonOnTap!(),
                          buttonTitle: mainButtonTitle ?? 'باشه',
                        ),
                      ),
                    ])
                  : FillButtonWidget(
                      height: 36,
                      isLoading: false,
                onTap: () => mainButtonOnTap == null ? Get.back() : mainButtonOnTap!(),
                buttonTitle: mainButtonTitle ?? 'باشه',
                    ),
            ),
          ],
          actionsPadding: const EdgeInsets.only(
            right: 24,
            left: 24,
            bottom: 24,
          ),
        ),
      ),
    );
  }
}
