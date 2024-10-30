import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/transaction_detail/pages/transaction_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class TransactionDetailPage extends BaseView<TransactionDetailController> {
  const TransactionDetailPage({super.key});

  @override
  Widget body() {
    return Column(
      children: [
        Container(
          height: 64,
          width: Get.width,
          color: AppColors.primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(onPressed: () => Get.back()),
                Center(
                  child: Text(
                    'Transaction Details',
                    style: Get.textTheme.titleLarge!.copyWith(color: AppColors.tertiaryColor),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
        ),
        controller.isLoading.value
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Shimmer.fromColors(
                  baseColor: AppColors.shimmerBaseColor,
                  highlightColor: AppColors.shimmerHighlightColor,
                  child: Container(
                    height: 240,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              )
            : Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transaction Data',
                        style: Get.textTheme.titleSmall!.copyWith(color: AppColors.tertiaryColor),
                      ),
                      Text(
                        controller.convertUnixToDate(controller.transactionDetail.result!.blockTime!).replaceAll('.000', ''),
                        style: Get.textTheme.titleSmall,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Balance before transaction',
                        style: Get.textTheme.titleSmall!.copyWith(color: AppColors.tertiaryColor),
                      ),
                      Text(
                        controller.convertSolanaBalance(balance: controller.transactionDetail.result!.meta!.preBalances![0]),
                        style: Get.textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Balance after transaction',
                        style: Get.textTheme.titleSmall!.copyWith(color: AppColors.tertiaryColor),
                      ),
                      Text(
                        controller.convertSolanaBalance(balance: controller.transactionDetail.result!.meta!.postBalances![0]),
                        style: Get.textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'solt',
                        style: Get.textTheme.titleSmall!.copyWith(color: AppColors.tertiaryColor),
                      ),
                      Text(
                        controller.transactionDetail.result!.slot.toString(),
                        style: Get.textTheme.titleSmall,
                      ),
                    ],
                  ),
                ]),
              ),
      ],
    );
  }
}
