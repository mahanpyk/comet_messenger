import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/home/pages/chat/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:get/get.dart';

class ChatPage extends BaseView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget body() {
    return Center(
      child: Text(
        controller.title.value,
        style: Get.textTheme.titleLarge,
      ),
    );
  }

  @override
  Widget? floatingActionButton() {
    return FloatingActionButton(
      backgroundColor: AppColors.primaryColor,
      onPressed: () {},
      child: const Icon(Icons.add),
    );
  }
}
