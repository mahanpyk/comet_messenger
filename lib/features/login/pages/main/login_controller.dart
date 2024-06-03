import 'dart:convert';
import 'dart:typed_data';

import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/core/app_utils_mixin.dart';
import 'package:comet_messenger/features/login/models/borsh_model.dart';
import 'package:comet_messenger/features/login/models/contact_model.dart';
import 'package:comet_messenger/features/login/models/login_request_model.dart';
import 'package:comet_messenger/features/login/models/login_response_model.dart';
import 'package:comet_messenger/features/login/repository/login_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController with AppUtilsMixin {
  LoginController(this._repo);

  final LoginRepository _repo;
  RxInt selectedAvatarIndex = RxInt(-1);
  TextEditingController phoneNumberTEC = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isEnableConfirmButton = false.obs;
  RxBool isValid = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
            requestModel: LoginRequestModel(
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
        var data = base64Decode(response.data!.result!.value!.data![0]);


        final data2 = Uint8List(4);
        data2.setAll(0, data.sublist(0, 4));




        List<int> accountDataBuffer = data.sublist(4, 0 + data.length);


        var borshModel2 = ContactModel();
        // var decode = Borsh;
        // var decode = borsh.deserialize(borshModel2.borshSchema, data2, ContactModel.fromJson);
        debugPrint('*****************');
        // debugPrint(decode.toString());
        debugPrint('-----------------');
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
