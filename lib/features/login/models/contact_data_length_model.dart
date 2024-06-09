import 'package:solana_borsh/borsh.dart';
import 'package:solana_borsh/codecs.dart';
import 'package:solana_borsh/models.dart';
import 'package:solana_borsh/types.dart';

class ContactDataLengthModel extends BorshObject {
  @override
  factory ContactDataLengthModel.fromJson(final Map<String, dynamic> json) => ContactDataLengthModel(length: json['length']);

  ContactDataLengthModel({this.length});

  final int? length;

  @override
  BorshSchema get borshSchema => borshCodec.schema;

  static BorshStructCodec get borshCodec => BorshStructCodec({'length': borsh.u32});

  @override
  Map<String, dynamic> toJson() => {'length': length};
}
