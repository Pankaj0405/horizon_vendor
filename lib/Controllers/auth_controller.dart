import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';
import '../models/add_events.dart' as add_event_model;

class AuthController extends GetxController {
  static AuthController instance = Get.find();


  void addEvent(String eventName, String orgName, String address, String desc) async {
    try {
      String eventId = const Uuid().v1();
      if(eventName.isNotEmpty && orgName.isNotEmpty && address.isNotEmpty && desc.isNotEmpty) {
        add_event_model.AddEvent newEvent = add_event_model.AddEvent(address: address, description: desc, eventName: eventName, organizationName: orgName, id: eventId);
        await firestore.collection('events').doc(eventId).set(newEvent.toJson()).then((value) => Get.snackbar('Alert', 'Event created successfully'));
      } else {
        Get.snackbar('Alert', 'Please enter all fields');
      }
    } catch (e) {
      Get.snackbar('Error creating event', e.toString());
      print(e.toString());
    }
  }
}