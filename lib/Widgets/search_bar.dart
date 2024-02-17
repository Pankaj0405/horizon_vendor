import 'package:flutter/material.dart';

class EventSearchBar extends StatefulWidget {
  const EventSearchBar({super.key});

  @override
  State<EventSearchBar> createState() => _EventSearchBarState();
}

class _EventSearchBarState extends State<EventSearchBar> {
  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      isFullScreen: false,
      viewConstraints: const BoxConstraints(
        maxHeight: 200,
      ),
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
          hintText: "Tour or event name",
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
      suggestionsBuilder: (BuildContext context, SearchController controller) {
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
    );
  }
}