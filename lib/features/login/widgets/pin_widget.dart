
import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:comet_messenger/app/core/app_images.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PinWidget extends StatelessWidget {
  const PinWidget({
    super.key,
    required this.title,
    required this.error,
    required this.currentIndex,
    required this.showBackButton,
    this.onTapBack,
    required this.incorrectPassword,
  });

  final String title;
  final RxBool error;
  final RxInt currentIndex;
  final bool showBackButton;
  final RxBool incorrectPassword;
  final VoidCallback? onTapBack;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        showBackButton
            ? Column(children: [
                Row(children: [
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: SvgPicture.asset(
                        AppIcons.icBack,
                        width: 32,
                        height: 32,
                      ),
                    ),
                    onTap: () => onTapBack!(),
                  ),
                ]),
                const SizedBox(height: 40)
              ])
            : const SizedBox(height: 96),
        Text(
          title,
          style: Get.textTheme.headlineSmall,
        ),
        const SizedBox(height: 48),
        SizedBox(
          height: 16,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Row(children: [
                  Container(
                    alignment: Alignment.center,
                    width: 16,
                    child: Obx(() {
                      return index >= currentIndex.value
                          ? SvgPicture.asset(
                              AppIcons.icPinCircle,
                              height: 16,
                              width: 16,
                            )
                          : Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.primaryColor,
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                            );
                    }),
                  ),
                  index < 3 ? const SizedBox(width: 21) : Container(),
                ]);
              },
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 4,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Obx(() {
          return AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            firstCurve: Curves.linear,
            crossFadeState: incorrectPassword.value || error.value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: SizedBox(
              child: Text(
                incorrectPassword.value ? 'رمز امنیتی وارد شده نادرست است' : 'رمز های امنیتی وارد شده مطابقت ندارند',
                style: Get.textTheme.bodySmall!.copyWith(color: AppColors.errorColor),
              ),
            ),
            secondChild: Container(),
          );
        }),
        const SizedBox(height: 16),
      ]),
    );
  }

  Widget pinInputCircle() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryColor,
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 0),
          ),
        ],
      ),
    );
  }
}
