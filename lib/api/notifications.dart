import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();
  static Future _notificationDetails() async{
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        'channel description',
        importance: Importance.max,
      ),
    );
  }

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/logo');
    final settings = InitializationSettings(android: android);

    await _notifications.initialize(settings,
      onSelectNotification: (payload) async {
      onNotifications.add(payload);
    },);
  }

  static Future showNotificationDaily({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime schedule,
}) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(schedule, tz.local),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,

    );
  }
 static Future cancelNotification() async {
   await _notifications.cancelAll();
 }

}