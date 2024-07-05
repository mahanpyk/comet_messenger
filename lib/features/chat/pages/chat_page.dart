import 'package:comet_messenger/features/chat/pages/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:comet_messenger/app/core/base/base_view.dart';

class ChatPage extends BaseView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget body() {
    return Column(
      children: [
        Offstage(
          offstage: true,
          child: Text(controller.test.value),
        ),
        // sample chat page
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return const Text('sample chat');
            },
          ),
        ),
      ],
    );
  }
}
