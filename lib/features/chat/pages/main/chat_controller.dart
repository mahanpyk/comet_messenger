import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/core/app_enums.dart';
import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:comet_messenger/app/core/app_utils_mixin.dart';
import 'package:comet_messenger/app/models/data_length_borsh_model.dart';
import 'package:comet_messenger/app/models/request_model.dart';
import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/chat/models/chat_details_borsh_model.dart';
import 'package:comet_messenger/features/chat/models/chat_details_response_model.dart';
import 'package:comet_messenger/features/chat/models/chat_list_model.dart';
import 'package:comet_messenger/features/chat/models/read_file_response_model.dart';
import 'package:comet_messenger/features/chat/models/send_file_request_model.dart';
import 'package:comet_messenger/features/chat/models/send_file_response_model.dart';
import 'package:comet_messenger/features/chat/repository/chat_repository.dart';
import 'package:comet_messenger/features/home/models/profile_borsh_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:solana_borsh/borsh.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController with AppUtilsMixin, WidgetsBindingObserver {
  ChatController(this._repo);

  final ChatRepository _repo;
  RxBool isLoading = RxBool(true);
  RxBool isTyping = RxBool(false);
  UserModel? userModel;
  Rx<ConversationBorshModel> conversationModel = Rx(ConversationBorshModel());
  Rx<ChatDetailsBorshModel> chatDetailsModel = Rx(ChatDetailsBorshModel());
  RxList<ChatListModel?> chatMessages = RxList([]);
  TextEditingController messageTEC = TextEditingController();
  Rx<ScrollController> scrollController = Rx(ScrollController(initialScrollOffset: 0));
  String tokenCipher = '';
  Timer? _refreshTimer;

  @override
  void onInit() async {
    var json = await UserStoreService.to.getUserModel();
    if (json != null) {
      userModel = UserModel.fromJson(json);
    }
    var args = Get.arguments;
    if (args != null) {
      conversationModel(ConversationBorshModel.fromJson(args));
    }
    var chatsJson = await UserStoreService.to.get(key: conversationModel.value.conversationId ?? '');
    if (chatsJson != null) {
      chatDetailsModel(ChatDetailsBorshModel.fromJson(chatsJson));
      await readMessageFromChatList();
    }
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    startRefreshingChats();
    getChatDetail();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    stopRefreshingChats();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      startRefreshingChats();
    } else if (state == AppLifecycleState.paused) {
      stopRefreshingChats();
    }
  }

  void startRefreshingChats() {
    _refreshTimer ??= Timer.periodic(const Duration(seconds: 8), (timer) async {
      await refreshChatList();
    });
  }

  void stopRefreshingChats() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<void> refreshChatList() async {
    try {
      await getChatDetail();
    } catch (e) {
      debugPrint("Error while refreshing chats: $e");
    }
  }

  Future<void> getChatDetail() async {
    _repo
        .chatDetailsRequest(
            requestModel: RequestModel(
      method: "getAccountInfo",
      params: [
        conversationModel.value.conversationId,
        ParamClass(
          commitment: "max",
          encoding: "base64",
        ).toJson()
      ],
      jsonrpc: "2.0",
      id: "b75758de-e0b2-469b-bd9c-ef366ee1b35a",
    ))
        .then(
      (ChatDetailsResponseModel response) async {
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
          var chatDetailsDeserialized = borsh.deserialize(ChatDetailsBorshModel().borshSchema, accountDataBuffer, ChatDetailsBorshModel.fromJson);
          var chatsJson = await UserStoreService.to.get(key: conversationModel.value.conversationId ?? '');
          if (chatsJson != null) {
            chatDetailsModel(ChatDetailsBorshModel.fromJson(chatsJson));
          }
          if ((chatDetailsModel.value.messages?.length ?? 0) != (chatDetailsDeserialized.messages?.length ?? 0)) {
            chatDetailsModel(chatDetailsDeserialized);
            chatMessages.clear();
            UserStoreService.to.save(key: conversationModel.value.conversationId ?? '', value: chatDetailsModel.toJson());
            await readMessageFromChatList();
          }
        }
        isLoading(false);
      },
    );
  }

  Future<void> readMessageFromChatList() async {
    try {
      const platform = MethodChannel(AppConstants.PLATFORM_CHANNEL);
      tokenCipher = chatDetailsModel.value.members?.last.tokenCipher ?? '';

      if (tokenCipher == "") {
        tokenCipher = await platform.invokeMethod('createCipher');
      } else {
        tokenCipher = await platform.invokeMethod('importCipher', {
          'tokenCipher': tokenCipher,
          'base64PrivateKey': AppConstants.PRIVATE_KEY,
        });
      }
      // convert to for
      for (int index = 0; index < (chatDetailsModel.value.messages?.length ?? 0); index++) {
        MessageBorshModel element = chatDetailsModel.value.messages![index];
        String text;
        try {
          final String decryptMessage = await platform.invokeMethod('decryptMessage', {
            'message': element.text,
            'privateKey': tokenCipher,
          });
          text = decryptMessage;
        } on Exception catch (e) {
          try {
            final String decryptMessage = await platform.invokeMethod('decryptMessage', {
              'message': element.text,
              'privateKey': "",
            });
            text = decryptMessage;
            debugPrint('*****************************');
            debugPrint("Failed to decrypt data: $e");
            debugPrint('#############################');
          } on Exception catch (e) {
            text = element.text!;
            debugPrint('*****************************');
            debugPrint("Failed to decrypt data: $e");
            debugPrint('#############################');
          }
        }
        element.status = ChatStateEnum.SUCCESS.name;

        if ((element.messageType ?? 'text') == 'text') {
          chatMessages.add(ChatListModel(
            text: text,
            messageType: MassageTypeEnum.TEXT,
            isMe: element.senderAddress == userModel!.id,
            time: chatDetailsModel.value.messages?[index].time,
            status: getStatusIcon(chatDetailsModel.value.messages![index].status ?? ChatStateEnum.SUCCESS.name),
          ));
        } else {
          chatMessages.add(ChatListModel(
            text: text,
            messageType: element.messageType == 'file' ? MassageTypeEnum.FILE : MassageTypeEnum.IMAGE,
            isMe: element.senderAddress == userModel!.id,
            time: chatDetailsModel.value.messages?[index].time,
            status: getStatusIcon(chatDetailsModel.value.messages![index].status ?? ChatStateEnum.SUCCESS.name),
            file: text == '' ? base64Decode(element.name ?? '') : null,
          ));
          readMessageFromIPFS(
            ipfs: text,
            index: index,
            isMe: element.senderAddress == userModel!.id,
            time: chatDetailsModel.value.messages?[index].time ?? '',
            status: getStatusIcon(chatDetailsModel.value.messages![index].status ?? ChatStateEnum.SUCCESS.name),
          );
        }
      }
      isLoading(false);
      if (chatMessages.isNotEmpty) {
        scrollToBottom();
      }
    } on PlatformException catch (e) {
      debugPrint('*****************************');
      debugPrint("Failed to decrypt data: '${e.message}'.");
      debugPrint('#############################');
      return;
    }
  }

  void sendMessage() async {
    if (messageTEC.text.isNotEmpty) {
      String time = setTimeFormat(DateTime.now().toUtc().toIso8601String());
      String text = messageTEC.text;
      var chatModel = ChatDetailsBorshModel(
        admin: chatDetailsModel.value.admin,
        messages: [
          ...chatDetailsModel.value.messages ?? [],
          MessageBorshModel(
            text: text,
            time: time,
            status: ChatStateEnum.SEND.name,
            senderAddress: userModel?.id ?? '',
            messageType: 'text',
          ),
        ],
        conversationName: chatDetailsModel.value.conversationName,
        createdTime: chatDetailsModel.value.createdTime,
        members: chatDetailsModel.value.members,
        isPrivate: chatDetailsModel.value.isPrivate,
      );
      chatDetailsModel(ChatDetailsBorshModel(
        admin: chatDetailsModel.value.admin,
        messages: [
          ...chatDetailsModel.value.messages ?? [],
          MessageBorshModel(
            text: text,
            time: time,
            status: ChatStateEnum.PENDING.name,
            senderAddress: userModel?.id ?? '',
            messageType: 'text',
          ),
        ],
        conversationName: chatDetailsModel.value.conversationName,
        createdTime: chatDetailsModel.value.createdTime,
        members: chatDetailsModel.value.members,
        isPrivate: chatDetailsModel.value.isPrivate,
      ));
      UserStoreService.to.save(key: conversationModel.value.conversationId ?? '', value: chatModel.toJson());
      chatMessages.add(ChatListModel(
        text: text,
        messageType: MassageTypeEnum.TEXT,
        isMe: true,
        time: time,
        status: getStatusIcon(ChatStateEnum.PENDING.name),
      ));
      scrollToBottom();

      const platform = MethodChannel(AppConstants.PLATFORM_CHANNEL);

      try {
        final String result = await platform.invokeMethod('encryptMessage', {
          'message': text,
          'key': tokenCipher,
        });
        messageTEC.clear();

        var conversationId = conversationModel.value.conversationId ?? '';
        var privateKey = userModel?.privateKey ?? '';
        var publicKey = userModel?.publicKey ?? '';
        var userName = userModel?.userName ?? '';

        final String sendTransaction = await platform.invokeMethod('sendTransaction', {
          'message': result,
          'privateKey': privateKey,
          'conversationId': conversationId,
          'userName': userName,
          'publicKey': publicKey,
          'time': time,
          'messageType': 'text'
        });

        debugPrint('*****************************');
        debugPrint(sendTransaction.toString());
        debugPrint('#############################');
        chatDetailsModel.value.messages!.removeWhere((element) => element.time == time);
        chatDetailsModel(ChatDetailsBorshModel(
          admin: chatDetailsModel.value.admin,
          messages: [
            ...chatDetailsModel.value.messages ?? [],
            MessageBorshModel(
              text: text,
              time: time,
              status: sendTransaction.toString() == 'true' ? ChatStateEnum.SEND.name : ChatStateEnum.FAILURE.name,
              senderAddress: userModel?.id ?? '',
              messageType: 'text',
            ),
          ],
          conversationName: chatDetailsModel.value.conversationName,
          createdTime: chatDetailsModel.value.createdTime,
          members: chatDetailsModel.value.members,
          isPrivate: chatDetailsModel.value.isPrivate,
        ));
        chatMessages.removeWhere((element) => (element?.time ?? '') == time);

        chatMessages.add(
          ChatListModel(
            text: text,
            messageType: MassageTypeEnum.TEXT,
            time: time,
            isMe: true,
            status: getStatusIcon(sendTransaction.toString() == 'true' ? ChatStateEnum.SEND.name : ChatStateEnum.FAILURE.name),
          ),
        );
      } on PlatformException catch (e) {
        debugPrint('*****************************');
        debugPrint("Failed to encrypt data: ${e.message}.");
        debugPrint('#############################');
      }

/*      _repo
          .sendMessage(
        requestModel: RequestModel(
          method: "sendTransaction",
          params: [
            conversationModel.conversationId,
            messageTEC.text,
            ParamClass(encoding: "base64").toJson(),
          ],
          jsonrpc: "2.0",
          id: "b75758de-e0b2-469b-bd9c-ef366ee1b35a",
        ),
      )
          .then((value) {
        if (value.statusCode == 200) {
          messageTEC.clear();
        }
      });*/
    }
  }

  String formatDate(String time) {
    try {
      DateTime utcDateTime = DateTime.parse(time);
      DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
      return formatter.format(utcDateTime);
    } on Exception catch (e) {
      DateTime utcDateTime = DateTime.now();
      DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
      return formatter.format(utcDateTime);
    }
  }

  String setTimeFormat(String iso8601string) {
    DateTime utcDateTime = DateTime.parse(iso8601string);
    utcDateTime = utcDateTime.toUtc().add(const Duration(hours: 3, minutes: 30));
    DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    String formatted = formatter.format(utcDateTime);
    return formatted;
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      scrollController.value.jumpTo(scrollController.value.position.maxScrollExtent);
    });
  }

  String getStatusIcon(String status) {
    if (status == ChatStateEnum.PENDING.name) {
      return AppIcons.icClock;
    } else if (status == ChatStateEnum.SEND.name) {
      return AppIcons.icCheck;
    } else if (status == ChatStateEnum.SUCCESS.name) {
      return AppIcons.icDoubleCheck;
    } else {
      return AppIcons.icFailure;
    }
  }

  void onTapChatHeader() {
    Get.toNamed(
      AppRoutes.CHAT_PROFILE,
      arguments: {
        'chatDetailModel': chatDetailsModel.toJson(),
        'avatar': getAvatar(conversationModel.value.avatar),
        'userName': getUserName(),
      },
    );
  }

  String getUserName() {
    return conversationModel.value.conversationName?.replaceAll('${userModel?.userName ?? ''}&_#', '').replaceAll('&_#${userModel?.userName ?? ''}', '') ??
        'No title';
  }

  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      Uint8List fileBytes = file.readAsBytesSync();
      double fileSizeInKB = fileBytes.lengthInBytes / 1024;
      if (fileSizeInKB > 100) {
        Get.snackbar(
          'Error',
          'File size is too large. Please select a file less than 100KB.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        List<String> list = await queryName(file);
        // convert file to base64
        String base64File = base64Encode(fileBytes);
        String time = setTimeFormat(DateTime.now().toUtc().toIso8601String());
        String text = '';
        String type;
        if (list[2] == 'jpeg' || list[2] == 'jpg' || list[2] == 'png') {
          type = list[2];
        } else {
          type = 'file';
        }
        var chatModel = ChatDetailsBorshModel(
          admin: chatDetailsModel.value.admin,
          messages: [
            ...chatDetailsModel.value.messages ?? [],
            MessageBorshModel(
              text: text,
              time: time,
              status: ChatStateEnum.SEND.name,
              senderAddress: userModel?.id ?? '',
              messageType: type,
              name: base64Encode(fileBytes),
            ),
          ],
          conversationName: chatDetailsModel.value.conversationName,
          createdTime: chatDetailsModel.value.createdTime,
          members: chatDetailsModel.value.members,
          isPrivate: chatDetailsModel.value.isPrivate,
        );
        chatDetailsModel(ChatDetailsBorshModel(
          admin: chatDetailsModel.value.admin,
          messages: [
            ...chatDetailsModel.value.messages ?? [],
            MessageBorshModel(
              text: text,
              time: time,
              status: ChatStateEnum.PENDING.name,
              senderAddress: userModel?.id ?? '',
              messageType: type,
            ),
          ],
          conversationName: chatDetailsModel.value.conversationName,
          createdTime: chatDetailsModel.value.createdTime,
          members: chatDetailsModel.value.members,
          isPrivate: chatDetailsModel.value.isPrivate,
        ));
        UserStoreService.to.save(key: conversationModel.value.conversationId ?? '', value: chatModel.toJson());
        chatMessages.add(
          ChatListModel(
            text: text,
            messageType: type == 'file' ? MassageTypeEnum.FILE : MassageTypeEnum.IMAGE,
            time: time,
            isMe: true,
            status: getStatusIcon(ChatStateEnum.PENDING.name),
            file: fileBytes,
          ),
        );
        scrollToBottom();
        _repo.sendFile(
            requestModel: SendFileRequestModel(
              image: base64File,
              name: list[0],
              size: list[1],
              type: list[2],
              uuid: const Uuid().v4(),
            ),
            headers: {
              "pinata_api_key": "8b4d1b2f17e8aabafb83",
              "pinata_secret_api_key": "b1030db36f592a52fb045799e864471b39829133df9906ded6b72bf8e75f880b",
              "Content-Type": "application/json",
            }).then(
          (SendFileResponseModel response) async {
            if (response.statusCode == 200) {
              text = response.data?.ipfsHash ?? '';

              const platform = MethodChannel(AppConstants.PLATFORM_CHANNEL);

              try {
                final String result = await platform.invokeMethod('encryptMessage', {
                  'message': response.data?.ipfsHash ?? '',
                  'key': tokenCipher,
                });
                messageTEC.clear();

                var conversationId = conversationModel.value.conversationId ?? '';
                var privateKey = userModel?.privateKey ?? '';
                var publicKey = userModel?.publicKey ?? '';
                var userName = userModel?.userName ?? '';

                final String sendTransaction = await platform.invokeMethod('sendTransaction', {
                  'message': result,
                  'privateKey': privateKey,
                  'conversationId': conversationId,
                  'userName': userName,
                  'publicKey': publicKey,
                  'time': time,
                  'messageType': type,
                });

                debugPrint('*****************************');
                debugPrint(sendTransaction.toString());
                debugPrint('#############################');
                chatDetailsModel.value.messages!.removeWhere((element) => element.time == time);
                chatDetailsModel(ChatDetailsBorshModel(
                  admin: chatDetailsModel.value.admin,
                  messages: [
                    ...chatDetailsModel.value.messages ?? [],
                    MessageBorshModel(
                      text: text,
                      time: time,
                      status: sendTransaction.toString() == 'true' ? ChatStateEnum.SEND.name : ChatStateEnum.FAILURE.name,
                      senderAddress: userModel?.id ?? '',
                      messageType: type,
                    ),
                  ],
                  conversationName: chatDetailsModel.value.conversationName,
                  createdTime: chatDetailsModel.value.createdTime,
                  members: chatDetailsModel.value.members,
                  isPrivate: chatDetailsModel.value.isPrivate,
                ));
                chatMessages.removeWhere((element) => (element?.time ?? '') == time);

                chatMessages.add(
                  ChatListModel(
                    text: text,
                    messageType: type == 'file' ? MassageTypeEnum.FILE : MassageTypeEnum.IMAGE,
                    time: time,
                    isMe: true,
                    status: getStatusIcon(sendTransaction.toString() == 'true' ? ChatStateEnum.SEND.name : ChatStateEnum.FAILURE.name),
                    file: fileBytes,
                  ),
                );
              } on PlatformException catch (e) {
                debugPrint('*****************************');
                debugPrint("Failed to encrypt data: ${e.message}.");
                debugPrint('#############################');
              }
            } else {
              Get.snackbar(
                'Error',
                'Something went wrong. Please try again.',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          },
        );
      }
    } else {}
  }

  Future<List<String>> queryName(File file) async {
    if (await file.exists()) {
      String name = path.basename(file.path);
      int size = await file.length();

      List<String> result = [];
      result.add(name);
      result.add((size / 1024).toString());
      result.add(path.extension(name).replaceAll('.', ''));
      return result;
    } else {
      throw Exception("File does not exist");
    }
  }

  void readMessageFromIPFS({
    required String ipfs,
    required int index,
    required bool isMe,
    required String time,
    required String status,
  }) {
    if (ipfs.isEmpty || ipfs == '') {
      chatMessages.removeWhere((element) => (element?.text ?? '') == ipfs);
      return;
    }
    _repo.readFile(urlParameter: ipfs).then((ReadFileResponseModel response) {
      if (response.statusCode == 200) {
        var type = response.data?.type ?? 'file';
        MassageTypeEnum massageType;
        if (type == 'jpeg' || type == 'jpg' || type == 'png') {
          massageType = MassageTypeEnum.IMAGE;
        } else {
          massageType = MassageTypeEnum.FILE;
        }

        // remove old message from list and add new file message to list at same index
        // find index
        var indexItem = chatMessages.indexWhere((element) => (element?.time ?? '') == time);
        // remove old message
        chatMessages.removeAt(indexItem);
        // add new message
        chatMessages.insert(
          indexItem > chatMessages.length ? chatMessages.length : indexItem,
          ChatListModel(
            text: ipfs,
            messageType: massageType,
            file: base64.decode(response.data?.content?.replaceAll('\n', '') ?? ''),
            isMe: isMe,
            time: time,
            status: status,
          ),
        );
        scrollToBottom();
        // isLoading(true);
        // isLoading(false);
      }
    });
  }

  Future<void> saveImageToGallery({required Uint8List imageBytes}) async {
    final result = await ImageGallerySaver.saveImage(
      imageBytes,
      quality: 80, // کیفیت تصویر
      name: "my_saved_image", // نام فایل
    );

    if (result['isSuccess']) {
      Get.snackbar(
        'Image saved to gallery',
        'Image saved successfully',
        colorText: AppColors.tertiaryColor,
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.successColor,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to save image',
        colorText: AppColors.tertiaryColor,
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.errorColor,
      );
    }
  }
}
