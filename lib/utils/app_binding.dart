import 'package:get/get.dart';

import '../controller/login_controller.dart';
import '../controller/home_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(HomeController());

  }
}
