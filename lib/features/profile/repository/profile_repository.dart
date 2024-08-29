import 'package:comet_messenger/app/core/app_enums.dart';
import 'package:comet_messenger/app/core/base/base_repository.dart';
import 'package:comet_messenger/app/models/request_model.dart';
import 'package:comet_messenger/app/models/response_model.dart';
import 'package:comet_messenger/features/authentication/models/balance_response_model.dart';

abstract class ProfileRepository extends BaseRepository {
  Future<double> getSolanaPrice();

  Future<BalanceResponseModel> getBalance({required RequestModel requestModel});
}

class WalletRepositoryImpl extends ProfileRepository {
  @override
  Future<double> getSolanaPrice() async {
    final ResponseModel response = await request(
      url:
          'https://api.diadata.org/v1/assetQuotation/Solana/0x0000000000000000000000000000000000000000',
      method: RequestMethodEnum.GET.name(),
      requiredToken: false,
    );
    try {
      if (response.success) {
        return response.body['Price'];
      } else {
        return -10;
      }
    } catch (e) {
      return -20;
    }
  }

  @override
  Future<BalanceResponseModel> getBalance(
      {required RequestModel requestModel}) async {
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
