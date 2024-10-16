import 'dart:convert';

AirDropResponseModel airDropResponseModelFromJson(Map<String, dynamic> json) =>
    AirDropResponseModel.fromJson(json);

String airDropResponseModelToJson(AirDropResponseModel data) =>
    json.encode(data.toJson());

class AirDropResponseModel {
  AirDropResponseModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory AirDropResponseModel.fromJson(Map<String, dynamic> json) =>
      AirDropResponseModel(
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
        result: json["result"],
        id: json["id"],
      );
  final String? jsonrpc;
  final String? result;
  final String? id;

  Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "result": result,
        "id": id,
      };
}
