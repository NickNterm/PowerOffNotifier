import 'dart:io';

import 'package:flutter/material.dart';
import 'package:power_off_notifier/api/api.dart';
import 'package:power_off_notifier/constants/colors.dart';
import 'package:power_off_notifier/models/announcement.dart';
import 'package:power_off_notifier/pages/loading/loading_screen.dart';
import 'package:power_off_notifier/providers/department_announcements.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';

import 'package:workmanager/workmanager.dart';

import 'notification/notification_service.dart';

void checkForAnnouncements() {
  Workmanager().executeTask((task, inputData) async {
    if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();

    pref = await SharedPreferences.getInstance();
    String department = pref.getString("department") ?? "ΙΩΑΝΝΙΝΩΝ";
    int id = pref.getInt("lastID") ?? 1;
    print(id);
    print(department);
    Map announcementMap =
        await Api().apiGetLatestAnnouncementFromDepartment(department, id);
    Announcement announcement = Announcement.fromAPI(announcementMap);
    await pref.setInt("lastID", announcement.id);
    NotificationService().sendNotification(announcement);
    return true;
  });
}

String? selectedNotificationPayload;
late SharedPreferences pref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    checkForAnnouncements, // The top level function, aka callbackDispatcher
  );
  Workmanager().registerPeriodicTask(
    "task-identifier",
    "simpleTask",
    frequency: const Duration(minutes: 15),
  );
  await NotificationService().init();

  //NotificationService().sendNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DepartmentAnnouncementsController>(
          create: (context) => DepartmentAnnouncementsController(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: kPrimaryColor,
        ),
        home: const LoadingScreen(),
      ),
    );
  }
}
