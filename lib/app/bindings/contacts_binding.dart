import 'package:comet_messenger/features/constacts/pages/main/contacts_controller.dart';
import 'package:comet_messenger/features/constacts/repository/contacts_repository.dart';
import 'package:get/get.dart';

class ContactsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactsRepository>(() => ContactsRepositoryImpl());
    Get.lazyPut<ContactsController>(() => ContactsController(Get.find<ContactsRepository>()));
  }
}
