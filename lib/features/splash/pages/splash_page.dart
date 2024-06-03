import 'package:comet_messenger/app/core/app_images.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/splash/pages/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  final SplashController controller = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedOpacity(
            duration: const Duration(seconds: 1, milliseconds: 500),
            opacity: controller.showState == CrossFadeState.showFirst ? 0.0 : 1.0,
            child: Image.asset(
              AppImages.imgLogo,
              width: 150,
            ),
          ),
          SizedBox(
            height: 8,
            width: Get.width,
          ),
          AnimatedCrossFade(
            duration: const Duration(seconds: 1),
            crossFadeState: controller.showState,
            secondCurve: Curves.fastLinearToSlowEaseIn,
            firstChild: const SizedBox(),
            secondChild: Text(
              'splash_title'.tr,
              style: Get.textTheme.displayLarge!.copyWith(color: AppColors.tertiaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
