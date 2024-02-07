import 'package:flutter/material.dart';
import './Category/category.dart';

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
            UpcomingEvents(),
            SizedBox(height: 35),
            Categories(),
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
              color: const Color.fromARGB(
                255,
                152,
                249,
                157,
              ),
              child: const Center(
                child: Text(
                  "Manage Sea Events",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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

//----------- upcoming events------------------------

class UpcomingEvents extends StatefulWidget {
  const UpcomingEvents({super.key});

  @override
  State<UpcomingEvents> createState() => _UpcomingEventsState();
}

class _UpcomingEventsState extends State<UpcomingEvents> {
  List upcomingEventsCards = [
    // color will be replaced by images
    ["Title", "description", true, Colors.red.shade300],
    ["inputText1", "inputText2", false, Colors.red.shade300],
    ["inputText1", "inputText2", true, Colors.red.shade300],
    ["inputText1", "inputText2", false, Colors.red.shade300],
    ["inputText1", "inputText2", true, Colors.red.shade300],
  ];

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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
              children: List.generate(
                upcomingEventsCards.length,
                    (index) => EventCard(
                  inputText1: upcomingEventsCards[index][0],
                  inputText2: upcomingEventsCards[index][1],
                  like: upcomingEventsCards[index][2],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class EventCard extends StatefulWidget {
  EventCard({
    Key? key,
    required this.inputText1,
    required this.inputText2,
    required this.like,
  }) : super(key: key);

  String inputText1;
  String inputText2;
  bool like;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 190,
        width: 220,
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              InkWell(
                onDoubleTap: () {
                  if (widget.like == false) {
                    setState(() {
                      widget.like = true;
                    });
                  } else {
                    setState(() {
                      widget.like = false;
                    });
                  }
                },
                child: Container(
                  height: 120,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.green,
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          if (widget.like == false) {
                            setState(() {
                              widget.like = true;
                            });
                          } else {
                            setState(() {
                              widget.like = false;
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: InkWell(
                              onTap: () {
                                if (widget.like == false) {
                                  setState(() {
                                    widget.like = true;
                                  });
                                } else {
                                  setState(() {
                                    widget.like = false;
                                  });
                                }
                              },
                              child: Icon(Icons.favorite,
                                  color:
                                  widget.like ? Colors.red : Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.inputText1,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.inputText2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//-------------------Categories------------------

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
    Key? key,
    required this.categoryTitle,
    required this.categoryIcon,
  }) : super(key: key);

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
