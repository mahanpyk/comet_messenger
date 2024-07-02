import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/home/models/profile_borsh_model.dart';
import 'package:comet_messenger/features/home/pages/chat/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ChatPage extends BaseView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: controller.chatList.isEmpty
                  ? const Text('No Chat yet!')
                  : ListView.builder(
                      itemCount: controller.chatList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return chatItemWidget(item: controller.chatList[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget? floatingActionButton() {
    return FloatingActionButton(
      backgroundColor: AppColors.primaryColor,
      onPressed: () => controller.contactsPage(),
      child: const Icon(Icons.add),
    );
  }

  Widget chatItemWidget({required ConversationBorshModel item}) {
    return GestureDetector(
      // onTap: () => controller.onTapTransactionDetail(item.signature!),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
          color: AppColors.backgroundSecondaryColor,
          child: ListTile(
            title: Text(
              item.conversationName?.replaceAll('moshtagh2&_#', '').replaceAll('&_#moshtagh2', '') ?? 'No title',
              textAlign: TextAlign.left,
              style: Get.textTheme.titleLarge!.copyWith(color: AppColors.tertiaryColor),
            ),
            subtitle: Text(
              'Last message',
              textAlign: TextAlign.left,
              style: Get.textTheme.bodySmall!.copyWith(color: AppColors.tertiaryColor),
            ),
            leading: Text(
              // just show hour and minute for example 12:00 AM or PM
              '${DateTime.now().hour}:${DateTime.now().minute}',
            ),
            trailing: SvgPicture.asset(
              '${AppIcons.icUserAvatar}${item.avatar ?? '0'}.svg',
              height: 48,
              width: 48,
            ),
          ),
        ),
      ),
    );
  }
}
