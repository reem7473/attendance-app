// import 'package:dio/dio.dart';

// Future<bool> checkInternetConnection() async {
//   try {
//     var response = await Dio().get('https://www.google.com');
//     if (response.statusCode == 200) {
//       print("yes");
//       return true;
//     } else {
//       print("no");
//       return false;
//     }
//   } catch (e) {
//     print("no: $e");
//     return false;
//   }
// }

import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> checkInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
         print("yes");

    return true;
  } else {
    return false;
  }
}
