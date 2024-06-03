import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/intro/pages/intro_controller.dart';
import 'package:comet_messenger/features/widgets/fill_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class IntroPage extends BaseView<IntroController> {
  const IntroPage({super.key});

  @override
  Widget body() {
    return Column(children: [
      Expanded(
        child: SizedBox(
          width: Get.width,
          child: PageView.builder(
            controller: controller.pageController,
            onPageChanged: (value) => controller.onChangeIndex(value: value),
            reverse: true,
            physics: const BouncingScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: introBodyWidget(
                  index: index,
                  title: "intro_title_${index + 1}".tr,
                  description: "intro_description_${index + 1}".tr,
                ),
              );
            },
          ),
        ),
      ),
      AnimatedCrossFade(
        firstChild: Padding(
          padding: const EdgeInsets.all(24),
          child: FillButtonWidget(
            isLoading: false,
            onTap: () => controller.onTapLoginAppButton(),
            buttonTitle: 'intro_button'.tr,
          ),
        ),
        secondChild: Align(
          alignment: Alignment.bottomCenter,
          child: rowStepsCircle(controller.index.value),
        ),
        crossFadeState: controller.index.value == 4 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 150),
      ),
    ]);
  }

  Widget introBodyWidget({
    required int index,
    required String title,
    required String description,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 240),
        Text(
          title,
          style: Get.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 24),
        Text(
          description,
          style: Get.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w400,
            color: AppColors.tertiaryColor.withOpacity(0.3),
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget rowStepsCircle(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 42),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [for (var i = 0; i < 5; i++) circleItem(i, index)],
      ),
    );
  }

  Widget circleItem(int i, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: 6,
      height: 6,
      curve: Curves.ease,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: i == index ? AppColors.primaryColor : AppColors.primaryColor.withOpacity(0.3),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
