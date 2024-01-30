import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:peanut/utils/app_binding.dart';
import 'package:peanut/utils/colors.dart';

import 'animation/custom_animation.dart';
import 'view/screens/intro/splash_screen.dart';
import 'view/screens/profile/home_page.dart';
import 'view/screens/sign_in/sign_in_page.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.wave
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.black
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.green
    ..textColor = Colors.green
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation()
  ;
}
void main() async {

  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final getdata = GetStorage();
  getdata.writeIfNull('isLoggedIn', false);
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );


  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      defaultTransition: Transition.fade,
      getPages: AppPages.route,
      initialRoute: '/SplashPage',
      initialBinding: AppBinding(),
      theme: ThemeData(
        primaryColor: ColorRes.appColor,
        primarySwatch: ColorRes.appColor,
        canvasColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: ColorRes.appColor,
        ),
      ),
    );
  }
}

class AppPages {
  static final route = [
    GetPage(
      name: '/SplashPage',
      page: () =>  const SplashPage(),
    ),
    GetPage(
      name: '/SignInPage',
      page: () =>  const SignInPage(),
    ),
    GetPage(
      name: '/HomePage',
      page: () =>  const HomePage(),
    ),

  ];
}
