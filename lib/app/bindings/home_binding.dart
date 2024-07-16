import 'package:comet_messenger/features/home/pages/chat_list/chat_list_controller.dart';
import 'package:comet_messenger/features/home/pages/groups/groups_controller.dart';
import 'package:comet_messenger/features/home/pages/main/home_controller.dart';
import 'package:comet_messenger/features/home/pages/settings/settings_controller.dart';
import 'package:comet_messenger/features/home/pages/wallet/wallet_controller.dart';
import 'package:comet_messenger/features/home/repository/chat_list_repository.dart';
import 'package:comet_messenger/features/home/repository/home_repository.dart';
import 'package:comet_messenger/features/home/repository/wallet_repository.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeRepository>(HomeRepositoryImpl());
    Get.put<HomeController>(HomeController(Get.find<HomeRepository>()));
    Get.put<SettingsController>(SettingsController());
    Get.put<ChatListRepository>(ChatListRepositoryImpl());
    Get.put<ChatListController>(ChatListController(Get.find<ChatListRepository>()));
    Get.put<GroupsController>(GroupsController());
    Get.put<WalletRepository>(WalletRepositoryImpl());
    Get.put<WalletController>(WalletController(Get.find<WalletRepository>()));
  }
}
