import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizon_vendor/Controllers/auth_controller.dart';
import 'package:horizon_vendor/card_discriptions/event_description.dart';
import 'package:horizon_vendor/card_discriptions/tour_card_description.dart';
import 'package:horizon_vendor/card_discriptions/volunteer_description.dart';
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
  List upcomingEventsCards = [
    // color will be replaced by images
    ["Denice", "An enthusiast about octopus", true, "assets/images/tour2.jpg"],
    [
      "Alice",
      "Lives to follow the hatchlings",
      false,
      "assets/images/event1.jpg"
    ],
    [
      "Maya",
      "comes outside to escape the city",
      true,
      "assets/images/tour2.jpg"
    ],
    ["Jack", "explorer of the corals", false, "assets/images/event2.jpeg"],
    ["Jimmy", "Loves the beach vibes", true, "assets/images/tour3.jpeg"],
  ];

  @override
  Widget build(BuildContext context) {
    _authController.getEvent();
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
        CarouselSlider(
          items: upcomingEventsCards
              .map(
                (item) => InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VolunteerCardDescription(
                          volunteerName: item[0],
                          volunteerDescription: item[1],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 400,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(item[3]),
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
                              item[0],
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
                              item[1],
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
              height: 170),
        ),
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
  List upcomingEventsCards = [
    // color will be replaced by images
    [
      "The Fire Night",
      "enjoy a night in the city but differently",
      true,
      "assets/images/event1.jpg"
    ],
    [
      "Beach wedding",
      "A wedding wave is going to strike the beach",
      false,
      "assets/images/event2.jpeg"
    ],
    [
      "The beach get together",
      "meet new people and discuss about, well it's up to you",
      true,
      "assets/images/event3.jpeg"
    ],
    [
      "Hatchling festival",
      "see the turtles emerging from the earth",
      false,
      "assets/images/event4.jpeg"
    ],
    [
      "Beach sand party",
      "it's can't be rock because it's a beach with sand",
      true,
      "assets/images/event5.jpg"
    ],
  ];

  @override
  Widget build(BuildContext context) {
    _authController.getEvent();
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
        CarouselSlider(
          items: upcomingEventsCards
              .map(
                (item) => InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventCardDescription(
                          eventName: item[0],
                          eventDescription: item[1],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 400,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(item[3]),
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
                              item[0],
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
                              item[1],
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
              height: 170),
        ),
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
  List upcomingEventsCards = [
    // color will be replaced by images
    [
      "The silent sea",
      "Perfect for embrassing the nature",
      true,
      "assets/images/tour1.jpeg"
    ],
    [
      "The swim beach",
      "If you like swimming in ocean and watch the aquatics, this is the place",
      false,
      "assets/images/tour2.jpg"
    ],
    [
      "Galgibaga",
      "Perfect for watching the new journey of hatchligs",
      true,
      "assets/images/tour3.jpeg"
    ],
    [
      "The blue lagoon",
      "If you want to see the real untouchd beauty of nature",
      false,
      "assets/images/tour4.jpg"
    ],
    [
      "Scubasauras",
      "The jurrasic for scuba divers",
      true,
      "assets/images/tour5.jpg"
    ],
  ];

  @override
  Widget build(BuildContext context) {
    _authController.getEvent();
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
        CarouselSlider(
          items: upcomingEventsCards
              .map(
                (item) => InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TourCardDescription(
                          tourName: item[0],
                          tourDescription: item[1],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 400,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/images/beach.jpg"),
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
                              item[0],
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
                              item[1],
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
              height: 170),
        ),
      ],
    );
  }
}

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List categoryList = [
    ["Boat Tours", const Icon(Icons.local_pizza)],
    ["Boat Tours", const Icon(Icons.list)],
    ["Boat Tours", const Icon(Icons.food_bank)],
    ["Boat Tours", const Icon(Icons.waves_outlined)],
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Categories",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(categoryList.length, (index) {
                  return CategoryTile(
                    categoryTitle: categoryList[index][0],
                    categoryIcon: categoryList[index][1],
                  );
                }),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoryPage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.keyboard_arrow_right,
                  size: 35,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryTile extends StatefulWidget {
  const CategoryTile({
    super.key,
    required this.categoryTitle,
    required this.categoryIcon,
  });

  final String categoryTitle;
  final Icon categoryIcon;

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey.shade300,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {},
                icon: widget.categoryIcon,
              ),
            ),
          ),
          Text(
            widget.categoryTitle,
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
