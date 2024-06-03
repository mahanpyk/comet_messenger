import 'package:comet_messenger/app/core/app_utils_mixin.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/transaction_detail/models/transaction_details_response_model.dart';
import 'package:comet_messenger/features/transaction_detail/repository/transaction_detail_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TransactionDetailController extends GetxController with AppUtilsMixin {
  TransactionDetailController(this._repository);

  final TransactionDetailRepository _repository;
  RxBool isLoading = true.obs;
  late final String signature;
  Data transactionDetail = Data();

  @override
  void onInit() {
    var data = Get.arguments;
    if (data != null) {
      signature = data['signature'];
    }
    getTransactionDetails();
    super.onInit();
  }

  void getTransactionDetails() {
    _repository.getTransactionDetailsRequest(signature: signature).then((TransactionDetailsResponseModel response) {
      if (response.statusCode == 200) {
        transactionDetail = response.data!;
        isLoading(false);
      } else {
        Get.snackbar(
          'خطا در برقراری ارتباط',
          "مشکلی پیش آمده است",
          mainButton: TextButton(
            onPressed: () {
              isLoading(true);
              getTransactionDetails();
            },
            child: const Text('تلاش مجدد'),
          ),
        );
      }
    });
  }

  void onTapSignature() {
    Clipboard.setData(ClipboardData(text: signature));
    Get.snackbar(
      '',
      'signature کپی شد',
      colorText: AppColors.tertiaryColor,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String convertUnixToDate(int unix) {
    return DateTime.fromMillisecondsSinceEpoch(unix * 1000).toString();
  }

  String convertSolanaBalance({required int balance}) {
    return (balance / 1000000000).toStringAsFixed(7);
  }
}
