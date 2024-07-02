import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/store/user_store_service.dart';
import 'package:comet_messenger/features/constacts/repository/contacts_repository.dart';
import 'package:comet_messenger/features/login/models/contact_model.dart';
import 'package:get/get.dart';

class ContactsController extends GetxController {
  ContactsController(this._repo);

  final ContactsRepository _repo;
  ContactModel? contactModel;
  RxList<Contact> contacts = RxList([]);

  @override
  void onInit() {
    super.onInit();
    var json = UserStoreService.to.get(key: AppConstants.CONTACTS);
    if (json != null) {
      contactModel = ContactModel.fromJson(json);
      contacts(contactModel!.contacts!);
    }
  }
}
