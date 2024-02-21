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
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _addressEditingController =
      TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _emailEditingConroller = TextEditingController();
  String guestName = "Guest";
  String address = "Address";
  String phoneNumber = "XXXXXXXXXX";
  String email = "Email";
  void changeName() {
    setState(() {
      guestName = _nameEditingController.text;
      phoneNumber = _phoneEditingController.text;
      email = _emailEditingConroller.text;
    });
    setState(() {
      address = _addressEditingController.text;
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
      body: Column(
        children: [
          SizedBox(
            height: 400,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 160,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Material(
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 10,
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 7, 159, 159),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    width: double.maxFinite,
                                    child: Center(
                                      child: Text(
                                        guestName,
                                        style: const TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned.directional(
                                    textDirection: TextDirection.ltr,
                                    end: 0,
                                    child: IconButton(
                                      style: const ButtonStyle(
                                        iconColor: MaterialStatePropertyAll(
                                            Colors.white),
                                      ),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: ((context) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                        255, 7, 159, 159)
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(25),
                                                  topRight: Radius.circular(25),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    child: textField(
                                                      "Enter your name",
                                                      _nameEditingController,
                                                      TextInputType.text,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    child: textField(
                                                      "Enter your Address",
                                                      _addressEditingController,
                                                      TextInputType.text,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    child: textField(
                                                      "Enter your Number",
                                                      _phoneEditingController,
                                                      TextInputType.phone,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    child: textField(
                                                      "Enter your Email",
                                                      _emailEditingConroller,
                                                      TextInputType
                                                          .emailAddress,
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: changeName,
                                                    style: const ButtonStyle(
                                                      elevation:
                                                          MaterialStatePropertyAll(
                                                              10),
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                        Color.fromARGB(
                                                            255, 7, 159, 159),
                                                      ),
                                                      padding:
                                                          MaterialStatePropertyAll(
                                                        EdgeInsets.only(
                                                            left: 20,
                                                            right: 20),
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
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  top: 130,
                  child: Material(
                    shape: CircleBorder(
                      side: BorderSide(
                        width: 0,
                        color: Colors.blue,
                      ),
                    ),
                    elevation: 5,
                    child: CircleAvatar(
                      radius: 50,
                    ),
                  ),
                ),
              ],
            ),
          ),
          //-------------------------------Address------------------------------
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Material(
              shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(255, 7, 159, 159),
                ),
                child: Center(
                  child: Text(
                    address,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
//--------------number---------------
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Material(
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(255, 7, 159, 159),
                ),
                child: Center(
                  child: Text(
                    phoneNumber,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
//------------email------------------
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Material(
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(255, 7, 159, 159),
                ),
                child: Center(
                  child: Text(
                    email,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
