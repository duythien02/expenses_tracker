import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init()async{
    tz.initializeTimeZones();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestExactAlarmsPermission();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid,);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification({required String title, required String body, required String payload}) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledTime= tz.TZDateTime(tz.local, now.year, now.month, now.day, 19, 27);

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'expense_tracker_id',
      'expense_tracker_name',
      channelDescription: 'track expense and income',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    tz.setLocalLocation(tz.getLocation("Asia/Ho_Chi_Minh"));
    return flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(
        scheduledTime,
        tz.local,
      ),
      notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }
}