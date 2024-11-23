import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/features/authentication/pages/pin/pin_controller.dart';
import 'package:comet_messenger/features/authentication/widgets/pin_widget.dart';
import 'package:comet_messenger/features/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PinPage extends BaseView<PinController> {
  const PinPage({super.key});

  @override
  Widget body() {
    return PopScope(
      canPop: controller.isChangePin,
      child: Column(
        children: [
          if (controller.isChangePin) const AppBarWidget(title: 'Change Pin'),
          Expanded(
            child: Stack(
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: GestureDetector(
                    onTap: () => controller.onTapPage(),
                    child: PageView(
                      controller: controller.pageViewController.value,
                      pageSnapping: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        PinWidget(
                          title: controller.isChangePin ? 'change_pin_title'.tr : 'pin_title'.tr,
                          currentIndex: controller.currentIndex,
                          error: controller.showError,
                          showBackButton: false,
                          incorrectPassword: controller.incorrectPassword,
                        ),
                        PinWidget(
                          title: controller.isChangePin ? 'pin_title_new'.tr : 'pin_title_confirm'.tr,
                          currentIndex: controller.currentIndex,
                          error: controller.showError,
                          showBackButton: !controller.isChangePin,
                          onTapBack: () => controller.onTapBack(),
                          incorrectPassword: controller.incorrectPassword,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Offstage(
                    offstage: true,
                    child: TextField(
                      autofocus: true,
                      focusNode: controller.focusNode,
                      controller: controller.pinTEC,
                      keyboardType: TextInputType.number,
                      onChanged: (String value) => controller.onChanged(value),
                      maxLength: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget? floatingActionButton() {
    return controller.fingerPrintEnabled.value && !controller.isChangePin
        ? FloatingActionButton(
            onPressed: () => controller.fingerPrintAuth(),
            child: const Icon(Icons.fingerprint),
          )
        : null;
  }
}
