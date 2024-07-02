import 'dart:convert';

ChatListResponseModel chatListResponseModelFromJson(Map<String, dynamic> json) => ChatListResponseModel.fromJson(json);

String chatListResponseModelToJson(ChatListResponseModel data) => json.encode(data.toJson());

class ChatListResponseModel {
  ChatListResponseModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory ChatListResponseModel.fromJson(Map<String, dynamic> json) => ChatListResponseModel(
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
        value: json["value"] == null ? null : Value.fromJson(json["value"]),
      );
  Context? context;
  Value? value;

  Map<String, dynamic> toJson() => {
        "context": context?.toJson(),
        "value": value?.toJson(),
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

class Value {
  Value({
    this.data,
    this.executable,
    this.lamports,
    this.owner,
    this.rentEpoch,
    this.space,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        data: json["data"] == null ? [] : List<String>.from(json["data"]!.map((x) => x)),
        executable: json["executable"],
        lamports: json["lamports"],
        owner: json["owner"],
        rentEpoch: json["rentEpoch"]?.toDouble(),
        space: json["space"],
      );
  List<String>? data;
  bool? executable;
  int? lamports;
  String? owner;
  double? rentEpoch;
  int? space;

  Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
        "executable": executable,
        "lamports": lamports,
        "owner": owner,
        "rentEpoch": rentEpoch,
        "space": space,
      };
}
