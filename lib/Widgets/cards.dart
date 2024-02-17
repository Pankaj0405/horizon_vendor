import 'package:flutter/material.dart';

Widget cardListTile(String title, String value) {
  return Padding(
    padding: const EdgeInsets.only(
      left: 20,
      right: 10,
      top: 10,
    ),
    child: Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(title,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w500),)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 18),)),
      ],
    ),
  );
}