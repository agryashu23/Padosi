import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:salon/hairSalon/screens/BHShowSalon.dart';
import 'package:salon/hairSalon/screens/BHViewAllCategories.dart';
import 'package:salon/hairSalon/screens/category_form.dart';
import 'BHShowBooking.dart';
import 'coupon.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../main/utils/AppWidget.dart';
import '../utils/BHColors.dart';
import 'BHSpecialListViewAllScreen.dart';
import 'BHSpecialOfferViewAllScreen.dart';
import 'load_widget.dart';

class BHDiscoverScreen extends StatefulWidget {
  static String tag = '/DiscoverBottomNavigationBarScreen';
  final String city;
  BHDiscoverScreen({required this.city});

  @override
  BHDiscoverScreenState createState() => BHDiscoverScreenState();
}

class BHDiscoverScreenState extends State<BHDiscoverScreen> with SingleTickerProviderStateMixin{
  late final AnimationController _slideAnimationController =
  AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1000));
  late final Animation<Offset> _slideAnimation =
  Tween<Offset>(begin:Offset(0,-10) , end:  const Offset(0, 0.2))
      .animate(_slideAnimationController);
  late final Animation<Offset> _slideAnimation2 =
  Tween<Offset>(begin:Offset(-10,-0) , end:  const Offset(0, 0))
      .animate(_slideAnimationController);

  @override
  void initState() {
    super.initState();
    _slideAnimationController.forward();
  }
  @override
  void dispose() {
    super.dispose();
    _slideAnimationController.dispose();
  }
  bool shimmer = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int gender = 0;
  String cityValue = "";
  bool current = false;
  TextEditingController textEditingController = TextEditingController();
  String location = "Search City";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15.h),
                    child: Row(
                      children: [
                        Text('Hi',
                            style: TextStyle(
                                fontSize: 18,
                                color: BHAppTextColorPrimary,
                                fontWeight: FontWeight.bold)),
                        8.width,
                        Text('User,',
                            style: TextStyle(
                                fontSize: 18,
                                color: BHColorPrimary,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12.h),
                    child: GestureDetector(
                      child: Icon(Icons.notifications,
                          color: BHColorPrimary, size: 22),
                      onTap: () {
                        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: BHSpecialOfferViewAllScreen(),
                        childCurrent: widget,duration: Duration(milliseconds: 500)));
                      },
                    ),
                  )
                ],
              ),
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16),
                      Text(widget.city,
                          style: TextStyle(
                              fontSize: 16, color: BHAppTextColorSecondary)),
                    ],
                  ),
                  GestureDetector(
                    onTap: ()async{
                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: BHShowSalon(),
                          childCurrent: widget,duration: Duration(milliseconds: 500)));
                      // Payment().launch(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color:BHColorPrimary,
                        borderRadius:BorderRadius.circular(10.0)
                      ),
                      child: Text("Salon near you"),
                    ),
                  )
                ],
              ),

              18.height,
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 4.w),
                      child: Text("Top Categories",
                          style: TextStyle(
                              fontSize: 15.w,
                              color: BHAppTextColorPrimary,
                              fontWeight: FontWeight.bold)),
                    ),
                    10.width,
                    Container(
                        width: 210.w,
                        child: Divider(color: Colors.grey.shade300,height:2.h,thickness: 1.w,))
                  ],
                ),
                15.height,
                Container(
                  height: 90.h,
                  child: FutureBuilder(
                      future: FirebaseFirestore.instance
                      .collection("category")
                      .get(),
                      builder: (context,snapshot){
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return BHLoading();
                        }
                        else {
                          var value = snapshot.data!.docs;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                              itemCount: value.length,
                              itemBuilder: (context,index){
                                  return GestureDetector(
                                    onTap: (){
                                      Fluttertoast.showToast(msg: value[index]["name"]);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(backgroundImage: NetworkImage(value[index]["image"]),radius: 35.w,),
                                          3.height,
                                          Text(value[index]["name"],style: TextStyle(fontSize: 12.w,fontWeight: FontWeight.w500),),
                                        ],
                                      ),
                                    ),
                                  );
                          });
                        }

                      }
                  ),
                ),

                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 4.w),
                      child: Text("All Services",
                          style: TextStyle(
                              fontSize: 15.w,
                              color: BHAppTextColorPrimary,
                              fontWeight: FontWeight.bold)),
                    ),
                    10.width,
                    Container(
                        width: 170.w,
                        child: Divider(color: Colors.grey.shade300,height:2.h,thickness: 1.w,)),
                    10.width,
                    GestureDetector(
                      onTap: (){
                        // BHViewAllCategories().launch(context);
                        Navigator.push(context, PageTransition(type: PageTransitionType.topToBottom, child: BHViewAllCategories(),
                            childCurrent: widget,duration: Duration(milliseconds: 500)));
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 4.w),
                        child: Text("View All",
                            style: TextStyle(
                                fontSize: 14.w,
                                decoration: TextDecoration.underline,
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                6.height,
                Container(
                  height: 162.h,
                  child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("categories")
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return BHLoading();
                        }
                        else if(snapshot.hasData) {
                          var value = snapshot.data!.docs;
                          return GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 150.w,
                                  mainAxisExtent: 88.h,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 7.w,
                                  mainAxisSpacing: 0.h),
                              itemCount: value.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return GestureDetector(
                                  onTap: () {

                                    Navigator.push(context, PageTransition(type: PageTransitionType.fade, curve:Curves.easeOut,child: CategoryForm(
                                        title: value[index]["name"],
                                        image: value[index]["image"]),
                                        childCurrent: widget,duration: Duration(milliseconds: 500)));
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment
                                        .start,
                                    children: [
                                      Card(
                                        elevation: 1,
                                        color: Colors.grey.shade100,
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.h),
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(
                                                bottom: 1.h),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(5)),
                                            child: Image.network(
                                              value[index]["image"],
                                              width: 55.w,
                                              height: 42.h,
                                              fit: BoxFit.cover,)
                                        ),
                                      ),
                                      Text(value[index]["name"],
                                        style: TextStyle(fontSize: 13.w),),
                                    ],
                                  ),
                                );
                              });
                        }
                        else{
                          return BHLoading();
                        }
                      }),
                ),
              ],
            ),
              Divider(color: Colors.grey,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("--------  "),
                  Center(
                    child: Column(
                      children: [
                        SlideTransition(
                          position: _slideAnimation2,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            color: Colors.grey.shade100,
                            elevation: 5,
                            child: Container(
                              padding: EdgeInsets.all(3.w),
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextButton(
                                onPressed: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                          return AlertDialog(
                                            content: Form(
                                                key: _formKey,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        'Book For -',
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            letterSpacing: 1.5,
                                                            color: BHColorPrimary),
                                                      ),
                                                      10.height,
                                                      ToggleSwitch(
                                                        minWidth: 95.w,
                                                        initialLabelIndex: 0,
                                                        cornerRadius: 10.0,
                                                        activeFgColor: Colors.white,
                                                        inactiveBgColor: Colors.grey,
                                                        inactiveFgColor: Colors.white,
                                                        totalSwitches: 2,
                                                        labels: ['Male', 'Female'],
                                                        icons: [Icons.male, Icons.female],
                                                        activeBgColors: [
                                                          [Colors.blue],
                                                          [Colors.pink]
                                                        ],
                                                        onToggle: (index) {
                                                          gender = index!;
                                                        },
                                                      ),
                                                      25.height,
                                                      Text(
                                                        'Choose City -',
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            letterSpacing: 1.5,
                                                            color: BHColorPrimary),
                                                      ),
                                                      10.height,
                                                      InkWell(
                                                          onTap: () async {
                                                            Prediction? place = await PlacesAutocomplete.show(
                                                                context: context,
                                                                apiKey: "AIzaSyC1A7zM67k09UeHvPcf0DJo_OHcx9pdwQc",
                                                                mode: Mode.overlay,
                                                                language: 'en',
                                                                radius: 1000000,
                                                                types: ["(cities)"],
                                                                strictbounds: false,
                                                                components: [Component(Component.country, 'in')],
                                                                //google_map_webservice package
                                                                onError: (err){
                                                                  print(err);
                                                                }
                                                            );

                                                            if(place != null){
                                                              print(place);
                                                              String ans="";
                                                                for(int i=0;i<place.description.toString().length;i++){
                                                                  if(place.description.toString()[i]==',' || place.description.toString()[i]==' '){
                                                                    break;
                                                                  }
                                                                  ans+=place.description.toString()[i];
                                                                }
                                                                setState((){
                                                                  location =ans;
                                                                  cityValue = ans;
                                                                });


                                                            }

                                                          },
                                                          child:Padding(
                                                            padding: EdgeInsets.all(15),
                                                            child: Card(
                                                              child: Container(
                                                                  padding: EdgeInsets.all(0),
                                                                  width: MediaQuery.of(context).size.width - 40,
                                                                  child: ListTile(
                                                                    title:Text(location, style: TextStyle(fontSize: 17.w),),
                                                                    trailing: Icon(Icons.search),
                                                                    dense: true,
                                                                  )
                                                              ),
                                                            ),
                                                          )
                                                      ),
                                                      10.height,
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Divider(
                                                              thickness: 0.5,
                                                              color: Colors.grey[400],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal: 10.0),
                                                            child: Text(
                                                              'OR',
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 16.w,
                                                                  fontWeight:
                                                                      FontWeight.w400),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Divider(
                                                              thickness: 0.5,
                                                              color: Colors.grey[400],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      7.height,
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            current = !current;
                                                          });
                                                        },
                                                        child: Card(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      10)),
                                                          elevation: 10,
                                                          child: Container(
                                                            width: 175.w,
                                                            padding: EdgeInsets.all(8),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors.black),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        10),
                                                                color: current
                                                                    ? BHColorPrimary
                                                                    : Colors.white),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(Icons.navigation),
                                                                Text(
                                                                  "Use Current Location",
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontWeight:
                                                                          FontWeight.w500,
                                                                      fontSize: 13.w),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                            actions: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  current = false;
                                                  Navigator.of(context).pop();
                                                  location="Search City";
                                                },
                                                child: Container(
                                                  width: 80.w,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5.w, vertical: 7.h),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(5),
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 1.0)),
                                                  child: Text('Cancel'),
                                                ),
                                              ),
                                              10.width,
                                              GestureDetector(
                                                onTap: () {
                                                  if(cityValue=="" && current==false){
                                                    Fluttertoast.showToast(msg: "Choose city");
                                                  }
                                                  else{
                                                    Navigator.of(context).pop();
                                                    BHSpecialListViewAllScreen(
                                                        gender: gender,
                                                        city: current
                                                            ? widget.city
                                                            : cityValue.toString())
                                                        .launch(context);
                                                    current = false;
                                                    location="Search City";
                                                  }
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  child: Container(
                                                    width: 80.w,
                                                    height: 35.h,
                                                    alignment: Alignment.center,
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 5.w, vertical: 7.h),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(5),
                                                    ),
                                                    child: Text('Next'),
                                                  ),
                                                ),
                                              ),
                                              10.width
                                            ],
                                          );
                                        });
                                      });
                                },
                                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                child: Image.asset("images/hairSalon/salon_image.png",height: 50.h,width: 60.w,),
                              ),
                            ),
                          ),
                        ),
                        5.height,
                        Text("Salon Booking",
                            style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 0.3,
                                fontSize: 15.w,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  Text("  -------"),
                ],
              ),
              SlideTransition(
                position: _slideAnimation,
                child: Container(
                  child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("admin")
                          .doc("discount")
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return BHLoading();
                        } else if (snapshot.hasData) {
                          var value = snapshot.data!;
                          return HorizontalCouponExample2(value["percent"].toString(),value["off"].toString());
                        } else {
                          return Container();
                        }
                      }),
                ),
              ),
              25.height,
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("bookings")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("booking")
                    .where("status", isEqualTo: "pending")
                    .limit(1)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return BHLoading();
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Container(
                      // alignment: Alignment.center,
                      // height: 50.h,
                      // padding: EdgeInsets.symmetric(vertical: 10.h),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(10),
                      // ),
                      // child: Text("No Upcoming Appointment",
                      //     style: TextStyle(
                      //         fontSize: 16.w,
                      //         color: Colors.grey,
                      //         fontWeight: FontWeight.w600)),
                    );
                  }
                  else {
                    var value = snapshot.data!.docs;
                    int index = 0;
                    return Column(
                      children: [
                        Text("Upcoming Appointment",
                            style: TextStyle(
                                fontSize: 16,
                                color: BHAppTextColorPrimary,
                                fontWeight: FontWeight.bold)),
                        10.height,
                        GestureDetector(
                          onTap: (){
                            BHShowBooking(id:value[index].id,bookingID:value[index]["booking_id"].toString()).launch(context);
                          },
                          child: Card(
                            elevation: 4,
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(5.w),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: whiteColor,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                child: commonCacheImageWidget(
                                                    value[index]["owner_image"], 60.h,
                                                    width: 80.w, fit: BoxFit.cover),
                                              ),
                                              10.width,
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 130.w,
                                                    child: Text(
                                                        value[index]["owner_name"],
                                                        style: TextStyle(
                                                            fontSize: 14.w,
                                                            color:
                                                                BHAppTextColorPrimary,
                                                            fontWeight:
                                                                FontWeight.bold)),
                                                  ),
                                                  8.height,
                                                  Row(
                                                    children: [
                                                      Icon(Icons.location_on,
                                                          size: 14.w,
                                                          color:
                                                              BHAppTextColorSecondary),
                                                      Container(
                                                        width: 130.w,
                                                        child: Text(
                                                            value[index]
                                                                    ["owner_address"] +
                                                                "," +
                                                                value[index]
                                                                    ["owner_city"],
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: BHGreyColor)),
                                                      ),
                                                    ],
                                                  ),
                                                  5.height,
                                                  Container(
                                                    width: 140.w,
                                                    child: Text(
                                                      "Appointment ID #${value[index]["booking_id"]}",
                                                      style: TextStyle(
                                                          fontSize: 13.w,
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight.w400),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ...List.generate(
                                                        value[index]["name"].length,
                                                        (idx) {
                                                      return Text(
                                                          value[index]["name"][idx],
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.black,
                                                              fontWeight:
                                                                  FontWeight.w400));
                                                    }),
                                                  ],
                                                ),
                                                Text(
                                                    DateFormat.jm()
                                                        .format(value[index]
                                                                ["booking_time"]
                                                            .toDate())
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: BHColorPrimary,
                                                        fontSize: 15.w,
                                                        fontWeight: FontWeight.bold)),
                                              ]),
                                          5.height,
                                          Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left: 4),
                                                child: Text('Total',
                                                    style: TextStyle(
                                                        color: BHColorPrimary,
                                                        fontSize: 15.w,
                                                        fontWeight: FontWeight.bold)),
                                              ),
                                              Text("\u{20B9}${value[index]["price"]}",
                                                  style: TextStyle(
                                                      color: BHAppTextColorPrimary,
                                                      fontSize: 15.w,
                                                      fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  DateFormat('yyyy-MM-dd').format(
                                                      value[index]["booking_time"]
                                                          .toDate()),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: BHAppTextColorSecondary)),
                                              // Image.asset(BHBarCodeImg, height: 50, width: 120),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              10.height,
              Row(
                children: [
                  5.width,
                   Text("Hair/Skin Feed",
                      style: TextStyle(
                          fontSize: 15.w,
                          color: BHAppTextColorPrimary,
                          fontWeight: FontWeight.bold)),
                  10.width,
                  Container(
                      width: 210.w,
                      child: Divider(color: Colors.grey.shade300,height:2.h,thickness: 1.w,))
                ],
              ),
              10.height,
              StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection("feeds").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var value = snapshot.data!.docs;
                      List<Widget> imageSliders = value
                          .map((item) => GestureDetector(
                        onTap: (){
                          // Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: BHShowFeed(image: item["image"], title:item["title"], text: item["feed"]),
                          //     childCurrent: widget,duration: Duration(milliseconds: 500)));
                        },
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Stack(
                                children: <Widget>[
                                  Image.network(item["image"], fit: BoxFit.cover, width: 240.w),
                                  Positioned(
                                    bottom: 0.0,
                                    left: 0.0,
                                    right: 0.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                      child: Text(
                                        item["title"],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.w,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      )).toList();
                      return Container(
                        child: CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio:16/7,
                            enlargeCenterPage: false,
                          ),
                          items: imageSliders,
                        ),
                      );
                    } else {
                      return Container(
                        alignment: Alignment.center,
                        height: 50.h,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text("No Feeds",
                            style: TextStyle(
                                fontSize: 16.w,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600)),
                      );
                    }
                  }),
              10.height,

            ],
          ),
        ),
      ),
    );
  }

}
