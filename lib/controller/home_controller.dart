import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:http/http.dart' as http;
import 'package:peanut/view/screens/sign_in/sign_in_page.dart';

import '../model/account_info.dart';
import '../model/trader_list.dart';
import '../network/request.dart';
import '../network/synchronize_data.dart';
import '../network/url.dart';

class HomeController extends GetxController {
  var accountInfo = AccountInfo().obs;
  RxList<OpenTraderList> openTrades = <OpenTraderList>[].obs;
  RxDouble totalProfit = 0.0.obs;

  void showLoader() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.custom,
    );
  }

  void showADialog(String title, String des) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(des),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Dismiss the dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  RxBool isLoading = false.obs;
  RxBool loading = false.obs;
  RxString customerCode = ''.obs;

  final storage = GetStorage();
  var token = '';
  var lastFourDigits = ''.obs;

  void calculateTotalProfit() {
    // Calculate the total profit
    double total = 0.0;
    for (var trade in openTrades) {
      total += trade.profit ?? 0.0;
    }

    // Update the totalProfit variable
    totalProfit.value = total;
  }

  bool isTokenExpired() {
    final String? tokenExpiration = storage.read('tokenExpiration');
    if (tokenExpiration != null) {
      final DateTime expirationDate = DateTime.parse(tokenExpiration);
      return DateTime.now().isAfter(expirationDate);
    }
    return true; // Token expiration information not found, assume expired
  }

  Future<void> refreshToken() async {
    try {
      final String refreshToken = storage.read('refreshToken');
      if (refreshToken == null) {
        // Handle the case where no refresh token is available
        print('No refresh token available');
        return;
      }

      final String refreshTokenApiUrl =
          'https://peanut.ifxdb.com/api/RefreshTokenEndpoint'; // Replace with your actual refresh token endpoint

      final Map<String, String> refreshTokenHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $refreshToken',
      };

      final http.Response refreshTokenResponse = await http.post(
        Uri.parse(refreshTokenApiUrl),
        headers: refreshTokenHeaders,
      );

      if (refreshTokenResponse.statusCode == 200) {
        var refreshedTokenData = json.decode(refreshTokenResponse.body);

        // Update storage with the new token and expiration date
        storage.write('token', refreshedTokenData['token']);
        storage.write('tokenExpiration', refreshedTokenData['expiration']);

        print('Token refreshed successfully');
      } else {
        // Handle token refresh API error
        print(
            'Token refresh failed. ${refreshTokenResponse.statusCode}, ${refreshTokenResponse.body}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error during token refresh: $e');
    }
  }

  @override
  void onInit() async {
    super.onInit();
    // getAccountInformation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getAccountInformation() async {
    isLoading(true);
    showLoader();
    const String apiUrl =
        'https://peanut.ifxdb.com/api/ClientCabinetBasic/GetAccountInformation';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      // "Authorization": "Bearer " + token
    };

    final Map<String, dynamic> requestBody = {
      "login": storage.read('userId'),
      "token": storage.read('token')
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    print('requestBody');
    print(requestBody.toString());

    try {
      if (response.statusCode == 200) {
        isLoading(false);
        print('successful');
        print('Response: ${response.body}');
        /*Utils.showSussesDialog(
                  'Good job!', 'You have submitted recruitment successfully.', 'OK', goToHome);*/
        EasyLoading.dismiss();
        // clearTextFields();
        final Map<String, dynamic> json = jsonDecode(response.body);
        accountInfo(AccountInfo.fromJson(json));
        //controller.accountInfo.value!.address
      } else if (response.statusCode == 500) {
        Utils.showErrorDialog('Oops!', 'Token has expired');
        storage.erase();
        Get.offAll(() => const SignInPage());
      } else {
        isLoading(false);
        print('Failed to submit');
        print('Response: ${response.statusCode}');
        Utils.showErrorDialog('Oops!', 'Something went wrong in server');
      }
    } catch (e) {
      print(e);
    }

    /*SynchronizationData.isInternet().then((connection) async {
      if (connection) {
        isLoading(true);
        showLoader();
        const String apiUrl =
            'https://peanut.ifxdb.com/api/ClientCabinetBasic/GetAccountInformation';

        final Map<String, String> headers = {
          'Content-Type': 'application/json',
          // "Authorization": "Bearer " + token
        };

        final Map<String, dynamic> requestBody = {
          "login": storage.read('userId'),
          "token": storage.read('token')
        };

        final http.Response response = await http.post(
          Uri.parse(apiUrl),
          headers: headers,
          body: jsonEncode(requestBody),
        );

        print('requestBody');
        print(requestBody.toString());

        try {
          if (response.statusCode == 200) {
            isLoading(false);
            print('successful');
            print('Response: ${response.body}');
            EasyLoading.dismiss();
            // clearTextFields();
            final Map<String, dynamic> json = jsonDecode(response.body);
            accountInfo(AccountInfo.fromJson(json));
            //controller.accountInfo.value!.address
          } else if (response.statusCode == 500) {
            Utils.showErrorDialog('Oops!', 'Token has expired');
            storage.erase();
            Get.offAll(() => const SignInPage());
          } else {
            isLoading(false);
            print('Failed to submit');
            print('Response: ${response.statusCode}');
            Utils.showErrorDialog('Oops!', 'Something went wrong in server');
          }
        } catch (e) {
          print(e);
        }
      } else {
        EasyLoading.dismiss();
        // Get.back();
        Get.snackbar('Oops!', '"No Internet"',
            snackPosition: SnackPosition.TOP, colorText: Colors.red);
      }
    });*/
  }

  Future<void> getLastFourNumbersPhone() async {
    const String apiUrl =
        'https://peanut.ifxdb.com/api/ClientCabinetBasic/GetLastFourNumbersPhone';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      // "Authorization": "Bearer " + token
    };

    final Map<String, dynamic> requestBody = {
      "login": storage.read('userId'),
      "token": storage.read('token')
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    print('requestBody');
    print(requestBody.toString());

    try {
      if (response.statusCode == 200) {
        print('successful');
        print('Response: ${response.body}');
        // var responseJson = json.decode(response.body);
        // print('lastFourDigits');
        // print(responseJson);

        lastFourDigits.value = response.body.toString();
        /*Utils.showSussesDialog(
                  'Good job!', 'You have submitted recruitment successfully.', 'OK', goToHome);*/
      } else if (response.statusCode == 500) {
        Utils.showErrorDialog('Oops!', 'Token has expired');
        storage.erase();
        Get.offAll(() => const SignInPage());
      } else {
        print('Failed to submit');
        print('Response: ${response.statusCode}');

        Utils.showErrorDialog('Oops!', 'Something went wrong in server');

        EasyLoading.showError('Failed with Error');
      }
    } catch (e) {
      print(e);
    }

    /* SynchronizationData.isInternet().then((connection) async {
      if (connection) {
        const String apiUrl =
            'https://peanut.ifxdb.com/api/ClientCabinetBasic/GetLastFourNumbersPhone';

        final Map<String, String> headers = {
          'Content-Type': 'application/json',
          // "Authorization": "Bearer " + token
        };

        final Map<String, dynamic> requestBody = {
          "login": storage.read('userId'),
          "token": storage.read('token')
        };

        final http.Response response = await http.post(
          Uri.parse(apiUrl),
          headers: headers,
          body: jsonEncode(requestBody),
        );

        print('requestBody');
        print(requestBody.toString());

        try {
          if (response.statusCode == 200) {
            print('successful');
            print('Response: ${response.body}');
            // var responseJson = json.decode(response.body);
            // print('lastFourDigits');
            // print(responseJson);

            lastFourDigits.value = response.body.toString();

          } else if (response.statusCode == 500) {
            Utils.showErrorDialog('Oops!', 'Token has expired');
            storage.erase();
            Get.offAll(() => const SignInPage());
          } else {
            print('Failed to submit');
            print('Response: ${response.statusCode}');

            Utils.showErrorDialog('Oops!', 'Something went wrong in server');

            EasyLoading.showError('Failed with Error');
          }
        } catch (e) {
          print(e);
        }
      }else{
        Get.snackbar('Oops!', '"No Internet"',
            snackPosition: SnackPosition.TOP, colorText: Colors.red);
      }
    });*/
  }

  Future<void> getOpenTrades() async {
    isLoading(true);
    const String apiUrl =
        'https://peanut.ifxdb.com/api/ClientCabinetBasic/GetOpenTrades';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      // "Authorization": "Bearer " + token
    };

    final Map<String, dynamic> requestBody = {
      "login": storage.read('userId'),
      "token": storage.read('token')
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    print('requestBody');
    print(requestBody.toString());

    try {
      if (response.statusCode == 200) {
        isLoading(false);
        print('successful');
        print('Response: ${response.body}');
        /*Utils.showSussesDialog(
                  'Good job!', 'You have submitted recruitment successfully.', 'OK', goToHome);*/
        final List<dynamic> jsonList = json.decode(response.body);
        openTrades.assignAll(
          jsonList.map((e) => OpenTraderList.fromJson(e)).toList(),
        );
        print('openTrades');
        print(openTrades.length);
        calculateTotalProfit();
      } else if (response.statusCode == 500) {
        Utils.showErrorDialog('Oops!', 'Token has expired');
        storage.erase();
        Get.offAll(() => const SignInPage());
      } else {
        isLoading(false);
        print('Failed to load');
        print('Response: ${response.statusCode}');
        Utils.showErrorDialog('Oops!', 'Something went wrong in server');
      }
    } catch (e) {
      print(e);
    }
  }
}
