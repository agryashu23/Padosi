import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../main/utils/AppWidget.dart';
import '../model/BHModel.dart';
import '../utils/BHColors.dart';
import '../utils/widget_constant.dart';
import 'BHDetailScreen.dart';
import 'package:nb_utils/nb_utils.dart';

import 'load_widget.dart';

class BHSpecialListViewAllScreen extends StatefulWidget {
  static String tag = '/SpecialListViewAllScreen';


  BHSpecialListViewAllScreen({required this.gender, required this.city});
  final int gender;
  final String city;

  @override
  BHSpecialListViewAllScreenState createState() => BHSpecialListViewAllScreenState();
}

class BHSpecialListViewAllScreenState extends State<BHSpecialListViewAllScreen> {
  bool loading= true;
  List dummyList=[];

  @override
  void initState() {
    super.initState();
    getSalon();
  }


  List selectedList=[];
  List searchResult=[];
  
  Future getSalon()async{
    await FirebaseFirestore.instance.collection("owners").where("city",isEqualTo:widget.city).get().then((value) {
      value.docs.forEach((element) {
        if(element["gender"]==widget.gender || element["gender"]==2){
          setState(() {
            selectedList.add(element.id);
            dummyList.add({"id":element.id,"name":element["salon_name"]});
          });
        }
      });
    });
    setState(() {
      loading = false;
    });

  }
  TextEditingController searchController = TextEditingController();
  List items=[];

  Widget specialListViewAllWidget() {
    return SizedBox(
      height: 520.h,
      child:
      selectedList.isEmpty?Center(child: Text("Sorry, \nCurrently no salon in your city \nwill be available soon",style:
      TextStyle(fontWeight: FontWeight.bold,fontSize: 16.w))):searchResult.length != 0 || searchController.text.isNotEmpty?ListView.builder(
        shrinkWrap: true,
        itemCount: searchResult.length,
        itemBuilder: (BuildContext context, int i) {
          return FutureBuilder(
              future: FirebaseFirestore.instance.collection("owners").doc(searchResult[i]).get(),
              builder: (context, snapshot) {
                if(snapshot.connectionState==ConnectionState.waiting){
                  return buildShimmerItems();
                }
                else {
                  var value = snapshot.data!;
                  return GestureDetector(
                    onTap: () {
                      BHDetailScreen( id: value.id,name:value["salon_name"],status:value["status"],phone:value["phone"],reviews:value["reviews"],gender:widget.gender).launch(context);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: whiteColor,
                          border: value["premium"]?Border.all(color: Color(0xFFffd700),width: 1.5):null,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5.w,
                            vertical: 10.w),
                        // margin: EdgeInsets.only(left: 10.w,
                        //     right: 10.w,
                        //     bottom: 10.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(15)),
                              child: commonCacheImageWidget(value["image"], 80,
                                  width: context.width() * 0.27,
                                  fit: BoxFit.cover),
                            ),
                            10.width,
                            Container(
                              margin: EdgeInsets.only(top: 5.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    value["salon_name"],
                                    style: TextStyle(fontSize: 14.w,
                                        color: BHAppTextColorPrimary,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  5.height,
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          size: 14,
                                          color: BHAppTextColorSecondary),
                                      Container(
                                        width: 200.w,
                                        child: Text(value["address"] + "," +
                                            value["city"],
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: BHGreyColor)),
                                      ),
                                    ],
                                  ),
                                  7.height,
                                  Row(
                                    children: [
                                      Text(value["reviews"].toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: BHGreyColor)),
                                      Padding(
                                          padding: EdgeInsets.only(left: 4),
                                          child: Icon(Icons.star,
                                              size: 14, color: BHColorPrimary)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),

                          ],
                        ),
                      ),
                    ),
                  );
                }
              }
          );
        },
      ):
      Container(
        height: 500.h,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: selectedList.length,
          itemBuilder: (BuildContext context, int index) {
            return FutureBuilder(
              future: FirebaseFirestore.instance.collection("owners").doc(selectedList[index]).get(),
              builder: (context, snapshot) {
                if(snapshot.connectionState==ConnectionState.waiting){
                  return buildShimmerItems();
                }
                else {
                  var value = snapshot.data!;
                  return GestureDetector(
                    onTap: () {
                      BHDetailScreen( id: value.id,name:value["salon_name"],status:value["status"],phone:value["phone"],reviews:value["reviews"], gender: widget.gender,).launch(context);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: whiteColor,
                          border: value["premium"]?Border.all(color: Color(0xFFffd700),width: 2):null,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5.w,
                            vertical: 10.w),
                        // margin: EdgeInsets.only(left: 10.w,
                        //     right: 10.w,
                        //     bottom: 10.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(15)),
                              child: commonCacheImageWidget(value["image"], 80,
                                  width: context.width() * 0.27,
                                  fit: BoxFit.cover),
                            ),
                            10.width,
                            Container(
                              margin: EdgeInsets.only(top: 5.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    value["salon_name"],
                                    style: TextStyle(fontSize: 14.w,
                                        color: BHAppTextColorPrimary,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  5.height,
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          size: 14,
                                          color: BHAppTextColorSecondary),
                                      Container(
                                        width: 200.w,
                                        child: Text(value["address"] + "," +
                                            value["city"],
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: BHGreyColor)),
                                      ),
                                    ],
                                  ),
                                  7.height,
                                  Row(
                                    children: [
                                      Text(value["reviews"].toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: BHGreyColor)),
                                      Padding(
                                          padding: EdgeInsets.only(left: 4),
                                          child: Icon(Icons.star,
                                              size: 14, color: BHColorPrimary)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),

                          ],
                        ),
                      ),
                    ),
                  );
                }
              }
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: BHColorPrimary,
        title: Text("Salon Lists", style: TextStyle(color: BHAppTextColorPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            finish(context);
          },
          child: Icon(Icons.arrow_back, color: blackColor),
        ),
      ),
      body: loading?Center(child: buildShimmerItems(),):Column(
        children: [
          Container(
            height: 80.h,
            padding: EdgeInsets.symmetric(vertical: 16.h,horizontal: 10.w),
            child: TextFormField(
              autocorrect: true,
              controller: searchController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                hintText: 'Find salon',
                prefixIcon: Icon(Icons.search, color: BHGreyColor),
                hintStyle: TextStyle(color: BHGreyColor),
                fillColor: Colors.white70,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: BHAppDividerColor, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: BHAppDividerColor, width: 1),
                ),
              ),
              onChanged: (val){
                  onSearchTextChanged(val);
              },
            ),
          ),
          specialListViewAllWidget(),
        ],
      )

    );
  }
 void onSearchTextChanged(String text) async {
    searchResult.clear();
    if (text=="") {
      setState(() {});
      return;
    }
    print(dummyList);

    dummyList.forEach((userDetail) async{
      if (userDetail["name"].toLowerCase().contains(text)) {
        searchResult.add(userDetail["id"]);
      }
    });
    setState(() {
    });
  }
}
