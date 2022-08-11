import 'package:flutter/material.dart';
import 'package:power_off_notifier/api/api.dart';
import 'package:power_off_notifier/models/announcement.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DepartmentAnnouncementsController extends ChangeNotifier with Api {
  List<Announcement>? _announcements = [];
  List<Announcement>? get announcements => _announcements;

  bool _hasData = false;
  bool get hasData => _hasData;

  Future<bool> getAnnouncementsFromDepartment(String department) async {
    _announcements = null;
    List<Announcement> localList = [];

    List<Map>? announcementsMap =
        await apiGetAnnouncementFromDepartment(department);
    if (announcementsMap != null) {
      for (var map in announcementsMap) {
        localList.add(Announcement.fromAPI(map));
      }
      _announcements = localList;
      if (_announcements!.isNotEmpty) {
        SharedPreferences.getInstance()
            .then((pref) => pref.setInt("lastID", _announcements!.first.id));
      }

      _hasData = true;
    }
    notifyListeners();
    return _hasData;
  }
}
