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

    if (stringEndDate.split(" ")[2] == "πμ") {
      stringEndDate = stringEndDate.split(" ")[0] +
          " " +
          stringEndDate.split(" ")[1] +
          " AM";
    } else {
      stringEndDate = stringEndDate.split(" ")[0] +
          " " +
          stringEndDate.split(" ")[1] +
          " PM";
    }
    if (stringStartDate.split(" ")[2] == "πμ") {
      stringStartDate = stringStartDate.split(" ")[0] +
          " " +
          stringStartDate.split(" ")[1] +
          " AM";
    } else {
      stringStartDate = stringStartDate.split(" ")[0] +
          " " +
          stringStartDate.split(" ")[1] +
          " PM";
    }
    Color color = Colors.white;
    if (DateFormat("dd/MM/yyyy hh:mm:ss a")
        .parse(stringStartDate)
        .isAfter(DateTime.now())) {
      color = Colors.green;
    } else if (DateFormat("dd/MM/yyyy hh:mm:ss a")
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
      startDate: map["start_date"],
      endDate: map["end_date"],
      department: map["department"],
      color: color,
    );
  }
}
