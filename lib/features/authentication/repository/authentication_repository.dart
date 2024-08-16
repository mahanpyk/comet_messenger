import 'package:comet_messenger/app/core/app_enums.dart';
import 'package:comet_messenger/app/core/base/base_repository.dart';
import 'package:comet_messenger/app/models/request_model.dart';
import 'package:comet_messenger/app/models/response_model.dart';
import 'package:comet_messenger/features/authentication/models/authentication_response_model.dart';

abstract class AuthenticationRepository extends BaseRepository {
  Future<AuthenticationResponseModel> login({required RequestModel requestModel});
}

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  @override
  Future<AuthenticationResponseModel> login({required RequestModel requestModel}) async {
    final ResponseModel response = await request(
      method: RequestMethodEnum.POST.name(),
      data: requestModel.toJson(),
      requiredToken: false,
    );
    AuthenticationResponseModel result = AuthenticationResponseModel();
    try {
      if (response.success) {
        result = authenticationResponseModelFromJson({'data': response.body});
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
