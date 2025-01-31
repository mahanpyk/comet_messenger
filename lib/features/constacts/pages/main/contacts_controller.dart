import 'dart:convert';

import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/core/app_dialog.dart';
import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:comet_messenger/app/models/data_length_borsh_model.dart';
import 'package:comet_messenger/app/models/request_model.dart';
import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/features/authentication/models/authentication_response_model.dart';
import 'package:comet_messenger/features/authentication/models/contact_model.dart';
import 'package:comet_messenger/features/constacts/repository/contacts_repository.dart';
import 'package:comet_messenger/features/home/models/profile_borsh_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:solana_borsh/borsh.dart';

class ContactsController extends GetxController {
  ContactsController(this._repo);

  final ContactsRepository _repo;
  RxBool isLoading = RxBool(true);
  ContactModel? contactModel;
  RxList<Contact> contacts = RxList([]);
  RxList<Contact> contactsTemp = RxList([]);
  UserModel? userModel;
  List<ConversationBorshModel> chatList = [];

  @override
  void onInit() async {
    super.onInit();
    var jsonUserModel = await UserStoreService.to.getUserModel();
    if (jsonUserModel != null) {
      userModel = UserModel.fromJson(jsonUserModel);
    }
    var args = Get.arguments;
    if (args != null) {
      chatList.addAll(args);
    }
    var contactsJson = await UserStoreService.to.get(key: AppConstants.CONTACTS);
    if (contactsJson != null) {
      contactModel = ContactModel.fromJson(contactsJson);
      contacts.addAll(contactModel?.contacts ?? []);
      isLoading(false);
    }
    getContactsList();
  }

  void showModalConfirmationCreateChat(Contact item) async {
    ConversationBorshModel? conversationModel = chatList.firstWhereOrNull((element) => element.conversationName?.contains(item.userName ?? '') ?? false);
    if (conversationModel != null) {
      Get.offAndToNamed(
        AppRoutes.CHAT,
        arguments: conversationModel.toJson(),
      );
    } else {
      AppDialog dialog = AppDialog(
        title: 'Create Conversation',
        subTitle: 'This will cost you. are you sure you want to create this conversation?',
        mainButtonTitle: 'Yes',
        icon: AppIcons.icWarning,
        mainButtonOnTap: () {
          Get.back();
          sendCreateConversation(item);
        },
        otherTask: () => Get.back(),
        otherTaskTitle: 'No',
      );
      dialog.showAppDialog();
    }
  }

  void sendCreateConversation(Contact item) async {
    isLoading(true);
    const platform = MethodChannel(AppConstants.PLATFORM_CHANNEL);
    try {
      var privateKey = userModel?.privateKey ?? '';
      var publicKey = userModel?.publicKey ?? '';
      var userName = userModel?.userName ?? '';
      var avatar = userModel?.avatar ?? '';
      var contactPublicKey = item.publicKey ?? '';
      var contactUsername = item.userName ?? '';
      final String result = await platform.invokeMethod('createConversation', {
        "publicKey": publicKey,
        "contactPublicKey": contactPublicKey,
        "privateKey": privateKey,
        "username": userName,
        "contactUsername": contactUsername,
        "indexAvatar": avatar,
      });

      debugPrint('*****************************');
      debugPrint(result);
      debugPrint('#############################');
      isLoading(false);
      Get.back(result: {
        'username': contactUsername,
        'avatar': item.avatar,
      });

      // Get.toNamed(AppRoutes.CHAT);
    } on PlatformException catch (e) {
      debugPrint('*****************************');
      debugPrint("Failed to create chat:\n${e.message}");
      debugPrint('#############################');
      Get.snackbar(
        "Error",
        "Something went wrong\n${e.message}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isLoading(false);
    }
  }

  void getContactsList({String? contactPDA}) {
    _repo
        .getContactsList(
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
        contactsTemp.addAll(decodeContacts.contacts ?? []);
        int indexContact = AppConstants.CONTACT_PDA_LIST.indexWhere((element) => element == (contactPDA ?? AppConstants.CONTACT_PDA_LIST.first));
        indexContact++;
        if (AppConstants.CONTACT_PDA_LIST.length > indexContact) {
          getContactsList(contactPDA: AppConstants.CONTACT_PDA_LIST[indexContact]);
        } else {
          if (contactsTemp.isNotEmpty && contactsTemp.length > contacts.length) {
            contacts.clear();
            contacts.addAll(contactsTemp);
            ContactModel contactModel = ContactModel(contacts: contacts);
            UserStoreService.to.save(key: AppConstants.CONTACTS, value: contactModel.toJson());
            isLoading(false);
            contactsTemp.close();
          }
        }
      } else {
        Get.snackbar(
          "Error",
          "Can't Load contacts",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    });
  }
}
