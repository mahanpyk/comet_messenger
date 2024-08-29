import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/authentication/models/contact_model.dart';
import 'package:comet_messenger/features/constacts/pages/main/contacts_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ContactsPage extends BaseView<ContactsController> {
  const ContactsPage({super.key});

  @override
  Widget body() {
    return Column(
      children: [
        Container(
          height: 64,
          width: Get.width,
          color: AppColors.primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Center(
              child: Text(
                'Contacts',
                style: Get.textTheme.titleLarge!.copyWith(color: AppColors.tertiaryColor),
              ),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              if (controller.isLoading.value) const Center(child: CircularProgressIndicator()),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: controller.contacts.isEmpty
                          ? const Text('No Contacts yet!')
                          : ListView.builder(
                              itemCount: controller.contacts.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return chatItemWidget(item: controller.contacts[index]);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget chatItemWidget({required Contact item}) {
    String icon = item.avatar != null ? item.avatar! : "0";
    try {
      int.parse(icon);
    } catch (e) {
      icon = "0";
    }
    return GestureDetector(
      onTap: () => controller.showModalConfirmationCreateChat(item),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
          color: AppColors.backgroundSecondaryColor,
          child: ListTile(
            title: Text(
              item.userName ?? '',
              textAlign: TextAlign.left,
              style: Get.textTheme.titleLarge!.copyWith(color: AppColors.tertiaryColor),
            ),
            trailing: SvgPicture.asset(
              '${AppIcons.icUserAvatar}$icon.svg',
              height: 48,
              width: 48,
            ),
          ),
        ),
      ),
    );
  }
}
