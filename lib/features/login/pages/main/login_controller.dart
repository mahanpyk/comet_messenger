import 'dart:convert';
import 'dart:typed_data';

import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/core/app_utils_mixin.dart';
import 'package:comet_messenger/app/models/request_model.dart';
import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/features/login/models/contact_data_length_model.dart';
import 'package:comet_messenger/features/login/models/contact_model.dart';
import 'package:comet_messenger/features/login/models/login_response_model.dart';
import 'package:comet_messenger/features/login/repository/login_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solana_borsh/borsh.dart';

class LoginController extends GetxController with AppUtilsMixin {
  LoginController(this._repo);

  final LoginRepository _repo;
  RxInt selectedAvatarIndex = RxInt(-1);
  TextEditingController phoneNumberTEC = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isEnableConfirmButton = false.obs;
  RxBool isValid = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserModel? userModel;

  /// validate user name
  void onChangeUserName({required String? value}) {
    if (value != null && value.length > 3) {
      isValid.value = true;
      // if (selectedAvatarIndex.value != -1) {
      isEnableConfirmButton(isValid.value);
      // }
      formKey.currentState!.validate();
    } else {
      isValid.value = false;
      isEnableConfirmButton(false);
    }
  }

  /// request login
  Future<void> onTapLogin() async {
    _repo
        .login(
            requestModel: RequestModel(
      method: "getAccountInfo",
      params: [
        AppConstants.CONTACT_PDA,
        ParamClass(
          commitment: "max",
          encoding: "base64",
        ).toJson()
      ],
      jsonrpc: "2.0",
      id: "b75758de-e0b2-469b-bd9c-ef366ee1b35a",
    ))
        .then((LoginResponseModel response) {
      if (response.statusCode == 200) {
        // get response and get length from first 4 bytes
        var data = base64Decode(response.data!.result!.value!.data![0]);
        final data2 = Uint8List(4);
        data2.setAll(0, data.sublist(0, 4));
        var decode = borsh.deserialize(ContactDataLengthModel().borshSchema, data2, ContactDataLengthModel.fromJson);
        int length = decode.length!;
        if (length == 0) {
          length = 288;
        }
        final accountDataBuffer = Uint8List(length);
        accountDataBuffer.setAll(0, data.sublist(4, length));
        var decodeContacts = borsh.deserialize(ContactModel().borshSchema, accountDataBuffer, ContactModel.fromJson);
        for (Contact element in decodeContacts.contacts!) {
          if (element.user_name == phoneNumberTEC.text) {
            userModel = UserModel(
              userName: element.user_name,
              avatar: element.avatar,
              lastName: element.last_name,
              basePubKey: element.base_pubkey,
              login: true,
            );
            UserStoreService.to.save(key: AppConstants.USER_ACCOUNT, value: element.toJson());
            Get.toNamed(AppRoutes.IMPORT_WALLET);
            break;
          }
        }
      }
    });
  }

  void onTapAvatar({required int index}) {
    selectedAvatarIndex(index);
    if (isValid.value) {
      isEnableConfirmButton(true);
    }
  }
}
