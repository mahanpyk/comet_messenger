import 'dart:convert';

SendFileResponseModel sendFileResponseModelFromJson(Map<String, dynamic> json) => SendFileResponseModel.fromJson(json);

String sendFileResponseModelToJson(SendFileResponseModel data) => json.encode(data.toJson());

class SendFileResponseModel {
  SendFileResponseModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory SendFileResponseModel.fromJson(Map<String, dynamic> json) => SendFileResponseModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
  String? message;
  int? statusCode;
  Data? data;

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class Data {
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        ipfsHash: json["ipfsHash"],
        pinSize: json["pinSize"],
        timestamp: json["Timestamp"],
      );

  Data({
    this.ipfsHash,
    this.pinSize,
    this.timestamp,
  });

  String? ipfsHash;
  int? pinSize;
  String? timestamp;

  Map<String, dynamic> toJson() => {
        "ipfsHash": ipfsHash,
        "pinSize": pinSize,
        "Timestamp": timestamp,
      };
}
