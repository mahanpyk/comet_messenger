class ListUserWalletsModel {
  factory ListUserWalletsModel.fromJson(Map<String, dynamic> json) =>
      ListUserWalletsModel(listWallets: List<UserWalletModel>.from(json["listWallets"].map((x) => UserWalletModel.fromJson(x))));

  ListUserWalletsModel({required this.listWallets});

  List<UserWalletModel>? listWallets;

  Map<String, dynamic> toJson() => {'listWallets': List<dynamic>.from(listWallets!.map((x) => x.toJson()))};
}

class UserWalletModel {
  factory UserWalletModel.fromJson(Map<String, dynamic> json) => UserWalletModel(
        id: json['id'],
        mnemonic: json['mnemonic'],
        isActive: json['isActive'],
      );

  UserWalletModel({
    required this.id,
    required this.mnemonic,
    required this.isActive,
  });

  int? id;
  String? mnemonic;
  bool? isActive;

  Map<String, dynamic> toJson() => {
        'id': id,
        'mnemonic': mnemonic,
        'isActive': isActive,
      };
}
