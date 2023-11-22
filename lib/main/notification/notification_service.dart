import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings initializationSettingsAndroid =
  const AndroidInitializationSettings('@mipmap/ic_launcher');
  // final onNotifications  =BehaviorSubject<String?>();

  void initNotification() async {
    // var initializationSettingsIOS = DarwinInitializationSettings(
    //     requestAlertPermission: true,
    //     requestBadgePermission: true,
    //     requestSoundPermission: true,
    //     onDidReceiveLocalNotification:
    //         (int id, String? title, String? body, String? payload) async {});
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);
    await notificationsPlugin.initialize(initializationSettings,
      // onDidReceiveNotificationResponse: (payload)async{
      // onNotifications.add(payload as String?);
      // }
      );
  }
  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max,
          priority: Priority.high,

        ),
        iOS: DarwinNotificationDetails());
  }
  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future scheduleNotification(
      {int id = 0,
        String? title,
        String? body,
        String? payLoad,
        required DateTime scheduledNotificationDateTime}) async {
    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        await notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }
}


