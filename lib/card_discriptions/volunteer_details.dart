import 'package:flutter/material.dart';

class VolunteerScreen extends StatefulWidget {
  String imagePath;
  String eventName;
  String maxSlots;
  String role;
  String date;
  VolunteerScreen({required this.imagePath, required this.eventName, required this.role, required this.date, required this.maxSlots,super.key});

  @override
  State<VolunteerScreen> createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen> {

  var textStyle1= TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  var textStyle2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

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
                    opacity: 0.8,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0, left: 15),
                          child: IconButton(
                            style: const ButtonStyle(
                              backgroundColor:
                              MaterialStatePropertyAll(Colors.white),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Text(
                          widget.eventName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.all(8.0),
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text('Last Date:', style: textStyle1,),
                            Text(widget.date, style: textStyle2,),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text('Max-Users:', style: textStyle1,),
                            Text(widget.maxSlots, style: textStyle2,),
                          ],
                        ),
                      ),
                    ),
                    // ListTile(
                    //   leading: Text('From:', style: textStyle1,),
                    //   trailing: Text(widget.fromDate, style: textStyle2,),
                    // ),
                    // ListTile(
                    //   leading: Text('To:', style: textStyle1,),
                    //   trailing: Text(widget.toDate, style: textStyle2,),
                    // ),
                    // ListTile(
                    //   leading: Text('Max-Users:', style: textStyle1,),
                    //   trailing: Text(widget.maxSlots, style: textStyle2,),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text(
                    //     'From: ${widget.fromDate}',
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text(
                    //     'To: ${widget.toDate}',
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 8,
                    //   ),
                    //   child: Text('Max-Users: ${widget.maxSlots}', style: TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.w500,
                    //   ),),
                    // ),
                  ],
                ),
              ),
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
        // floatingActionButton: Container(
        //   width: 100,
        //   child: FloatingActionButton(
        //     onPressed: () {},
        //     // isExtended: true,
        //     child: Text(widget.price, style: TextStyle(
        //       fontSize: 20,
        //       fontWeight: FontWeight.bold,
        //     ),),
        //   ),
        // ),
      ),
    );
  }
}

