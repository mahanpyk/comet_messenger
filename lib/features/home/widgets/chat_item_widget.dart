import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/home/models/profile_borsh_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ChatItemWidget extends StatelessWidget {
  const ChatItemWidget({
    super.key,
    required this.conversationBorshModel,
    required this.onTapItem,
    required this.userName,
    required this.avatar,
  });

  final ConversationBorshModel conversationBorshModel;
  final VoidCallback onTapItem;
  final String userName, avatar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapItem(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
          color: AppColors.backgroundSecondaryColor,
          child: ListTile(
            title: Text(
              (conversationBorshModel.conversationName?.replaceAll('${userName ?? ''}&_#', '').replaceAll('&_#${userName ?? ''}', '') ?? 'No title'),
              textAlign: TextAlign.left,
              style: Get.textTheme.titleLarge!.copyWith(color: AppColors.tertiaryColor),
            ),
            subtitle: Text(
              conversationBorshModel.newConversation == 'true' ? 'This is a new conversation' : 'Last message',
              textAlign: TextAlign.left,
              style: Get.textTheme.bodySmall!.copyWith(color: conversationBorshModel.newConversation == 'true' ? AppColors.redColor : AppColors.tertiaryColor),
            ),
            leading: Text(
              // just show hour and minute for example 12:00 AM or PM
              '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour > 12 ? 'PM' : 'AM'}',
            ),
            trailing: SvgPicture.asset(
              avatar,
              height: 48,
              width: 48,
            ),
          ),
        ),
      ),
    );
  }
}
