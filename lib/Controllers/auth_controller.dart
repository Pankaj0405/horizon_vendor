import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';
import '../models/add_events.dart' as add_event_model;
import '../models/addVolunteers.dart' as add_volunteers;

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final Rx<List<add_event_model.AddEvent>> _eventData =
      Rx<List<add_event_model.AddEvent>>([]);
  List<add_event_model.AddEvent> get eventData => _eventData.value;
  final Rx<List<add_volunteers.AddVolunteers>> _volunteerData = Rx<List<add_volunteers.AddVolunteers>>([]);
  List<add_volunteers.AddVolunteers> get volunteerData => _volunteerData.value;

  void addEvent(String eventName, String orgName, String address, String desc,
      String maxSlots, String price, String imagePath) async {
    try {
      String eventId = const Uuid().v1();
      if (eventName.isNotEmpty &&
          orgName.isNotEmpty &&
          address.isNotEmpty &&
          desc.isNotEmpty &&
          maxSlots.isNotEmpty &&
          price.isNotEmpty &&
          imagePath.isNotEmpty) {
        add_event_model.AddEvent newEvent = add_event_model.AddEvent(
            address: address,
            description: desc,
            eventName: eventName,
            organizationName: orgName,
            id: eventId,
            maxSlots: maxSlots,
            price: price,
            imagePath: imagePath);
        await firestore
            .collection('events')
            .doc(eventId)
            .set(newEvent.toJson())
            .then(
                (value) => Get.snackbar('Alert', 'Event created successfully'));
      } else {
        Get.back();
        Get.snackbar('Alert', 'Please enter all fields');
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Error creating event', e.toString());
      print(e.toString());
    }
  }

  Future<List<add_event_model.AddEvent>> getAllEvents() async {
    QuerySnapshot querySnapshot = await firestore.collection('events').get();

    List<add_event_model.AddEvent> events = querySnapshot.docs
        .map((documentSnapshot) =>
            add_event_model.AddEvent.fromSnap(documentSnapshot))
        .toList();
    print('Fetched events: $events');
    return events;
  }

  void getEvent() async {
    _eventData.bindStream(
        firestore.collection('events').snapshots().map((QuerySnapshot query) {
      List<add_event_model.AddEvent> retValue = [];
      for (var element in query.docs) {
        retValue.add(add_event_model.AddEvent.fromSnap(element));
      }
      return retValue;
    }));
  }

  void addVolunteers(String eventName, String number, String role) async {
    try {
      String volunteerId = const Uuid().v1();
      if (eventName.isNotEmpty && number.isNotEmpty && role.isNotEmpty) {
        add_volunteers.AddVolunteers volunteers = add_volunteers.AddVolunteers(
            id: volunteerId,
            role: role,
            eventName: eventName,
            volNumber: number);
        await firestore
            .collection('volunteers')
            .doc(volunteerId)
            .set(volunteers.toJson())
            .then((value) => Get.snackbar(
                'Alert', ' Volunteers requirement added successfully'));
      }
    } catch (e) {
      Get.snackbar('Error adding volunteers requirements!', e.toString());
    }
  }

  void getVolunteers() async {
    _volunteerData.bindStream(firestore.collection('volunteers').snapshots().map((QuerySnapshot query) {
      List<add_volunteers.AddVolunteers> retValue = [];
      for(var element in query.docs) {
        retValue.add(add_volunteers.AddVolunteers.fromSnap(element));
      }
      return retValue;
    }
    ));
  }
}