import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key, required this.title});

  final String title;

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
            BackButton(onPressed: () => Get.back()),
            Center(
              child: Text(
                title,
                style: Get.textTheme.titleLarge!
                    .copyWith(color: AppColors.tertiaryColor),
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }
}
