import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:horizon_vendor/constants.dart';
import 'package:intl/intl.dart';
import 'package:horizon_vendor/camera_screen3.dart';
import 'package:image_picker/image_picker.dart';
import './Widgets/text_fields.dart';
import './Controllers/auth_controller.dart';
import 'card_discriptions/event_details.dart';

class AddNewEvent extends StatefulWidget {
  const AddNewEvent({super.key});

  @override
  State<AddNewEvent> createState() => _AddNewEventState();
}

class _AddNewEventState extends State<AddNewEvent>
    with TickerProviderStateMixin {
  ImagePicker _imagePicker = ImagePicker();
  // bool isLoading = false;
  XFile? imagePath;
  String? link;
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
  late final TabController _tabController;

  String dropDownValue = "Select";
  List<String> items = ["Select", "Event", "Tour"];

  var textStyle = const TextStyle(
    overflow: TextOverflow.fade,
    color: Colors.black,
    fontSize: 15,
  );

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

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  void emptyFields() {
    _addressController.text = "";
    _descController.text = "";
    _organizationController.text = "";
    _eventNameController.text = "";
    _slotsController.text = "";
    _priceController.text = "";
    imagePath = null;
    image = null;
    fromDateController.text = '';
    toDateController.text = '';
    startTimeController.text = '';
    endTimeController.text = '';
    dropDownValue = "Select";
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
                          setState(() {

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
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Container(
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
                            value: dropDownValue,
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
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Text(
                                    items,
                                    // maxLines: 2,
                                  ),
                                ),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setModalState(() {
                                dropDownValue = newValue!;
                                // selectedEventId = _authController.eventData
                                //     .firstWhere(
                                //         (event) => event.eventName == newValue)
                                //     .id;
                                // print(selectedEventId);
                              });
                            },
                          ),
                          // const EventDropdown(), // event dropdown
                        ),
                      ),
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
                                  startTimeController.text = pickedTime.format(
                                      context); //set output date to TextField value.
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
                                  endTimeController.text = pickedTime.format(
                                      context); //set output date to TextField value.
                                });
                              } else {
                                print("Time is not selected");
                              }
                            },
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // Expanded(
                      //   flex: 0,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: [
                      //       Text(
                      //         'Image: ',
                      //         style: TextStyle(
                      //           fontSize: 20,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //       isLoading
                      //           ? CircularProgressIndicator(
                      //               color: Colors.blue,
                      //             )
                      //           : GestureDetector(
                      //               onTap: () {
                      //                 setModalState(() {
                      //                   pickImage();
                      //                   print(imagePath!.name);
                      //                 });
                      //               },
                      //               child: Container(
                      //                 padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      //                 decoration: BoxDecoration(
                      //                   border: Border.all(),
                      //                   borderRadius: BorderRadius.circular(10),
                      //                 ),
                      //                 child: const Text('Select'),
                      //               ),
                      //             ),
                      //       if (imagePath != null)
                      //         SizedBox(
                      //           width: 70,
                      //           child: Text(
                      //             imagePath!.name,
                      //             style: TextStyle(
                      //                 fontSize: 16, color: Colors.black),
                      //             overflow: TextOverflow.ellipsis,
                      //           ),
                      //         ),
                      //     ],
                      //   ),
                      // ),
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
                                link!,
                                dropDownValue,
                                fromDateController.text,
                                toDateController.text,
                                startTimeController.text,
                                endTimeController.text,
                                firebaseAuth.currentUser!.uid);
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
    _authController.getEvent();
    _authController.getTour();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // toolbarHeight: 120,
          title: const Text(
            "Tours and Events",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          // flexibleSpace: const Column(
          //   children: [
          //     Text(
          //       "Tours and Events",
          //       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          //     ),
          //     SizedBox(
          //       height: 20,
          //     ),
          //     Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 20),
          //       child: EventSearchBar(),
          //     ),
          //   ],
          // ),
          // centerTitle: true,
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
        body: TabBarView(
          controller: _tabController,
          children: [
            Obx(
              () => _authController.tourData.isNotEmpty
                  ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: _authController.tourData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final tours = _authController.tourData[index];
                    return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(() => EventScreen(
                                      maxSlots: tours.maxSlots,
                                      address: tours.address,
                                      eventName: tours.eventName,
                                      toDate: tours.toDate,
                                      fromDate: tours.fromDate,
                                      orgName: tours.organizationName,
                                      price: tours.price,
                                      desc: tours.description,
                                      imagePath: tours.imagePath,
                                      startTime: tours.startTime,
                                      endTime: tours.endTime,
                                      id: tours.id,
                                      type: tours.type,
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: double.maxFinite,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(tours.imagePath),
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
                                            tours.eventName,
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
                                            '${tours.maxSlots}, ${tours.address}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.symmetric(
                                        //     horizontal: 10,
                                        //     vertical: 2,
                                        //   ),
                                        //   child: Text(
                                        //     'Max-Slots: ${tours.maxSlots}',
                                        //     style: const TextStyle(
                                        //       fontSize: 14,
                                        //       fontWeight: FontWeight.bold,
                                        //       color: Colors.white,
                                        //     ),
                                        //   ),
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            tours.description,
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
                            ),
                            // Card(
                            //   color: const Color.fromARGB(255, 7, 159, 159)
                            //       .withOpacity(0.8),
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //
                            //     children: [
                            //       Padding(
                            //         padding: const EdgeInsets.only(top:15, bottom: 15, left: 15, right: 5),
                            //         child: Material(
                            //           elevation: 15,
                            //           child: Image.network(
                            //             tours
                            //                 .imagePath, // Replace 'image.png' with your image asset path
                            //             width: 150,
                            //             height: 150,
                            //             fit: BoxFit.fill,
                            //           ),
                            //         ),
                            //       ),
                            //       Column(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         // mainAxisAlignment: MainAxisAlignment.center,
                            //         children: [
                            //           const SizedBox(
                            //             height: 10,
                            //           ),
                            //           SizedBox(
                            //             width: 150,
                            //             child: Text(
                            //               tours.eventName,
                            //               maxLines: 2,
                            //               style: const TextStyle(
                            //                 fontSize: 28,
                            //                 fontWeight: FontWeight.bold,
                            //                 overflow: TextOverflow.ellipsis,
                            //                 color: Colors.white,
                            //               ),
                            //             ),
                            //           ),
                            //           const SizedBox(height: 8.0),
                            //           // SizedBox(
                            //           //   width: 150,
                            //           //   child: Text(
                            //           //     'Type: ${tours.type}',
                            //           //     maxLines: 2,
                            //           //     style: const TextStyle(
                            //           //       fontSize: 20,
                            //           //       fontWeight: FontWeight.w500,
                            //           //       overflow: TextOverflow.ellipsis,
                            //           //       color: Colors.white,
                            //           //     ),
                            //           //   ),
                            //           // ),
                            //           // const SizedBox(height: 8.0),
                            //           // cardListTile('', events.description),
                            //           SizedBox(
                            //             height: 80,
                            //             width: 150,
                            //             child: Text(
                            //               tours.description,
                            //               maxLines: 2,
                            //               style: const TextStyle(
                            //                 fontSize: 18,
                            //                 overflow: TextOverflow.ellipsis,
                            //                 fontWeight: FontWeight.w300,
                            //                 color: Colors.white,
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ],
                            //     // child: Row(
                            //     //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //     //   children: [
                            //     //     Container(
                            //     //       height: 400,
                            //     //       width: 200,
                            //     //       child: imagePath != null? Image.asset(imagePath!.path, fit: BoxFit.fill,) : Container(color: Colors.blue,),
                            //     //     ),
                            //     //     Column(
                            //     //       // crossAxisAlignment: CrossAxisAlignment.center,
                            //     //       children: [
                            //     //         cardListTile('Event: ', events.eventName),
                            //     //         cardListTile('Organized By: ', events.organizationName),
                            //     //         cardListTile('Description: ', events.description),
                            //     //       ],
                            //     //     ),
                            //     //   ],
                            //     // ),
                            //   ),
                            // ),
                          );

                  })
                  : const Center(child: Text('No Tours Added Yet', style:  TextStyle(fontSize: 25),)),
            ),
            Obx(
              () => _authController.tourData.isNotEmpty
                  ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: _authController.eventData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final events = _authController.eventData[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => EventScreen(
                                maxSlots: events.maxSlots,
                                address: events.address,
                                eventName: events.eventName,
                                toDate: events.toDate,
                                fromDate: events.fromDate,
                                orgName: events.organizationName,
                                price: events.price,
                                desc: events.description,
                                imagePath: events.imagePath,
                                startTime: events.startTime,
                                endTime: events.endTime,
                                id: events.id,
                                type: events.type,
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.maxFinite,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(events.imagePath),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 2,
                                    ),
                                    child: Text(
                                      events.eventName,
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
                                      '${events.maxSlots}, ${events.address}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //     horizontal: 10,
                                  //     vertical: 2,
                                  //   ),
                                  //   child: Text(
                                  //     'Location: ${events.address}',
                                  //     style: const TextStyle(
                                  //       fontSize: 14,
                                  //       fontWeight: FontWeight.bold,
                                  //       color: Colors.white,
                                  //     ),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      events.description,
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
                      ),
                      // Card(
                      //   color: const Color.fromARGB(255, 7, 159, 159)
                      //       .withOpacity(0.8),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Padding(
                      //         padding: const EdgeInsets.only(
                      //           top: 15,
                      //           right: 5,
                      //           bottom: 15,
                      //           left: 15,
                      //         ),
                      //         child: Material(
                      //           elevation: 10,
                      //           child: Image.network(
                      //             events
                      //                 .imagePath, // Replace 'image.png' with your image asset path
                      //             width: 150,
                      //             height: 150,
                      //             fit: BoxFit.fill,
                      //           ),
                      //         ),
                      //       ),
                      //       Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         // mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           const SizedBox(
                      //             height: 10,
                      //           ),
                      //           SizedBox(
                      //             width: 150,
                      //             child: Text(
                      //               events.eventName,
                      //               maxLines: 2,
                      //               style: const TextStyle(
                      //                 fontSize: 28,
                      //                 fontWeight: FontWeight.bold,
                      //                 overflow: TextOverflow.ellipsis,
                      //                 color: Colors.white,
                      //               ),
                      //             ),
                      //           ),
                      //           const SizedBox(height: 8.0),
                      //           // SizedBox(
                      //           //   width: 150,
                      //           //   child: Text(
                      //           //     events.description,
                      //           //     maxLines: 2,
                      //           //     style: const TextStyle(
                      //           //       fontSize: 20,
                      //           //       fontWeight: FontWeight.w500,
                      //           //       overflow: TextOverflow.ellipsis,
                      //           //       color: Colors.white,
                      //           //     ),
                      //           //   ),
                      //           // ),
                      //           // const SizedBox(height: 8.0),
                      //           // cardListTile('', events.description),
                      //           SizedBox(
                      //             height: 80,
                      //             width: 150,
                      //             child: Text(
                      //               events.description,
                      //               maxLines: 2,
                      //               style: const TextStyle(
                      //                 fontSize: 18,
                      //                 overflow: TextOverflow.ellipsis,
                      //                 fontWeight: FontWeight.w300,
                      //                 color: Colors.white,
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //     // child: Row(
                      //     //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     //   children: [
                      //     //     Container(
                      //     //       height: 400,
                      //     //       width: 200,
                      //     //       child: imagePath != null? Image.asset(imagePath!.path, fit: BoxFit.fill,) : Container(color: Colors.blue,),
                      //     //     ),
                      //     //     Column(
                      //     //       // crossAxisAlignment: CrossAxisAlignment.center,
                      //     //       children: [
                      //     //         cardListTile('Event: ', events.eventName),
                      //     //         cardListTile('Organized By: ', events.organizationName),
                      //     //         cardListTile('Description: ', events.description),
                      //     //       ],
                      //     //     ),
                      //     //   ],
                      //     // ),
                      //   ),
                      // ),
                    );
                  })
                  : const Center(child: Text('No Events Added Yet', style:  TextStyle(fontSize: 25),)),
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
            firebaseAuth.currentUser == null
                ? Get.snackbar("title", "message")
                : openBottomSheet();
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
