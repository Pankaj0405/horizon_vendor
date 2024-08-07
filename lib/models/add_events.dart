import 'package:cloud_firestore/cloud_firestore.dart';

class AddEvent {
  String id;
  String eventName;
  String organizationName;
  String address;
  String description;
  String maxSlots;
  String price;
  String imagePath;
  String type;
  String fromDate;
  String toDate;
  String startTime;
  String endTime;
  String vendorId;

  AddEvent(
      {required this.address,
      required this.description,
      required this.eventName,
      required this.organizationName,
      required this.id,
      required this.price,
      required this.maxSlots,
      required this.imagePath,
      required this.type,
      required this.fromDate,
      required this.toDate,
      required this.startTime,
      required this.endTime,
      required this.vendorId});

  Map<String, dynamic> toJson() => {
        "id": id,
        "Event Name": eventName,
        "Organization Name": organizationName,
        "Address": address,
        "Description": description,
        "Max Slots": maxSlots,
        "Booking price": price,
        "Image Path": imagePath,
        "Type": type,
        "From": fromDate,
        "To": toDate,
        "Start Time": startTime,
        "End Time": endTime,
        "vendorId": vendorId,
      };

  static AddEvent fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return AddEvent(
      id: snapshot["id"] ?? '',
      address: snapshot["Address"] ?? '',
      description: snapshot["Description"] ?? '',
      eventName: snapshot["Event Name"] ?? '',
      organizationName: snapshot["Organization Name"] ?? '',
      maxSlots: snapshot["Max Slots"] ?? '',
      price: snapshot["Booking price"] ?? '',
      imagePath: snapshot["Image Path"] ?? '',
      type: snapshot["Type"] ?? '',
      fromDate: snapshot['From'] ?? '',
      toDate: snapshot['To'] ?? '',
      startTime: snapshot['Start Time'] ?? '',
      endTime: snapshot['End Time'] ?? '',
      vendorId: snapshot['vendor Id'] ?? ''
    );
  }
}
