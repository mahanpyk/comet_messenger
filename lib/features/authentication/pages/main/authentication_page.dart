import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/features/authentication/pages/main/authentication_controller.dart';
import 'package:comet_messenger/features/widgets/fill_button_widget.dart';
import 'package:comet_messenger/features/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationPage extends BaseView<AuthenticationController> {
  const AuthenticationPage({super.key});

  @override
  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'login_title'.tr,
            style: Get.textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          Form(
            key: controller.formKey,
            child: TextFormFieldWidget(
              controller: controller.phoneNumberTEC,
              keyboardType: TextInputType.text,
              onChanged: (value) => controller.onChangeUserName(value: value),
              validator: (value) => controller.isValid.value ? null : 'login_text_field_error'.tr,
              label: Text('login_text_field_label'.tr),
            ),
          ),
          const SizedBox(height: 24),
          FillButtonWidget(
            buttonTitle: 'login_button'.tr,
            onTap: () => controller.onTapLogin(),
            isLoading: controller.isLoading.value,
            enable: controller.isEnableConfirmButton.value,
          ),
        ],
      ),
    );
  }
}
