// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:horizon_vendor/card_discriptions/volunteer_details.dart';
import 'package:horizon_vendor/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizon_vendor/Controllers/auth_controller.dart';
import 'package:horizon_vendor/Widgets/text_fields.dart';
import 'package:horizon_vendor/models/add_events.dart';
import 'package:intl/intl.dart';

import 'camera_screen3.dart';

class AddVolunteer extends StatefulWidget {
  const AddVolunteer({super.key});

  @override
  State<AddVolunteer> createState() => _AddVolunteerState();
}

class _AddVolunteerState extends State<AddVolunteer>
    with TickerProviderStateMixin {
  final _authController = Get.put(AuthController());
  List<String> items = [];
  List<String> items2 = [];
  String eventDropDown = 'Event';
  String tourDropDown = 'Tour';
  String typeDropDown = 'Event';
  List<String> items1 = ['Event', 'Tour'];
  String selectedEventId = '';
  String selectedTourId = '';
  final _volunteerController = TextEditingController();
  final _roleController = TextEditingController();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _addressController = TextEditingController();

  TabController? _tabController;
  final ImagePicker _imagePicker = ImagePicker();
  // bool isLoading = false;
  XFile? imagePath;
  String? link;

  var textStyle = const TextStyle(
    overflow: TextOverflow.fade,
    color: Colors.black,
    fontSize: 15,
  );

  emptyFields() {
    _roleController.text = "";
    _volunteerController.text = "";
    _fromDateController.text = "";
    _toDateController.text = "";
    _startTimeController.text = "";
    _endTimeController.text = "";
    image = null;
    _addressController.text = '';
    // eventDropDown = 'Event';
  }

  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Future<String> fetchData() async {
    setState(() {
      isLoading =
      true; // Set isLoading to false to hide the circular progress indicator
    });
    _tabController = TabController(length: 2, vsync: this);
    await _authController.getVolunteers();
    print(_authController.volunteerData.length);
    await populateEventsDropdown();
    await populateToursDropdown();
    setState(() {
      isLoading =
      false; // Set isLoading to false to hide the circular progress indicator
    });
    return "Data fetched successfully";
  }



  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
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
                    Container(
                      width: double.maxFinite,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey[300], border: Border.all(width: 1)),
                      child: DropdownButton(
                        dropdownColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        isExpanded: true,
                        // Initial Value
                        value: typeDropDown,
                        style: textStyle,
                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),
                        hint: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Text('Events and tours'),
                        ),
                        // Array list of items
                        items: items1.map((String items) {
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
                            typeDropDown = newValue!;
                            // selectedEventId = _authController.eventData
                            //     .firstWhere(
                            //         (event) => event.eventName == newValue)
                            //     .id;
                            print(typeDropDown);
                          });
                        },
                      ),
                      // const EventDropdown(), // event dropdown
                    ),
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
                    typeDropDown == "Event"
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
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       left: 20.0, right: 20.0),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       border: Border.all(width: 1),
                    //     ),
                    //     child: const Row(
                    //       mainAxisAlignment:
                    //       MainAxisAlignment.spaceEvenly,
                    //       children: [
                    //         Text(
                    //           "No. of volunteers required:",
                    //           style: TextStyle(
                    //             fontSize: 18,
                    //           ),
                    //         ),
                    //         SizedBox(height: 40),
                    //         MyDropdown(),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    // const Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: Padding(
                    //       padding: EdgeInsets.only(left: 20.0),
                    //       child: Text(
                    //         "Role description",
                    //         style: TextStyle(
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //     )),
                    // const SizedBox(height: 20),
                    // const RoleDescription(),
                    // SizedBox(height: 20),
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
                              _authController.addVolunteers(
                                  typeDropDown == "Event" ? eventDropDown:tourDropDown,
                                  _volunteerController.text,
                                  _roleController.text,
                                  typeDropDown,
                                  typeDropDown == "Event" ? selectedEventId : selectedTourId,
                                  link!,
                                  _fromDateController.text,
                                  _toDateController.text,
                                  _startTimeController.text,
                                  _endTimeController.text,
                                  _addressController.text, firebaseAuth.currentUser!.uid);

                            Get.back();
                            emptyFields();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                            ),
                            child: Text(
                              'ADD',
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
    _authController.getEventVolunteers();
    _authController.getTourVolunteers();
    // _authController.getEvent();
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          // leading: BackButton(
          //   style: const ButtonStyle(
          //     iconSize: MaterialStatePropertyAll(30),
          //   ),
          //   onPressed: () {
          //     // Get.back();
          //   },
          // ),
          title: const Text(
            "Volunteers",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                icon: Icon(Icons.tour),
                text: "Tours",
              ),
              Tab(
                icon: Icon(Icons.event),
                text: "Events",
              ),
            ],
          ),
        ),
        body:isLoading
            ? const Center(child: CircularProgressIndicator())
            :  TabBarView(
          controller: _tabController,
          children: [
            Obx(
              () => _authController.volunteerTourData.isNotEmpty
                  ? ListView.builder(
                  itemCount: _authController.volunteerTourData.length,
                  itemBuilder: (context,index) {
                    final volunteers = _authController.volunteerTourData[index];
                    return InkWell(
                            onTap: () {
                              Get.to(() => VolunteerScreen(
                                  imagePath: volunteers.imagePath,
                                  eventName: volunteers.eventName,
                                  role: volunteers.role,
                                  fromDate: volunteers.fromDate,
                                  maxSlots: volunteers.volNumber,
                                  startTime: volunteers.startTime,
                                  endTime: volunteers.endTime,
                                  toDate: volunteers.toDate,
                                  address: volunteers.address,
                                  id: volunteers.id,
                                  type: volunteers.type));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: double.maxFinite,
                                height: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(volunteers.imagePath),
                                    fit: BoxFit.fill,
                                    opacity: 0.6,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 2,
                                        ),
                                        child: Text(
                                          volunteers.eventName,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 2,
                                        ),
                                        child: Text(
                                          'Last Date: ${volunteers.fromDate}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 2,
                                        ),
                                        child: Text(
                                          'Max-Slots: ${volunteers.volNumber}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          volunteers.role,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                  })
                  : const Center(child: Text('No Volunteers for Tours Added Yet', style:  TextStyle(fontSize: 25),)),
            ),
            Obx(
              () {
                return _authController.volunteerEventData.isNotEmpty
                  ? ListView.builder(
                    itemCount: _authController.volunteerEventData.length,
                    itemBuilder: (BuildContext context, int index1) {
                      final volunteers = _authController.volunteerEventData[index1];
                      return InkWell(
                        onTap: () {
                          Get.to(() => VolunteerScreen(
                              imagePath: volunteers.imagePath,
                              eventName: volunteers.eventName,
                              role: volunteers.role,
                              fromDate: volunteers.fromDate,
                              maxSlots: volunteers.volNumber,
                              toDate: volunteers.toDate,
                              endTime: volunteers.endTime,
                              startTime: volunteers.startTime,
                              address: volunteers.address,
                              id: volunteers.id,
                              type: volunteers.type));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.maxFinite,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(volunteers.imagePath),
                                fit: BoxFit.fill,
                                opacity: 0.6,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 2,
                                    ),
                                    child: Text(
                                      volunteers.eventName,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 2,
                                    ),
                                    child: Text(
                                      'Last Date: ${volunteers.fromDate}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 2,
                                    ),
                                    child: Text(
                                      'Max-Slots: ${volunteers.volNumber}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      volunteers.role,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );


                    })
                    : const Center(child: Text('No Volunteers for Events Added Yet', style:  TextStyle(fontSize: 25),));
              }
            ),
          ],
        ),

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
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

//------------------Event drop down menu---------------------
// class EventDropdown extends StatefulWidget {
//   const EventDropdown({super.key});
//
//   @override
//   // ignore: library_private_types_in_public_api
//   _EventDropdownState createState() => _EventDropdownState();
// }

// class _EventDropdownState extends State<EventDropdown> {
//   String eventSelectedValue = ''; // Initialize with an empty string
//   List<String> eventsOptions = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<String>(
//       value: eventSelectedValue.isNotEmpty
//           ? eventSelectedValue
//           : null, // Adjusted value to show hint
//       onChanged: (String? newValue) {
//         setState(() {
//           eventSelectedValue = newValue ?? '';
//         });
//       },
//       hint: const Padding(
//         padding: EdgeInsets.only(left: 20.0, right: 20.0),
//         child: Text('Events and tours'),
//       ), // Set the hint text
//       items: eventsOptions.map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }
// }

//--------------------Tour drop down---------------

// class ToursDropdown extends StatefulWidget {
//   const ToursDropdown({super.key});
//
//   @override
//   // ignore: library_private_types_in_public_api
//   _ToursDropdownState createState() => _ToursDropdownState();
// }

// class _ToursDropdownState extends State<ToursDropdown> {
//   String tourSelectedValue = ''; // Initialize with an empty string
//   List<String> toursOptions = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<String>(
//       value: tourSelectedValue.isNotEmpty
//           ? tourSelectedValue
//           : null, // Adjusted value to show hint
//       onChanged: (String? newValue) {
//         setState(() {
//           tourSelectedValue = newValue ?? '';
//         });
//       },
//       hint: const Text('Tours'), // Set the hint text
//       items: toursOptions.map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }
// }

// class MyDropdown extends StatefulWidget {
//   const MyDropdown({super.key});
//
//   @override
//   // ignore: library_private_types_in_public_api
//   _MyDropdownState createState() => _MyDropdownState();
// }

// class _MyDropdownState extends State<MyDropdown> {
//   int? selectedValue;
//   List<int> options = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<int>(
//       value: selectedValue,
//       onChanged: (int? newValue) {
//         setState(() {
//           selectedValue = newValue;
//         });
//       },
//       hint: const Text('        '), // Set the hint text
//       items: options.map<DropdownMenuItem<int>>((int value) {
//         return DropdownMenuItem<int>(
//           value: value,
//           child: Text(value.toString()),
//         );
//       }).toList(),
//     );
//   }
// }

//--------------------------Role description-------------------------

// class RoleDescription extends StatefulWidget {
//   const RoleDescription({super.key});
//
//   @override
//   State<RoleDescription> createState() => _RoleDescriptionState();
// }

// class _RoleDescriptionState extends State<RoleDescription> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(width: 1),
//         ),
//         child: const TextField(
//           maxLines: 4,
//         ),
//       ),
//     );
//   }
// }
