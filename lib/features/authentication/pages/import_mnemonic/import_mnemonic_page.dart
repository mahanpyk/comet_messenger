import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/features/authentication/pages/import_mnemonic/import_mnemonic_controller.dart';
import 'package:comet_messenger/features/widgets/fill_button_widget.dart';
import 'package:comet_messenger/features/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImportMnemonicPage extends BaseView<ImportMnemonicController> {
  const ImportMnemonicPage({super.key});

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
              maxLines: 3,
            ),
          ]),
        ),
        FillButtonWidget(
          isLoading: controller.isLoading.value,
          onTap: () => controller.checkMnemonic(),
          buttonTitle: 'check mnemonic and import',
          enable: controller.enableButton.value,
        ),
      ]),
    );
  }
}
