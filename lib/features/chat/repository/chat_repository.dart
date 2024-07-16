import 'package:comet_messenger/app/core/app_enums.dart';
import 'package:comet_messenger/app/core/base/base_repository.dart';
import 'package:comet_messenger/app/models/request_model.dart';
import 'package:comet_messenger/app/models/response_model.dart';
import 'package:comet_messenger/features/chat/models/chat_details_response_model.dart';

abstract class ChatRepository extends BaseRepository {
  Future<ChatDetailsResponseModel> chatDetailsRequest({required RequestModel requestModel});
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
}
