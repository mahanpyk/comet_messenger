import 'package:comet_messenger/app/core/app_enums.dart';
import 'package:comet_messenger/app/core/base/base_repository.dart';
import 'package:comet_messenger/app/models/response_model.dart';
import 'package:comet_messenger/features/login/models/login_request_model.dart';
import 'package:comet_messenger/features/login/models/login_response_model.dart';

abstract class LoginRepository extends BaseRepository {
  Future<LoginResponseModel> login({required LoginRequestModel requestModel});
}

class LoginRepositoryImpl extends LoginRepository {
  @override
  Future<LoginResponseModel> login({required LoginRequestModel requestModel}) async {
    final ResponseModel response = await request(
      method: RequestMethodEnum.POST.name(),
      data: requestModel.toJson(),
      requiredToken: false,
    );
    LoginResponseModel result = LoginResponseModel();
    try {
      if (response.success) {
        result = loginResponseModelFromJson({'data':response.body});
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
