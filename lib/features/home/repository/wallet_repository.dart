import 'package:comet_messenger/app/core/app_enums.dart';
import 'package:comet_messenger/app/core/base/base_repository.dart';
import 'package:comet_messenger/app/models/request_model.dart';
import 'package:comet_messenger/app/models/response_model.dart';
import 'package:comet_messenger/features/home/models/transactions_response_model.dart';
import 'package:comet_messenger/features/login/models/balance_response_model.dart';

abstract class WalletRepository extends BaseRepository {
  Future<double> getSolanaPrice();

  Future<TransactionsResponseModel> getTransactionsRequest({required String walletAddress});

  Future<BalanceResponseModel> getBalance({required RequestModel requestModel});
}

class WalletRepositoryImpl extends WalletRepository {
  @override
  Future<double> getSolanaPrice() async {
    final ResponseModel response = await request(
      url: 'https://api.diadata.org/v1/assetQuotation/Solana/0x0000000000000000000000000000000000000000',
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
  Future<TransactionsResponseModel> getTransactionsRequest({required String walletAddress}) async {
    final ResponseModel response = await request(
      url: 'https://api.mainnet-beta.solana.com',
      method: RequestMethodEnum.POST.name(),
      requiredToken: false,
      data: {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "getConfirmedSignaturesForAddress2",
        "params": [
          walletAddress,
          {"limit": 10}
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
