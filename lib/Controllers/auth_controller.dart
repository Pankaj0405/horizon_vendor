// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';
import '../models/add_events.dart' as add_event_model;
import '../models/addVolunteers.dart' as add_volunteers;

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final Rx<List<add_event_model.AddEvent>> _eventData =
      Rx<List<add_event_model.AddEvent>>([]);
  List<add_event_model.AddEvent> get eventData => _eventData.value;
  final Rx<List<add_volunteers.AddVolunteers>> _volunteerData =
      Rx<List<add_volunteers.AddVolunteers>>([]);
  final Rx<List<add_volunteers.AddVolunteers>> _volunteerEventData =
      Rx<List<add_volunteers.AddVolunteers>>([]);
  List<add_volunteers.AddVolunteers> get volunteerEventData =>
      _volunteerEventData.value;
  final Rx<List<add_volunteers.AddVolunteers>> _volunteerTourData =
      Rx<List<add_volunteers.AddVolunteers>>([]);
  List<add_volunteers.AddVolunteers> get volunteerTourData =>
      _volunteerTourData.value;
  final Rx<List<add_event_model.AddEvent>> _tourData =
      Rx<List<add_event_model.AddEvent>>([]);
  List<add_event_model.AddEvent> get tourData => _tourData.value;
  List<add_volunteers.AddVolunteers> get volunteerData => _volunteerData.value;

  void addEvent(
      String eventName,
      String orgName,
      String address,
      String desc,
      String maxSlots,
      String price,
      String imagePath,
      String type,
      String fromDate,
      String toDate,
      String startTime,
      String endTime,
      String vendorId) async {
    try {
      // String id = const Uuid().v1();
      String eventId = const Uuid().v1();
      if (eventName.isNotEmpty &&
          orgName.isNotEmpty &&
          address.isNotEmpty &&
          desc.isNotEmpty &&
          maxSlots.isNotEmpty &&
          price.isNotEmpty &&
          imagePath.isNotEmpty &&
          type != 'Select' &&
          fromDate.isNotEmpty &&
          toDate.isNotEmpty &&
          startTime.isNotEmpty &&
          endTime.isNotEmpty &&
          vendorId.isNotEmpty) {
        add_event_model.AddEvent newEvent = add_event_model.AddEvent(
            address: address,
            description: desc,
            eventName: eventName,
            organizationName: orgName,
            id: eventId,
            maxSlots: maxSlots,
            price: price,
            imagePath: imagePath,
            type: type,
            fromDate: fromDate,
            toDate: toDate,
            startTime: startTime,
            endTime: endTime,
            vendorId: vendorId);
        if (type == "Event") {
          await firestore
              .collection('events')
              .doc(eventId)
              .set(newEvent.toJson())
              .then((value) =>
                  Get.snackbar('Alert', 'Event created successfully'));
        } else {
          await firestore
              .collection('tours')
              .doc(eventId)
              .set(newEvent.toJson())
              .then((value) =>
                  Get.snackbar('Alert', 'Tour created successfully'));
        }
      } else {
        Get.back();
        Get.snackbar('Alert', 'Please enter all fields');
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Error creating event or tour', e.toString());
      print(e.toString());
    }
  }

  Future<void> updateEvent(
      String eventId,
      String eventName,
      String orgName,
      String address,
      String maxSlots,
      String price,
      String desc,
      String fromDate,
      String toDate,
      String startTime,
      String endTime,
      String imagePath) async {
    try {
      if (eventName.isNotEmpty &&
          orgName.isNotEmpty &&
          address.isNotEmpty &&
          maxSlots.isNotEmpty &&
          price.isNotEmpty &&
          desc.isNotEmpty &&
          fromDate.isNotEmpty &&
          toDate.isNotEmpty &&
          startTime.isNotEmpty &&
          endTime.isNotEmpty &&
          imagePath.isNotEmpty) {
        await firestore.collection('events').doc(eventId).update({
          "Event Name": eventName,
          "Organization Name": orgName,
          "Address": address,
          "Description": desc,
          "Max Slots": maxSlots,
          "Booking price": price,
          "Image Path": imagePath,
          "From": fromDate,
          "To": toDate,
          "Start Time": startTime,
          "End Time": endTime
        });
        Get.snackbar('Alert Message', 'Event updated successfully');
      }
    } catch (e) {
      Get.snackbar('Error updating event', e.toString());
      print(e.toString());
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await firestore.collection('events').doc(eventId).delete();
      Get.snackbar('Alert', 'Event deleted successfully');
    } catch (e) {
      Get.snackbar('Error deleting Event', e.toString());
      print(e.toString());
    }
  }

  Future<void> updateTour(
      String tourId,
      String tourName,
      String orgName,
      String address,
      String maxSlots,
      String price,
      String desc,
      String fromDate,
      String toDate,
      String startTime,
      String endTime,
      String imagePath) async {
    try {
      if (tourName.isNotEmpty &&
          orgName.isNotEmpty &&
          address.isNotEmpty &&
          maxSlots.isNotEmpty &&
          price.isNotEmpty &&
          desc.isNotEmpty &&
          fromDate.isNotEmpty &&
          toDate.isNotEmpty &&
          startTime.isNotEmpty &&
          endTime.isNotEmpty &&
          imagePath.isNotEmpty) {
        await firestore.collection('events').doc(tourId).update({
          "Event Name": tourName,
          "Organization Name": orgName,
          "Address": address,
          "Description": desc,
          "Max Slots": maxSlots,
          "Booking price": price,
          "Image Path": imagePath,
          "From": fromDate,
          "To": toDate,
          "Start Time": startTime,
          "End Time": endTime
        });
        Get.snackbar('Alert', 'Tour updated successfully');
      }
    } catch (e) {
      Get.snackbar('Error updating tour', e.toString());
      print(e.toString());
    }
  }

  Future<void> deleteTour(String tourId) async {
    try {
      await firestore.collection('tours').doc(tourId).delete();
      Get.snackbar('Alert', 'Tour deleted successfully');
    } catch (e) {
      Get.snackbar('Error deleting Tour', e.toString());
      print(e.toString());
    }
  }

  Future<void> updateVolunteer(
      String volunteerId,
      String address,
      String maxSlots,
      String desc,
      String fromDate,
      String toDate,
      String startTime,
      String endTime,
      String imagePath) async {
    try {
      if (address.isNotEmpty &&
          maxSlots.isNotEmpty &&
          desc.isNotEmpty &&
          fromDate.isNotEmpty &&
          toDate.isNotEmpty &&
          startTime.isNotEmpty &&
          endTime.isNotEmpty &&
          imagePath.isNotEmpty) {
        await firestore.collection('volunteers').doc(volunteerId).update({
          "Address": address,
          "role": desc,
          "No of Volunteers": maxSlots,
          "Image Path": imagePath,
          "From Date": fromDate,
          "To Date": toDate,
          "Start Time": startTime,
          "End Time": endTime
        });
        Get.snackbar('Alert', 'Volunteer details updated successfully');
      }
    } catch (e) {
      Get.snackbar("Error updating volunteer's details", e.toString());
      print(e.toString());
    }
  }

  Future<void> deleteVolunteer(String volunteerId) async {
    try {
      await firestore.collection('events').doc(volunteerId).delete();
      Get.snackbar('Alert', 'Volunteer deleted successfully');
    } catch (e) {
      Get.snackbar('Error deleting Volunteer', e.toString());
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

  Future<List<add_event_model.AddEvent>> getAllTours() async {
    // DateTime now = DateTime.now();
    // String currentDate = DateFormat('yyyy-MM-dd').format(now);
    QuerySnapshot querySnapshot = await firestore.collection('tours').get();

    List<add_event_model.AddEvent> tours = querySnapshot.docs
        .map((documentSnapshot) =>
            add_event_model.AddEvent.fromSnap(documentSnapshot))
        .toList();
    print('Fetched events: $tours');
    return tours;
  }

  void getEvent() async {
    _eventData.bindStream(firestore
        .collection('events')
        .where('vendorId', isEqualTo: firebaseAuth.currentUser!.uid)
        .orderBy('From', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<add_event_model.AddEvent> retValue = [];
      for (var element in query.docs) {
        retValue.add(add_event_model.AddEvent.fromSnap(element));
      }
      return retValue;
    }));
  }

  void getTour() async {
    _tourData.bindStream(firestore
        .collection('tours')
        .where('vendorId', isEqualTo: firebaseAuth.currentUser!.uid)
        .orderBy('From', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<add_event_model.AddEvent> retValue = [];
      for (var element in query.docs) {
        retValue.add(add_event_model.AddEvent.fromSnap(element));
      }
      return retValue;
    }));
  }

  void addVolunteers(
      String eventName,
      String number,
      String role,
      String type,
      String eventId,
      String imagePath,
      String fromDate,
      String toDate,
      String startTime,
      String endTime,
      String address,
      String vendorId) async {
    try {
      String volunteerId = const Uuid().v1();
      if (eventName.isNotEmpty &&
          eventId.isNotEmpty &&
          number.isNotEmpty &&
          role.isNotEmpty &&
          imagePath.isNotEmpty &&
          fromDate.isNotEmpty &&
          toDate.isNotEmpty &&
          startTime.isNotEmpty &&
          endTime.isNotEmpty &&
          startTime.isNotEmpty &&
          vendorId.isNotEmpty) {
        add_volunteers.AddVolunteers volunteers = add_volunteers.AddVolunteers(
            id: volunteerId,
            role: role,
            eventName: eventName,
            volNumber: number,
            type: type,
            eventId: eventId,
            imagePath: imagePath,
            fromDate: fromDate,
            toDate: toDate,
            startTime: startTime,
            endTime: endTime,
            address: address,
            vendorId: vendorId);
        await firestore
            .collection('volunteers')
            .doc(volunteerId)
            .set(volunteers.toJson())
            .then((value) => Get.snackbar(
                'Success', ' Volunteers requirement added successfully'));
        print('success');
      }
    } catch (e) {
      print('add volunteer erro ${e.toString()}');
      Get.snackbar('Error adding volunteers requirements!', e.toString());
    }
  }

  Future<void> getVolunteers() async {
    _volunteerData.bindStream(firestore
        .collection('volunteers')
        .where('VendorId', isEqualTo: firebaseAuth.currentUser!.uid)
        .orderBy('From Date')
        .snapshots()
        .map((QuerySnapshot query) {
      List<add_volunteers.AddVolunteers> retValue = [];
      for (var element in query.docs) {
        retValue.add(add_volunteers.AddVolunteers.fromSnap(element));
      }
      return retValue;
    }));
  }

  Future<void> getEventVolunteers() async {
    _volunteerEventData.bindStream(
      firestore
          .collection('volunteers')
          .where('VendorId', isEqualTo: firebaseAuth.currentUser!.uid)
          .where('type', isEqualTo: 'Event')
          .orderBy('From Date', descending: false)
          .snapshots()
          .map((QuerySnapshot query) {
        List<add_volunteers.AddVolunteers> retValue = [];
        for (var element in query.docs) {
          retValue.add(add_volunteers.AddVolunteers.fromSnap(element));
        }
        return retValue;
      }),
    );
  }


  Future<void> getTourVolunteers() async {
    _volunteerTourData.bindStream(firestore
        .collection('volunteers')
        .where('VendorId', isEqualTo: firebaseAuth.currentUser!.uid)
        .where('type', isEqualTo: 'Tour')
        .orderBy('From Date', descending: false)
        .snapshots()
        .map((QuerySnapshot query) {
      List<add_volunteers.AddVolunteers> retValue = [];
      for (var element in query.docs) {
        retValue.add(add_volunteers.AddVolunteers.fromSnap(element));
      }
      return retValue;
    }));
  }
}
