import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    super.key,
    required this.title,
    this.balance,
    this.showBackButton = true,
    this.isLoading = false,
  });

  final String title;
  final double? balance;
  final bool showBackButton;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: Get.width,
      color: AppColors.primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: showBackButton ? BackButton(onPressed: () => Get.back()) : const SizedBox(),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  title,
                  style: Get.textTheme.titleLarge!.copyWith(color: AppColors.tertiaryColor),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: balance != null
                  ? isLoading
                      ? const SizedBox(
                          height: 32,
                          width: 32,
                          child: Align(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Center(
                          child: Text(
                            '${balance!.toStringAsFixed(9)} SOL',
                            textAlign: TextAlign.center,
                            style: Get.textTheme.bodySmall!.copyWith(color: AppColors.tertiaryColor),
                          ),
                        )
                  : const SizedBox(width: 40),
            )
          ],
        ),
      ),
    );
  }
}
