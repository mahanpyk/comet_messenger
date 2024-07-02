import 'dart:convert';

import 'package:comet_messenger/app/core/app_enums.dart';

UserModel userResponseModelFromJson(Map<String, dynamic> json) => UserModel.fromJson(json);

String userResponseModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    this.userName,
    this.lastName,
    this.modalCreate,
    this.avatar,
    this.basePublicKey,
    this.publicKey,
    this.login,
    this.privateKey,
    this.stateAuthLogin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        userName: json['userName'],
        lastName: json['lastName'],
        modalCreate: json['modalCreate'],
        avatar: json['avatar'],
        basePublicKey: json['basePublicKey'],
        publicKey: json['publicKey'],
        login: json['login'],
        privateKey: json['privateKey'],
        stateAuthLogin: json['stateAuthLogin'],
      );
  final String? id;
  final String? userName;
  final String? lastName;
  final String? modalCreate;
  final String? avatar;
  final String? basePublicKey;
  final String? publicKey;
  final bool? login;
  final String? privateKey;
  final StateAuthLoginEnum? stateAuthLogin;

  // Mnemonics.MnemonicCode mnemonicCode;

  Map<String, dynamic> toJson() => {
        "id": id,
        "userName": userName,
        "lastName": lastName,
        "modalCreate": modalCreate,
        "avatar": avatar,
        "basePublicKey": basePublicKey,
        "publicKey": publicKey,
        "login": login,
        "privateKey": privateKey,
        "stateAuthLogin": stateAuthLogin,
      };
}
