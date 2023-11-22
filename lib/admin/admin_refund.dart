import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';

import '../hairSalon/utils/BHConstants.dart';

class AdminRefund extends StatefulWidget {
  const AdminRefund({Key? key}) : super(key: key);

  @override
  State<AdminRefund> createState() => _AdminRefundState();
}

class _AdminRefundState extends State<AdminRefund> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Refund Details"),
          centerTitle: true,
          backgroundColor: BHColorPrimary,
        ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("refund").snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child:CircularProgressIndicator());
          }
          else if(!snapshot.hasData){
            print("ans");
            return Center(child: Text("No Data Found",style: TextStyle(fontSize: 18.w,fontWeight:FontWeight.bold,color: Colors.black),),);
          }
          else{
            var value = snapshot.data!.docs;
            return Container(
                color: BHGreyColor.withOpacity(0.1),
                child: ListView.builder(
                    itemCount: value.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(5.w),
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        child: SingleChildScrollView(
                          child: Column(
                            children:[
                              Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: whiteColor,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 5.w),
                                              width: 130.w,
                                              child: Text(value[index]["user_name"],
                                                  style: TextStyle(
                                                      fontSize: 15.w,
                                                      color: BHAppTextColorPrimary,
                                                      fontWeight: FontWeight.bold)),
                                            ),
                                            4.height,
                                            Container(width: 130.w,
                                              child: Text(
                                                  value[index]["user_phone"],
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: BHGreyColor)),
                                            ),

                                          ],
                                        ),
                                        Container(
                                          width: 140.w,
                                          child: Text(
                                            "Appointment ID #${value[index]["booking_id"]}",
                                            style: TextStyle(
                                                fontSize: 14.w,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600 ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(height: 5.h,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 4),
                                          child: Text('UPI No.',
                                              style:
                                              TextStyle(
                                                  color: Colors.black, fontSize: 13.w,fontWeight: FontWeight.bold)),
                                        ),
                                        Text("${value[index]["upi"]}",
                                            style: TextStyle(
                                                color: BHAppTextColorPrimary,
                                                fontSize: 13.w)),
                                      ],
                                    ),
                                    5.height,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 4),
                                          child: Text('UPI-Id',
                                              style:
                                              TextStyle(
                                                  color: Colors.black, fontSize: 13.w,fontWeight: FontWeight.bold)),
                                        ),
                                        Text("${value[index]["upi_id"]}",
                                            style: TextStyle(
                                                color: BHAppTextColorPrimary,
                                                fontSize: 13.w)),
                                      ],
                                    ),
                                    5.height,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 4),
                                          child: Text('Account No.',
                                              style:
                                              TextStyle(
                                                  color: Colors.black, fontSize: 13.w,fontWeight: FontWeight.bold)),
                                        ),
                                        Text("${value[index]["account"]}",
                                            style: TextStyle(
                                                color: BHAppTextColorPrimary,
                                                fontSize: 13.w)),
                                      ],
                                    ),
                                    5.height,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 4),
                                          child: Text('IFSC Code',
                                              style:
                                              TextStyle(
                                                  color: Colors.black, fontSize: 13.w,fontWeight: FontWeight.bold)),
                                        ),
                                        Text("${value[index]["ifsc"]}",
                                            style: TextStyle(
                                                color: BHAppTextColorPrimary,
                                                fontSize: 13.w)),
                                      ],
                                    ),
                                    5.height,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 4),
                                          child: Text('Refund',
                                              style:
                                              TextStyle(
                                                  color: Colors.black, fontSize: 15.w,fontWeight: FontWeight.bold)),
                                        ),
                                        Text("\u{20B9}${value[index]["price"]}",
                                            style: TextStyle(
                                                color: BHAppTextColorPrimary,
                                                fontSize: 15.w,fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    5.height,
                                    Center(
                                      child: GestureDetector(
                                        onTap:()async{
                                          String ids="";
                                          showDialog<void>(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  contentTextStyle: TextStyle(color: BHAppTextColorSecondary),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                                                  actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
                                                  title: Text("Completed Refund", style: TextStyle(fontSize: 16, color: BHAppTextColorPrimary)),
                                                  content: Text("Are you sure refund is completed", style: TextStyle(fontSize: 14, color: BHAppTextColorSecondary)),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text(BHBtnYes, style: TextStyle(color: Colors.blue, fontSize: 14)),
                                                      onPressed: () async {
                                                        await FirebaseFirestore.instance.collection("cancelled").where("booking_id",isEqualTo: value[index]["booking_id"]).get().then((value) {
                                                          value.docs.forEach((element) {
                                                            ids = element.id;
                                                          });
                                                        });
                                                        await FirebaseFirestore.instance.collection("cancelled").doc(ids).update({
                                                          "mode":"completed",
                                                        });
                                                        await FirebaseFirestore.instance.collection("refund").doc(value[index].id).delete();
                                                        Navigator.of(context).pop();
                                                        Fluttertoast.showToast(msg: "Refund Completed");
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text(BHBtnNo, style: TextStyle(color: Colors.blue, fontSize: 14)),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });

                                        },
                                        child: Card(
                                          elevation: 5.0,
                                          child: Container(
                                            padding:EdgeInsets.symmetric(horizontal: 10.w,vertical: 7.h),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                            ),
                                            child: Text("Completed",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                          ),
                                        ),
                                      ),
                                    ),
                                    10.height,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }));
          }
        }
      ),
    );
  }
}
