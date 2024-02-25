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
import '../models/add_events.dart';

// ignore: must_be_immutable
class VolunteerScreen extends StatefulWidget {
  String imagePath;
  String eventName;
  String maxSlots;
  String role;
  String fromDate;
  String toDate;
  String startTime;
  String endTime;
  String address;
  String id;
  String type;
  VolunteerScreen({required this.imagePath, required this.eventName, required this.role, required this.fromDate, required this.maxSlots, required this.toDate, required this.endTime, required this.startTime, required this.address, required this.id, required this.type,super.key});

  @override
  State<VolunteerScreen> createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen> {

  var textStyle1= const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  var textStyle2 = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  final _authController = Get.put(AuthController());
  List<String> items = [];
  List<String> items2 = [];
  String eventDropDown = 'Event';
  String tourDropDown = 'Tour';
  String selectedEventId = '';
  String selectedTourId = '';
  final _volunteerController = TextEditingController();
  final _roleController = TextEditingController();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _addressController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  // bool isLoading = false;
  XFile? imagePath;
  String? link;

  var textStyle = const TextStyle(
    overflow: TextOverflow.fade,
    color: Colors.black,
    fontSize: 15,
  );


  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    _roleController.text = widget.role;
    _volunteerController.text = widget.maxSlots;
    _fromDateController.text = widget.fromDate;
    _toDateController.text = widget.toDate;
    _startTimeController.text = widget.startTime;
    _endTimeController.text = widget.endTime;
    _addressController.text = widget.address;
    link = widget.imagePath;
    super.initState();
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

  Future<void> populateEventsDropdown() async {
    List<AddEvent> events = await _authController.getAllEvents();
    setState(() {
      items = events.map((event) => event.eventName).toList();
      print(items);
      eventDropDown = items[0]; // Set the default value
    });
  }

  Future<void> populateToursDropdown() async {
    List<AddEvent> tours = await _authController.getAllTours();
    setState(() {
      items2 = tours.map((tour) => tour.eventName).toList();
      print(items2);
      tourDropDown = items2[0]; // Set the default value
    });
  }

  openBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: ((context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 8.0),
                    //     child: BackButton(
                    //       onPressed: () {
                    //         Navigator.pop(context);
                    //       },
                    //       style: const ButtonStyle(
                    //           iconSize: MaterialStatePropertyAll(30)),
                    //     ),
                    //   ),
                    // ),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.arrow_back)),
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
                    const SizedBox(
                      height: 20,
                    ),
                    // Container(
                    //   width: double.maxFinite,
                    //   height: 50,
                    //   decoration: BoxDecoration(
                    //       color: Colors.grey[300], border: Border.all(width: 1)),
                    //   child: DropdownButton(
                    //     dropdownColor: Colors.white,
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 20,
                    //     ),
                    //     borderRadius: BorderRadius.circular(20),
                    //     isExpanded: true,
                    //     // Initial Value
                    //     value: typeDropDown,
                    //     style: textStyle,
                    //     // Down Arrow Icon
                    //     icon: const Icon(Icons.keyboard_arrow_down),
                    //     hint: const Padding(
                    //       padding: EdgeInsets.symmetric(
                    //         horizontal: 20,
                    //       ),
                    //       child: Text('Events and tours'),
                    //     ),
                    //     // Array list of items
                    //     items: items1.map((String items) {
                    //       return DropdownMenuItem(
                    //         value: items,
                    //         child: Container(
                    //           margin: const EdgeInsets.symmetric(
                    //             horizontal: 20,
                    //           ),
                    //           child: Text(
                    //             items,
                    //             maxLines: 2,
                    //           ),
                    //         ),
                    //       );
                    //     }).toList(),
                    //     // After selecting the desired option,it will
                    //     // change button value to selected value
                    //     onChanged: (String? newValue) {
                    //       setModalState(() {
                    //         typeDropDown = newValue!;
                    //         // selectedEventId = _authController.eventData
                    //         //     .firstWhere(
                    //         //         (event) => event.eventName == newValue)
                    //         //     .id;
                    //         print(typeDropDown);
                    //       });
                    //     },
                    //   ),
                    //   // const EventDropdown(), // event dropdown
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Events and Tours',
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    widget.type == "Event"
                        ? Container(
                      width: double.maxFinite,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(width: 1)),
                      child: DropdownButton(
                        dropdownColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        isExpanded: true,
                        // Initial Value
                        value: eventDropDown,
                        style: textStyle,
                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),
                        hint: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Text('Events and tours'),
                        ),
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Text(
                                items,
                                maxLines: 2,
                              ),
                            ),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setModalState(() {
                            eventDropDown = newValue!;
                            selectedEventId = _authController.eventData
                                .firstWhere(
                                    (event) => event.eventName == newValue)
                                .id;
                            // print(selectedEventId);
                          });
                        },
                      ),
                    )
                        : Container(
                      width: double.maxFinite,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(width: 1)),
                      child: DropdownButton(
                        dropdownColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        isExpanded: true,
                        // Initial Value
                        value: tourDropDown,
                        style: textStyle,
                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),
                        hint: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Text('Tours'),
                        ),
                        // Array list of items
                        items: items2.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Text(
                                items,
                                maxLines: 2,
                              ),
                            ),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setModalState(() {
                            tourDropDown = newValue!;
                            selectedTourId = _authController.tourData
                                .firstWhere(
                                    (tour) => tour.eventName == newValue)
                                .id;
                            print(selectedTourId);
                          });
                        },
                      ),
                      // const EventDropdown(), // event dropdown
                    ),
                    const SizedBox(height: 20),
                    textField('No. of Volunteers required: ',
                        _volunteerController, TextInputType.number),
                    textField(
                        'Address', _addressController, TextInputType.text),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Role Description',
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextField(
                      controller: _roleController,
                      // expands: true,
                      maxLines: 3,
                      // enabled: false,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Text(
                        'From Date: ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      trailing: SizedBox(
                        height: 30,
                        width: 120,
                        child: TextField(
                          controller: _fromDateController,
                          style: const TextStyle(color: Colors.black),
                          cursorColor:
                          Colors.blue, //editing controller of this TextField
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
                                _fromDateController.text =
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
                        'To Date: ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      trailing: SizedBox(
                        height: 30,
                        width: 120,
                        child: TextField(
                          controller: _toDateController,
                          style: const TextStyle(color: Colors.black),
                          cursorColor:
                          Colors.blue, //editing controller of this TextField
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
                                _toDateController.text =
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
                          controller: _startTimeController,
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
                                _startTimeController.text =
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
                          controller: _endTimeController,
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
                                _endTimeController.text =
                                    pickedTime.format(context); //set output date to TextField value.
                              });
                            } else {
                              print("Time is not selected");
                            }
                          },
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            setModalState(() {
                              _authController.updateVolunteer(widget.id, _addressController.text, _volunteerController.text, _roleController.text, _fromDateController.text, _toDateController.text, _startTimeController.text, _endTimeController.text, link!);
                              Get.back();
                            });

                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                            ),
                            child: Text(
                              'UPDATE',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
      }),
    );
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
              ListTile(
                leading: const Icon(Icons.people_alt_outlined),
                title: Text(
                  widget.maxSlots,
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
                  widget.role,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
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
                onPressed: () {
                  _authController.deleteVolunteer(widget.id);
                  Get.back();
                },
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

