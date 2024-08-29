import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/core/app_dialog.dart';
import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/features/authentication/models/contact_model.dart';
import 'package:comet_messenger/features/constacts/repository/contacts_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ContactsController extends GetxController {
  ContactsController(this._repo);

  final ContactsRepository _repo;
  RxBool isLoading = RxBool(false);
  ContactModel? contactModel;
  RxList<Contact> contacts = RxList([]);
  UserModel? userModel;

  @override
  void onInit() async {
    super.onInit();
    var jsonUserModel = await UserStoreService.to.getUserModel();
    if (jsonUserModel != null) {
      userModel = UserModel.fromJson(jsonUserModel);
    }
    var json = UserStoreService.to.get(key: AppConstants.CONTACTS);
    if (json != null) {
      contactModel = ContactModel.fromJson(json);
      contactModel!.contacts!
          .removeWhere((element) => element.userName == userModel?.userName);
      contacts(contactModel!.contacts!);
    }
  }

  void showModalConfirmationCreateChat(Contact item) async {
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
      debugPrint(result.toString());
      debugPrint('#############################');
      Get.toNamed(AppRoutes.CHAT);
      isLoading(false);
    } on PlatformException catch (e) {
      debugPrint('*****************************');
      debugPrint("Failed to encrypt data: ${e.message}.");
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
}
