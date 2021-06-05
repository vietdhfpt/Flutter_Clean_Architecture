import 'package:connectivity/connectivity.dart';

abstract class NetworkInfo {
  Future<bool> isConnected();
}

class NetworkInfoImpl implements NetworkInfo {
  // final DataConnectionChecker connectionChecker;
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> isConnected() async {
    final result = await connectivity.checkConnectivity();
    if (result != ConnectivityResult.none) {
      return true;
    }
    return false;
  }
}
