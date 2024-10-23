import 'package:solana_borsh/borsh.dart';
import 'package:solana_borsh/codecs.dart';
import 'package:solana_borsh/models.dart';
import 'package:solana_borsh/types.dart';

class ChatDetailsBorshModel extends BorshObject {
  @override
  factory ChatDetailsBorshModel.fromJson(final Map<String, dynamic> json) => ChatDetailsBorshModel(
        conversationName: json['conversation_name'],
        createdTime: json['createdTime'],
        messages: (json['messages'] as List<dynamic>?)?.map((final dynamic e) => MessageBorshModel.fromJson(e as Map<String, dynamic>)).toList(),
        members: (json['members'] as List<dynamic>?)?.map((final dynamic e) => UserBorshModel.fromJson(e as Map<String, dynamic>)).toList(),
        admin: (json['admin'] as Map<String, dynamic>?) != null ? UserBorshModel.fromJson(json['admin'] as Map<String, dynamic>) : null,
        isPrivate: json['is_private'],
      );

  ChatDetailsBorshModel({
    this.conversationName,
    this.createdTime,
    this.messages,
    this.members,
    this.admin,
    this.isPrivate,
  });

  final String? conversationName;
  final String? createdTime;
  final List<MessageBorshModel>? messages;
  final List<UserBorshModel>? members;
  final UserBorshModel? admin;
  final bool? isPrivate;

  @override
  Map<String, dynamic> toJson() => {
        'conversation_name': conversationName,
        'createdTime': createdTime,
        'messages': messages?.map((final e) => e.toJson()).toList(),
        'members': members?.map((final e) => e.toJson()).toList(),
        'admin': admin?.toJson(),
        'is_private': isPrivate,
      };

  @override
  BorshSchema get borshSchema => borshCodec.schema;

  static BorshStructCodec get borshCodec => BorshStructCodec({
        'conversation_name': borsh.string(),
        'created_time': borsh.string(),
        'messages': borsh.list(MessageBorshModel.borshCodec, 10),
        'members': borsh.list(UserBorshModel.borshCodec, 10),
        'admin': UserBorshModel.borshCodec,
        // 'is_private': borsh.boolean,
      });
}

class UserBorshModel extends BorshObject {
  @override
  factory UserBorshModel.fromJson(final Map<String, dynamic> json) => UserBorshModel(
        userAddress: json['user_address'],
        userName: json['user_name'],
        tokenCipher: json['token_cipher'],
      );

  UserBorshModel({
    this.userAddress,
    this.userName,
    this.tokenCipher,
  });

  final String? userAddress;
  final String? userName;
  final String? tokenCipher;

  @override
  BorshSchema get borshSchema => borshCodec.schema;

  static BorshStructCodec get borshCodec => BorshStructCodec({
        'user_address': borsh.string(),
        'user_name': borsh.string(),
        'token_cipher': borsh.string(),
      });

  @override
  Map<String, dynamic> toJson() => {
        'user_address': userAddress,
        'user_name': userName,
        'token_cipher': tokenCipher,
      };
}

class MessageBorshModel extends BorshObject {
  @override
  factory MessageBorshModel.fromJson(final Map<String, dynamic> json) => MessageBorshModel(
        messageId: json['message_id'],
        text: json['text'],
        time: json['time'],
        seenBy: (json['seen_by'] as List<dynamic>?)?.map((final dynamic e) => UserBorshModel.fromJson(e as Map<String, dynamic>)).toList(),
        senderAddress: json['sender_address'],
        messageType: json['message_type'],
        offlineAdded: json['offline_added'],
        status: json['status'],
        state: json['state'],
        image: json['image'],
        checkUploadIpfs: json['check_upload_ipfs'],
        name: json['name'],
        size: json['size'],
      );

  MessageBorshModel({
    this.messageId,
    this.text,
    this.time,
    this.seenBy,
    this.senderAddress,
    this.messageType,
    this.offlineAdded,
    this.status,
    this.state,
    this.image,
    this.checkUploadIpfs,
    this.name,
    this.size,
  });

  final String? messageId;
  final String? text;
  final String? time;
  final List<UserBorshModel>? seenBy;
  final String? senderAddress;
  final String? messageType;
  final bool? offlineAdded;
  String? status;
  final String? state;
  final String? image;
  final String? checkUploadIpfs;
  final String? name;
  final String? size;

  @override
  BorshSchema get borshSchema => borshCodec.schema;

  static BorshStructCodec get borshCodec => BorshStructCodec({
        'message_id': borsh.string(),
        'text': borsh.string(),
        'time': borsh.string(),
        'seen_by': borsh.list(UserBorshModel.borshCodec, 10),
        'sender_address': borsh.string(),
        'message_type': borsh.string(),
      });

  @override
  Map<String, dynamic> toJson() => {
        'message_id': messageId,
        'text': text,
        'time': time,
        'seen_by': seenBy,
        'sender_address': senderAddress,
        'message_type': messageType,
        'offline_added': offlineAdded,
        'status': status,
        'state': state,
        'image': image,
        'check_upload_ipfs': checkUploadIpfs,
        'name': name,
        'size': size,
      };
}
