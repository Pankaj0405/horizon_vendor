import 'package:flutter/material.dart';
import 'package:ocean_vendors_app/main.dart';

class AddVolunteer extends StatefulWidget {
  const AddVolunteer({super.key});

  @override
  State<AddVolunteer> createState() => _AddVolunteerState();
}

class _AddVolunteerState extends State<AddVolunteer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        leading: BackButton(
          style: const ButtonStyle(
            iconSize: MaterialStatePropertyAll(30),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const MyApp();
                },
              ),
            );
          },
        ),
        title: const Text(
          "Volunteers",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Add Volunteers",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FloatingActionButton(
                backgroundColor: Colors.green,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                child: const Text(
                  'Add Volunteers',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: ((context) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: BackButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: const ButtonStyle(
                                      iconSize: MaterialStatePropertyAll(30)),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1)),
                                  child:
                                      const EventDropdown(), // event dropdown
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                ),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "No. of volunteers required:",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                    MyDropdown(),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    "Role description",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                            const SizedBox(height: 20),
                            const RoleDescription(),
                            // SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.deepPurple.shade300)),
                                  onPressed: () {},
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

//------------------Event drop down menu---------------------
class EventDropdown extends StatefulWidget {
  const EventDropdown({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EventDropdownState createState() => _EventDropdownState();
}

class _EventDropdownState extends State<EventDropdown> {
  String eventSelectedValue = ''; // Initialize with an empty string
  List<String> eventsOptions = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: eventSelectedValue.isNotEmpty
          ? eventSelectedValue
          : null, // Adjusted value to show hint
      onChanged: (String? newValue) {
        setState(() {
          eventSelectedValue = newValue ?? '';
        });
      },
      hint: const Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Text('Events and tours'),
      ), // Set the hint text
      items: eventsOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

//--------------------Tour drop down---------------

class ToursDropdown extends StatefulWidget {
  const ToursDropdown({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ToursDropdownState createState() => _ToursDropdownState();
}

class _ToursDropdownState extends State<ToursDropdown> {
  String tourSelectedValue = ''; // Initialize with an empty string
  List<String> toursOptions = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: tourSelectedValue.isNotEmpty
          ? tourSelectedValue
          : null, // Adjusted value to show hint
      onChanged: (String? newValue) {
        setState(() {
          tourSelectedValue = newValue ?? '';
        });
      },
      hint: const Text('Tours'), // Set the hint text
      items: toursOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class MyDropdown extends StatefulWidget {
  const MyDropdown({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  int? selectedValue;
  List<int> options = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: selectedValue,
      onChanged: (int? newValue) {
        setState(() {
          selectedValue = newValue;
        });
      },
      hint: const Text('        '), // Set the hint text
      items: options.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }
}

//--------------------------Role description-------------------------

class RoleDescription extends StatefulWidget {
  const RoleDescription({super.key});

  @override
  State<RoleDescription> createState() => _RoleDescriptionState();
}

class _RoleDescriptionState extends State<RoleDescription> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1),
        ),
        child: const TextField(
          maxLines: 4,
        ),
      ),
    );
  }
}
