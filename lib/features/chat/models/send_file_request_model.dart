class SendFileRequestModel {
  SendFileRequestModel({
    this.image,
    this.name,
    this.size,
    this.type,
    this.uuid,
  });

  String? image;
  String? name;
  String? size;
  String? type;
  String? uuid;

  Map<String, dynamic> toJson() => {
        "pinataOptions": {"cidVersion": 0},
        "pinataContent": {
          "content": image,
          "name": name,
          "size": size,
          "type": type,
        },
        "pinataMetadata": {"name": uuid},
      };
}
