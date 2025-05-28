import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  // Check current connection status
  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result.any((r) => _isNetworkAvailable(r));
  }

  // Stream real-time connection changes
  Stream<bool> get connectionStream {
    return _connectivity.onConnectivityChanged.map((results) {
      return results.any((result) => _isNetworkAvailable(result));
    });
  }

  bool _isNetworkAvailable(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }
}
