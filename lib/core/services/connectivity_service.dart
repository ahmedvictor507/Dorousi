import 'package:connectivity_plus/connectivity_plus.dart';

/// Service to check internet connectivity.
/// Used by the Splash screen to gate app entry.
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Returns true if the device has an active internet connection.
  Future<bool> hasConnection() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }

  /// Stream of connectivity changes for reactive UI updates.
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
