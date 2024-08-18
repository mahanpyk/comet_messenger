import 'dart:async';
import 'dart:convert';

import 'package:comet_messenger/app/core/app_constants.dart';
import 'package:comet_messenger/app/services/storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class UserStoreService {
  UserStoreService(this._storage);

  final LocalStorage _storage;
  final _secureStorage = const FlutterSecureStorage();

  static UserStoreService get to => Get.find();

  Future<void> saveToken(String tokenString) async {
    await _secureStorage.write(key: AppConstants.TOKEN, value: tokenString);
  }

  Future<void> saveRefreshToken(String tokenString) async {
    await _secureStorage.write(
        key: AppConstants.REFRESH_TOKEN, value: tokenString);
  }

  Future<String?> getToken() async {
    String? result = await _secureStorage.read(key: AppConstants.TOKEN);
    return result;
  }

  Future<String?> getRefreshToken() async {
    String? result = await _secureStorage.read(key: AppConstants.REFRESH_TOKEN);
    return result;
  }

  void deleteToken() async =>
      await _secureStorage.delete(key: AppConstants.TOKEN);

  void deleteRefreshToken() async =>
      await _secureStorage.delete(key: AppConstants.REFRESH_TOKEN);

  Future<void> save({required String key, required dynamic value}) async =>
      await _storage.write(key, value);

  dynamic get({required String key}) {
    var result = _storage.read(key);
    if (result == null) {
      return null;
    }
    return result;
  }

  Future<void> savePin(String pin) async {
    await _secureStorage.write(
      key: AppConstants.PIN,
      value: pin,
    );
  }

  Future<String?> getPin() async {
    String? result = await _secureStorage.read(key: AppConstants.PIN);
    return result;
  }

  Future<void> delete({required String key}) async => _storage.remove(key);

  void deleteAll() async {
    _storage.removeAll();
    await _secureStorage.deleteAll();
  }

  Future<void> saveMnemonic(String tokenString) async {
    await _secureStorage.write(
      key: AppConstants.MNEMONIC,
      value: tokenString,
    );
  }

  Future<String?> getMnemonic() async {
    String? result = await _secureStorage.read(key: AppConstants.MNEMONIC);
    return result;
  }

  Future<void> saveUserModel(Map<String, dynamic> userModel) async {
    final jsonString = jsonEncode(userModel);
    await _secureStorage.write(
      key: AppConstants.USER_ACCOUNT,
      value: jsonString,
    );
  }

  Future<Map<String, dynamic>?> getUserModel() async {
    String? result = await _secureStorage.read(key: AppConstants.USER_ACCOUNT);
    if (result == null) {
      return null;
    }
    return jsonDecode(result) as Map<String, dynamic>;
  }
}
