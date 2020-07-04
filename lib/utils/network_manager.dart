import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';

class NetworkManager {
  static final NetworkManager _singleton = new NetworkManager.internal();

  NetworkManager.internal();

  static NetworkManager getInstance() => _singleton;
  final Connectivity _connectivity = Connectivity();

  bool isConnected = true;
  StreamController connectionChangeController =
      new StreamController.broadcast();

  Stream get connectionChangeStream => connectionChangeController.stream;

  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  void dispose() {
    connectionChangeController.close();
  }

  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  Future<bool> checkConnection() async {
    bool previousConnection = isConnected;

    try {
      final result = await InternetAddress.lookup('example.com');
      isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isConnected = false;
    }
    if (previousConnection != isConnected) {
      connectionChangeController.add(isConnected);
    }
    return isConnected;
  }
}

class NoInternetAccessException implements Exception {}
