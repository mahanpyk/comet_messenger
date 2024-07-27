import 'package:comet_messenger/app/core/app_images.dart';
import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/chat/pages/chat_controller.dart';
import 'package:comet_messenger/features/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends BaseView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget body() {
    return Column(
      children: [
        AppBarWidget(
            title: controller.conversationModel.conversationName
                    ?.replaceAll(
                        '${controller.userModel?.userName ?? ''}&_#', '')
                    .replaceAll(
                        '&_#${controller.userModel?.userName ?? ''}', '') ??
                'No title'),
        Expanded(
          child: Stack(
            children: [
              SizedBox(
                width: Get.width,
                child: Image.asset(
                  AppImages.imgChatBackgroundPage,
                  fit: BoxFit.fill,
                ),
              ),
              controller.isLoading.value
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                  : Column(
                      children: [
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount:
                                controller.chatDetailsModel.messages?.length ??
                                    0,
                            itemBuilder: (context, index) {
                              if (controller
                                      .chatDetailsModel.messages?[index].name ==
                                  controller.userModel?.userName) {
                                return massageItem(
                                  message: controller.chatDetailsModel
                                          .messages?[index].text ??
                                      '',
                                  isMe: true,
                                );
                              } else {
                                return massageItem(
                                  message: controller.chatDetailsModel
                                          .messages?[index].text ??
                                      '',
                                  isMe: false,
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
            ],
          ),
        ),
        Container(
          height: 64,
          width: Get.width,
          color: AppColors.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.messageTEC,
                    decoration: const InputDecoration(
                      hintText: 'Message',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => controller.sendMessage(),
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget massageItem({required String message, required bool isMe}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: isMe
                    ? AppColors.primaryColor.withOpacity(0.5)
                    : AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(message),
            ),
          ),
        ],
      ),
    );
  }
}
