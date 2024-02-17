import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizon_vendor/Controllers/auth_controller1.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final auth = Get.put(AuthController1());
  String guestName = "Guest";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile Page",
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
      ),
      // body: Center(
      //   child: ElevatedButton(
      //     onPressed: (){
      //       auth.logout();
      //     },
      //     child: const Text(
      //       'Log out'
      //     ),
      //   )
      // ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Hii!",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Text(
                  guestName,
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: ((context) {
                        return Container(
                          height: 100,
                        );
                      }),
                    );
                  },
                  icon: const Icon(Icons.edit_square),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
