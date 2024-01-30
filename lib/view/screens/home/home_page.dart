import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:peanut/controller/login_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controller/home_controller.dart';
import '../../../utils/app_colors.dart';
import '../../widgets/skeleton_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = Get.find();
  final LoginController _loginController = Get.find();
  final storage = GetStorage();

  void _showProductModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.80,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: const BoxDecoration(
                color: AppColors.appColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Obx(() => _homeController.isLoading.value
                  ? ListView.builder(
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: SkeletonCard());
                      },
                    )
                  : Card(
                      child: Column(
                        //"address": "Мусы Джалиля д.32 кор.1 кв.77",
                        //     "balance": 314.79,
                        //     "city": "Калининград",
                        //     "country": "Belarus",
                        //     "currency": 0,
                        //     "currentTradesCount": 4,
                        //     "currentTradesVolume": 0.04,
                        //     "equity": 241.56000000000003,
                        //     "freeMargin": 73.91484000000003,
                        //     "isAnyOpenTrades": true,
                        //     "isSwapFree": false,
                        //     "leverage": 1,
                        //     "name": "Tester",
                        //     "phone": "4abb3f0b138407cd3d0f00443abad73d",
                        //     "totalTradesCount": 1636,
                        //     "totalTradesVolume": 76.15,
                        //     "type": 1,
                        //     "verificationLevel": 1,
                        //     "zipCode": "ru236022"
                        children: [
                          Text(_homeController.accountInfo.value.address
                              .toString()),
                          Text(_homeController.accountInfo.value.balance
                              .toString()),
                          Text(_homeController.accountInfo.value.city
                              .toString()),
                          Text(_homeController.accountInfo.value.country
                              .toString()),
                          Text(_homeController.lastFourDigits.value.toString()),
                        ],
                      ),
                    )),
            ))
          ],
        ),
      ),
    );
  }
  Future<bool> showExitPopup(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Do you want to exit?"),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            //  print('yes selected');
                            exit(0);
                          },
                          child: const Text("Yes"),
                          style: ElevatedButton.styleFrom(
                              primary: AppColors.appColor),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              //  print('no selected');
                              Navigator.of(context).pop();
                            },
                            child: const Text("No",
                                style: TextStyle(color: Colors.black)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
  @override
  void initState() {
    _homeController.getAccountInformation();
    _homeController.getLastFourNumbersPhone();
    _homeController.getOpenTrades();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    /*  appBar: AppBar(
        title: Text('Hello, ' + storage.read('userId')),
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
          IconButton(
            icon: const Icon(
              Icons.person_outline,
              color: Colors.white,
            ),
            onPressed: () async {
              _showProductModalBottomSheet(Get.context!);
            },
          ),
        ],
      ),*/
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            return;
          }
          showExitPopup(context);
        },
        child: Column(
          children: [
            Container(
              width: Get.width,
              height: 140,
              decoration:  const BoxDecoration(
                color: AppColors.appColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child:  Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10,),
                    Obx(
                          () => ListTile(
                        title: Text('Total Profit: ${_homeController.totalProfit}'),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      children:[
                        IconButton(
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            _loginController.logOut();
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            _showProductModalBottomSheet(Get.context!);
                          },
                        ),
                      ]
                    )
                  ],
                ),
              ),
            ),

            Expanded(
              child: RefreshIndicator(
                // onRefresh: () => _homeController.getOpenTrades(),
                onRefresh: () async {
                  await _homeController.getOpenTrades();
                  _homeController.calculateTotalProfit();
                },
                child: Obx(
                  () => _homeController.isLoading.value
                      ? ListView.builder(
                          itemCount: 5,
                          itemBuilder: (BuildContext context, int index) {
                            return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: SkeletonCard());
                          },
                        )
                      : ListView.builder(
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
            ),
          ],
        ),
      ),
    );
  }
}
