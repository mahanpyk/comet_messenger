import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/widgets/fill_button_widget.dart';
import 'package:comet_messenger/features/widgets/outline_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeightBottomSheetWidget extends StatelessWidget {
  HeightBottomSheetWidget({
    super.key,
    required this.onTapSave,
  });
  final void Function(String date) onTapSave;
  final RxInt selectedHeight = 150.obs;

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
                  'قد',
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
                              'سانتی‌متر (CM)',
                              style: Get.textTheme.titleSmall,
                            ),
                          ]),
                    ),
                const Divider(
                  height: 32,
                      thickness: 1,
                      color: AppColors.tertiaryColor,
                    ),
                    SizedBox(
                      height: 100,
                      width: 40,
                      child: CupertinoPicker(
                        scrollController:
                            FixedExtentScrollController(initialItem: 50),
                        backgroundColor: Colors.transparent,
                        onSelectedItemChanged: (value) {
                          selectedHeight(value + 100);
                        },
                        selectionOverlay: Container(
                          decoration: const BoxDecoration(
                              border: Border.symmetric(
                                  horizontal:
                                      BorderSide(color: AppColors.primaryColor))),
                        ),
                        itemExtent: 40,
                        children: List.generate(101, (index) => index + 100)
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
                      onTap: () => onTapSave(selectedHeight.value.toString()),
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
