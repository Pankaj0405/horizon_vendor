import 'package:cloud_firestore/cloud_firestore.dart';

class AddVolunteers {
  String id;
  String eventName;
  String volNumber;
  String role;
  String type;
  String eventId;
  String imagePath;
  String fromDate;
  String toDate;
  String startTime;
  String endTime;
  String address;
  String vendorId;

  AddVolunteers(
      {required this.id,
      required this.role,
      required this.eventName,
      required this.volNumber,
      required this.type,
      required this.eventId,
      required this.imagePath,
      required this.fromDate,
        required this.toDate,
      required this.endTime,
      required this.startTime,
      required this.address,
      required this.vendorId});

  Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "Event Name": eventName,
        "No of Volunteers": volNumber,
        "type": type,
        "Event Id": eventId,
        "Image Path": imagePath,
        "From Date": fromDate,
        "To Date": toDate,
        "Start Time": startTime,
        "End Time": endTime,
        "Address": address,
        "VendorId": vendorId
      };

  static AddVolunteers fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return AddVolunteers(
        id: snapshot["id"] ?? '',
        role: snapshot["role"] ?? '',
        eventName: snapshot["Event Name"] ?? '',
        volNumber: snapshot["No of Volunteers"] ?? '',
        type: snapshot['type'] ?? '',
        eventId: snapshot['Event Id'] ?? '',
        imagePath: snapshot["Image Path"] ?? '',
        fromDate: snapshot['From Date'] ?? '',
        toDate: snapshot['To Date'] ?? '',
        startTime: snapshot['Start Time'] ?? '',
        endTime: snapshot['End Time'] ?? '',
        address: snapshot['Address'] ?? '',
        vendorId: snapshot['Vendor Id'] ?? '');
  }
}
