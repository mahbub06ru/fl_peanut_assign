import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:peanut/controller/login_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controller/home_controller.dart';
import '../../../network/url.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/constants.dart';
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
                            child: const SkeletonCard());
                      },
                    )
                  : ListView(
                   children: [
                     Column(

                       children: [
                         Card(
                           child: ListTile(
                             title: const Text('Name'),
                             subtitle: Text(_homeController.accountInfo.value.name.toString()),
                           ),
                         ),
                         Card(
                           child: ListTile(
                             title: const Text('Address'),
                             subtitle: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('${_homeController.accountInfo.value.address}'),
                                 Text('City: ${_homeController.accountInfo.value.city}'),
                                 Text('Zip Code: ${_homeController.accountInfo.value.zipCode}'),
                               ],
                             ),
                           ),
                         ),
                         Card(
                           child: ListTile(
                             title: const Text('Balance'),
                             subtitle: Text(Utils.formatDoubleToTwoDecimalPlaces(_homeController.accountInfo.value.balance!)),
                           ),
                         ),
                         Card(
                           child: ListTile(
                             title: const Text('Current Trades Count'),
                             subtitle: Text(Utils.formatDoubleToTwoDecimalPlaces(_homeController.accountInfo.value.currentTradesCount)),
                           ),
                         ),
                         Card(
                           child: ListTile(
                             title: const Text('Equity'),
                             subtitle: Text(Utils.formatDoubleToTwoDecimalPlaces(_homeController.accountInfo.value.equity!)),
                           ),
                         ),
                         Card(
                           child: ListTile(
                             title: const Text('Free Margin'),
                             subtitle: Text(Utils.formatDoubleToTwoDecimalPlaces(_homeController.accountInfo.value.freeMargin!)),
                           ),
                         ),
                         Card(
                           child: ListTile(
                             title: const Text('Total Trades Count'),
                             subtitle: Text(Utils.formatDoubleToTwoDecimalPlaces(_homeController.accountInfo.value.totalTradesCount!)),
                           ),
                         ),
                         Card(
                           child: ListTile(
                             title: const Text('Total Trades Volume'),
                             subtitle: Text(Utils.formatDoubleToTwoDecimalPlaces(_homeController.accountInfo.value.totalTradesVolume!)),
                           ),
                         ),
                         Card(
                           child: ListTile(
                             title: const Text('Last Four Digit of Phone'),
                             subtitle: Text(_homeController.lastFourDigits.value.toString()),
                           ),
                         ),


                       ],
                     )
                   ],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.person_outline,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
        onPressed: () {
          _showProductModalBottomSheet(Get.context!);
        },
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            return;
          }
          showExitPopup(context);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: Get.width,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.appColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Hello: ${storage.read('userId')}',
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
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
                  ],
                ),
              ),
            ),
            Obx(
              () => ListTile(
                title: Text(
                  // 'Total Profit: ${_homeController.totalProfit}',
                  'Total Profit: ${Utils.formatDoubleToTwoDecimalPlaces(_homeController.totalProfit.value)}',
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
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
                                child: const SkeletonCard());
                          },
                        )
                      : ListView.builder(
                        itemCount: _homeController.openTrades.length,
                        itemBuilder: (context, index) {
                          final trade = _homeController.openTrades[index];
                          return Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Card(
                              // Customize card UI as needed
                              child: ListTile(
                                title: Text('Symbol: ${trade.symbol}',style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Profit: ${trade.profit}'),
                                    Text('Current Price: ${trade.currentPrice}'),
                                    Text('Open Price: ${trade.openPrice}'),
                                    Text('Swaps: ${trade.swaps}'),
                                    Text('Symbol: ${trade.symbol}'),
                                    Text('Open Time: ${Utils.convertOpenTime(trade.openTime.toString())}'),
                                  ],
                                ),
                                // Add other fields as needed
                              ),
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
