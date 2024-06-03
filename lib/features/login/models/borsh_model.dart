import 'package:solana_borsh/borsh.dart';
import 'package:solana_borsh/codecs.dart';
import 'package:solana_borsh/models.dart';
import 'package:solana_borsh/types.dart';

class BorshModel extends BorshObject {

  BorshModel({
    this.u8,
    this.u16,
    this.u32,
    this.u64,
    this.string,
    this.stringSized,
    this.array,
    this.vec,
  });

  final int? u8;
  final int? u16;             // optional value.
  final int? u32;             // optional value.
  final BigInt? u64;
  final String? string;
  final String? stringSized;   // Fixed-length string.
  final List<int>? array;      // Fixed-length list.
  final List<BigInt>? vec;     // Dynamic-length list.

  @override
  BorshSchema get borshSchema => borshCodec.schema;

  static BorshStructCodec get borshCodec => BorshStructCodec({
    'u8': borsh.u8,
    'u16': borsh.u16.option(),
    'u32': borsh.u32.cOption(), // 4-byte optional flag.
    'u64': borsh.u64,
    'string': borsh.string(),
    'stringSized': borsh.stringSized(7),
    'array': borsh.array(borsh.i64, 10),
    'vec': borsh.vec(borsh.u64),
  });

  @override
  factory BorshModel.fromJson(final Map<String, dynamic> json) => BorshModel(
    u8: json['u8'],
    u16: json['u16'],
    u32: json['u32'],
    u64: json['u64'],
    string: json['string'],
    stringSized: json['stringSized'],
    array: json['array'],
    vec: json['vec'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'u8': u8,
    'u16': u16,
    'u32': u32,
    'u64': u64,
    'string': string,
    'stringSized': stringSized,
    'array': array,
    'vec': vec,
  };
}