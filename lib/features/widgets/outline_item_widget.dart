import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OutlineItemWidget extends StatelessWidget {
  const OutlineItemWidget({
    super.key,
    required this.title,
    required this.selected,
    this.onTap,
  });
  final String title;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1,
            color: selected ? AppColors.primaryColor : AppColors.tertiaryColor,
          ),
        ),
        child: Row(children: [
          Container(
            width: 20,
            height: 20,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: AppColors.tertiaryColor,
              ),
            ),
            child: selected
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primaryColor,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Get.textTheme.bodyMedium,
          ),
        ]),
      ),
    );
  }
}
