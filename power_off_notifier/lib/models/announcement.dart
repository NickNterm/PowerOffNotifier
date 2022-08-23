import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Announcement {
  final int id;
  final String department;
  final String municipality;
  final String description;
  final String type;
  final String startDate;
  final String endDate;
  final Color color;
  Announcement({
    required this.id,
    required this.municipality,
    required this.description,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.department,
    required this.color,
  });

  factory Announcement.fromAPI(Map map) {
    String stringStartDate = map["start_date"];

    String stringEndDate = map["end_date"];

    Color color = Colors.white;
    if (DateFormat("yyyy-MM-ddThh:mm:ss")
        .parse(stringStartDate)
        .isAfter(DateTime.now())) {
      color = Colors.green;
    } else if (DateFormat("yyyy-MM-ddThh:mm:ss")
        .parse(stringEndDate)
        .isAfter(DateTime.now())) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }
    return Announcement(
      id: map["id"],
      municipality: map["municipality"],
      description: map["description"],
      type: map["type"],
      startDate: DateFormat("dd/MM/yyyy hh:mm")
          .format(DateFormat("yyyy-MM-ddThh:mm:ss").parse(stringStartDate)),
      endDate: DateFormat("dd/MM/yyyy hh:mm")
          .format(DateFormat("yyyy-MM-ddThh:mm:ss").parse(stringEndDate)),
      department: map["department"],
      color: color,
    );
  }
}
