import 'dart:convert';

ReadFileResponseModel readFileResponseModelFromJson(Map<String, dynamic> json) => ReadFileResponseModel.fromJson(json);

String readFileResponseModelToJson(ReadFileResponseModel data) => json.encode(data.toJson());

class ReadFileResponseModel {
  ReadFileResponseModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory ReadFileResponseModel.fromJson(Map<String, dynamic> json) => ReadFileResponseModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
  String? message;
  int? statusCode;
  Data? data;

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class Data {
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        content: json["content"],
        name: json["name"],
        size: json["size"],
        type: json["type"],
      );

  Data({
    this.content,
    this.name,
    this.size,
    this.type,
  });

  String? content;
  String? name;
  String? size;
  String? type;

  Map<String, dynamic> toJson() => {
        "content": content,
        "name": name,
        "size": size,
        "type": type,
      };
}
