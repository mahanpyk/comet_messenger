import 'package:solana_borsh/borsh.dart';
import 'package:solana_borsh/codecs.dart';
import 'package:solana_borsh/models.dart';
import 'package:solana_borsh/types.dart';

class ProfileBorshModel extends BorshObject {
  @override
  factory ProfileBorshModel.fromJson(final Map<String, dynamic> json) => ProfileBorshModel(
        userName: json['userName'],
        createdTime: json['createdTime'],
        index: json['index'],
        conversationList: (json['conversation_list'] as List<dynamic>?)?.map((final dynamic e) => ConversationBorshModel.fromJson(e as Map<String, dynamic>)).toList(),
      );

  ProfileBorshModel({
    this.conversationList,
    this.createdTime,
    this.index,
    this.userName,
  });

  final String? userName;
  final String? createdTime;
  final String? index;
  final List<ConversationBorshModel>? conversationList;

  @override
  Map<String, dynamic> toJson() => {
        'userName': userName,
        'createdTime': createdTime,
        'index': index,
        'conversation_list': conversationList,
      };

  @override
  BorshSchema get borshSchema => borshCodec.schema;

  static BorshStructCodec get borshCodec => BorshStructCodec({
        'userName': borsh.string(),
        'createdTime': borsh.string(),
        'index': borsh.string(),
        'conversation_list': borsh.list(ConversationBorshModel.borshCodec, 10),
      });
// BorshListCodec(Contact.borshCodec);
// {
//       'contacts': borsh.list(Contact.borshCodec, 10),
// });
}

class ConversationBorshModel extends BorshObject {
  @override
  factory ConversationBorshModel.fromJson(final Map<String, dynamic> json) => ConversationBorshModel(
        conversationId: json['conversation_id'],
        conversationName: json['conversation_name'],
        newConversation: json['new_conversation'],
        avatar: json['avatar'],
      );

  ConversationBorshModel({
    this.conversationId,
    this.conversationName,
    this.newConversation,
    this.avatar,
  });

  final String? conversationId;
  final String? conversationName;
  final String? newConversation;
  final String? avatar;

  @override
  BorshSchema get borshSchema => borshCodec.schema;

  static BorshStructCodec get borshCodec => BorshStructCodec({
        'conversation_id': borsh.string(),
        'conversation_name': borsh.string(),
        'avatar': borsh.string(),
      });

  @override
  Map<String, dynamic> toJson() => {
        'conversation_id': conversationId,
        'conversation_name': conversationName,
        'new_conversation': newConversation,
        'avatar': avatar,
      };
}
