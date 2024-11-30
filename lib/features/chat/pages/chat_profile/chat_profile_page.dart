import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/chat/models/chat_details_borsh_model.dart';
import 'package:comet_messenger/features/chat/pages/chat_profile/chat_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ChatProfilePage extends BaseView<ChatProfileController> {
  const ChatProfilePage({super.key});

  @override
  Widget body() {
    return Column(
      children: [
        IgnorePointer(
          ignoring: true,
          child: controller.isLoading.value ? const SizedBox() : const SizedBox(),
        ),
        Container(
          width: Get.width,
          color: AppColors.primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [BackButton(onPressed: () => Get.back())]),
              ),
              const SizedBox(height: 16),
              SvgPicture.asset(
                controller.avatar,
                height: 120,
                width: 120,
              ),
              const SizedBox(height: 24),
              Text(
                controller.userName,
                style: Get.textTheme.titleLarge!.copyWith(color: AppColors.tertiaryColor),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                "info",
                style: Get.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListView.separated(
                  itemCount: controller.chatDetailsModel.value.members?.length ?? 0,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return profileMembers(item: controller.chatDetailsModel.value.members![index]);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(height: 24);
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget profileMembers({required UserBorshModel item}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.userName ?? ""),
              const SizedBox(height: 8),
              Text(
                item.userAddress ?? "",
                style: Get.textTheme.bodyMedium,
                maxLines: 2,
              )
            ],
          ),
        ),
        const SizedBox(width: 16),
        QrImageView(
          data: item.userAddress ?? "",
          version: QrVersions.auto,
          size: 64,
          backgroundColor: Colors.white,
        ),
      ],
    );
  }
}
