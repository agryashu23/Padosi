import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart';

import '../model/BHModel.dart';
import '../utils/BHColors.dart';
import '../utils/BHConstants.dart';
import '../utils/BHImages.dart';
import '../utils/widget_constant.dart';
import 'BHBookAppointmentScreen.dart';
import 'load_widget.dart';

class BHPackageOffersScreen extends StatefulWidget {
  static String tag = '/PackageOffersScreen';

  BHPackageOffersScreen({required this.id ,required this.ownerId, required this.gender});

  final String id;
  final String ownerId;
  final int gender;

  @override
  BHPackageOffersScreenState createState() => BHPackageOffersScreenState();
}

class BHPackageOffersScreenState extends State<BHPackageOffersScreen> {

  @override
  void initState() {
    super.initState();
  }
  List times=[];
  String slot="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            finish(context);
          },
          child: Icon(Icons.arrow_back,color: Colors.white,),
        ),
        title: Text("Package Details",style: TextStyle(fontSize: 16.w,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("services").doc(widget.ownerId).collection("package").doc(widget.id).get(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return BHLoading();
          }
          var value = snapshot.data!;
          return Stack(
            children: <Widget>[
              Image.network(
                value["image"],
                height: 200.h,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                margin: EdgeInsets.only(top: 175.h),
                padding: EdgeInsets.all(16.w),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16),
                  ),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(value["name"], style: TextStyle(fontSize: 16, color: BHAppTextColorSecondary, fontWeight: FontWeight.bold)),
                          Text('\u{20B9} ${value["price"]}', style: TextStyle(color: BHColorPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      8.height,
                      Divider(color: BHAppDividerColor),
                      8.height,
                      Text(BHTxtServicesInclude, style: TextStyle(color: BHAppTextColorPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                      ListView.builder(
                          itemCount: value["services"].length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 16),
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 5.w),
                              child: Text(value["services"][index], style: TextStyle(color: Colors.black, fontSize: 14)),
                            );
                          }),
                      8.height,
                      Divider(color: BHAppDividerColor),
                      6.height,
                      Text("Duration", style: TextStyle(color: BHAppTextColorPrimary, fontWeight: FontWeight.bold, fontSize: 16.w)),
                      5.height,
                      Text(value["duration"]+" min", style: TextStyle(color: BHAppTextColorPrimary, fontSize: 14.w,fontWeight: FontWeight.w400)),
                      18.height,
                      Text("About", style: TextStyle(color: BHAppTextColorPrimary, fontWeight: FontWeight.bold, fontSize: 16.w)),
                      8.height,
                      Text(value["desc"], style: TextStyle(color: BHAppTextColorPrimary, fontSize: 14.w,fontWeight: FontWeight.w400)),
                      10.height,
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: BHColorPrimary,

                        ),
                        child: TextButton(
                          onPressed: () async{
                            await FirebaseFirestore.instance.collection("owners").doc(widget.ownerId).get().then((value){
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
                            List package=[];
                            package.add({"image":value["image"],"name":value["name"],"duration":value["duration"],"price":value["price"]});
                            // print(slot);
                            // print(day);
                            BHBookAppointmentScreen(time:times,day:day,slot:slot,packages:package,services:[],id:widget.ownerId,gender: widget.gender,).launch(context);
                          },
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(10.0),
                          // ),
                          child: Text(BHBtnBookAppointment, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),

                      //16.height,
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
