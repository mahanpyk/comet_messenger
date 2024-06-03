import 'dart:convert';

TransactionsResponseModel transactionsResponseModelFromJson(Map<String, dynamic> json) => TransactionsResponseModel.fromJson(json);

String transactionsResponseModelToJson(TransactionsResponseModel data) => json.encode(data.toJson());

class TransactionsResponseModel {
  TransactionsResponseModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory TransactionsResponseModel.fromJson(Map<String, dynamic> json) => TransactionsResponseModel(
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
        result: json["result"] == null ? [] : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
        id: json["id"],
      );
  String? jsonrpc;
  List<Result>? result;
  int? id;

  Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
        "id": id,
      };
}

class Result {
  Result({
    this.blockTime,
    this.confirmationStatus,
    this.err,
    this.memo,
    this.signature,
    this.slot,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        blockTime: json["blockTime"],
        confirmationStatus: json["confirmationStatus"],
        err: json["err"],
        memo: json["memo"],
        signature: json["signature"],
        slot: json["slot"],
      );
  int? blockTime;
  String? confirmationStatus;
  dynamic err;
  dynamic memo;
  String? signature;
  int? slot;

  Map<String, dynamic> toJson() => {
        "blockTime": blockTime,
        "confirmationStatus": confirmationStatus,
        "err": err,
        "memo": memo,
        "signature": signature,
        "slot": slot,
      };
}
