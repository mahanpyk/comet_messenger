import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/models/list_user_wallets_model.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/features/home/models/transactions_response_model.dart';
import 'package:comet_messenger/features/home/repository/wallet_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:http/http.dart';
import 'package:solana/solana.dart' as solana;
import 'package:solana_web3/solana_web3.dart' as solana_web3;

class WalletController extends GetxController {
  WalletController(this._repository);

  final WalletRepository _repository;
  RxDouble assets = RxDouble(0.0);
  late final String? mnemonic;

  // BalanceResult? solanaBalance;
  int solanaBalance = 0;
  String solanaWalletAddress = '';
  RxDouble solanaPrice = RxDouble(0.0);
  solana.Ed25519HDKeyPair? solanaWallet;
  solana.RpcClient? rpcClient;
  RxBool isLoading = true.obs;
  ListUserWalletsModel? listUserWalletsModel;
  RxInt activeWallet = RxInt(0);
  RxList<Result> transactionsList = RxList([]);


  @override
  void onInit() async {
    var wallets = UserStoreService.to.get(key: AppConstants.WALLETS);
    if (wallets != null) {
      listUserWalletsModel = ListUserWalletsModel.fromJson(wallets);
    }
    var wallet = listUserWalletsModel!.listWallets!.firstWhere((element) => element.isActive == true);
    activeWallet(wallet.id);
    mnemonic = await UserStoreService.to.getMnemonic();
    await createSolanaWalletWithPrivateKey();
    getSolanaPrice();
    super.onInit();
  }

  Future<void> createSolanaWalletWithPrivateKey() async {
    try {
      final cluster = solana_web3.Cluster.mainnet;
      final connection = solana_web3.Connection(cluster);
      final privateKeyBytes = solana_web3.base58.decode(mnemonic.toString());
      final wallet1 = solana_web3.Keypair.fromSeckeySync(privateKeyBytes);
      solanaWalletAddress = wallet1.pubkey.toString();
      solanaBalance = await connection.getBalance(wallet1.pubkey);
      solanaPrice(solanaBalance.toDouble() / 1000000000);
      debugPrint('*****************');
      debugPrint('Private Key Bytes: $privateKeyBytes');
      debugPrint('address1 : $solanaWalletAddress');
      debugPrint('balance: $solanaBalance');
      debugPrint('-----------------');
    } catch (e) {
      debugPrint('*****************');
      debugPrint('Error: $e');
      debugPrint('-----------------');
    }
  }

  void onTapSolana() {
  }

  void onTapBitcoin() {
  }

  void onTapWallets() {
  }

  void getSolanaPrice() {
    _repository.getSolanaPrice().then((double response) {
      assets(solanaPrice * response);
      isLoading(false);
    });
  }

  void getTransactions() {
    _repository.getTransactionsRequest(walletAddress: solanaWalletAddress).then((TransactionsResponseModel response) {
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
