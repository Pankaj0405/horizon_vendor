import 'package:flutter/material.dart';

Widget textField(String label, TextEditingController controller, TextInputType keyboardType) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          // enabled: false,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[300],
          ),
        ),
      ],
    ),
  );
}