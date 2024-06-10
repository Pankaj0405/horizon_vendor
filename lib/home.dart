import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizon_vendor/Controllers/auth_controller.dart';
import 'package:horizon_vendor/add_volunteers.dart';
import 'package:horizon_vendor/card_discriptions/event_description.dart';
import 'package:horizon_vendor/card_discriptions/tour_card_description.dart';
import 'package:horizon_vendor/card_discriptions/volunteer_description.dart';
import 'package:horizon_vendor/new_event.dart';
import './Category/category.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // ignore: unnecessary_const
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopPart(),
            SizedBox(height: 35),
            TodaysVolunteer(),
            SizedBox(height: 35),
            UpcomingEvents(),
            SizedBox(height: 35),
            UpcomingTours(),
            SizedBox(height: 20),
            // Categories(),
          ],
        ),
      ),
    );
  }
}

// --------------------------upper part-------------------

class TopPart extends StatefulWidget {
  const TopPart({super.key});

  @override
  State<TopPart> createState() => _TopPartState();
}

class _TopPartState extends State<TopPart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 285,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 250,
              width: double.maxFinite,
              color: const Color(0xFF7A98E5),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/beach.jpg',
                    width: double.maxFinite,
                    // height: 200,
                    fit: BoxFit.fitWidth,
                  ),
                  const Center(
                    child: Text(
                      "Manage Sea Events",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Positioned(
                  //   bottom: 16.0,
                  //   left: 16.0,
                  //   child: Text(
                  //     'Manage Sea Events',
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 20.0,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                  ),
                  child: SearchAnchor(
                    builder:
                        (BuildContext context, SearchController controller) {
                      return SearchBar(
                        controller: controller,
                        padding: const MaterialStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 16.0)),
                        onTap: () {
                          controller.openView();
                        },
                        onChanged: (_) {
                          controller.openView();
                        },
                        leading: const Icon(Icons.search),
                        hintText: "Enter location or event name",
                        shape: const MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              side: BorderSide(width: 1)),
                        ),
                        elevation: const MaterialStatePropertyAll(0),
                      );
                    },
                    suggestionsBuilder:
                        (BuildContext context, SearchController controller) {
                      return List<ListTile>.generate(
                        5,
                        (int index) {
                          final String item = 'item $index';
                          return ListTile(
                            title: Text(item),
                            onTap: () {
                              setState(
                                () {
                                  controller.closeView(item);
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                    viewElevation: 0,
                  ),
                ),
                // Add your search results or other content here based on _searchText
                // For example, you can use a ListView.builder to display a list of items.
                // ListView.builder(
                //   itemCount: filteredItems.length,
                //   itemBuilder: (context, index) {
                //     return ListTile(
                //       title: Text(filteredItems[index]),
                //     );
                //   },
                // ),
                // Replace the above commented code with your own content based on the search results.
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//----------- today's volunteer------------------------

class TodaysVolunteer extends StatefulWidget {
  const TodaysVolunteer({super.key});

  @override
  State<TodaysVolunteer> createState() => _TodaysVolunteerState();
}

class _TodaysVolunteerState extends State<TodaysVolunteer> {
  final _authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _authController.getEvent();
    _authController.getVolunteers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 22.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Today's Volunteers",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Obx(() {
          if (_authController.volunteerData.isEmpty) {
            return const Center(
              child: Text('No Volunteers Available'),
            );
          }
          return CarouselSlider(
            items: _authController.volunteerData
                .map(
                  (volunteer) => InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => VolunteerCardDescription(
                  //       volunteerName: volunteer.name, // Assuming `name` is a field in the volunteer model
                  //       volunteerDescription: volunteer.description, // Assuming `description` is a field in the volunteer model
                  //     ),
                  //   ),
                  // );
                  Get.to(() => const AddVolunteer());
                },
                child: Container(
                  width: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(volunteer.imagePath), // Assuming `imagePath` is a field in the volunteer model
                      fit: BoxFit.fill,
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
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            volunteer.eventName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 10,
                          ),
                          child: Text(
                            'SLots: ${volunteer.volNumber}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            volunteer.role,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
                .toList(),
            options: CarouselOptions(
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              autoPlay: true,
              enableInfiniteScroll: true,
              viewportFraction: 0.8,
              animateToClosest: true,
              height: 170,
            ),
          );
        }),
      ],
    );
  }
}

//----------- upcoming events------------------------

class UpcomingEvents extends StatefulWidget {
  const UpcomingEvents({super.key});

  @override
  State<UpcomingEvents> createState() => _UpcomingEventsState();
}

class _UpcomingEventsState extends State<UpcomingEvents> {
  final _authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _authController.getEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 22.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Upcoming events",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Obx(() {
          if (_authController.eventData.isEmpty) {
            return const Center(
              child: Text('No Upcoming Events Available'),
            );
          }
          return CarouselSlider(
            items: _authController.eventData
                .map(
                  (event) => InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => EventCardDescription(
                  //       eventName: event.eventName, // Assuming `name` is a field in the event model
                  //       eventDescription: event.description, // Assuming `description` is a field in the event model
                  //     ),
                  //   ),
                  // );
                  Get.to(() => const AddNewEvent());
                },
                child: Container(
                  width: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(event.imagePath), // Assuming `imagePath` is a field in the event model
                      fit: BoxFit.fill,
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
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            event.eventName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            event.description,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
                .toList(),
            options: CarouselOptions(
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              autoPlay: false,
              enableInfiniteScroll: true,
              viewportFraction: 0.8,
              animateToClosest: true,
              height: 170,
            ),
          );
        }),
      ],
    );
  }
}


// ignore: must_be_immutable
// class EventCard extends StatefulWidget {
//   EventCard({
//     super.key,
//     required this.inputText1,
//     required this.inputText2,
//   });

//   String inputText1;
//   String inputText2;

//   @override
//   State<EventCard> createState() => _EventCardState();
// }

// class _EventCardState extends State<EventCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Container(
//         width: 220,
//         decoration: BoxDecoration(
//             color: Colors.grey.shade300,
//             borderRadius: BorderRadius.circular(6)),
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Column(
//             children: [
//               Container(
//                 height: 120,
//                 width: double.maxFinite,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(6),
//                   color: Colors.green,
//                 ),
//                 // child: Align(
//                 //   alignment: Alignment.topRight,
//                 //   child: Padding(
//                 //     padding: const EdgeInsets.all(8.0),
//                 //     child: Container(
//                 //       decoration: BoxDecoration(
//                 //         color: Colors.white.withOpacity(0.8),
//                 //         borderRadius: BorderRadius.circular(6),
//                 //       ),
//                 //       child: Padding(
//                 //         padding: const EdgeInsets.all(5),
//                 //         child: Icon(Icons.favorite,
//                 //             color:
//                 //             widget.like ? Colors.red : Colors.black),
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//               ),
//               const SizedBox(
//                 height: 7,
//               ),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   widget.inputText1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                       fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   widget.inputText2,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.w500),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//-------------------Categories------------------

//----------- upcoming tours------------------------

class UpcomingTours extends StatefulWidget {
  const UpcomingTours({super.key});

  @override
  State<UpcomingTours> createState() => _UpcomingToursState();
}

class _UpcomingToursState extends State<UpcomingTours> {
  final _authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _authController.getTour();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 22.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Upcoming Tours",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Obx(() {
          if (_authController.tourData.isEmpty) {
            return const Center(
              child: Text('No Upcoming Tours Available'),
            );
          }
          return CarouselSlider(
            items: _authController.tourData
                .map(
                  (tour) => InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => TourCardDescription(
                  //       tourName: tour.eventName, // Assuming `name` is a field in the event model
                  //       tourDescription: tour.description, // Assuming `description` is a field in the event model
                  //     ),
                  //   ),
                  // );
                },
                child: Container(
                  width: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(tour.imagePath), // Assuming `imagePath` is a field in the event model
                      fit: BoxFit.fill,
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
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            tour.eventName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            tour.description,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
                .toList(),
            options: CarouselOptions(
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              autoPlay: false,
              enableInfiniteScroll: true,
              viewportFraction: 0.8,
              animateToClosest: true,
              height: 170,
            ),
          );
        }),
      ],
    );
  }
}

// class Categories extends StatefulWidget {
//   const Categories({super.key});
//
//   @override
//   State<Categories> createState() => _CategoriesState();
// }
//
// class _CategoriesState extends State<Categories> {
//   List categoryList = [
//     ["Boat Tours", const Icon(Icons.local_pizza)],
//     ["Boat Tours", const Icon(Icons.list)],
//     ["Boat Tours", const Icon(Icons.food_bank)],
//     ["Boat Tours", const Icon(Icons.waves_outlined)],
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20),
//       child: Column(
//         children: [
//           const Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               "Categories",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: List.generate(categoryList.length, (index) {
//                   return CategoryTile(
//                     categoryTitle: categoryList[index][0],
//                     categoryIcon: categoryList[index][1],
//                   );
//                 }),
//               ),
//               IconButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const CategoryPage(),
//                     ),
//                   );
//                 },
//                 icon: const Icon(
//                   Icons.keyboard_arrow_right,
//                   size: 35,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class CategoryTile extends StatefulWidget {
//   const CategoryTile({
//     super.key,
//     required this.categoryTitle,
//     required this.categoryIcon,
//   });
//
//   final String categoryTitle;
//   final Icon categoryIcon;
//
//   @override
//   State<CategoryTile> createState() => _CategoryTileState();
// }
//
// class _CategoryTileState extends State<CategoryTile> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(6),
//               color: Colors.grey.shade300,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: IconButton(
//                 onPressed: () {},
//                 icon: widget.categoryIcon,
//               ),
//             ),
//           ),
//           Text(
//             widget.categoryTitle,
//             style: const TextStyle(
//               fontSize: 11,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
