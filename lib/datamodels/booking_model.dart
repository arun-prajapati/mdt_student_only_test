// To parse this JSON data, do
//
//     final booking = bookingFromJson(jsonString);

import 'dart:convert';

List<Booking> bookingFromJson(String str) =>
    List<Booking>.from(json.decode(str).map((x) => Booking.fromJson(x)));

String bookingToJson(List<Booking> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

//class BookingsList{
//  final List<Booking> bookings;
//
//  BookingsList({
//    this.bookings,
//  });
//
//  factory BookingsList.fromJson(List<dynamic> json) {
//
//    List<Booking> bookings = new List<Booking>();
//    bookings = json.map((i)=>Booking.fromJson(i)).toList();
//
//    return new BookingsList(
//        bookings: bookings
//    );
//  }
//
//}

class Booking {
  Booking({
    required this.name,
    required this.requestedDate,
    required this.requestedTime,
    required this.location,
    required this.type,
    required this.bookingType,
  });

  final String name;
  final DateTime requestedDate;
  final String requestedTime;
  final String location;
  final String type;
  final String bookingType;

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        name: json["name"],
        requestedDate: DateTime.parse(json["requested_date"]),
        requestedTime: json["requested_time"],
        location: json["location"],
        type: json["type"],
        bookingType: json["booking_type"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "requested_date":
            "${requestedDate.year.toString().padLeft(4, '0')}-${requestedDate.month.toString().padLeft(2, '0')}-${requestedDate.day.toString().padLeft(2, '0')}",
        "requested_time": requestedTime,
        "location": location,
        "type": type,
        "booking_type": bookingType,
      };
}
