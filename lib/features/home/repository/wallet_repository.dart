import 'package:comet_messenger/app/core/app_enums.dart';
import 'package:comet_messenger/app/core/base/base_repository.dart';
import 'package:comet_messenger/app/models/response_model.dart';
import 'package:comet_messenger/features/home/models/transactions_response_model.dart';

abstract class WalletRepository extends BaseRepository {
  Future<TransactionsResponseModel> getTransactionsRequest(
      {required String walletAddress});
}

class WalletRepositoryImpl extends WalletRepository {
  @override
  Future<TransactionsResponseModel> getTransactionsRequest(
      {required String walletAddress}) async {
    final ResponseModel response = await request(
      method: RequestMethodEnum.POST.name(),
      requiredToken: false,
      data: {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "getConfirmedSignaturesForAddress2",
        "params": [
          walletAddress,
        ]
      },
    );
    TransactionsResponseModel result = TransactionsResponseModel();
    try {
      if (response.success) {
        result = TransactionsResponseModel.fromJson(response.body);
        result.statusCode = response.statusCode;
        return result;
      } else {
        result.statusCode = response.statusCode;
        return result;
      }
    } catch (e) {
      return result;
    }
  }
}
