import 'package:solana_borsh/borsh.dart';
import 'package:solana_borsh/codecs.dart';
import 'package:solana_borsh/models.dart';
import 'package:solana_borsh/types.dart';

class ContactModel extends BorshObject {
  @override
  factory ContactModel.fromJson(final Map<String, dynamic> json) => ContactModel(
        contacts: (json['contacts'] as List<dynamic>?)?.map((final dynamic e) => Contact.fromJson(e as Map<String, dynamic>)).toList(),
      );

  ContactModel({this.contacts});

  final List<Contact>? contacts;

  // toJson
  @override
  Map<String, dynamic> toJson() => {
        'contacts': contacts?.map((final e) => e.toJson()).toList(),
      };

  @override
  BorshSchema get borshSchema => borshCodec.schema;

  static BorshStructCodec get borshCodec => BorshStructCodec({
        'contacts': borsh.list(Contact.borshCodec, 10),
      });
// BorshListCodec(Contact.borshCodec);
// {
//       'contacts': borsh.list(Contact.borshCodec, 10),
// });
}

class Contact extends BorshObject {
  @override
  factory Contact.fromJson(final Map<String, dynamic> json) => Contact(
        userName: json['user_name'],
        lastName: json['last_name'],
        publicKey: json['public_key'],
        basePubKey: json['base_pubkey'],
        avatar: json['avatar'],
      );

  Contact({
    this.userName,
    this.lastName,
    this.publicKey,
    this.basePubKey,
    this.avatar,
  });

  final String? userName;
  final String? lastName;
  final String? publicKey;
  final String? basePubKey;
  final String? avatar;

  @override
  BorshSchema get borshSchema => borshCodec.schema;

  static BorshStructCodec get borshCodec => BorshStructCodec({
        'user_name': borsh.string(),
        'last_name': borsh.string(),
        'public_key': borsh.string(),
        'base_pubkey': borsh.string(),
        'avatar': borsh.string(),
      });

  @override
  Map<String, dynamic> toJson() => {
        'user_name': userName,
        'last_name': lastName,
        'public_key': publicKey,
        'base_pubkey': basePubKey,
        'avatar': avatar,
      };
}
