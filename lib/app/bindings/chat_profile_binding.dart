import 'package:comet_messenger/features/chat/pages/chat_profile/chat_profile_controller.dart';
import 'package:get/get.dart';

class ChatProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatProfileController>(() => ChatProfileController());
  }
}
