//
// import 'dart:developer';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// Future<void> setUpInteractedMessage() async {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   //IOS
//   await FirebaseMessaging.instance
//       .setForegroundNotificationPresentationOptions(
//     alert: true, // Required to display a heads up notification
//     badge: true,
//     sound: true,
//   );
//
//   //Android
//   NotificationSettings settings = await messaging.requestPermission(
//     alert: true,
//     announcement: false,
//     badge: true,
//     carPlay: false,
//     criticalAlert: false,
//     provisional: false,
//     sound: true,
//   );
//
//   log('User granted permission: ${settings.authorizationStatus}');
//
//   //Get the message from tapping on the notification when app is not in foreground
//   // RemoteMessage? initialMessage = await messaging.getInitialMessage();
//
//   //If the message contains a service, navigate to the admin
//   // if (initialMessage != null) {
//   //   await _mapMessageToUser(initialMessage);
//   // }
//
//   //This listens for messages when app is in background
//   // FirebaseMessaging.onMessageOpenedApp.listen(_mapMessageToUser);
//
//   //Listen to messages in Foreground
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//
//     //Initialize FlutterLocalNotifications
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'schedular_channel', // id
//       'Schedular Notifications', // title
//       description:
//       'This channel is used for Schedular app notifications.', // description
//       importance: Importance.max,
//     );
//
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     //Construct local notification using our created channel
//     if (notification != null && android != null) {
//       flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               channelDescription: channel.description,
//               icon: "@mipmap/ic_launcher", //Your app icon goes here
//               // other properties...
//             ),
//           ));
//     }
//   });
// }
//
// void showNotification(QueryDocumentSnapshot<Map<String,dynamic>> event){
//   const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails("001", 'Local Notification',channelDescription: 'To send Notification');
//   const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
//   FlutterLocalNotificationsPlugin().show(01, event.get('title'), event.get('subtitle'), notificationDetails);
// }