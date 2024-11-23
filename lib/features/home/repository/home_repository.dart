import 'package:comet_messenger/app/core/app_enums.dart';
import 'package:comet_messenger/app/core/base/base_repository.dart';
import 'package:comet_messenger/app/models/request_model.dart';
import 'package:comet_messenger/app/models/response_model.dart';
import 'package:comet_messenger/features/home/models/balance_response_model.dart';

abstract class HomeRepository extends BaseRepository {
  Future<BalanceResponseModel> getBalance({required RequestModel requestModel});
}

class HomeRepositoryImpl extends HomeRepository {
  @override
  Future<BalanceResponseModel> getBalance({required RequestModel requestModel}) async {
    final ResponseModel response = await request(
      method: RequestMethodEnum.POST.name(),
      data: requestModel.toJson(),
      requiredToken: false,
    );
    BalanceResponseModel result = BalanceResponseModel();
    try {
      if (response.success) {
        result = balanceResponseModelFromJson({'data': response.body});
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
