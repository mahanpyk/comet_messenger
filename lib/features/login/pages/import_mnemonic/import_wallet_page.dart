import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/login/pages/import_mnemonic/import_wallet_controller.dart';
import 'package:comet_messenger/features/widgets/fill_button_widget.dart';
import 'package:comet_messenger/features/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImportWalletPage extends BaseView<ImportWalletController> {
  const ImportWalletPage({super.key});

  @override
  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        Expanded(
          child: Column(children: [
            const SizedBox(height: 80),
            Text(
              'please enter your mnemonic',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: 40),
            TextFormFieldWidget(
              controller: controller.importMnemonicTEC,
              keyboardType: TextInputType.text,
              label: const Text('enter mnemonic'),
              onChanged: (text) => controller.onChanged(text),
            ),
          ]),
        ),
        FillButtonWidget(
          isLoading: controller.isLoading.value,
          onTap: () => controller.checkMnemonic(),
          buttonTitle: 'check mnemonic and import',
          enable: controller.enableButton.value,
        ),
/*        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          firstCurve: Curves.linear,
          crossFadeState: controller.showError.value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: SizedBox(
            child: Text(
              'رمز های امنیتی وارد شده مطابقت ندارند',
              style: Get.textTheme.bodySmall!.copyWith(color: AppColors.textErrorColor),
            ),
          ),
          secondChild: Container(),
        )*/
      ]),
    );
  }
}
