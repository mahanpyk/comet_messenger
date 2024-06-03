import 'dart:async';

import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/core/app_enums.dart';
import 'package:comet_messenger/app/services/storage_service.dart';
import 'package:get/get.dart';

class LocalizeStoreService {
  LocalizeStoreService(this._storage);

  final LocalStorage _storage;

  static LocalizeStoreService get to => Get.find();

  Future<LocalizeStoreService> init() async {
    return this;
  }

  Future<void> saveLanguages({required LanguageEnum language}) async {
    await _storage.write(AppConstants.LANGUAGE, language);
  }

  LanguageEnum get languages {
    LanguageEnum? lang = _storage.read(AppConstants.LANGUAGE);
    return lang ?? LanguageEnum.PERSIAN;
  }
}
