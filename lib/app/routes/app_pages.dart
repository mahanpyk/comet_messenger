import 'package:comet_messenger/app/bindings/contacts_binding.dart';
import 'package:comet_messenger/app/bindings/create_mnemonic_binding.dart';
import 'package:comet_messenger/app/bindings/home_binding.dart';
import 'package:comet_messenger/app/bindings/import_wallet_binding.dart';
import 'package:comet_messenger/app/bindings/intro_binding.dart';
import 'package:comet_messenger/app/bindings/login_binding.dart';
import 'package:comet_messenger/app/bindings/pin_binding.dart';
import 'package:comet_messenger/app/bindings/splash_binding.dart';
import 'package:comet_messenger/app/bindings/transaction_detail_binding.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/features/constacts/pages/main/contacts_page.dart';
import 'package:comet_messenger/features/home/pages/main/home_page.dart';
import 'package:comet_messenger/features/intro/pages/intro_page.dart';
import 'package:comet_messenger/features/login/pages/create_mnemonic/create_mnemonic_page.dart';
import 'package:comet_messenger/features/login/pages/import_mnemonic/import_wallet_page.dart';
import 'package:comet_messenger/features/login/pages/main/login_page.dart';
import 'package:comet_messenger/features/login/pages/pin/pin_page.dart';
import 'package:comet_messenger/features/splash/pages/splash_page.dart';
import 'package:comet_messenger/features/transaction_detail/pages/transaction_detail_page.dart';
import 'package:get/get.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.INTRO,
      page: () => const IntroPage(),
      binding: IntroBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.IMPORT_WALLET,
      page: () => const ImportWalletPage(),
      binding: ImportWalletBinding(),
    ),
    GetPage(
      name: AppRoutes.CREATE_MNEMONIC,
      page: () => const CreateMnemonicPage(),
      binding: CreateMnemonicBinding(),
    ),
    GetPage(
      name: AppRoutes.PIN,
      page: () => const PinPage(),
      binding: PinBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.TRANSACTION_DETAIL,
      page: () => const TransactionDetailPage(),
      binding: TransactionDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.CONTACTS,
      page: () => const ContactsPage(),
      binding: ContactsBinding(),
    ),
  ];
}
