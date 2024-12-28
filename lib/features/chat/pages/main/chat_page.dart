import 'package:comet_messenger/app/core/app_enums.dart';
import 'package:comet_messenger/app/core/app_icons.dart';
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
                          : ListView.builder(
                              controller: controller.scrollController.value,
                              itemCount: controller.chatMessages.length,
                              itemBuilder: (context, index) {
                                if (controller.chatMessages[index]?.messageType == MassageTypeEnum.TEXT) {
                                  return massageItem(
                                    message: controller.chatMessages[index]?.text ?? '',
                                    isMe: controller.chatMessages[index]?.isMe ?? false,
                                    time: controller.chatMessages[index]?.time ?? '',
                                    chatStatus: controller.chatMessages[index]?.status ?? '',
                                  );
                                } else {
                                  if (controller.chatMessages[index]?.file != null) {
                                    if (controller.chatMessages[index]?.messageType == MassageTypeEnum.IMAGE) {
                                      return imageItem(
                                        isMe: controller.chatMessages[index]?.isMe ?? false,
                                        index: index,
                                        time: controller.chatMessages[index]?.time ?? '',
                                        chatStatus: controller.chatMessages[index]?.status ?? '',
                                      );
                                    } else {
                                      return fileItem(isMe: controller.chatMessages[index]?.isMe ?? false);
                                    }
                                  } else {
                                    return imageLoadingItem(isMe: controller.chatMessages[index]?.isMe ?? false);
                                  }
                                }
                              },
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
                                onFieldSubmitted: (value) => controller.isTyping.value ? controller.sendMessage() : null,
                                minLines: 1,
                                maxLines: 4,
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
                              onPressed: () => controller.selectFile(),
                              icon: const Icon(
                                Icons.attach_file,
                                color: AppColors.tertiaryColor,
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

  Widget imageItem({
    required bool isMe,
    required int index,
    required String time,
    required String chatStatus,
  }) {
    bool sending = chatStatus != AppIcons.icDoubleCheck;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                textDirection: isMe ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Container(
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ]),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.memory(
                            controller.chatMessages[index]!.file!,
                            width: 240,
                          ),
                          if (sending) const CircularProgressIndicator()
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => controller.saveImageToGallery(imageBytes: controller.chatMessages[index]!.file!),
                    icon: const CircleAvatar(child: Icon(Icons.download_for_offline_outlined, color: AppColors.tertiaryColor)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(children: [
                if (isMe)
                  SvgPicture.asset(
                    chatStatus,
                    width: 16,
                    height: 16,
                    color: AppColors.tertiaryColor,
                  ),
                const SizedBox(width: 8),
                Text(
                  controller.formatDate(time),
                  style: Get.textTheme.bodySmall,
                )
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget fileItem({required bool isMe}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            // onTap: () => controller.saveFile(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isMe ? AppColors.primaryColor.withValues(alpha: 0.7) : AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Download File',
                style: Get.textTheme.labelLarge!.copyWith(color: AppColors.tertiaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget imageLoadingItem({required bool isMe}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                const CircularProgressIndicator(),
                Text(
                  'loading image...',
                  style: Get.textTheme.labelLarge!.copyWith(color: AppColors.tertiaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
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
                    color: isMe ? AppColors.primaryColor.withValues(alpha: 0.7) : AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ]),
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
