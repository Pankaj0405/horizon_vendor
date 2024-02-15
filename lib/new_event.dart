import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizon_vendor/Widgets/cards.dart';
import 'package:image_picker/image_picker.dart';
import './Widgets/text_fields.dart';
import './Controllers/auth_controller.dart';
import './main.dart';
import './Widgets/search_bar.dart';

class AddNewEvent extends StatefulWidget {
  const AddNewEvent({super.key});

  @override
  State<AddNewEvent> createState() => _AddNewEventState();
}

class _AddNewEventState extends State<AddNewEvent> {
  ImagePicker _imagePicker = ImagePicker();
  bool isLoading = false;
  XFile? imagePath;
  final _authController = Get.put(AuthController());
  final _eventNameController = TextEditingController();
  final _organizationController = TextEditingController();
  final _addressController = TextEditingController();
  final _descController = TextEditingController();
  final _slotsController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _imagePicker = new ImagePicker();
  }

  pickImage() async {
    try {
      setState(() {
        isLoading = true;
      });
      XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        imagePath = XFile(image.path, name: image.name);
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void emptyFields() {
    _addressController.text = "";
    _descController.text = "";
    _organizationController.text = "";
    _eventNameController.text = "";
    _slotsController.text = "";
    _priceController.text = "";
    imagePath = null;
  }

  openBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        // enableDrag: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textField('Event or Tour Name', _eventNameController,
                        TextInputType.text),
                    textField('Organization Name', _organizationController,
                        TextInputType.text),
                    textField(
                        'Address', _addressController, TextInputType.text),
                    textField(
                        'Max slots', _slotsController, TextInputType.number),
                    textField('Booking Price', _priceController,
                        TextInputType.number),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Event Description',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextField(
                      maxLines: 3,
                      // expands: true,
                      controller: _descController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[300],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      flex: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Image: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.blue,
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      pickImage();
                                      print(imagePath!.name);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text('Select'),
                                  ),
                                ),
                          if (imagePath != null)
                            SizedBox(
                              width: 70,
                              child: Text(
                                imagePath!.name,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          _authController.addEvent(
                              _eventNameController.text,
                              _organizationController.text,
                              _addressController.text,
                              _descController.text,
                              _slotsController.text,
                              _priceController.text,
                              imagePath!.path);
                          Get.back();
                          emptyFields();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                          ),
                          child: const Text(
                            'ADD',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _authController.getEvent();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 120,
          flexibleSpace: const Column(
            children: [
              const Text(
                "Tours and Events",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: EventSearchBar(),
              ),
            ],
          ),
          // centerTitle: true,
        ),
        body: Obx(() => ListView.builder(
            shrinkWrap: true,
            itemCount: _authController.eventData.length,
            itemBuilder: (BuildContext context, int index) {
              final events = _authController.eventData[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          "", // Replace 'image.png' with your image asset path
                          width: 100,
                          height: 200,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 8,),
                          Container(
                            width: 150,
                            child: Text(
                              events.eventName,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Container(
                            width: 150,
                            child: Text(
                              'Organized By: \n${events.organizationName}',
                              maxLines: 2,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          // cardListTile('', events.description),
                          Container(
                            height: 80,
                            width: 150,
                            child: Text(
                              events.description,
                              maxLines: 2,
                              style: TextStyle(fontSize: 18, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                    ],
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     Container(
                    //       height: 400,
                    //       width: 200,
                    //       child: imagePath != null? Image.asset(imagePath!.path, fit: BoxFit.fill,) : Container(color: Colors.blue,),
                    //     ),
                    //     Column(
                    //       // crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: [
                    //         cardListTile('Event: ', events.eventName),
                    //         cardListTile('Organized By: ', events.organizationName),
                    //         cardListTile('Description: ', events.description),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
              );
            }),),


        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            openBottomSheet();
          },
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }
}

//-------------------searchbar----------------------------

//---------------------Duration--------------------
// class Duration extends StatefulWidget {
//   const Duration({super.key});
//
//   @override
//   State<Duration> createState() => _DurationState();
// }
//
// class _DurationState extends State<Duration> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(
//         top: 15,
//         bottom: 15,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: List.generate(7, (index) {
//           return InkWell(
//             child: Container(
//               decoration: BoxDecoration(
//                   color: Colors.grey.shade200, shape: BoxShape.circle),
//               child: Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Text(
//                   (index + 1).toString(),
//                   style: const TextStyle(fontSize: 15),
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

//------------------Timing--------------------------

// class EventTiming extends StatefulWidget {
//   const EventTiming({super.key});
//
//   @override
//   State<EventTiming> createState() => _EventTimingState();
// }
//
// class _EventTimingState extends State<EventTiming> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           InkWell(
//             onTap: () {},
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.all(10),
//                 child: Text("Morning"),
//               ),
//             ),
//           ),
//           InkWell(
//             onTap: () {},
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.all(10),
//                 child: Text("Afternoon"),
//               ),
//             ),
//           ),
//           InkWell(
//             onTap: () {},
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.all(10),
//                 child: Text("Evening"),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
