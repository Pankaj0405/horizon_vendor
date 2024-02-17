import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizon_vendor/Controllers/auth_controller1.dart';
import 'package:horizon_vendor/constants.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController1 authController = Get.put(AuthController1());

  Future<void> checkFirstTimeLogin() async {
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3),()=>authController.checkLoginStatus(firebaseAuth.currentUser));
  }
  @override
  Widget build(BuildContext context) {
    checkFirstTimeLogin();
    return Scaffold(
backgroundColor: Colors.white,
        body: Center(
          child: Container(
            child: const Image(
              image: AssetImage(
                'assets/images/beach.jpg'
              ),
            ),
          ),
        )
    );
  }
}