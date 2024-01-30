import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../controller/login_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/constants.dart';



class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final LoginController _loginController = Get.find();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();

  final getData = GetStorage();

  var version = "";

  @override
  void initState() {
    super.initState();
    _loginController.useridTextController.text = '2088888';
    _loginController.passTextController.text = 'ral11lod';

    try {
      version = getData.read('AppVersion');
      print(version);
    } catch (e) {
      print(e);
    }
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
                            primary:AppColors.buttonColor, // Change the background color here
                          ),
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
                              primary:AppColors.buttonColor, // Change the background color here
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
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              children: [
                Container(
                  width: Get.width,
                  height: 300,
                  decoration: const BoxDecoration(
                    color: AppColors.appColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(Constants.login,style: TextStyle(
                          fontSize: 35,color: Colors.white, fontWeight: FontWeight.bold
                        ),),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
                          Form(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: TextFormField(
                                    focusNode: _focusNode,
                                    textCapitalization:
                                    TextCapitalization.characters,
                                    controller:
                                    _loginController.useridTextController,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'OpenSans',
                                      fontSize: 18,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                      ),
                                      hintText: 'ENTER YOUR ID',
                                      hintStyle: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'OpenSans',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 20.0),
                                    ),
                                    validator: (value) =>
                                    value!.trim().isEmpty
                                        ? 'ID required'
                                        : null,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.deny(
                                          RegExp(r"\s\b|\b\s"))
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: TextFormField(
                                    controller:
                                    _loginController.passTextController,
                                    obscureText: true,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'OpenSans',
                                      fontSize: 18,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.grey,
                                      ),
                                      hintText: 'ENTER YOUR PASSWORD',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                        fontFamily: 'OpenSans',
                                        fontSize: 18,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 20.0),
                                    ),
                                    validator: (value) =>
                                    value!.trim().isEmpty
                                        ? 'Password required'
                                        : null,
                                  ),
                                ),

                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0),
                            child: SizedBox(
                              width: Get.width,
                              child: MaterialButton(
                                  color:  AppColors.buttonColor,
                                  height: 45,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'LOGIN',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!
                                        .validate()) {
                                      // _loginController.apiLogin();
                                      _loginController.login();

                                    }
                                  }),
                            ),
                          )
                        ]
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
