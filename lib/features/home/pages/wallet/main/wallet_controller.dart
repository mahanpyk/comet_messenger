import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/home/models/transactions_response_model.dart' as transactions_model;
import 'package:comet_messenger/features/home/repository/wallet_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:solana/solana.dart';

class WalletController extends GetxController with GetTickerProviderStateMixin {
  WalletController(this._repo);

  final WalletRepository _repo;
  RxBool isLoading = true.obs;
  RxList<transactions_model.Result> transactionsList = RxList([]);
  UserModel? userModel;
  late final TabController tabController;
  final TextEditingController receiverAddressTEC = TextEditingController();
  final TextEditingController amountTEC = TextEditingController();
  RpcClient? rpcClient;

  @override
  void onInit() async {
    tabController = TabController(length: 2, vsync: this);
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
          'Error in creating connection',
          'Please try again later',
          mainButton: TextButton(
            onPressed: () {
              isLoading(true);
              getTransactions();
            },
            child: const Text('Retry'),
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

  void onTapTransaction() async {
    if (amountTEC.text.isEmpty || receiverAddressTEC.text.isEmpty) {
      Get.snackbar(
        'Error in creating transaction',
        'Please enter amount and receiver address',
        colorText: AppColors.tertiaryColor,
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.errorColor,
      );
      return;
    }
    const MethodChannel platform = MethodChannel(AppConstants.PLATFORM_CHANNEL);
    try {
      isLoading(true);
      final String result = await platform.invokeMethod('withdraw', {
        "publicKey": receiverAddressTEC.text,
        "privateKey": userModel?.privateKey ?? '',
        "amount": amountTEC.text,
      });
      debugPrint('*****************');
      debugPrint(result);
      debugPrint('-----------------');
      if (result.isNotEmpty && result == 'SUCCESS') {
        Get.snackbar(
          'Transaction successful',
          'The transaction will be in your account in a few minutes',
          colorText: AppColors.tertiaryColor,
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.successColor,
        );
      } else {
        Get.snackbar(
          'Error in creating transaction',
          'Please try again later',
          colorText: AppColors.tertiaryColor,
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.errorColor,
        );
      }
      isLoading(false);
    } on PlatformException catch (e) {
      isLoading(false);
      Get.snackbar(
        'Field to Create Account',
        'Failed to encrypt data: \n${e.message}.',
        colorText: AppColors.tertiaryColor,
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.errorColor,
      );
      debugPrint('*****************************');
      debugPrint("Failed to encrypt data: '${e.message}'.");
      debugPrint('#############################');
    } on Exception catch (e) {
      isLoading(false);
      Get.snackbar(
        'Error in creating transaction',
        'Please try again later',
        colorText: AppColors.tertiaryColor,
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.errorColor,
      );
    }
  }

// void onTapReadQRCode() async {
//   final result = await Get.toNamed(AppRoutes.QR_CODE);
//   if (result != null) {
//     receiverAddressTEC.text = result;
//   }
// }
}
