import 'package:comet_messenger/app/core/app_utils_mixin.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/chat/models/chat_details_borsh_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

  void showQrCodeLargeSize(UserBorshModel item) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(item.userName ?? ""),
              const SizedBox(height: 16),
              QrImageView(
                data: item.userAddress ?? "",
                version: QrVersions.auto,
                size: 256,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Copied',
      'Public key copied to clipboard',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.successColor,
    );
  }
}
