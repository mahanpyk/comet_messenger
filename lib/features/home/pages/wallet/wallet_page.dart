import 'package:comet_messenger/app/core/app_icons.dart';
import 'package:comet_messenger/app/core/base/base_view.dart';
import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/features/home/models/transactions_response_model.dart';
import 'package:comet_messenger/features/home/pages/wallet/wallet_controller.dart';
import 'package:comet_messenger/features/widgets/fill_button_widget.dart';
import 'package:comet_messenger/features/widgets/text_form_field_widget.dart';
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
        Container(
          height: 48,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(width: 2),
          ),
          child: TabBar(
            indicatorWeight: 0,
            dividerColor: Colors.transparent,
            controller: controller.tabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: AppColors.primaryColor,
            ),
            labelStyle: const TextStyle(
              color: AppColors.tertiaryColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelColor: AppColors.tertiaryColor,
            indicatorSize: TabBarIndicatorSize.tab,
            splashBorderRadius: BorderRadius.circular(20),
            padding: const EdgeInsets.all(3),
            tabs: const [
              Tab(text: 'Transactions History'),
              Tab(text: 'Withdraw'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller.tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Column(
                children: [
                  controller.transactionsList.isEmpty
                      ? const Expanded(
                          child: Center(
                            child: Text('No transactions yet!'),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: controller.transactionsList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return transactionItem(item: controller.transactionsList[index]);
                            },
                          ),
                        ),
                ],
              ),
              Column(children: [
                const SizedBox(height: 40),
                TextFormFieldWidget(
                  controller: controller.receiverAddressTEC,
                  keyboardType: TextInputType.text,
                  label: const Text('Please enter the wallet address'),
                  // suffixIcon: IconButton(
                  //   icon: const Icon(Icons.qr_code_scanner_rounded),
                  //   onPressed: () => controller.onTapReadQRCode(),
                  //   tooltip: 'دریافت ادرس از QRCode',
                  // ),
                ),
                const SizedBox(height: 24),
                TextFormFieldWidget(
                  controller: controller.amountTEC,
                  keyboardType: TextInputType.number,
                  label: const Text('Please enter the amount'),
                ),
                const SizedBox(height: 24),
                FillButtonWidget(
                  isLoading: false,
                  enable: controller.isEnable.value,
                  onTap: () => controller.onTapTransaction(),
                  buttonTitle: 'ارسال',
                ),
              ]),
            ],
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
