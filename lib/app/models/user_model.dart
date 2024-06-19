import 'dart:convert';

import 'package:comet_messenger/app/core/app_enums.dart';

UserModel userResponseModelFromJson(Map<String, dynamic> json) => UserModel.fromJson(json);

String userResponseModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel( {
    this.id,
    this.userName,
    this.lastName,
    this.modalCreate,
    this.avatar,
    this.basePubKey,
    this.login,
    this.privateKey,
    this.stateAuthLogin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userName: json['user_name'],
        lastName: json['last_name'],
        avatar: json['avatar'],
        basePubKey: json['base_pubkey'],
        login: true,
        privateKey: json['privateKey'],
        stateAuthLogin: StateAuthLoginEnum.GET_INDEX,
      );
  final String? id;
  final String? userName;
  final String? lastName;
  final String? modalCreate;
  final String? avatar;
  final String? basePubKey;
  final bool? login;
  final String? privateKey;
  final StateAuthLoginEnum? stateAuthLogin;

  // Mnemonics.MnemonicCode mnemonicCode;

  Map<String, dynamic> toJson() => {
    "userName": userName,
    "modalCreate": modalCreate,
    "id": id,
    "avatar": avatar,
    "basePubKey": basePubKey,
    "login": login,
    "privateKey": privateKey,
    "stateAuthLogin": stateAuthLogin
  };
}
