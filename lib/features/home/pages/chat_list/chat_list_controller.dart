import 'dart:convert';
import 'dart:typed_data';

import 'package:comet_messenger/app/models/data_length_borsh_model.dart';
import 'package:comet_messenger/app/models/request_model.dart';
import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/features/home/models/chat_list_response_model.dart';
import 'package:comet_messenger/features/home/models/profile_borsh_model.dart';
import 'package:comet_messenger/features/home/repository/chat_list_repository.dart';
import 'package:get/get.dart';
import 'package:solana_borsh/borsh.dart';

class ChatListController extends GetxController {
  ChatListController(this._repo);

  final ChatListRepository _repo;
  RxString title = RxString('There is nothing here');
  UserModel? userModel;
  RxList<ConversationBorshModel> chatList = RxList<ConversationBorshModel>([]);

  @override
  void onInit() async {
    var json = await UserStoreService.to.getUserModel();
    if (json != null) {
      userModel = UserModel.fromJson(json);
    }
    getChatsList();
    super.onInit();
  }

  Future<void> getChatsList() async {
    _repo
        .chatListRequest(
        requestModel: RequestModel(
          method: "getAccountInfo",
          params: [
            userModel!.publicKey,
            ParamClass(
              commitment: "max",
              encoding: "base64",
            ).toJson()
          ],
          jsonrpc: "2.0",
          id: "b75758de-e0b2-469b-bd9c-ef366ee1b35a",
        ))
        .then(
          (ChatListResponseModel response) {
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
          var decodeContacts = borsh.deserialize(ProfileBorshModel().borshSchema, accountDataBuffer, ProfileBorshModel.fromJson);
          chatList.addAll(decodeContacts.conversationList!);
          UserStoreService.to.saveUserModel(userModel!.toJson());
        }
      },
    );
  }

  void contactsPage() => Get.toNamed(AppRoutes.CONTACTS);

  void onTapTransactionDetail({required ConversationBorshModel item}) {
    Get.toNamed(AppRoutes.CHAT, arguments: item.toJson());
  }
}
