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
  Data({
    this.ipfsHash,
    this.pinSize,
    this.timestamp,
    this.isDuplicate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        ipfsHash: json["IpfsHash"],
        pinSize: json["PinSize"],
        timestamp: json["Timestamp"],
        isDuplicate: json["isDuplicate"],
      );
  String? ipfsHash;
  int? pinSize;
  String? timestamp;
  bool? isDuplicate;

  Map<String, dynamic> toJson() => {
        "IpfsHash": ipfsHash,
        "PinSize": pinSize,
        "Timestamp": timestamp,
        "isDuplicate": isDuplicate,
      };
}
