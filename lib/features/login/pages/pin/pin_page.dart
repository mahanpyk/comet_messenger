
import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/features/login/pages/pin/pin_controller.dart';
import 'package:comet_messenger/features/login/widgets/pin_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PinPage extends BaseView<PinController> {
  const PinPage({super.key});

  @override
  Widget body() {
    return PopScope(
      canPop: false,
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
                    title: 'pin_title'.tr,
                    currentIndex: controller.currentIndex,
                    error: controller.showError,
                    showBackButton: false,
                    incorrectPassword: controller.incorrectPassword,
                  ),
                  PinWidget(
                    title: 'pin_title_confirm'.tr,
                    currentIndex: controller.currentIndex,
                    error: controller.showError,
                    showBackButton: true,
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
    );
  }

/*  Widget? floatingActionButton() {
    return controller.fingerPrintEnabled.value
        ? FloatingActionButton(
            onPressed: () => controller.fingerPrintAuth(),
            child: const Icon(Icons.fingerprint),
          )
        : null;
  }*/
}
