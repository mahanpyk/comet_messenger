import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/login/pages/main/login_controller.dart';
import 'package:comet_messenger/features/widgets/fill_button_widget.dart';
import 'package:comet_messenger/features/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginPage extends BaseView<LoginController> {
  const LoginPage({super.key});

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
              // validator: (value) => controller.phoneNumberValidator(value: value),
              label: Text('login_text_field_label'.tr),
            ),
          ),
/*          const SizedBox(height: 24),
          Text(
            'login_avatar_title'.tr,
            style: Get.textTheme.headlineSmall,
          ),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 1.0,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return avatarItemWidget(
                index: index,
                isSelected: controller.selectedAvatarIndex.value == index,
                onTap: ({required int index}) => controller.onTapAvatar(index: index),
              );
            },
          ),*/
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

  Widget avatarItemWidget({
    required int index,
    required bool isSelected,
    required Function({required int index}) onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(index: index),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(
                  color: AppColors.redColor,
                  width: 2,
                )
              : null,
        ),
        child: SvgPicture.asset('${AppIcons.icUserAvatar}$index.svg'),
      ),
    );
  }
}
