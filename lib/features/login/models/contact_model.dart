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

  @override
  Map<String, dynamic> toJson() => {
        'contacts': contacts,
      };

  @override
  BorshSchema get borshSchema => borshCodec.schema;

  static BorshStructCodec get borshCodec => BorshStructCodec({
        'contacts': borsh.array(Contact.borshCodec, 10),
  });
}

class Contact extends BorshObject {
  @override
  factory Contact.fromJson(final Map<String, dynamic> json) => Contact(
        user_name: json['user_name'],
        last_name: json['last_name'],
        public_key: json['public_key'],
        base_pubkey: json['base_pubkey'],
        avatar: json['avatar'],
      );

  Contact({
    this.user_name,
    this.last_name,
    this.public_key,
    this.base_pubkey,
    this.avatar,
  });

  final String? user_name;
  final String? last_name;
  final String? public_key;
  final String? base_pubkey;
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
        'user_name': user_name,
        'last_name': last_name,
        'public_key': public_key,
        'base_pubkey': base_pubkey,
        'avatar': avatar,
      };
}
