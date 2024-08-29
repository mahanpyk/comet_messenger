import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/features/home/models/transactions_response_model.dart' as transactions_model;
import 'package:comet_messenger/features/home/repository/wallet_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  WalletController(this._repo);

  final WalletRepository _repo;
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
}
