import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizon_vendor/Controllers/auth_controller1.dart';
import 'package:horizon_vendor/Widgets/text_fields.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final auth = Get.put(AuthController1());
  final TextEditingController _textEditingController = TextEditingController();
  String guestName = "Guest";
  void changeName() {
    setState(() {
      guestName = _textEditingController.text;
    });
    setState(() {
      navigator?.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: const EdgeInsets.only(top: 50.0, left: 15, right: 15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset("assets/images/logo.jpg"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    SizedBox(
                      width: 200,
                      child: Text(
                        guestName,
                        style: const TextStyle(
                          fontSize: 30,
                        ),
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: ((context) {
                        return Container(
                          height: 600,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 7, 159, 159)
                                .withOpacity(0.5),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.only(top: 20),
                                child: textField(
                                  "Enter your name",
                                  _textEditingController,
                                  TextInputType.text,
                                ),
                              ),
                              const SizedBox(height: 30),
                              TextButton(
                                onPressed: changeName,
                                style: const ButtonStyle(
                                  elevation: MaterialStatePropertyAll(10),
                                  backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 7, 159, 159),
                                  ),
                                  padding: MaterialStatePropertyAll(
                                    EdgeInsets.only(left: 20, right: 20),
                                  ),
                                ),
                                child: const Text(
                                  "Save",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
