import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/home/models/transactions_response_model.dart';
import 'package:comet_messenger/features/home/pages/wallet/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class WalletPage extends BaseView<WalletController> {
  const WalletPage({super.key});

  @override
  Widget body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(children: [
        SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('transactions History'),
              Text('Tab'),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                controller.transactionsList.isEmpty ?
                const Text('No transactions yet!')
                    : ListView.builder(
                  itemCount: controller.transactionsList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return transactionItem(item: controller.transactionsList[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget transactionItem({required Result item}) {
    return GestureDetector(
      onTap: () => controller.onTapTransactionDetail(item.signature!),
      child: Card(
        color: AppColors.backgroundSecondaryColor,
        child: ListTile(
          leading: const CircleAvatar(
            child: Icon(
              Icons.check,
              color: AppColors.primaryColor,
            ),
          ),
          title: Text(
            'Transaction',
            textAlign: TextAlign.right,
            style: Get.textTheme.titleLarge!.copyWith(color: AppColors.tertiaryColor),
          ),
          subtitle: Text(
            controller.convertUnixToDate(item.blockTime!).replaceFirst('.000', ''),
            textAlign: TextAlign.right,
            style: Get.textTheme.bodySmall!.copyWith(color: AppColors.tertiaryColor),
            textDirection: TextDirection.ltr,
          ),
          trailing: SvgPicture.asset(
            AppIcons.icNavigate,
            height: 32,
            width: 32,
          ),
        ),
      ),
    );
  }

}
