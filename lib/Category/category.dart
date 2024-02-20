import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List categoryList = [
    ["Category name", const Icon(Icons.circle_notifications_outlined)],
    ["Category name", const Icon(Icons.circle_notifications_outlined)],
    ["Category name", const Icon(Icons.circle_notifications_outlined)],
    ["Category name", const Icon(Icons.circle_notifications_outlined)],
    ["Category name", const Icon(Icons.circle_notifications_outlined)],
    ["Category name", const Icon(Icons.circle_notifications_outlined)],
    ["Category name", const Icon(Icons.circle_notifications_outlined)],
    ["Category name", const Icon(Icons.circle_notifications_outlined)],
    ["Category name", const Icon(Icons.circle_notifications_outlined)],
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 30, right: 30),
            child: Column(
              children: [
                SearchAnchor(
                  builder: (BuildContext context, SearchController controller) {
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
                      hintText: "Search for event",
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
                const SizedBox(height: 25),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 650,
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(categoryList.length, (index) {
                        return CategoryCard(
                          categoryIcon: categoryList[index][1],
                          categoryName: categoryList[index][0],
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatefulWidget {
  const CategoryCard({
    super.key,
    required this.categoryIcon,
    required this.categoryName,
  });

  final Icon categoryIcon;
  final String categoryName;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 1.0),
        child: Material(
          elevation: 20,
          shadowColor: Colors.black,
          borderOnForeground: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.grey.shade100),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: IconButton(
                      onPressed: () {},
                      icon: widget.categoryIcon,
                      iconSize: 50,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    widget.categoryName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.keyboard_arrow_right_rounded,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}