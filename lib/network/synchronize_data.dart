import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class SynchronizationData {
  static Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (await InternetConnectionChecker().hasConnection) {
        // ignore: avoid_print
        print("Mobile data detected & internet connection confirmed.");
        return true;
      } else {
        // ignore: avoid_print
        print('No internet :( Reason:');
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (await InternetConnectionChecker().hasConnection) {
        // ignore: avoid_print
        print("wifi data detected & internet connection confirmed.");
        return true;
      } else {
        // ignore: avoid_print
        print('No internet :( Reason:');
        return false;
      }
    } else {
      // ignore: avoid_print
      print(
          "Neither mobile data or WIFI detected, not internet connection found.");
      return false;
    }
  }

  
}
