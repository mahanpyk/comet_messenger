import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/home/models/profile_borsh_model.dart';
import 'package:comet_messenger/features/home/pages/chat_list/chat_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ChatListPage extends BaseView<ChatListController> {
  const ChatListPage({super.key});

  @override
  Widget body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: controller.isLoading.value
                  ? ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: AppColors.shimmerBaseColor,
                          highlightColor: AppColors.shimmerHighlightColor,
                          child: const Card(
                            child: ListTile(),
                          ),
                        );
                      },
                    )
                  : controller.chatList.isEmpty
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_rounded, color: AppColors.tertiaryColor, size: 96),
                            SizedBox(
                              width: double.infinity,
                              height: 8,
                            ),
                            Text('Chat has not started yet!'),
                          ],
                        )
                      : RefreshIndicator(
                          onRefresh: () => controller.onRefresh(),
                          child: ListView.builder(
                            itemCount: controller.chatList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return chatItemWidget(item: controller.chatList[index]);
                            },
                          ),
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
    String icon = item.avatar != null ? item.avatar! : "0";
    try {
      int.parse(icon);
    } catch (e) {
      icon = "0";
    }
    return GestureDetector(
      onTap: () => controller.onTapTransactionDetail(item: item),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
          color: AppColors.backgroundSecondaryColor,
          child: ListTile(
            title: Text(
              item.conversationName?.replaceAll('${controller.userModel?.userName ?? ''}&_#', '').replaceAll('&_#${controller.userModel?.userName ?? ''}', '') ?? 'No title',
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
              '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour > 12 ? 'PM' : 'AM'}',
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
