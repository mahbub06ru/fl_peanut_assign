import 'dart:convert';
import 'dart:async';
import 'dart:ffi';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:peanut/view/screens/sign_in/sign_in_page.dart';

import '../network/request.dart';
import '../network/url.dart';
import '../view/screens/home/home_page.dart';


class LoginController extends GetxController {
  late TextEditingController useridTextController;
  late TextEditingController passTextController;

  final storage = GetStorage();

  void showLoader() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.custom,
    );
  }

  bool isTokenExpired() {
    final String? tokenExpiration = storage.read('tokenExpiration');
    if (tokenExpiration != null) {
      final DateTime expirationDate = DateTime.parse(tokenExpiration);
      return DateTime.now().isAfter(expirationDate);
    }
    return true;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    useridTextController = TextEditingController();
    passTextController = TextEditingController();
  }

  Future<void> login() async {
    showLoader();
    final String apiUrl =
        'https://peanut.ifxdb.com/api/ClientCabinetBasic/IsAccountCredentialsCorrect';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      'login': useridTextController.text.trim(),
      'password': passTextController.text
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Login successful');
      print('Response: ${response.body}');

      var responseJson = json.decode(response.body);
      print(responseJson);
      print(responseJson['token']);
      storage.write('token', responseJson['token']);
      storage.write('userId', useridTextController.text.trim());

      // Set token expiration logic (assuming token has an expiration field)
      // final DateTime expirationDate = DateTime.now().add(Duration(days: 1)); // Adjust as needed
      // storage.write('tokenExpiration', expirationDate.toString());


      EasyLoading.dismiss();
      Get.to(()=>HomePage());

    } else {
      EasyLoading.dismiss();
      Utils.showErrorDialog(
          'Oops!', 'Invalid credential');
    }
  }

  void logOut() {
      storage.erase();

    Get.offAll(() => const SignInPage());

    Get.snackbar('Logout', 'successfully done.',
        snackPosition: SnackPosition.TOP);
  }
}
