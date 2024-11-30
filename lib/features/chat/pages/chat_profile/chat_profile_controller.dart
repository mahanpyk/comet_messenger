import 'package:comet_messenger/app/core/app_utils_mixin.dart';
import 'package:comet_messenger/features/chat/models/chat_details_borsh_model.dart';
import 'package:get/get.dart';

class ChatProfileController extends GetxController with AppUtilsMixin {
  RxBool isLoading = RxBool(false);
  Rx<ChatDetailsBorshModel> chatDetailsModel = Rx(ChatDetailsBorshModel());
  late final String avatar;
  late final String userName;

  @override
  void onInit() async {
    var args = Get.arguments;
    if (args != null) {
      chatDetailsModel(ChatDetailsBorshModel.fromJson(args['chatDetailModel']));
      avatar = args['avatar'] ?? '0';
      userName = args['userName'] ?? 'No title';
    }
    super.onInit();
  }
}
