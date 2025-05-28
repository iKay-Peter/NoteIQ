import 'package:flutter/material.dart';
import 'package:notiq/app/utils/network/connectivity_service.dart';

class NetworkProvider with ChangeNotifier {
  final ConnectivityService _service;
  bool _isConnected = true;

  NetworkProvider(this._service) {
    _init();
  }

  bool get isConnected => _isConnected;

  Future<void> _init() async {
    _isConnected = await _service.isConnected();
    _service.connectionStream.listen((status) {
      _isConnected = status;
      notifyListeners();
    });
  }

  Future<void> checkConnection() async {
    _isConnected = await _service.isConnected();
    notifyListeners();
  }
}
