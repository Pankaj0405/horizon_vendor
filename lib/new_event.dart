import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final _authController = Get.put(AuthController());
  final _eventNameController = TextEditingController();
  final _organizationController = TextEditingController();
  final _addressController = TextEditingController();
  final _descController = TextEditingController();

  void emptyFields() {
    _addressController.text = "";
    _descController.text = "";
    _organizationController.text = "";
    _eventNameController.text = "";
  }

  openBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        // enableDrag: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                textField('Event or Tour Name', _eventNameController),
                textField('Organization Name', _organizationController),
                textField('Address', _addressController),
                SizedBox(height: 10,),
                Align(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Event Description',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _authController.addEvent(_eventNameController.text, _organizationController.text, _addressController.text, _descController.text);
                      emptyFields();
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                      ),
                      child: const Text('ADD', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const MyApp()),
                ),
              );
            },
          ),
          title: const Text(
            "Tours and Events",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              // SizedBox(height: 40),

              EventSearchBar(), // search bar
              SizedBox(height: 50),

              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     "Set duration",
              //     style: TextStyle(
              //       fontSize: 20,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // Duration(),
              // SizedBox(height: 30),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     "When should the Event Start",
              //     style: TextStyle(
              //       fontSize: 20,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // EventTiming(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: const Icon(Icons.add, color: Colors.white,),
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