import 'dart:convert';

BalanceResponseModel balanceResponseModelFromJson(Map<String, dynamic> json) => BalanceResponseModel.fromJson(json);

String balanceResponseModelToJson(BalanceResponseModel data) => json.encode(data.toJson());

class BalanceResponseModel {
  BalanceResponseModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory BalanceResponseModel.fromJson(Map<String, dynamic> json) => BalanceResponseModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
  String? message;
  int? statusCode;
  Data? data;

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
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
  String? id;

  Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "result": result?.toJson(),
        "id": id,
      };
}

class Result {
  Result({
    this.context,
    this.value,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        context: json["context"] == null ? null : Context.fromJson(json["context"]),
        value: json["value"],
      );
  Context? context;
  int? value;

  Map<String, dynamic> toJson() => {
        "context": context?.toJson(),
        "value": value,
      };
}

class Context {
  Context({
    this.apiVersion,
    this.slot,
  });

  factory Context.fromJson(Map<String, dynamic> json) => Context(
        apiVersion: json["apiVersion"],
        slot: json["slot"],
      );
  String? apiVersion;
  int? slot;

  Map<String, dynamic> toJson() => {
        "apiVersion": apiVersion,
        "slot": slot,
      };
}
