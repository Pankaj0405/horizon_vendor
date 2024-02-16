import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizon_vendor/Controllers/auth_controller1.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final auth=Get.put(AuthController1());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile Page",
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            auth.logout();
          },
          child: Text(
            'Log out'
          ),
        )
      ),
    );
  }
}