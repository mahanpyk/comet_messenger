import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/home/pages/chat_list/chat_list_controller.dart';
import 'package:comet_messenger/features/home/widgets/chat_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatListPage extends BaseView<ChatListController> {
  const ChatListPage({super.key});

  @override
  Widget body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: controller.isLoading.value
          ? SingleChildScrollView(
              child: ListView.builder(
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
              ),
            )
          : controller.chatList.isEmpty
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_rounded,
                      color: AppColors.tertiaryColor,
                      size: 96,
                    ),
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
                      return ChatItemWidget(
                        conversationBorshModel: controller.chatList[index],
                        userName: controller.userModel?.userName ?? '',
                        avatar: controller.getAvatar(controller.chatList[index].avatar),
                        onTapItem: () => controller.onTapTransactionDetail(item: controller.chatList[index]),
                      );
                    },
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
}
