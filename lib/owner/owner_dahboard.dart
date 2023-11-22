import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../hairSalon/utils/BHColors.dart';
import '../hairSalon/utils/BHConstants.dart';
import '../main/notification/notification_service.dart';
import 'owner_appointments.dart';
import 'owner_profile.dart';


class OwnerDashedBoard extends StatefulWidget {
  static String tag = '/DashedBoardScreen';

  @override
  OwnerDashedBoardState createState() => OwnerDashedBoardState();
}

class OwnerDashedBoardState extends State<OwnerDashedBoard> {

  @override
  void initState() {
    super.initState();
    Stream<QuerySnapshot<Map<String,dynamic>>> notificationStream = FirebaseFirestore.instance.
    collection("salon_bookings").doc(FirebaseAuth.instance.currentUser!.uid).collection("booking").snapshots();
    notificationStream.listen((event) {
      if(event.docs.isEmpty){
        return ;
      }
    showNotification(event.docs.first);
    });
  }
  void showNotification(QueryDocumentSnapshot<Map<String,dynamic>> event){
    NotificationService().showNotification(title: event.get('booking_id').toString(),body:"You got a booking");
  }






  int _selectedIndex = 0;
  var _pages = <Widget>[
    OwnerAppointmentScreen(),
    OwnerProfileScreen(),
  ];

  Widget _bottomTab() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(color: BHColorPrimary),
      selectedItemColor: BHColorPrimary,
      unselectedLabelStyle: TextStyle(color: BHGreyColor),
      unselectedItemColor: BHGreyColor,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.date_range), label: BHBottomNavAppointment),

        BottomNavigationBarItem(icon: Icon(Icons.person), label: BHBottomNavProfile),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // changeStatusColor(Colors.white);

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: _bottomTab(),
        body: Center(child: _pages.elementAt(_selectedIndex)),
      ),
    );
  }

}
