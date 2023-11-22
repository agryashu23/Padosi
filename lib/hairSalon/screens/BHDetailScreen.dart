import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../main/utils/AppWidget.dart';
import '../model/BHModel.dart';
import '../utils/BHColors.dart';
import '../utils/BHConstants.dart';
import '../utils/BHImages.dart';
import '../utils/widget_constant.dart';
import 'BHBookAppointmentScreen.dart';
import 'BHPackageOffersScreen.dart';
import 'load_widget.dart';

class BHDetailScreen extends StatefulWidget {
  static String tag = '/NewSliverCustom';

  BHDetailScreen({required this.id ,required this.name, required this.status,required this.phone, required this.reviews, required this.gender});
  final String id;
  final String name;
  final int status;
  final String phone;
  final double reviews;
  final int gender;
  @override
  BHDetailScreenState createState() => BHDetailScreenState();
}

class BHDetailScreenState extends State<BHDetailScreen>
    with SingleTickerProviderStateMixin {
  int _radioValue1 = 0;
  TabController? controller;
  TextEditingController reviewController =TextEditingController();

  List<BHReviewModel> reviewList = [];
  Map<int, Widget> _children = {
    0: Text('Services'),
    1: Text('Packages'),
  };
  int _currentSelection = 0;
  // List<BHMakeUpModel> makeupList=[];

  int switcherIndex1 = 0;
  bool exist=false;
  @override
  void initState(){
    super.initState();
    getExist();
  }

  getExist()async{
    var doc = await FirebaseFirestore.instance.collection("reviews").doc(widget.id).collection("review").doc(FirebaseAuth.instance.currentUser!.uid).get();
    if(doc.exists){
      setState(() {
        exist=true;

      });
    }
  }
  double rating2=0.0;

  void something(int value) {
    setState(() {
      _radioValue1 = value;
      print(_radioValue1);
    });
  }
  List times=[];
  String slot="";


  @override
  Widget build(BuildContext context) {
    //ABOUT WIDGET// --------------------------------------------------
    Widget aboutWidget() {
      return FutureBuilder(
        future: FirebaseFirestore.instance.collection("owners").doc(widget.id).get(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return BHLoading();
          }
          else {
            var value = snapshot.data!;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: whiteColor,
                        boxShadow: [
                          BoxShadow(
                              color: BHGreyColor.withOpacity(0.3),
                              offset: Offset(0.0, 1.0),
                              blurRadius: 2.0)
                        ],
                      ),
                      child: Container(
                        width: 320.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              BHTxtInformation,
                              style: TextStyle(
                                  color: BHAppTextColorPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            8.height,
                            Text(value["about"],
                                style: TextStyle(
                                    color: BHAppTextColorSecondary,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.w),
                      margin: EdgeInsets.only(top: 10.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: whiteColor,
                        boxShadow: [
                          BoxShadow(
                              color: BHGreyColor.withOpacity(0.3),
                              offset: Offset(0.0, 1.0),
                              blurRadius: 2.0)
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            BHTxtContact,
                            style: TextStyle(
                                color: BHAppTextColorPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          8.height,
                          Row(
                            children: [
                              Icon(Icons.call, size: 16.w),
                              8.width,
                              Text(value["phone"],
                                  style: TextStyle(
                                      color: BHAppTextColorSecondary,
                                      fontSize: 14)),
                            ],
                          ),
                          // 8.height,
                          // Row(
                          //   children: [
                          //     Icon(Icons.web, size: 16.w),
                          //     8.width,
                          //     Text('www.salon.com',
                          //         style: TextStyle(
                          //             color: BHAppTextColorSecondary,
                          //             fontSize: 14)),
                          //   ],
                          // )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.w),
                      margin: EdgeInsets.only(top: 10.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: whiteColor,
                        boxShadow: [
                          BoxShadow(
                              color: BHGreyColor.withOpacity(0.3),
                              offset: Offset(0.0, 1.0),
                              blurRadius: 2.0)
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            BHTxtOpeningTime,
                            style: TextStyle(
                                color: BHAppTextColorPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          8.height,
                          for(int i=0;i<value["timeslots"].length;i++)
                          showTimings(value["timeslots"][i]["title"], value["timeslots"][i]["timing"]),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 7.w, vertical: 10.h),
                      margin: EdgeInsets.only(top: 10.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: whiteColor,
                        boxShadow: [
                          BoxShadow(
                              color: BHGreyColor.withOpacity(0.3),
                              offset: Offset(0.0, 1.0),
                              blurRadius: 2.0)
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            BHTxtAddress,
                            style: TextStyle(
                                color: BHAppTextColorPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          8.width,
                          GestureDetector(
                            onTap: (){
                              MapsLauncher.launchQuery(value["address"]+","+value["city"]);
                            },
                            child: SizedBox(
                                width: 200.w,
                                child: Text(value["address"]+","+value["city"],
                                    style: TextStyle(
                                        color: BHColorPrimary, fontSize: 14,decoration: TextDecoration.underline))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      );
    }
    //GALLERY WIDGET //=----------------------------------------------------

    Widget galleryWidget() {
      return FutureBuilder(
        future:FirebaseFirestore.instance.collection("owners").doc(widget.id).get(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return BHLoading();
          }
          else{
            var value = snapshot.data!;
            return MasonryGridView.count(
              scrollDirection: Axis.vertical,
              crossAxisCount: 3,
              itemCount: value["gallery"].length,
              padding: EdgeInsets.all(10.w),
              itemBuilder: (BuildContext context, int index) => ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Image.network(value["gallery"][index],
                    height: 80.h, fit: BoxFit.cover),
              ),
              // staggeredTileBuilder: (int index) => new StaggeredTile.count(2, index.isEven ? 2 : 3),
              mainAxisSpacing: 8.h,
              crossAxisSpacing: 8.w,
            );
          }
        }
      );
    }

    //SERVICES WIDGET//--------------------------------------------------

    Widget serviceWidget() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.height,
          SizedBox(
            width: context.width(),
            child: MaterialSegmentedControl(
              children: _children,
              selectionIndex: _currentSelection,
              borderColor: Colors.grey,
              selectedColor: BHColorPrimary,
              unselectedColor: Colors.white,
              selectedTextStyle: TextStyle(color: Colors.white),
              unselectedTextStyle: TextStyle(color: Colors.black),
              borderRadius: 6.0,
              onSegmentTapped: (index) {
                setState(() {
                  _currentSelection = int.parse(index.toString());
                });
              },
            ),
          ),
          5.height,
          _currentSelection == 0? servicesPart() : packagesPart(),
          selectedServices.isEmpty || widget.status==1?Container():Container(
            width: MediaQuery.of(context).size.width,
            height: 45.h,
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: BoxDecoration(
                color: BHColorPrimary, borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.only(left: 8.w,right: 8.w,bottom: 10.h),
            child: TextButton(
              onPressed: () async{
                await FirebaseFirestore.instance.collection("owners").doc(widget.id).get().then((value){
                  times = value["timeslots"];
                });
                String day =DateFormat('EEEE').format(DateTime.now());
                times.forEach((element) {
                  if(element["title"]==day){
                    setState(() {
                      slot = element["timing"];
                    });
                  }
                });
                BHBookAppointmentScreen(time:times,day:day,slot:slot,packages:[],services:selectedServices,id:widget.id,gender:widget.gender).launch(context);
                // BHBookAppointmentScreen(timeslots:timeSlots).launch(context);
              },

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${selectedServices.length} Items  \u{20B9}${amount}",
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Text("Book Services",
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: 14.w,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      );
    }

    //REVIEW WIDGET//--------------------------------------------------------

    Widget reviewWidget() {
      return SingleChildScrollView(
        child: Column(
          children: [
            exist?Container():Container(
              padding: EdgeInsets.all(8.w),
              margin: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                      color: BHGreyColor.withOpacity(0.3),
                      offset: Offset(0.0, 1.0),
                      blurRadius: 2.0)
                ],
              ),
              child: Column(
                children: [
                  Text(
                    BHTxtReview,
                    style: TextStyle(
                      fontSize: 16,
                      color: BHAppTextColorPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  8.height,
                  Text(
                    BHTxtReviewMsg,
                    style: TextStyle(fontSize: 14, color: BHGreyColor),
                  ),
                  8.height,
                  RatingBar.builder(
                    onRatingUpdate: (rating) {
                      setState(() {
                        rating2 = rating;
                      });
                    },
                    initialRating: 1.5,
                    glow: true,
                    glowColor: BHGreyColor,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    allowHalfRating: true,
                    minRating: 1,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: BHColorPrimary,
                    ),
                  ),
                  8.height,
                  Row(
                    children: [
                      Container(
                        height: 45.h,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: reviewController,
                          decoration: InputDecoration(
                            hintText: 'Say something...',
                            hintStyle: TextStyle(color: BHGreyColor),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 2.h),
                            filled: true,
                            fillColor: BHGreyColor.withOpacity(0.1),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(color: whiteColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(color: whiteColor),
                            ),
                          ),
                        ),
                      ).expand(),
                      8.width,
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: BHColorPrimary,
                        ),
                        child: IconButton(
                          onPressed: () async{
                            if(rating2==0.0 || reviewController.text.isEmpty){
                              Fluttertoast.showToast(msg: "Please enter rating and message");
                            }
                            else{
                              String user_name="";
                              String user_image="";
                              await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value){
                                user_name = value["name"];
                                user_image = value["image"];
                              });
                              await FirebaseFirestore.instance.collection("reviews").doc(widget.id).collection("review").doc(FirebaseAuth.instance.currentUser!.uid).set({
                                "rating":rating2,
                                "message":reviewController.text,
                                "user_name":user_name,
                                "user_image":user_image
                              });
                              await FirebaseFirestore.instance.collection("owners").doc(widget.id).update({
                                "reviews":FieldValue.increment(rating2),
                              });
                              Fluttertoast.showToast(msg: "Review Updated");
                              setState(() {
                                exist=true;
                              });
                            }
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: whiteColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: FirebaseFirestore.instance.collection("reviews").doc(widget.id).collection("review").get(),
              builder: (context, snapshot) {
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(child:CircularProgressIndicator());
                }
                else if(!snapshot.hasData){
                  return Center(child: Text("No reviews",style: TextStyle(fontSize: 18.w,fontWeight:FontWeight.bold,color: Colors.black),),);
                }
                else{
                  var value = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: value.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 0),
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.w,vertical: 3.h),
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: BHGreyColor.withOpacity(0.3),
                                offset: Offset(0.0, 1.0),
                                blurRadius: 2.0,
                              ),
                            ]),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                  NetworkImage(value[index]["user_image"]),
                                  radius: 30,
                                ),
                                10.width,
                                Column(
                                  children: [
                                    Text(
                                      value[index]["user_name"],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: BHAppTextColorPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          value[index]["rating"].toString(),
                                          style: TextStyle(
                                            color: BHAppTextColorSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                        2.width,
                                        Icon(
                                          Icons.star,
                                          color: BHColorPrimary,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                  ],
                                ),
                                5.height,
                            Text(
                              value[index]["message"],
                              style: TextStyle(
                                color: BHAppTextColorSecondary,
                                fontSize: 14,
                              ),
                            ),
                            3.height,
                          ],
                        ),
                      );
                    },
                  );
                }

              }
            ),
          ],
        ),
      );
    }


    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: white),
                  onPressed: () {
                    finish(context);
                  },
                ),
                backgroundColor: BHColorPrimary,
                pinned: true,
                elevation: 2,
                expandedHeight: 220.h,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Stack(
                    children: [
                      Image.asset(
                        BHDashedBoardImage3,
                        height: 250.h,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 100.h,left: 20.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.name,
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 16.w,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.reviews.toString(),
                                      style: TextStyle(
                                          color: whiteColor, fontSize: 16),
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.star,
                                            color: BHColorPrimary),
                                        onPressed: () {})
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 20.w),
                              height: 30.h,
                              width: 75.w,
                              color: widget.status==0?BHColorPrimary:Colors.red,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(widget.status==0?"Open":"Closed",
                                    style: TextStyle(
                                        color: whiteColor, fontSize: 14)),
                                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  centerTitle: true,
                ),
                bottom: TabBar(
                  labelColor: whiteColor,
                  unselectedLabelColor: whiteColor,
                  isScrollable: true,
                  indicatorColor: BHColorPrimary,
                  indicatorWeight: 3.0,
                  tabs: [
                    Tab(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(BHTabServices,
                              style: TextStyle(
                                  fontSize: 14.w,
                                  fontWeight: FontWeight.bold))),
                    ),
                    Tab(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(BHTabAbout,
                              style: TextStyle(
                                  fontSize: 14.w,
                                  fontWeight: FontWeight.bold))),
                    ),
                    Tab(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(BHTabGallery,
                              style: TextStyle(
                                  fontSize: 14.w,
                                  fontWeight: FontWeight.bold))),
                    ),

                    Tab(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(BHTabReview + "s",
                              style: TextStyle(
                                  fontSize: 14.w,
                                  fontWeight: FontWeight.bold))),
                    ),
                    // Tab(
                    //   child: Align(alignment: Alignment.center, child: Text(BHTabSalonSpecialList,style: TextStyle(fontSize: 14.w,fontWeight: FontWeight.bold))),
                    // ),
                  ],
                  controller: controller,
                ),
                actions: [
                  IconButton(
                      icon: Icon(Icons.call, color: whiteColor, size: 16),
                      onPressed: ()async {
                        UrlLauncher.launch("tel:${widget.phone}");
                      }),
                  // IconButton(icon: Icon(Icons.message, color: whiteColor, size: 16), onPressed: () {}),
                ],
              ),
            ];
          },
          body: TabBarView(
            children: [
              serviceWidget(),
              aboutWidget(),
              galleryWidget(),
              reviewWidget(),
              // specialListsWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget servicesPart() {
    return Expanded(
      child: FutureBuilder(
        future: getService(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return BHLoading();
          }
          else if(!snapshot.hasData){
            return Center(child: Text("No Services found"),);
          }
          else {
            return ListView.builder(
              itemCount: currentServices.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(0),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: CheckboxListTile(
                    tileColor: Colors.grey.shade100,
                    selectedTileColor: Colors.blue.shade50,
                    title: Text(
                      currentServices[index]["name"],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: BHAppTextColorPrimary,
                          fontSize: 14),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          currentServices[index]["duration"]+" min",
                          style: TextStyle(
                              color: BHAppTextColorSecondary, fontSize: 14),
                        ),
                        8.width,
                        Text(
                          '\u{20B9}${currentServices[index]["price"]}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: BHColorPrimary),
                        ),
                      ],
                    ),
                    secondary: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      child: commonCacheImageWidget(BHDashedBoardImage1, 80.h,
                          width: 90.w, fit: BoxFit.cover),
                    ),
                    autofocus: false,
                    activeColor: Colors.blue,
                    checkColor: Colors.white,
                    selected: currentServices[index]["value"],
                    value: currentServices[index]["value"],
                    onChanged: (value) {
                      setState(() {
                        currentServices[index]["value"] = value;
                        if (selectedServices.contains(currentServices[index])) {
                          selectedServices.remove(currentServices[index]);
                          amount=amount-int.parse(currentServices[index]["price"]);
                        } else {
                          selectedServices.add(currentServices[index]);
                          amount=amount+int.parse(currentServices[index]["price"]);

                        }
                      });
                    },
                  ),
                );
              },
            );
          }
        }
      ),
    );
  }

  Widget packagesPart() {
    return Expanded(
      child: FutureBuilder(
        future:FirebaseFirestore.instance.collection("services").doc(widget.id).collection("package").get(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return BHLoading();
          }
          else if(!snapshot.hasData){
            return Center(child: Text("No Package Found"),);
          }
          else {
            var value = snapshot.data!.docs;
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(8.w),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: whiteColor,
                    boxShadow: [
                      BoxShadow(
                          color: BHGreyColor.withOpacity(0.3),
                          offset: Offset(0.0, 1.0),
                          blurRadius: 2.0)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        child: commonCacheImageWidget(value[index]["image"],
                            110.h,
                            width: context.width(), fit: BoxFit.cover),
                      ),
                      8.height,
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              value[index]["name"],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: BHAppTextColorPrimary,
                                  fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () {
                                BHPackageOffersScreen(id:value[index].id.toString() , ownerId:widget.id,gender:widget.gender).launch(context);
                              },
                              child: Container(
                                width: 70.w,
                                child: Text(
                                  "View",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: BHColorPrimary,
                                      decoration: TextDecoration.underline,
                                      fontSize: 16.w),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Text(
                          '\u{20B9} ${value[index]["price"]}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.w,
                              color: Colors.grey),
                        ),
                      ),
                      10.height
                    ],
                  ),
                );
              },
            );
          }
        }
      ),
    );
  }
  int amount=0;
  List selectedServices=[];
  List currentServices=[];
  Future getService()async{
    if(currentServices.isEmpty){
      await FirebaseFirestore.instance.collection("services").doc(widget.id).collection("service").get().then((value) {
        value.docs.forEach((element) {
          currentServices.add({"id":element.id,"name":element["name"],"price":element["price"],"duration":element["duration"],"value":false});
        });
      });
    }
    print(selectedServices);
    return currentServices;
  }
}
