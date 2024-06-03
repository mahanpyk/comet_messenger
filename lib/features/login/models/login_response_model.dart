import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(Map<String, dynamic> json) => LoginResponseModel.fromJson(json);

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
  LoginResponseModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
  String? message;
  int? statusCode;
  Data? data;

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class Data {
  String? jsonrpc;
  Result? result;
  String? id;

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

  Map<String, dynamic> toJson() => {
    "jsonrpc": jsonrpc,
    "result": result?.toJson(),
    "id": id,
  };
}

class Result {
  Context? context;
  Value? value;

  Result({
    this.context,
    this.value,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    context: json["context"] == null ? null : Context.fromJson(json["context"]),
    value: json["value"] == null ? null : Value.fromJson(json["value"]),
  );

  Map<String, dynamic> toJson() => {
    "context": context?.toJson(),
    "value": value?.toJson(),
  };
}

class Context {
  String? apiVersion;
  int? slot;

  Context({
    this.apiVersion,
    this.slot,
  });

  factory Context.fromJson(Map<String, dynamic> json) => Context(
    apiVersion: json["apiVersion"],
    slot: json["slot"],
  );

  Map<String, dynamic> toJson() => {
    "apiVersion": apiVersion,
    "slot": slot,
  };
}

class Value {
  List<String>? data;
  bool? executable;
  int? lamports;
  String? owner;
  double? rentEpoch;
  int? space;

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

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
    "executable": executable,
    "lamports": lamports,
    "owner": owner,
    "rentEpoch": rentEpoch,
    "space": space,
  };
}

