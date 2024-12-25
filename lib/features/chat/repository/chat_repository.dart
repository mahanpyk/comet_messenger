import 'package:comet_messenger/app/core/app_enums.dart';
import 'package:comet_messenger/app/core/base/base_repository.dart';
import 'package:comet_messenger/app/models/request_model.dart';
import 'package:comet_messenger/app/models/response_model.dart';
import 'package:comet_messenger/features/chat/models/chat_details_response_model.dart';
import 'package:comet_messenger/features/chat/models/read_file_response_model.dart';
import 'package:comet_messenger/features/chat/models/send_file_request_model.dart';
import 'package:comet_messenger/features/chat/models/send_file_response_model.dart';

abstract class ChatRepository extends BaseRepository {
  Future<ChatDetailsResponseModel> chatDetailsRequest({required RequestModel requestModel});

  Future<ChatDetailsResponseModel> sendMessage({required RequestModel requestModel});

  Future<SendFileResponseModel> sendFile({
    required SendFileRequestModel requestModel,
    required Map<String, String> headers,
  });

  Future<ReadFileResponseModel> readFile({required String urlParameter});
}

class ChatRepositoryImpl extends ChatRepository {
  @override
  Future<ChatDetailsResponseModel> chatDetailsRequest({required RequestModel requestModel}) async {
    final ResponseModel response = await request(
      method: RequestMethodEnum.POST.name(),
      data: requestModel.toJson(),
      requiredToken: false,
    );
    ChatDetailsResponseModel result = ChatDetailsResponseModel();
    try {
      if (response.success) {
        result = chatDetailsResponseModelFromJson({'data': response.body});
        result.statusCode = response.statusCode;
        return result;
      } else {
        result.message = response.message;
        result.statusCode = response.statusCode;
        return result;
      }
    } catch (e) {
      result.message = e.toString();
      result.statusCode = 600;
      return result;
    }
  }

  @override
  Future<ChatDetailsResponseModel> sendMessage({required RequestModel requestModel}) async {
    final ResponseModel response = await request(
      method: RequestMethodEnum.POST.name(),
      data: requestModel.toJson(),
      requiredToken: false,
    );
    ChatDetailsResponseModel result = ChatDetailsResponseModel();
    try {
      if (response.success) {
        result = chatDetailsResponseModelFromJson({'data': response.body});
        result.statusCode = response.statusCode;
        return result;
      } else {
        result.message = response.message;
        result.statusCode = response.statusCode;
        return result;
      }
    } catch (e) {
      result.message = e.toString();
      result.statusCode = 600;
      return result;
    }
  }

  @override
  Future<SendFileResponseModel> sendFile({
    required SendFileRequestModel requestModel,
    required Map<String, String> headers,
  }) async {
    final ResponseModel response = await request(
      baseUrl: "https://api.pinata.cloud/pinning/pinJSONToIPFS",
      method: RequestMethodEnum.POST.name(),
      data: requestModel.toJson(),
      headers: headers,
      requiredToken: false,
    );
    SendFileResponseModel result = SendFileResponseModel();
    try {
      if (response.success) {
        result = sendFileResponseModelFromJson({'data': response.body});
        result.statusCode = response.statusCode;
        return result;
      } else {
        result.message = response.message;
        result.statusCode = response.statusCode;
        return result;
      }
    } catch (e) {
      result.message = e.toString();
      result.statusCode = 600;
      return result;
    }
  }

  @override
  Future<ReadFileResponseModel> readFile({required String urlParameter}) async {
    final ResponseModel response = await request(
      baseUrl: 'https://gateway.pinata.cloud/ipfs/',
      urlParameters: urlParameter,
      method: RequestMethodEnum.GET.name(),
      requiredToken: false,
    );
    ReadFileResponseModel result = ReadFileResponseModel();
    try {
      if (response.success) {
        result = readFileResponseModelFromJson({'data': response.body});
        result.statusCode = response.statusCode;
        return result;
      } else {
        result.message = response.message;
        result.statusCode = response.statusCode;
        return result;
      }
    } catch (e) {
      result.message = e.toString();
      result.statusCode = 600;
      return result;
    }
  }
}
