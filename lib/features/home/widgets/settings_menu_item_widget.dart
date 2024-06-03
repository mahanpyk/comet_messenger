import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SettingsMenuItemWidget extends StatelessWidget {
  const SettingsMenuItemWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(children: [
          SvgPicture.asset(icon),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: Get.textTheme.bodyMedium,
            ),
          ),
          SvgPicture.asset(AppIcons.icNavigate),
        ]),
      ),
    );
  }
}
