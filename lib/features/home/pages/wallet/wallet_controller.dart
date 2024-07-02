import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/models/request_model.dart';
import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/features/home/models/transactions_response_model.dart' as transactions_model;
import 'package:comet_messenger/features/home/repository/wallet_repository.dart';
import 'package:comet_messenger/features/login/models/balance_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  WalletController(this._repo);

  final WalletRepository _repo;
  RxDouble assets = RxDouble(0.0);
  RxBool isLoading = true.obs;
  RxList<transactions_model.Result> transactionsList = RxList([]);
  UserModel? userModel;

  @override
  void onInit() async {
    var json = await UserStoreService.to.getUserModel();
    if (json != null) {
      userModel = UserModel.fromJson(json);
    }
    getTransactions();
    getBalance();
    super.onInit();
  }

  void getTransactions() {
    _repo.getTransactionsRequest(walletAddress: userModel!.basePublicKey!).then((transactions_model.TransactionsResponseModel response) {
      if (response.statusCode == 200) {
        transactionsList.addAll(response.data!.result!);
        isLoading(false);
      } else {
        Get.snackbar(
          'خطا در برقراری ارتباط',
          "مشکلی پیش آمده است",
          mainButton: TextButton(
            onPressed: () {
              isLoading(true);
              getTransactions();
            },
            child: const Text('تلاش مجدد'),
          ),
        );
      }
    });
  }

  String convertUnixToDate(int unix) {
    return DateTime.fromMillisecondsSinceEpoch(unix * 1000).toString();
  }

  void onTapTransactionDetail(String signature) {
    Get.toNamed(
      AppRoutes.TRANSACTION_DETAIL,
      arguments: {'signature': signature},
    );
  }

  void getBalance() {
    Future.delayed(const Duration(seconds: 1), () {
      _repo
          .getBalance(
              requestModel: RequestModel(
        method: "getBalance",
        params: [userModel!.basePublicKey!],
        jsonrpc: "2.0",
        id: "b75758de-e0b2-469b-bd9c-ef366ee1b35a",
      ))
          .then((BalanceResponseModel response) {
        if (response.statusCode == 200) {
          double balance = response.data!.result!.value! / 1000000000;
          assets(balance);

          UserStoreService.to.save(key: AppConstants.BALANCE, value: balance);
        }
      });
    });
  }
}
