import 'package:cloud_firestore/cloud_firestore.dart';

class AddEvent {
  String id;
  String eventName;
  String organizationName;
  String address;
  String description;

  AddEvent(
      {required this.address,
        required this.description,
        required this.eventName,
        required this.organizationName,
        required this.id});

  Map<String, dynamic> toJson() => {
    "id": id,
    "Event Name": eventName,
    "Organization Name": organizationName,
    "Address": address,
    "Description": description,
  };

  static AddEvent fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return AddEvent(
        id: snapshot["id"],
        address: snapshot["Address"],
        description: snapshot["Description"],
        eventName: snapshot["Event Name"],
        organizationName: snapshot["Organization Name"]);
  }
}