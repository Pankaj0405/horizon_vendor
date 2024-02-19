import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizon_vendor/Controllers/auth_controller.dart';
import 'package:horizon_vendor/Widgets/text_fields.dart';
import 'package:horizon_vendor/models/add_events.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  String eventDropDown = 'Events';
  String tourDropDown = 'Tours';
  String typeDropDown = 'Event';
  List<String> items1 = ['Event', 'Tour'];
  String selectedEventId = '';
  final _volunteerController = TextEditingController();
  final _roleController = TextEditingController();
  late final TabController _tabController;

  var textStyle = const TextStyle(
    overflow: TextOverflow.fade,
    color: Colors.black,
    fontSize: 15,
  );

  emptyFields() {
    _roleController.text = "";
    _volunteerController.text = "";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    populateEventsDropdown();
    populateToursDropdown();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void populateEventsDropdown() async {
    List<AddEvent> events = await _authController.getAllEvents();
    setState(() {
      items = events.map((event) => event.eventName).toList();
      print(items);
      eventDropDown = items[0]; // Set the default value
    });
  }

  void populateToursDropdown() async {
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
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: 30.h,
                horizontal: 20.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back)),
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
                  Text(
                    'Events and Tours',
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
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
                                selectedEventId = _authController.tourData
                                    .firstWhere(
                                        (tour) => tour.eventName == newValue)
                                    .id;
                                print(selectedEventId);
                              });
                            },
                          ),
                          // const EventDropdown(), // event dropdown
                        ),
                  SizedBox(height: 20.h),
                  textField('No. of Volunteers required: ',
                      _volunteerController, TextInputType.number),
                  SizedBox(height: 20.h),
                  Text(
                    'Role Description',
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
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
                  SizedBox(height: 10.h),
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
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20.h,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          _authController.addVolunteers(
                              eventDropDown,
                              _volunteerController.text,
                              _roleController.text,
                              typeDropDown);
                          emptyFields();
                          Get.back();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.w,
                          ),
                          child: Text(
                            'ADD',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    _authController.getVolunteers();
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
        body: TabBarView(
          controller: _tabController,
          children: [
            Obx(
              () => ListView.builder(
                  itemCount: _authController.volunteerData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final volunteers = _authController.volunteerData[index];
                    return volunteers.type == "Tour"
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: const Color.fromARGB(255, 7, 159, 159)
                                  .withOpacity(0.6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 10),
                                    child: Image.asset(
                                      "", // Replace 'image.png' with your image asset path
                                      width: 100,
                                      height: 200,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        volunteers.eventName,
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'Volunteers: ${volunteers.volNumber}',
                                        style: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      // cardListTile('', events.description),
                                      SizedBox(
                                        height: 80,
                                        width: 150,
                                        child: Text(
                                          volunteers.role,
                                          maxLines: 2,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : null;
                  }),
            ),
            Obx(
              () => ListView.builder(
                  itemCount: _authController.volunteerData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final volunteers = _authController.volunteerData[index];
                    return volunteers.type == "Event"
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: const Color.fromARGB(255, 7, 159, 159)
                                  .withOpacity(0.6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 10),
                                    child: Image.asset(
                                      "", // Replace 'image.png' with your image asset path
                                      width: 100,
                                      height: 200,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        volunteers.eventName,
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'Volunteers: ${volunteers.volNumber}',
                                        style: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      // cardListTile('', events.description),
                                      SizedBox(
                                        height: 80,
                                        width: 150,
                                        child: Text(
                                          volunteers.role,
                                          maxLines: 2,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white,
                                          ),
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
                          )
                        : null;
                  }),
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
