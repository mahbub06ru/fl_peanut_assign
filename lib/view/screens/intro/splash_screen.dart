import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'dart:async';
import 'dart:developer' as developer;
import 'package:get_storage/get_storage.dart';

import '../../../controller/login_controller.dart';
import '../../widgets/custom_alert_dialog.dart';
import '../home/home_page.dart';
import '../sign_in/sign_in_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  final LoginController controller = Get.find();

  bool? _isConnected;

  Future<void> _checkInternetConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');
      print(response);
      if (response.isNotEmpty) {
        setState(() {
          _isConnected = true;

        });
      }
    } on SocketException catch (err) {
      setState(() {
        _isConnected = false;
      });
      if (kDebugMode) {
        print(err);
      }
    }
  }

  final storage = GetStorage();

  String? UserID,todaysDate;

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    detectUser();

  }
  void detectUser() async {

    UserID= storage.read('userId');
    if(UserID != null){
      Get.to(()=>HomePage());

    }else{
      Get.to(()=>SignInPage());
    }



  }


  @override
  void initState() {
    super.initState();

    _checkInternetConnection();
    startTime();
  }

  @override
  void dispose() {
    controller.dispose();
    // _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      constraints: BoxConstraints(
        maxWidth: Get.width,  // Set your maximum width here
        maxHeight: Get.height, // Set your maximum height here
      ),
      child: Image.asset(
        'assets/images/bg.png',
        fit: BoxFit.fill, // or any other fit value as per your requirement
      ),
    );
  }
}
