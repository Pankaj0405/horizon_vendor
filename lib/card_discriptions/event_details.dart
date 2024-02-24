// ignore_for_file: avoid_print

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../Controllers/auth_controller.dart';
import '../Widgets/text_fields.dart';
import '../camera_screen3.dart';

// ignore: must_be_immutable
class EventScreen extends StatefulWidget {
  String eventName;
  String orgName;
  String address;
  String maxSlots;
  String desc;
  String price;
  String fromDate;
  String toDate;
  String imagePath;
  String startTime;
  String endTime;
  String id;
  EventScreen(
      {required this.maxSlots,
      required this.address,
      required this.eventName,
      required this.toDate,
      required this.fromDate,
      required this.orgName,
      required this.price,
      required this.desc,
      required this.imagePath,
      required this.endTime,
      required this.startTime,
        required this.id,
      super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {

  ImagePicker _imagePicker = ImagePicker();
  // bool isLoading = false;
  XFile? imagePath;
  String? link;
  // ignore: unused_field
  final _authController = Get.put(AuthController());
  final _eventNameController = TextEditingController();
  final _organizationController = TextEditingController();
  final _addressController = TextEditingController();
  final _descController = TextEditingController();
  final _slotsController = TextEditingController();
  final _priceController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();

  var textStyle1 = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  var textStyle2 = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  @override
  void initState() {
    _imagePicker = ImagePicker();
    _eventNameController.text = widget.eventName;
    _organizationController.text = widget.orgName;
    _addressController.text = widget.address;
    _descController.text = widget.desc;
    _slotsController.text = widget.maxSlots;
    _priceController.text = widget.price;
    fromDateController.text = widget.fromDate;
    toDateController.text = widget.toDate;
    startTimeController.text = widget.startTime;
    endTimeController.text = widget.endTime;
    super.initState();
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.21,
          maxWidth: double.infinity,
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setModalState(() {
                              _getImageFromCamera();
                            });

                            print("a");
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.grey.shade100),
                                child: const Icon(Icons.camera_alt),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text("Camera")
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setModalState(() {
                              _getImageFromGallery();
                            });

                            print("b");
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.grey.shade100),
                                child:
                                const Icon(Icons.browse_gallery_outlined),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text("Gallery")
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          );
        });
  }

  File? image;
  Future _getImageFromGallery() async {
    Get.back();
    try {
      final XFile? image =
      await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      link = await upload(imageTemp);
      setState(() {
        this.image = imageTemp;
        // _infoController.uploadToStorage(this.image!);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  List<CameraDescription> cameras = [];

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
  }

  Future<void> _getImageFromCamera() async {
    Get.back();

    if (cameras.isEmpty) {
      // Initialize cameras if not already done
      await _initializeCamera();
    }

    // final CameraController controller = CameraController(
    //   cameras[0], // Use the first camera
    //   ResolutionPreset.medium,
    // );
    //
    // await controller.initialize();
    final result = await Get.to(() => CameraScreen3(camera: cameras[0]));

    try {
      if (result != null) {
        final imageTemp = File(result);
        link = await upload(imageTemp);

        setState(() {
          image = imageTemp;
        });
      }
      // final XFile image = await controller.takePicture();
      //
      // final imageTemp = File(image.path);
      // link = await upload(imageTemp);
      //
      // setState(() {
      //   this.image = imageTemp;
      // });
    } catch (e) {
      print('Failed to take picture: $e');
    }
    // finally {
    //   await controller.dispose();
    // }
  }

  Future<String> upload(File imageFile) async {
    try {
      // Create a unique filename for the uploaded image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Reference to the Firebase Storage bucket
      Reference storageReference =
      FirebaseStorage.instance.ref().child('images/$fileName.jpg');

      // Upload the image to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(imageFile);

      // Get the download URL once the image is uploaded
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // Return the download URL
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
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
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(Icons.arrow_back_rounded)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // _infoController.profilePhotoget.value == null?_showBottomSheet():null;

                          setModalState(() {
                            _showBottomSheet();
                          });
                        },
                        child: (image != null)
                            ? CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 60,
                            backgroundImage: FileImage(image!))
                            : const Icon(
                          Icons.image_rounded,
                          size: 60,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //     top: 20,
                      //   ),
                      //   child: Container(
                      //     width: double.maxFinite,
                      //     height: 50,
                      //     decoration: BoxDecoration(
                      //         color: Colors.grey[300],
                      //         border: Border.all(width: 1)),
                      //     child: DropdownButton(
                      //       dropdownColor: Colors.white,
                      //       padding: const EdgeInsets.symmetric(
                      //         horizontal: 20,
                      //       ),
                      //       borderRadius: BorderRadius.circular(20),
                      //       isExpanded: true,
                      //       // Initial Value
                      //       value: dropDownValue,
                      //       style: textStyle,
                      //       // Down Arrow Icon
                      //       icon: const Icon(Icons.keyboard_arrow_down),
                      //       hint: const Padding(
                      //         padding: EdgeInsets.symmetric(
                      //           horizontal: 20,
                      //         ),
                      //         child: Text('Events and tours'),
                      //       ),
                      //       // Array list of items
                      //       items: items.map((String items) {
                      //         return DropdownMenuItem(
                      //           value: items,
                      //           child: Container(
                      //             margin: const EdgeInsets.symmetric(
                      //               horizontal: 20,
                      //             ),
                      //             child: Text(
                      //               items,
                      //               // maxLines: 2,
                      //             ),
                      //           ),
                      //         );
                      //       }).toList(),
                      //       // After selecting the desired option,it will
                      //       // change button value to selected value
                      //       onChanged: (String? newValue) {
                      //         setModalState(() {
                      //           dropDownValue = newValue!;
                      //           // selectedEventId = _authController.eventData
                      //           //     .firstWhere(
                      //           //         (event) => event.eventName == newValue)
                      //           //     .id;
                      //           // print(selectedEventId);
                      //         });
                      //       },
                      //     ),
                      //     // const EventDropdown(), // event dropdown
                      //   ),
                      // ),
                      textField('Event or Tour Name', _eventNameController,
                          TextInputType.text),
                      textField('Organized By', _organizationController,
                          TextInputType.text),
                      textField(
                          'Address', _addressController, TextInputType.text),
                      textField(
                          'Max slots', _slotsController, TextInputType.number),
                      textField('Booking Price', _priceController,
                          TextInputType.number),
                      const SizedBox(
                        height: 10,
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Event Description',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextField(
                        maxLines: 2,
                        // expands: true,
                        controller: _descController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                      ),
                      ListTile(
                        leading: const Text(
                          'From: ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        trailing: SizedBox(
                          height: 30,
                          width: 120,
                          child: TextField(
                            controller: fromDateController,
                            style: const TextStyle(color: Colors.black),
                            cursorColor: Colors
                                .blue, //editing controller of this TextField
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                contentPadding: const EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            readOnly:
                            true, //set it true, so that user will not able to edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  // DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101));

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                //you can implement different kind of Date Format here according to your requirement

                                setState(() {
                                  fromDateController.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {
                                print("Date is not selected");
                              }
                            },
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Text(
                          'To: ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        trailing: SizedBox(
                          height: 30,
                          width: 120,
                          child: TextField(
                            controller: toDateController,
                            style: const TextStyle(color: Colors.black),
                            cursorColor: Colors
                                .blue, //editing controller of this TextField
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                contentPadding: const EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            readOnly:
                            true, //set it true, so that user will not able to edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  // DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101));

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                //you can implement different kind of Date Format here according to your requirement

                                setState(() {
                                  toDateController.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {
                                print("Date is not selected");
                              }
                            },
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Text(
                          'Start Time: ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        trailing: SizedBox(
                          height: 30,
                          width: 120,
                          child: TextField(
                            controller: startTimeController,
                            style: const TextStyle(color: Colors.black),
                            cursorColor: Colors
                                .blue, //editing controller of this TextField
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                contentPadding: const EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            readOnly:
                            true, //set it true, so that user will not able to edit text
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              // showDatePicker(
                              //     context: context,
                              //     initialDate: DateTime.now(),
                              //     firstDate: DateTime.now(),
                              //     // DateTime(2000), //DateTime.now() - not to allow to choose before today.
                              //     lastDate: DateTime(2101));

                              if (pickedTime != null) {
                                print(
                                    pickedTime); //pickedDate output format => 2021-03-10 00:00:00.000
                                // String formattedTime =
                                // DateFormat('hh:mm a').format();
                                // print(
                                //     formattedTime); //formatted date output using intl package =>  2021-03-16
                                //you can implement different kind of Date Format here according to your requirement

                                setState(() {
                                  startTimeController.text =
                                      pickedTime.format(context); //set output date to TextField value.
                                });
                              } else {
                                print("Time is not selected");
                              }
                            },
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Text(
                          'End Time: ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        trailing: SizedBox(
                          height: 30,
                          width: 120,
                          child: TextField(
                            controller: endTimeController,
                            style: const TextStyle(color: Colors.black),
                            cursorColor: Colors
                                .blue, //editing controller of this TextField
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                contentPadding: const EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            readOnly:
                            true, //set it true, so that user will not able to edit text
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              // showDatePicker(
                              //     context: context,
                              //     initialDate: DateTime.now(),
                              //     firstDate: DateTime.now(),
                              //     // DateTime(2000), //DateTime.now() - not to allow to choose before today.
                              //     lastDate: DateTime(2101));

                              if (pickedTime != null) {
                                print(
                                    pickedTime); //pickedDate output format => 2021-03-10 00:00:00.000
                                // String formattedTime =
                                // DateFormat('hh:mm a').format();
                                // print(
                                //     formattedTime); //formatted date output using intl package =>  2021-03-16
                                //you can implement different kind of Date Format here according to your requirement

                                setState(() {
                                  endTimeController.text =
                                      pickedTime.format(context); //set output date to TextField value.
                                });
                              } else {
                                print("Time is not selected");
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                            ),
                            child: Text(
                              'UPDATE',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 270,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(widget.imagePath),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0, left: 15),
                      child: IconButton(
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white54),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              ListTile(
                // leading: Icon(Icons.event),
                title: Text(
                  widget.eventName,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.apartment),
                title: Text(
                  widget.orgName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: Text(
                  widget.address,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.monetization_on_outlined),
                title: Text(
                  'Rs ${widget.price}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month_outlined),
                title: Text(
                  '${widget.fromDate} - ${widget.toDate}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.alarm),
                title: Text(
                  '${widget.startTime} - ${widget.endTime}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.desc,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     // crossAxisAlignment: CrossAxisAlignment.stretch,
              //     children: [
              //       Card(
              //         child: Padding(
              //           padding: const EdgeInsets.all(10),
              //           child: Column(
              //             children: [
              //               Text('From:', style: textStyle1,),
              //               Text(widget.fromDate, style: textStyle2,),
              //             ],
              //           ),
              //         ),
              //       ),
              //       Card(
              //         child: Padding(
              //           padding: const EdgeInsets.all(10),
              //           child: Column(
              //             children: [
              //               Text('To:', style: textStyle1,),
              //               Text(widget.toDate, style: textStyle2,),
              //             ],
              //           ),
              //         ),
              //       ),
              //       Card(
              //         child: Padding(
              //           padding: const EdgeInsets.all(10),
              //           child: Column(
              //             children: [
              //               Text('Max-Users:', style: textStyle1,),
              //               Text(widget.maxSlots, style: textStyle2,),
              //             ],
              //           ),
              //         ),
              //       ),
              //       // ListTile(
              //       //   leading: Text('From:', style: textStyle1,),
              //       //   trailing: Text(widget.fromDate, style: textStyle2,),
              //       // ),
              //       // ListTile(
              //       //   leading: Text('To:', style: textStyle1,),
              //       //   trailing: Text(widget.toDate, style: textStyle2,),
              //       // ),
              //       // ListTile(
              //       //   leading: Text('Max-Users:', style: textStyle1,),
              //       //   trailing: Text(widget.maxSlots, style: textStyle2,),
              //       // ),
              //       // Padding(
              //       //   padding: const EdgeInsets.all(8.0),
              //       //   child: Text(
              //       //     'From: ${widget.fromDate}',
              //       //     style: TextStyle(
              //       //       fontSize: 18,
              //       //       fontWeight: FontWeight.w500,
              //       //     ),
              //       //   ),
              //       // ),
              //       // Padding(
              //       //   padding: const EdgeInsets.all(8.0),
              //       //   child: Text(
              //       //     'To: ${widget.toDate}',
              //       //     style: TextStyle(
              //       //       fontSize: 18,
              //       //       fontWeight: FontWeight.w500,
              //       //     ),
              //       //   ),
              //       // ),
              //       // Padding(
              //       //   padding: const EdgeInsets.symmetric(
              //       //     horizontal: 8,
              //       //   ),
              //       //   child: Text('Max-Users: ${widget.maxSlots}', style: TextStyle(
              //       //     fontSize: 20,
              //       //     fontWeight: FontWeight.w500,
              //       //   ),),
              //       // ),
              //     ],
              //   ),
              // ),
              // Column(
              //   // mainAxisAlignment: MainAxisAlignment.start,
              //   // crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(
              //       "Organised By: ${widget.orgName}",
              //       style: TextStyle(
              //         fontSize: 22,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     SizedBox(height: 8),
              //     Padding(
              //       padding: EdgeInsets.only(left: 8.0),
              //       child: Text(
              //         widget.orgName,
              //         style: TextStyle(
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 15),
              // Description(eventDescription: widget.eventDescription),
              // const SizedBox(height: 25),
              // PlacePictures(),
              // const SizedBox(height: 25),
              // const Details(),
              // const SizedBox(height: 25),
              // const Align(
              //   alignment: Alignment.centerLeft,
              //   child: Padding(
              //     padding: EdgeInsets.only(left: 25.0),
              //     child: Text(
              //       "Location",
              //       style: TextStyle(
              //         fontSize: 20,
              //       ),
              //     ),
              //   ),
              // ),
              // const LocationDetails(),
            ],
          ),
        ),
        // floatingActionButton: ,
        bottomNavigationBar: Container(
          // color: Colors.grey[200],
          decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Colors.grey, width: 1, style: BorderStyle.solid)),
          ),
          height: 70,
          width: double.maxFinite,
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {},
                // isExtended: true,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
                child: const Text(
                  'DELETE',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  openBottomSheet();
                },
                // isExtended: true,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
                child: const Text(
                  'EDIT',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
