import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';

import '../main/notification/notification_service.dart';
import 'SideMenu.dart';
import 'dashboard_screen.dart';


class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  NotificationService notificationService = NotificationService();
  // void listenNotifications()=>NotificationService().onNotifications.stream.listen(onClicked);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  // void onClicked(String? payload)=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdminHome()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: BHColorPrimary,
        title: Text("Dashboard"),
        centerTitle: true,
      ),
      drawer: SideMenu(),
      body: DashBoardScreen(),

    );
  }

  void showNotification(QueryDocumentSnapshot<Map<String,dynamic>> event){
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails("001", "local notification");
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    flutterLocalNotificationsPlugin.show(01, event.get("title"), event.get("user_phone"), notificationDetails);
  }


  @override
  void initState() {
    super.initState();
    notificationService.initNotification();
    Stream<QuerySnapshot<Map<String,dynamic>>> notificationStream = FirebaseFirestore.instance.collection("other_bookings").snapshots();
    notificationStream.listen((event) {
      if(event.docs.isEmpty){
        return;
      }
      showNotification(event.docs.first);
    });
    // listenNotifications();
  }
}
