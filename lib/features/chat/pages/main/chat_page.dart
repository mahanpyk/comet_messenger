import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:comet_messenger/app/core/app_images.dart';
import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/chat/pages/main/chat_controller.dart';
import 'package:comet_messenger/features/widgets/app_bar_widget.dart';
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
          child: AppBarWidget(
              title: controller.conversationModel.conversationName
                      ?.replaceAll('${controller.userModel?.userName ?? ''}&_#', '')
                      .replaceAll('&_#${controller.userModel?.userName ?? ''}', '') ??
                  'No title'),
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                AppImages.imgChatBackgroundPage,
                fit: BoxFit.fitWidth,
              ),
              controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            controller: controller.scrollController.value,
                            itemCount: controller.chatDetailsModel.value.messages?.length ?? 0,
                            itemBuilder: (context, index) {
                              return massageItem(
                                message: controller.chatMessages[index],
                                isMe: controller.chatDetailsModel.value.messages?[index].senderAddress == controller.userModel?.id,
                                time: controller.chatDetailsModel.value.messages?[index].time ?? '',
                                doubleCheck: controller.chatDetailsModel.value.messages?[index].status == 'success',
                                failed: controller.chatDetailsModel.value.messages?[index].status == 'failed',
                              );
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
    );
  }

  Widget massageItem({
    required String message,
    required bool isMe,
    required String time,
    required bool doubleCheck,
    bool failed = false,
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
                        child: Wrap(
                          children: [
                            Text(
                              message,
                              style: Get.textTheme.bodyMedium!.copyWith(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.justify,
                              textDirection: message.contains(RegExp(r'[a-zA-Z]')) ? TextDirection.ltr : TextDirection.rtl,
                            ),
                          ],
                        ),
                      ),
                    ),
                    failed
                        ? const Icon(
                            Icons.error_outline,
                            color: AppColors.errorColor,
                            size: 12,
                          )
                        : SvgPicture.asset(
                            doubleCheck ? AppIcons.icDoubleCheck : AppIcons.icCheck,
                            width: 16,
                            height: 16,
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
}
