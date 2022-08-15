import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:power_off_notifier/models/announcement.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  NotificationService._internal();
  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('bolt_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String? payload) async {
    //Handle notification tapped logic here
  }
  void sendNotification(Announcement announcement) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      "0",
      "Announcement",
      enableLights: true,
      fullScreenIntent: true,
      visibility: NotificationVisibility.public,
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        1,
        "Νέα ανακοίνωση για τον νομό ${announcement.department}",
        "Δήμος ${announcement.municipality}\n${announcement.description}",
        platformChannelSpecifics,
        payload: 'data');
  }
}
