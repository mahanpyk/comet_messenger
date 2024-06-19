import 'dart:convert';

RequestModel requestModelFromJson(Map<String, dynamic> json) => RequestModel.fromJson(json);

String requestModelToJson(RequestModel data) => json.encode(data.toJson());

class RequestModel {
  RequestModel({
    this.method,
    this.params,
    this.jsonrpc,
    this.id,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        method: json["method"],
        params: json["params"] == null ? [] : List<dynamic>.from(json["params"]!.map((x) => x)),
        jsonrpc: json["jsonrpc"],
        id: json["id"],
      );
  String? method;
  List<dynamic>? params;
  String? jsonrpc;
  String? id;

  Map<String, dynamic> toJson() => {
        "method": method,
        "params": params == null ? [] : List<dynamic>.from(params!.map((x) => x)),
        "jsonrpc": jsonrpc,
        "id": id,
      };
}

class ParamClass {
  ParamClass({
    this.commitment,
    this.encoding,
  });

  factory ParamClass.fromJson(Map<String, dynamic> json) => ParamClass(
        commitment: json["commitment"],
        encoding: json["encoding"],
      );
  String? commitment;
  String? encoding;

  Map<String, dynamic> toJson() => {
        "commitment": commitment,
        "encoding": encoding,
      };
}
