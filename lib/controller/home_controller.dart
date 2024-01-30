import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:http/http.dart' as http;

import '../model/account_info.dart';
import '../model/trader_list.dart';
import '../network/request.dart';
import '../network/url.dart';

class HomeController extends GetxController {

  var accountInfo = AccountInfo().obs;
  RxList<OpenTraderList> openTrades = <OpenTraderList>[].obs;
  RxDouble totalProfit = 0.0.obs;

  void showLoader() async{
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
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
  RxBool isLoading = false.obs;
  RxBool loading = false.obs;
  RxString customerCode = ''.obs;

  final storage = GetStorage();
  var token='';
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

  @override
  void onInit() async{
    super.onInit();
    // getAccountInformation();

  }

  @override
  void dispose() {
    super.dispose();
  }
  Future<void>  getAccountInformation() async {
     isLoading(true);
     showLoader();
     const String apiUrl = 'https://peanut.ifxdb.com/api/ClientCabinetBasic/GetAccountInformation';

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
       if (response.statusCode == 200 ) {
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

            } else {
              isLoading(false);
              print('Failed to submit');
              print('Response: ${response.statusCode}');
              Utils.showErrorDialog(
                  'Oops!', 'Something went wrong in server');

              EasyLoading.showError('Failed with Error');

            }
     } catch (e) {
       print(e);
     }

  }
  Future<void>  getLastFourNumbersPhone() async {
     showLoader();
     const String apiUrl = 'https://peanut.ifxdb.com/api/ClientCabinetBasic/GetLastFourNumbersPhone';

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
       if (response.statusCode == 200 ) {
              print('successful');
              print('Response: ${response.body}');
              // var responseJson = json.decode(response.body);
              // print('lastFourDigits');
              // print(responseJson);

              lastFourDigits.value =response.body.toString();
              /*Utils.showSussesDialog(
                  'Good job!', 'You have submitted recruitment successfully.', 'OK', goToHome);*/
              EasyLoading.dismiss();
              // clearTextFields();
            } else {
              print('Failed to submit');
              print('Response: ${response.statusCode}');

              Utils.showErrorDialog(
                  'Oops!', 'Something went wrong in server');

              EasyLoading.showError('Failed with Error');


            }
     } catch (e) {
       print(e);
     }

  }
  Future<void>  getOpenTrades() async {
    isLoading(true);
     showLoader();
     const String apiUrl = 'https://peanut.ifxdb.com/api/ClientCabinetBasic/GetOpenTrades';

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
       if (response.statusCode == 200 ) {
              isLoading(false);
              print('successful');
              print('Response: ${response.body}');
              /*Utils.showSussesDialog(
                  'Good job!', 'You have submitted recruitment successfully.', 'OK', goToHome);*/
              EasyLoading.dismiss();
              final List<dynamic> jsonList = json.decode(response.body);
              openTrades.assignAll(
                jsonList.map((e) => OpenTraderList.fromJson(e)).toList(),
              );
              print('openTrades');
              print(openTrades.length);
              calculateTotalProfit();
            } else {
               isLoading(false);
              print('Failed to load');
              print('Response: ${response.statusCode}');

               Utils.showErrorDialog(
                 'Oops!', 'Something went wrong in server');

              EasyLoading.showError('Failed with Error');


            }
     } catch (e) {
       print(e);
     }

  }

}