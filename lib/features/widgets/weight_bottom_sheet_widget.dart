import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/widgets/fill_button_widget.dart';
import 'package:comet_messenger/features/widgets/outline_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeightBottomSheetWidget extends StatelessWidget {
  WeightBottomSheetWidget({
    super.key,
    required this.onTapSave,
    required this.title,
  });

  final void Function(String date) onTapSave;
  final RxInt selectedWeightKG = 90.obs;
  final RxInt selectedWeight = 0.obs;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Container(
                height: 4,
                width: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.tertiaryColor,
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  title,
                  style: Get.textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'بر اساس',
                              style: Get.textTheme.titleSmall,
                            ),
                            Text(
                              'کیلوگرم (KG)',
                              style: Get.textTheme.titleSmall,
                            ),
                          ]),
                    ),
                    const Divider(
                      height: 32,
                      thickness: 1,
                      color: AppColors.tertiaryColor,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                        height: 100,
                        width: 40,
                        child: CupertinoPicker(
                          backgroundColor: Colors.transparent,
                          onSelectedItemChanged: (value) =>
                              selectedWeight(value),
                          selectionOverlay: Container(
                            decoration: const BoxDecoration(
                              border: Border.symmetric(
                                horizontal:
                                    BorderSide(color: AppColors.primaryColor),
                              ),
                            ),
                          ),
                          looping: true,
                          itemExtent: 40.0,
                          children: List.generate(10, (index) => index)
                              .map(
                                (text) => Center(
                                  child: Text(
                                    text.toString(),
                                    style: Get.textTheme.titleSmall,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '.',
                        style: Get.textTheme.bodyLarge,
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 100,
                        width: 40,
                        child: CupertinoPicker(
                          scrollController:
                              FixedExtentScrollController(initialItem: 50),
                          backgroundColor: Colors.transparent,
                          onSelectedItemChanged: (value) =>
                              selectedWeightKG(value + 40),
                          selectionOverlay: Container(
                            decoration: const BoxDecoration(
                              border: Border.symmetric(
                                horizontal:
                                    BorderSide(color: AppColors.primaryColor),
                              ),
                            ),
                          ),
                          itemExtent: 40,
                          children: List.generate(121, (index) => index + 40)
                              .map(
                                (text) => Center(
                                  child: Text(
                                    text.toString(),
                                    style: Get.textTheme.titleSmall,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ]),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Row(children: [
                  Expanded(
                    child: OutlineButtonWidget(
                      onTap: () => Get.back(),
                      buttonTitle: 'بازگشت',
                      color: AppColors.tertiaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FillButtonWidget(
                      isLoading: false,
                      onTap: () => onTapSave(
                          '${selectedWeightKG.value}.${selectedWeight.value}'),
                      buttonTitle: 'ذخیره',
                    ),
                  ),
                ]),
              ),
            ]),
      ),
    );
  }
}
