import 'package:comet_messenger/app/models/user_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/features/home/models/transactions_response_model.dart' as transactions_model;
import 'package:comet_messenger/features/home/repository/wallet_repository.dart';
import 'package:flutter/material.dart';
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
    try {
      final senderPublicKey = Ed25519HDPublicKey.fromBase58(userModel?.id ?? '');
      final recipientPublicKey = Ed25519HDPublicKey.fromBase58(receiverAddressTEC.text);

      final transferInstruction = SystemInstruction.transfer(
        fundingAccount: senderPublicKey,
        recipientAccount: recipientPublicKey,
        lamports: int.parse(amountTEC.text),
      );
      final message = Message(instructions: [transferInstruction]);
      // final signature = await rpcClient!.signAndSendTransaction(message, [solanaWallet!]);

      Get.snackbar(
        'تراکنش موفق',
        'تراکنش با موفقیت انجام شد',
        colorText: Colors.black,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
      );

      debugPrint('*****************');
      // debugPrint('Transaction signature: $signature');
      debugPrint('-----------------');
    } catch (error) {
      debugPrint('*****************');
      debugPrint('Error during transaction: $error');
      debugPrint('-----------------');
      rethrow;
    }
  }
}
