import 'package:comet_messenger/app/core/app_utils_mixin.dart';
import 'package:comet_messenger/features/chat/models/chat_details_borsh_model.dart';
import 'package:get/get.dart';

class ChatProfileController extends GetxController with AppUtilsMixin {
  RxBool isLoading = RxBool(false);
  ChatDetailsBorshModel chatDetailsModel = ChatDetailsBorshModel();
  late final String avatar;

  @override
  void onInit() async {
    var args = Get.arguments;
    if (args != null) {
      chatDetailsModel = ChatDetailsBorshModel.fromJson(args['chatDetailModel']);
      avatar = args['avatar'] ?? '0';
    }
    super.onInit();
  }
}
