import 'package:comet_messenger/app/core/app_enums.dart';
import 'package:comet_messenger/app/core/base/base_repository.dart';
import 'package:comet_messenger/app/models/response_model.dart';
import 'package:comet_messenger/features/transaction_detail/models/transaction_details_response_model.dart';

abstract class TransactionDetailRepository extends BaseRepository {
  Future<TransactionDetailsResponseModel> getTransactionDetailsRequest({required String signature});
}

class TransactionDetailRepositoryImpl extends TransactionDetailRepository {
  @override
  Future<TransactionDetailsResponseModel> getTransactionDetailsRequest({required String signature}) async {
    final ResponseModel response = await request(
      url: 'https://api.mainnet-beta.solana.com',
      method: RequestMethodEnum.POST.name(),
      requiredToken: false,
      data: {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "getTransaction",
        "params": [
          signature,
          {"encoding": "jsonParsed"}
        ]
      },
    );
    TransactionDetailsResponseModel result = TransactionDetailsResponseModel();
    try {
      if (response.success) {
        result = TransactionDetailsResponseModel.fromJson(response.body);
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
