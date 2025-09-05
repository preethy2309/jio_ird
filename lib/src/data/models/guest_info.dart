import 'package:flutter/material.dart';

@immutable
class GuestInfo {
  final String roomNo;
  final String propertyId;
  final String guestName;
  final String guestId;

  const GuestInfo({
    required this.roomNo,
    required this.propertyId,
    required this.guestName,
    required this.guestId,
  });

  Map<String, dynamic> toMap() {
    return {
      "room_no": roomNo,
      "property_id": propertyId,
      "guest_name": guestName,
      "guest_id": guestId,
    };
  }
}
