import 'package:comet_messenger/features/transaction_detail/pages/transaction_detail_controller.dart';
import 'package:comet_messenger/features/transaction_detail/repository/transaction_detail_repository.dart';
import 'package:get/get.dart';

class TransactionDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionDetailRepository>(() => TransactionDetailRepositoryImpl());
    Get.lazyPut<TransactionDetailController>(() => TransactionDetailController(Get.find<TransactionDetailRepository>()));
  }
}
