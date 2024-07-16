import 'package:comet_messenger/features/chat/pages/chat_controller.dart';
import 'package:comet_messenger/features/chat/repository/chat_repository.dart';
import 'package:get/get.dart';

class ChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatRepository>(() => ChatRepositoryImpl());
    Get.lazyPut<ChatController>(() => ChatController(Get.find<ChatRepository>()));
  }
}
