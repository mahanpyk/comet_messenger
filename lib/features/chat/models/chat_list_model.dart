import 'dart:typed_data';

import 'package:comet_messenger/app/core/app_enums.dart';

class ChatListModel {
  ChatListModel({
    required this.text,
    required this.messageType,
    this.file,
    this.isMe,
    this.time,
    this.status,
  });

  final String text;
  final MassageTypeEnum messageType;
  Uint8List? file;
  bool? isMe;
  String? time;
  String? status;
}
