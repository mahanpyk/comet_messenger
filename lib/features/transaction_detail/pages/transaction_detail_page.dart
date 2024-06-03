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
        const SizedBox(height: 48),
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
                  Text(
                    'جزئیات تراکنش',
                    style: Get.textTheme.titleMedium!.copyWith(color: AppColors.primaryColor),
                  ),
                  const SizedBox(height: 16),
                  const Divider(
                    height: 1,
                    color: AppColors.backgroundSecondaryColor,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'تاریخ تراکنش',
                        style: Get.textTheme.titleMedium!.copyWith(color: AppColors.tertiaryColor),
                      ),
                      Text(
                        controller.convertUnixToDate(controller.transactionDetail.result!.blockTime!).replaceAll('.000', ''),
                        style: Get.textTheme.titleMedium,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'موجودی قبل از تراکنش',
                        style: Get.textTheme.titleMedium!.copyWith(color: AppColors.tertiaryColor),
                      ),
                      Text(
                        controller.convertSolanaBalance(balance: controller.transactionDetail.result!.meta!.preBalances![0]),
                        style: Get.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'موجودی بعد از تراکنش',
                        style: Get.textTheme.titleMedium!.copyWith(color: AppColors.tertiaryColor),
                      ),
                      Text(
                        controller.convertSolanaBalance(balance: controller.transactionDetail.result!.meta!.postBalances![0]),
                        style: Get.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'solt',
                        style: Get.textTheme.titleMedium!.copyWith(color: AppColors.tertiaryColor),
                      ),
                      Text(
                        controller.transactionDetail.result!.slot.toString(),
                        style: Get.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'signature',
                            style: Get.textTheme.titleMedium!.copyWith(color: AppColors.tertiaryColor),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            controller.signature,
                            style: Get.textTheme.titleMedium!.copyWith(
                              color: AppColors.primaryColor,
                              overflow: TextOverflow.ellipsis,
                            ),
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.copy, color: AppColors.primaryColor),
                      ],
                    ),
                  ),
                ]),
              ),
      ],
    );
  }
}
