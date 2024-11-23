import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/features/security/pages/security_controller.dart';
import 'package:comet_messenger/features/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecurityPage extends BaseView<SecurityController> {
  const SecurityPage({super.key});

  @override
  Widget body() {
    return Column(
      children: [
        const AppBarWidget(title: 'Security'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            const SizedBox(height: 8),
            if (controller.deviceHasFingerPrint.value)
              Column(
                children: [
                  ListTile(
                    title: Text(
                      'Fingerprint',
                      style: Get.textTheme.bodyMedium,
                    ),
                    trailing: Switch(
                      value: controller.fingerprintState.value,
                      onChanged: (value) => controller.onChangeFingerprint(value),
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ListTile(
              title: Text('Change Pin', style: Get.textTheme.bodyMedium),
              onTap: () => controller.onTapChangePin(),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            )
          ]),
        )
      ],
    );
  }
}
