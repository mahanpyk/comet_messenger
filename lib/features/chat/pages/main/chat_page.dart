import 'package:comet_messenger/app/core/app_enums.dart';
import 'package:comet_messenger/app/core/app_images.dart';
import 'package:comet_messenger/app/core/app_regex.dart';
import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/chat/pages/main/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ChatPage extends BaseView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget body() {
    return Column(
      children: [
        InkWell(
          onTap: () => controller.onTapChatHeader(),
          child: Container(
            height: kToolbarHeight,
            width: Get.width,
            color: AppColors.primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  BackButton(onPressed: () => Get.back()),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 1,
                        color: AppColors.tertiaryColor,
                      ),
                    ),
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    child: SvgPicture.asset(
                      controller.getAvatar(controller.conversationModel.value.avatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    controller.getUserName(),
                    style: Get.textTheme.titleLarge!.copyWith(color: AppColors.tertiaryColor),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                AppImages.imgChatBackgroundPage,
                fit: BoxFit.cover,
              ),
              Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.transparent,
                body: Column(
                  children: [
                    Expanded(
                      child: controller.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : Column(children: [
                              const SizedBox(height: 8),
                              Expanded(
                                child: ListView.builder(
                                  controller: controller.scrollController.value,
                                  itemCount: controller.chatDetailsModel.value.messages?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return massageItem(
                                      message: controller.chatMessages[index] ?? '',
                                      isMe: controller.chatDetailsModel.value.messages?[index].senderAddress == controller.userModel?.id,
                                      time: controller.chatDetailsModel.value.messages?[index].time ?? '',
                                      chatStatus:
                                          controller.getStatusIcon(controller.chatDetailsModel.value.messages![index].status ?? ChatStateEnum.SUCCESS.name),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                            ]),
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
                                onFieldSubmitted: (value) => controller.isTyping.value ? controller.sendMessage() : null,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    controller.isTyping.value = true;
                                  } else {
                                    controller.isTyping.value = false;
                                  }
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () => controller.isTyping.value ? controller.sendMessage() : null,
                              icon: Icon(
                                Icons.send,
                                color: AppColors.tertiaryColor.withOpacity(controller.isTyping.value ? 1.0 : 0.5),
                              ),
                            ),
                          ],
                        ),
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

  Widget massageItem({
    required String message,
    required bool isMe,
    required String time,
    required String chatStatus,
  }) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isMe ? AppColors.primaryColor.withOpacity(0.5) : AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        top: 8,
                        bottom: 8,
                      ),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: Get.width - 80),
                        child: Wrap(children: [
                          Text(
                            message,
                            style: Get.textTheme.bodyMedium!.copyWith(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.justify,
                            textDirection: message.contains(AppRegex.alphabetRegex) ? TextDirection.ltr : TextDirection.rtl,
                          ),
                        ]),
                      ),
                    ),
                    if (isMe)
                      SvgPicture.asset(
                        chatStatus,
                        width: 16,
                        height: 16,
                        color: AppColors.tertiaryColor,
                      ),
                    const SizedBox(width: 8)
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                controller.formatDate(time),
                style: Get.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool resizeToAvoidBottomInset() => false;
}
