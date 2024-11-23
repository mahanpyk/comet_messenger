import 'package:comet_messenger/app/bindings/authentication_binding.dart';
import 'package:comet_messenger/app/bindings/chat_binding.dart';
import 'package:comet_messenger/app/bindings/chat_profile_binding.dart';
import 'package:comet_messenger/app/bindings/contacts_binding.dart';
import 'package:comet_messenger/app/bindings/create_mnemonic_binding.dart';
import 'package:comet_messenger/app/bindings/fingerprint_binding.dart';
import 'package:comet_messenger/app/bindings/home_binding.dart';
import 'package:comet_messenger/app/bindings/import_wallet_binding.dart';
import 'package:comet_messenger/app/bindings/intro_binding.dart';
import 'package:comet_messenger/app/bindings/pin_binding.dart';
import 'package:comet_messenger/app/bindings/profile_binding.dart';
import 'package:comet_messenger/app/bindings/security_binding.dart';
import 'package:comet_messenger/app/bindings/show_mnemonic_binding.dart';
import 'package:comet_messenger/app/bindings/splash_binding.dart';
import 'package:comet_messenger/app/bindings/transaction_detail_binding.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/features/authentication/pages/create_mnemonic/create_mnemonic_page.dart';
import 'package:comet_messenger/features/authentication/pages/fingerprint/fingerprint_page.dart';
import 'package:comet_messenger/features/authentication/pages/import_mnemonic/import_mnemonic_page.dart';
import 'package:comet_messenger/features/authentication/pages/main/authentication_page.dart';
import 'package:comet_messenger/features/authentication/pages/pin/pin_page.dart';
import 'package:comet_messenger/features/chat/pages/chat_profile/chat_profile_page.dart';
import 'package:comet_messenger/features/chat/pages/main/chat_page.dart';
import 'package:comet_messenger/features/constacts/pages/main/contacts_page.dart';
import 'package:comet_messenger/features/home/pages/main/home_page.dart';
import 'package:comet_messenger/features/intro/pages/intro_page.dart';
import 'package:comet_messenger/features/profile/pages/profile_page.dart';
import 'package:comet_messenger/features/security/pages/security_page.dart';
import 'package:comet_messenger/features/show_mnemonic/pages/show_mnemonic_page.dart';
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
      name: AppRoutes.AUTHENTICATION,
      page: () => const AuthenticationPage(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: AppRoutes.IMPORT_MNEMONIC,
      page: () => const ImportMnemonicPage(),
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
      name: AppRoutes.FINGERPRINT,
      page: () => const FingerprintPage(),
      binding: FingerprintBinding(),
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
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.SHOW_MNEMONIC,
      page: () => const ShowMnemonicPage(),
      binding: ShowMnemonicBinding(),
    ),
    GetPage(
      name: AppRoutes.CHAT,
      page: () => const ChatPage(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: AppRoutes.CHAT_PROFILE,
      page: () => const ChatProfilePage(),
      binding: ChatProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.SECURITY,
      page: () => const SecurityPage(),
      binding: SecurityBinding(),
    ),
  ];
}
