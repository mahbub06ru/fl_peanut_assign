import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:peanut/controller/login_controller.dart';

import '../../../controller/home_controller.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final HomeController _homeController = Get.find();
  final LoginController _loginController = Get.find();
  final storage = GetStorage();
  @override
  void initState() {
    _homeController.getAccountInformation();
    // _homeController.getLastFourNumbersPhone();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, '+storage.read('userId')),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              _loginController.logOut();
            },
          ),
        ],

      ),
      body:  RefreshIndicator(
        onRefresh: () => _homeController.getOpenTrades(),
        child: Obx(
              () => ListView.builder(
            itemCount: _homeController.openTrades.length,
            itemBuilder: (context, index) {
              final trade = _homeController.openTrades[index];
              return Card(
                // Customize card UI as needed
                child: ListTile(
                  title: Text('Symbol: ${trade.symbol}'),
                  subtitle: Text('Profit: ${trade.profit}'),
                  // Add other fields as needed
                ),
              );
            },
          ),
        ),
      ),
    );

  }
}
