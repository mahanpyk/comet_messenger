import 'dart:convert';

TransactionDetailsResponseModel transactionDetailsResponseModelFromJson(Map<String, dynamic> json) => TransactionDetailsResponseModel.fromJson(json);

String transactionDetailsResponseModelToJson(TransactionDetailsResponseModel data) => json.encode(data.toJson());

class TransactionDetailsResponseModel {
  TransactionDetailsResponseModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory TransactionDetailsResponseModel.fromJson(Map<String, dynamic> json) => TransactionDetailsResponseModel(
        data: json == null ? null : Data.fromJson(json),
      );
  String? message;
  int? statusCode;
  Data? data;

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.jsonrpc,
    this.result,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        jsonrpc: json["jsonrpc"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
        id: json["id"],
      );
  String? jsonrpc;
  Result? result;
  int? id;

  Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "result": result?.toJson(),
        "id": id,
      };
}

class Result {
  Result({
    this.blockTime,
    this.meta,
    this.slot,
    this.transaction,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        blockTime: json["blockTime"],
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        slot: json["slot"],
        transaction: json["transaction"] == null ? null : Transaction.fromJson(json["transaction"]),
      );
  int? blockTime;
  Meta? meta;
  int? slot;
  Transaction? transaction;

  Map<String, dynamic> toJson() => {
        "blockTime": blockTime,
        "meta": meta?.toJson(),
        "slot": slot,
        "transaction": transaction?.toJson(),
      };
}

class Meta {
  Meta({
    this.computeUnitsConsumed,
    this.err,
    this.fee,
    this.innerInstructions,
    this.logMessages,
    this.postBalances,
    this.postTokenBalances,
    this.preBalances,
    this.preTokenBalances,
    this.rewards,
    this.status,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        computeUnitsConsumed: json["computeUnitsConsumed"],
        err: json["err"],
        fee: json["fee"],
        innerInstructions: json["innerInstructions"] == null ? [] : List<InnerInstruction>.from(json["innerInstructions"]!.map((x) => InnerInstruction.fromJson(x))),
        logMessages: json["logMessages"] == null ? [] : List<String>.from(json["logMessages"]!.map((x) => x)),
        postBalances: json["postBalances"] == null ? [] : List<int>.from(json["postBalances"]!.map((x) => x)),
        postTokenBalances: json["postTokenBalances"] == null ? [] : List<dynamic>.from(json["postTokenBalances"]!.map((x) => x)),
        preBalances: json["preBalances"] == null ? [] : List<int>.from(json["preBalances"]!.map((x) => x)),
        preTokenBalances: json["preTokenBalances"] == null ? [] : List<dynamic>.from(json["preTokenBalances"]!.map((x) => x)),
        rewards: json["rewards"] == null ? [] : List<dynamic>.from(json["rewards"]!.map((x) => x)),
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
      );
  int? computeUnitsConsumed;
  dynamic err;
  int? fee;
  List<InnerInstruction>? innerInstructions;
  List<String>? logMessages;
  List<int>? postBalances;
  List<dynamic>? postTokenBalances;
  List<int>? preBalances;
  List<dynamic>? preTokenBalances;
  List<dynamic>? rewards;
  Status? status;

  Map<String, dynamic> toJson() => {
        "computeUnitsConsumed": computeUnitsConsumed,
        "err": err,
        "fee": fee,
        "innerInstructions": innerInstructions == null ? [] : List<dynamic>.from(innerInstructions!.map((x) => x.toJson())),
        "logMessages": logMessages == null ? [] : List<dynamic>.from(logMessages!.map((x) => x)),
        "postBalances": postBalances == null ? [] : List<dynamic>.from(postBalances!.map((x) => x)),
        "postTokenBalances": postTokenBalances == null ? [] : List<dynamic>.from(postTokenBalances!.map((x) => x)),
        "preBalances": preBalances == null ? [] : List<dynamic>.from(preBalances!.map((x) => x)),
        "preTokenBalances": preTokenBalances == null ? [] : List<dynamic>.from(preTokenBalances!.map((x) => x)),
        "rewards": rewards == null ? [] : List<dynamic>.from(rewards!.map((x) => x)),
        "status": status?.toJson(),
      };
}

class InnerInstruction {
  InnerInstruction({
    this.index,
    this.instructions,
  });

  factory InnerInstruction.fromJson(Map<String, dynamic> json) => InnerInstruction(
        index: json["index"],
        instructions: json["instructions"] == null ? [] : List<Instruction>.from(json["instructions"]!.map((x) => Instruction.fromJson(x))),
      );
  int? index;
  List<Instruction>? instructions;

  Map<String, dynamic> toJson() => {
        "index": index,
        "instructions": instructions == null ? [] : List<dynamic>.from(instructions!.map((x) => x.toJson())),
      };
}

class Instruction {
  Instruction({
    this.accounts,
    this.data,
    this.programId,
    this.stackHeight,
  });

  factory Instruction.fromJson(Map<String, dynamic> json) => Instruction(
        accounts: json["accounts"] == null ? [] : List<String>.from(json["accounts"]!.map((x) => x)),
        data: json["data"],
        programId: json["programId"],
        stackHeight: json["stackHeight"],
      );
  List<String>? accounts;
  String? data;
  String? programId;
  int? stackHeight;

  Map<String, dynamic> toJson() => {
        "accounts": accounts == null ? [] : List<dynamic>.from(accounts!.map((x) => x)),
        "data": data,
        "programId": programId,
        "stackHeight": stackHeight,
      };
}

class Status {
  Status({
    this.ok,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        ok: json["Ok"],
      );
  dynamic ok;

  Map<String, dynamic> toJson() => {
        "Ok": ok,
      };
}

class Transaction {
  Transaction({
    this.message,
    this.signatures,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        message: json["message"] == null ? null : Message.fromJson(json["message"]),
        signatures: json["signatures"] == null ? [] : List<String>.from(json["signatures"]!.map((x) => x)),
      );
  Message? message;
  List<String>? signatures;

  Map<String, dynamic> toJson() => {
        "message": message?.toJson(),
        "signatures": signatures == null ? [] : List<dynamic>.from(signatures!.map((x) => x)),
      };
}

class Message {
  Message({
    this.accountKeys,
    this.instructions,
    this.recentBlockhash,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        accountKeys: json["accountKeys"] == null ? [] : List<AccountKey>.from(json["accountKeys"]!.map((x) => AccountKey.fromJson(x))),
        instructions: json["instructions"] == null ? [] : List<Instruction>.from(json["instructions"]!.map((x) => Instruction.fromJson(x))),
        recentBlockhash: json["recentBlockhash"],
      );
  List<AccountKey>? accountKeys;
  List<Instruction>? instructions;
  String? recentBlockhash;

  Map<String, dynamic> toJson() => {
        "accountKeys": accountKeys == null ? [] : List<dynamic>.from(accountKeys!.map((x) => x.toJson())),
        "instructions": instructions == null ? [] : List<dynamic>.from(instructions!.map((x) => x.toJson())),
        "recentBlockhash": recentBlockhash,
      };
}

class AccountKey {
  AccountKey({
    this.pubkey,
    this.signer,
    this.source,
    this.writable,
  });

  factory AccountKey.fromJson(Map<String, dynamic> json) => AccountKey(
        pubkey: json["pubkey"],
        signer: json["signer"],
        source: sourceValues.map[json["source"]]!,
        writable: json["writable"],
      );
  String? pubkey;
  bool? signer;
  Source? source;
  bool? writable;

  Map<String, dynamic> toJson() => {
        "pubkey": pubkey,
        "signer": signer,
        "source": sourceValues.reverse[source],
        "writable": writable,
      };
}

enum Source { TRANSACTION }

final sourceValues = EnumValues({"transaction": Source.TRANSACTION});

class EnumValues<T> {
  EnumValues(this.map);

  Map<String, T> map;
  late Map<T, String> reverseMap;

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
