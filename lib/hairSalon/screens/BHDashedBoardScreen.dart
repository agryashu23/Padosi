import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import '../utils/BHColors.dart';
import '../utils/BHConstants.dart';
import '../utils/widget_constant.dart';
import 'BHAppointmentScreen.dart';
import 'BHDiscoverScreen.dart';
import 'BHProfileScreen.dart';

class BHDashedBoardScreen extends StatefulWidget {
  static String tag = '/DashedBoardScreen';
  // final String city;

  // BHDashedBoardScreen({required this.city});

  @override
  BHDashedBoardScreenState createState() => BHDashedBoardScreenState();
}

class BHDashedBoardScreenState extends State<BHDashedBoardScreen> {

  int _selectedIndex = 0;
  String ans="";
  Position? _currentPosition;
  String currentCity="";

  getLocation()async{
    bool permission = await handleLocationPermission();
    // Fluttertoast.showToast(
    //     msg: "Please Wait", timeInSecForIosWeb: 6);
    if (permission) {
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        setState(() => _currentPosition = position);
      }).catchError((e) {
        debugPrint(e);
      });
      await placemarkFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude)
          .then((List<Placemark> placemarks) {
        Placemark place = placemarks[0];
        currentCity = place.locality.toString();
        setState(() {
        });
      }).catchError((e) {
        debugPrint(e.toString());
      });
    }
    else {
      Fluttertoast.showToast(
          msg: "Permission Declined", timeInSecForIosWeb: 4);
    }
  }
  //  getToken() async {
  //   await FirebaseMessaging.instance.getToken().then((token) {
  //     FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid.toString()).update({'user-token': token});
  //   });
  // }
  // NotificationService notificationService = NotificationService();
  // void listenNotifications()=>NotificationService().onNotifications.stream.listen(onClicked);
  // void onClicked(String? payload)=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BHAppointmentScreen()));

  @override
  void initState() {
    super.initState();
    // notificationService.initNotification();
    // listenNotifications();
    getLocation();
    // setUpInteractedMessage();
    // Stream<QuerySnapshot<Map<String,dynamic>>> notificationStream = FirebaseFirestore.instance.collection("notifications").snapshots();
    // notificationStream.listen((event) {
    //   print(event.docs.length);
    //   if(event.docs.isEmpty){
    //     return;
    //   }
    //   else{
    //     showNotification(event.docs.first);
    //   }
    // });
  }

  List<Widget> _pages() => [
    BHDiscoverScreen(city:currentCity),
    // BHNotifyScreen(),
    BHAppointmentScreen(),
    // BHMessagesScreen(),
    BHProfileScreen(),
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
        BottomNavigationBarItem(icon: Icon(Icons.home), label: BHBottomNavDiscover),
        // BottomNavigationBarItem(icon: Icon(Icons.business), label: BHBottomNavNotify),
        BottomNavigationBarItem(icon: Icon(Icons.date_range), label: BHBottomNavAppointment),
        // BottomNavigationBarItem(icon: Icon(Icons.message), label: BHBottomNavMessages),
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
    final List<Widget> pages = _pages();
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: _bottomTab(),
        body: Center(child: pages.elementAt(_selectedIndex)),
        floatingActionButton: DraggableFab(
          child: FloatingActionButton(
            onPressed: ()async{
              final link = WhatsAppUnilink(
                phoneNumber: '+916205818799',
                text: "Hey! I have query about padosi app.",
              );
              await UrlLauncher.launch('$link');
            },
            child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset("images/hairSalon/whats_app.png",height:53,width: 53,)),
          ),
        )
      ),
    );
  }
}
