import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService {
  ConnectivityService._internal() {
    Connectivity().onConnectivityChanged.listen(
          (List<ConnectivityResult> result) {
        _timer?.cancel();
        if (result.contains(ConnectivityResult.none)) {
          hasConnection = false;
        } else {
          hasConnection = true;
          _timer = Timer.periodic(
            const Duration(seconds: 10),
            (_) async => hasConnection = await _checkConnection(),
          );
        }
      },
    );
  }

  static final ConnectivityService instance = ConnectivityService._internal();
  Timer? _timer;
  final RxBool _hasConnection = true.obs;

  bool get hasConnection => _hasConnection.value;

  set hasConnection(bool value) => _hasConnection.value = value;

  Future<bool> _checkConnection() async {
    bool hasConnection;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }
    return hasConnection;
  }

  Future<void> initializeConnection() async {
    List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    for (var element in connectivityResult) {
      if (element == ConnectivityResult.mobile || element == ConnectivityResult.wifi) {
        hasConnection = await _checkConnection();
      } else {
        hasConnection = false;
      }
    }
  }
}
