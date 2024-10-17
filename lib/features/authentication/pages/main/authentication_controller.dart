import 'dart:convert';
import 'dart:typed_data';

import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:comet_messenger/app/core/app_utils_mixin.dart';
import 'package:comet_messenger/app/models/data_length_borsh_model.dart';
import 'package:comet_messenger/app/models/request_model.dart';
import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/authentication/models/authentication_response_model.dart';
import 'package:comet_messenger/features/authentication/models/contact_model.dart';
import 'package:comet_messenger/features/authentication/repository/authentication_repository.dart';
import 'package:comet_messenger/features/widgets/fill_button_widget.dart';
import 'package:comet_messenger/features/widgets/outline_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:solana_borsh/borsh.dart';

class AuthenticationController extends GetxController with AppUtilsMixin {
  AuthenticationController(this._repo);

  final AuthenticationRepository _repo;
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

  void onTapAvatar({required int index}) {
    selectedAvatarIndex(index);
    if (isValid.value) {
      isEnableConfirmButton(true);
    }
  }

  /// request login
  Future<void> onTapLogin({String? contactPDA}) async {
    // hide keyboard
    FocusManager.instance.primaryFocus?.unfocus();
    isLoading(true);
    userModel = null;
    _repo
        .login(
            requestModel: RequestModel(
      method: "getAccountInfo",
      params: [
        contactPDA ?? AppConstants.CONTACT_PDA_LIST.first,
        ParamClass(
          commitment: "max",
          encoding: "base64",
        ).toJson()
      ],
      jsonrpc: "2.0",
      id: "b75758de-e0b2-469b-bd9c-ef366ee1b35a",
    ))
        .then((AuthenticationResponseModel response) {
      isLoading(false);
      if (response.statusCode == 200) {
        // get response and get length from first 4 bytes
        var data = base64Decode(response.data!.result!.value!.data![0]);
        final data2 = Uint8List(4);

        //convert to byte array
        data2.setAll(0, data.sublist(0, 4));
        var decode = borsh.deserialize(DataLengthBorshModel().borshSchema, data2, DataLengthBorshModel.fromJson);
        int length = decode.length!;
        if (length == 0) {
          length = 288;
        }
        final accountDataBuffer = Uint8List(length);
        accountDataBuffer.setAll(0, data.sublist(4, length));
        var decodeContacts = borsh.deserialize(ContactModel().borshSchema, accountDataBuffer, ContactModel.fromJson);
        // UserStoreService.to.save(key: AppConstants.CONTACTS, value: decodeContacts.toJson());
        for (Contact element in decodeContacts.contacts!) {
          if (element.userName == phoneNumberTEC.text) {
            userModel = UserModel(
              userName: element.userName,
              avatar: element.avatar,
              lastName: element.lastName,
              basePublicKey: element.basePubKey,
              publicKey: element.publicKey,
              login: true,
            );
            // UserStoreService.to.saveUserModel(userModel!.toJson());
            Get.toNamed(AppRoutes.IMPORT_MNEMONIC);
            return;
          }
        }
        int indexContact = AppConstants.CONTACT_PDA_LIST.indexWhere((element) => element == (contactPDA ?? AppConstants.CONTACT_PDA_LIST.first));
        indexContact++;
        if (userModel == null && AppConstants.CONTACT_PDA_LIST.length == indexContact) {
          showSelectProfileDialog();
        } else {
          onTapLogin(contactPDA: AppConstants.CONTACT_PDA_LIST[indexContact]);
        }
      } else {
        Get.snackbar(
          "Error",
          "Something went wrong",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    });
  }

  void showSelectProfileDialog() {
    Get.dialog(
      barrierDismissible: true,
      PopScope(
        canPop: false,
        child: AlertDialog(
          content: SizedBox(
            width: 160,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Select Profile Icon",
                  style: Get.textTheme.headlineSmall,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => onTapAvatar(index: index),
                      child: Obx(() {
                        return Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            border: selectedAvatarIndex.value == index
                                ? Border.all(
                                    color: AppColors.redColor,
                                    width: 2,
                                  )
                                : null,
                          ),
                          child: SvgPicture.asset('${AppIcons.icUserAvatar + index.toString()}.svg'),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(
                width: double.infinity,
                height: 48,
              ),
              child: Row(children: [
                Expanded(
                  child: OutlineButtonWidget(
                    height: 36,
                    color: AppColors.tertiaryColor,
                    onTap: () {
                      Get.back();
                      selectedAvatarIndex(-1);
                    },
                    child: Text(
                      "Cancel",
                      style: Get.textTheme.labelLarge,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() {
                    return FillButtonWidget(
                      height: 36,
                      enable: selectedAvatarIndex.value != -1,
                      isLoading: false,
                      onTap: () {
                        Get.back();
                        Get.toNamed(
                          AppRoutes.CREATE_MNEMONIC,
                          arguments: {
                            "avatar": selectedAvatarIndex.value,
                            "userName": phoneNumberTEC.text,
                          },
                        );
                      },
                      buttonTitle: "Select",
                    );
                  }),
                ),
              ]),
            ),
          ],
          actionsPadding: const EdgeInsets.only(
            right: 24,
            left: 24,
            bottom: 24,
          ),
        ),
      ),
    );
  }
}
