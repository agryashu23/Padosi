import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/screens/BHDashedBoardScreen.dart';
import 'package:salon/hairSalon/screens/step_appointment.dart';
import 'package:salon/hairSalon/utils/dialog.dart';
import 'package:time_slot/controller/day_part_controller.dart';
import '../../main/utils/AppWidget.dart';
import '../utils/BHColors.dart';
import '../utils/BHConstants.dart';
import '../utils/BHImages.dart';

class BHBookAppointmentScreen extends StatefulWidget {
  static String tag = '/BookAppointmentScreen';

  BHBookAppointmentScreen(
      {required this.time,
      required this.day,
      required this.slot,
      required this.packages,
      required this.services,
      required this.id,
      required this.gender});
  final List time;
  final String day;
  final String slot;
  final List packages;
  final List services;
  final String id;
  final int gender;

  @override
  BHBookAppointmentScreenState createState() => BHBookAppointmentScreenState();
}

class BHBookAppointmentScreenState extends State<BHBookAppointmentScreen> {
  int currentStep = 0;
  bool loading = false;
  DayPartController dayPartController = DayPartController();
  bool chosen = false;

  DateTime? selectTime;

  String currslot = "";
  List finalItems = [];
  int amount = 0;
  int value1 = 0;

  @override
  void initState() {
    super.initState();
    currslot = widget.slot;
    print(widget.services);
  }

  int discount = 0;
  int percent = 0;

  Future getData() async {
    if (widget.services.isEmpty) {
      finalItems = widget.packages;
    } else {
      finalItems = widget.services;
    }

    if (amount == 0) {
      for (int i = 0; i < finalItems.length; i++) {
        amount += int.parse(finalItems[i]["price"]);
      }
    }
    int rewards = 0;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      rewards = value["rewards"];
    });
    await FirebaseFirestore.instance
        .collection("admin")
        .doc("discount")
        .get()
        .then((value) {
      if (rewards < 5) {
        percent = value["percent"];
      } else if (rewards == 5) {
        discount = value["off"];
        if (discount > amount) {
          discount = amount;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget paymentStepper() {
      return FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                            color: BHAppTextColorPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 15.w),
                      ),
                      Text(
                        widget.services.isEmpty
                            ? "${widget.packages.length} Packages"
                            : "${widget.services.length} Services",
                        style: TextStyle(
                            color: BHAppTextColorPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 15.w),
                      ),
                    ],
                  ),
                  5.height,
                  Wrap(
                    children: List.generate(finalItems.length, (index) {
                      return Card(
                        elevation: 10,
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.h, horizontal: 8.w),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: commonCacheImageWidget(
                                      widget.services.isEmpty
                                          ? finalItems[index]["image"]
                                          : BHWalkThroughImg1,
                                      55.h,
                                      width: context.width() * 0.18,
                                      fit: BoxFit.cover),
                                ),
                                10.width,
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 130.w,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            finalItems[index]["name"],
                                            style: TextStyle(
                                                color: BHAppTextColorPrimary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.w),
                                          ),
                                          7.height,
                                          Text(
                                            '\u{20B9} ${finalItems[index]["price"]}',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.w),
                                          ),
                                          7.height,
                                          Text(
                                            finalItems[index]["duration"] +
                                                ' min',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.w),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(DateFormat('dd-MM-yyyy')
                                        .format(selectTime ?? DateTime.now())),
                                    7.height,
                                    Text(DateFormat('kk:mm:a')
                                        .format(selectTime ?? DateTime.now())),
                                  ],
                                )
                              ],
                            )),
                      );
                    }),
                  ),
                  15.height,
                  Text(
                    'Bill Details',
                    style: TextStyle(
                        fontSize: 15.w,
                        color: BHAppTextColorPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    margin: EdgeInsets.only(top: 7.h),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Item Total',
                                style: TextStyle(
                                    color: BHAppTextColorPrimary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.w),
                              ),
                              Text(
                                '\u{20B9} $amount',
                                style: TextStyle(
                                    color: BHAppTextColorPrimary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.w),
                              ),
                            ],
                          ),
                          10.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Discount',
                                style: TextStyle(
                                    color: BHAppTextColorPrimary,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                percent == 0
                                    ? '\u{20B9} ${discount}'
                                    : "% ${percent}",
                                style: TextStyle(
                                    color: BHAppTextColorPrimary,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.grey.shade200,
                            thickness: 1.0,
                          ),
                          4.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'To Pay',
                                style: TextStyle(
                                    color: BHColorPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.w),
                              ),
                              Text(
                                percent == 0
                                    ? '\u{20B9} ${amount - discount}'
                                    : "\u{20B9} ${amount - (percent * amount) / 100}",
                                style: TextStyle(
                                    color: BHColorPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.w),
                              ),
                            ],
                          ),
                          3.height,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: BHColorPrimary,
        title: Text('Book Appointment',
            style: TextStyle(
                color: BHAppTextColorPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            finish(context);
          },
          child: Icon(Icons.arrow_back, color: blackColor),
        ),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        elevation: 5,
        physics: BouncingScrollPhysics(),
        controlsBuilder: (context, _) {
          return Container(
            margin: EdgeInsets.only(top: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 140.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: BHColorPrimary,
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (currentStep > 0) {
                        setState(() {
                          currentStep -= 1;
                        });
                      } else {
                        currentStep = 0;
                        finish(context);
                      }
                    },
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10.0)),
                    child: Text(BHBtnCancel,
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: BHColorPrimary,
                  ),
                  width: 140.w,
                  child: TextButton(
                    onPressed: () async {
                      if (currentStep == 0) {
                        if (currslot == "Closed") {
                          Fluttertoast.showToast(msg: "Choose Another Date");
                        } else if (selectTime == null) {
                          Fluttertoast.showToast(msg: "Please Choose Time");
                        } else {
                          setState(() {
                            currentStep += 1;
                          });
                        }
                      }
                      else {
                        String owner_name = "";
                        String owner_address = "";
                        String owner_city = "";
                        String owner_image = "";
                        String owner_phone = "";
                        String user_name = "";
                        String user_phone = "";
                        String user_image = "";
                        String user_email = "";
                        Random random = Random();
                        var code = 1000 + random.nextInt(9999 - 1000);
                        await FirebaseFirestore.instance
                            .collection("owners")
                            .doc(widget.id)
                            .get()
                            .then((value) {
                          owner_name = value["salon_name"];
                          owner_address = value["address"];
                          owner_city = value["city"];
                          owner_image = value["image"];
                          owner_phone = value["phone"];
                        });
                        List names = [];
                        for (int i = 0; i < finalItems.length; i++) {
                          names.add(finalItems[i]["name"]);
                        }
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get()
                            .then((value) {
                          user_name = value["name"];
                          user_phone = value["phone"];
                          user_image = value["image"];
                          user_email = value["email"]??"";
                        });
                        int booking_id = 0;
                        await FirebaseFirestore.instance
                            .collection("booking_id")
                            .doc("booking_id")
                            .get()
                            .then((value) {
                          booking_id = value["id"];
                        });
                        await FirebaseFirestore.instance
                            .collection("booking_id")
                            .doc("booking_id")
                            .update({"id": FieldValue.increment(1)});
                        DateTime now = DateTime.now();
                        String ans = percent == 0
                            ? '${amount - discount}'
                            : "${amount-(percent*amount)/100}";
                        double value = double.parse(ans);

                        await FirebaseFirestore.instance.collection("bookings").doc(FirebaseAuth.instance.currentUser!.uid).collection("booking").add({
                          "owner_id":widget.id,
                          "booking_time":selectTime,
                          "owner_name": owner_name,
                          "owner_address":owner_address,
                          "owner_phone":owner_phone,
                          "owner_city":owner_city,
                          "gender":widget.gender,
                          "owner_image":owner_image,
                          "name": names,
                          "booking_id":booking_id,
                          "price":value,
                          "status":"pending",
                          "mode":"offline",
                          "switch":false,
                          "created_at":now,
                          "code":code,
                        });
                        await FirebaseFirestore.instance.collection("bookings").doc(FirebaseAuth.instance.currentUser!.uid).set({
                          "a":"",
                        });
                        await FirebaseFirestore.instance.collection("salon_bookings").doc(widget.id).collection("booking").add({
                          "created_at":now,
                          "user_id":FirebaseAuth.instance.currentUser!.uid,
                          "user_name":user_name,
                          "user_phone":user_phone,
                          "user_image":user_image,
                          "gender":widget.gender,
                          "name": names,
                          "booking_id":booking_id,
                          "price":value,
                          "status":"pending",
                          "mode":"offline",
                          "booking_time":selectTime,
                          "code":code,
                        });
                        await ShowDialog4(context);
                        Timer(Duration(seconds: 2), () async {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) => BHDashedBoardScreen()), (
                                  route) => false);
                        });

                        // await showModalBottomSheet(
                        //     context: context,
                        //     builder: (context) {
                        //       return StatefulBuilder(// this is new
                        //           builder: (BuildContext context,
                        //               StateSetter setState) {
                        //         return Container(
                        //           height: 200.h,
                        //           child: Column(
                        //             children: [
                        //               GestureDetector(
                        //                 onTap: () {
                        //                   setState(() {
                        //                     value1 = 1;
                        //                   });
                        //                 },
                        //                 child: ListTile(
                        //                   dense:true,
                        //                   leading: Icon(
                        //                     Icons.paypal,
                        //                     size: 35,
                        //                   ),
                        //                   title: Text("Online Payment",style: TextStyle(fontSize: 15.w,fontWeight: FontWeight.bold),),
                        //                   subtitle: Text( percent == 0
                        //                       ? '\u{20B9} ${amount - discount}'
                        //                       : "\u{20B9} ${amount - (percent * amount) / 100}",style: TextStyle(fontSize: 14.w,color: Colors.blue),),
                        //                   trailing: value1==1?Icon(
                        //                     Icons.check_circle,
                        //                     color: BHColorPrimary,
                        //                   ):null,
                        //                 ),
                        //               ),
                        //               Divider(),
                        //               GestureDetector(
                        //                 onTap: () {
                        //                   setState(() {
                        //                     value1 = 2;
                        //                   });
                        //                 },
                        //                 child: ListTile(
                        //                   dense:true,
                        //                   leading: Icon(
                        //                     Icons.payment,
                        //                     size: 35,
                        //                   ),
                        //                   title: Text("Cash on Delivery",style: TextStyle(fontSize: 15.w,fontWeight: FontWeight.bold),),
                        //                   subtitle: Text('\u{20B9} $amount',style: TextStyle(fontSize: 14.w,color: Colors.blue),),
                        //                   trailing: value1==2?Icon(
                        //                     Icons.check_circle, color: BHColorPrimary,
                        //                   ):null,
                        //                 ),
                        //               ),
                        //               10.height,
                        //               Container(
                        //                 decoration: BoxDecoration(
                        //                   borderRadius: BorderRadius.circular(10),
                        //                   color: BHColorPrimary,
                        //                 ),
                        //                 width: 200.w,
                        //                 child: TextButton(
                        //                   onPressed: () async{
                        //                     if(value1==0){
                        //                       Fluttertoast.showToast(msg: "Choose one option");
                        //                     }
                        //                     else if(value1==2){
                        //                       await FirebaseFirestore.instance.collection("bookings").doc(FirebaseAuth.instance.currentUser!.uid).collection("booking").add({
                        //                         "owner_id":widget.id,
                        //                         "booking_time":selectTime,
                        //                         "owner_name": owner_name,
                        //                         "owner_address":owner_address,
                        //                         "owner_phone":owner_phone,
                        //                         "owner_city":owner_city,
                        //                         "gender":widget.gender,
                        //                         "owner_image":owner_image,
                        //                         "name": names,
                        //                         "booking_id":booking_id,
                        //                         "price":amount,
                        //                         "status":"pending",
                        //                         "mode":"offline",
                        //                         "switch":false,
                        //                         "created_at":now,
                        //                         "code":code,
                        //                       });
                        //                       await FirebaseFirestore.instance.collection("bookings").doc(FirebaseAuth.instance.currentUser!.uid).set({
                        //                         "a":"",
                        //                       });
                        //                       await FirebaseFirestore.instance.collection("salon_bookings").doc(widget.id).collection("booking").add({
                        //                         "created_at":now,
                        //                         "user_id":FirebaseAuth.instance.currentUser!.uid,
                        //                         "user_name":user_name,
                        //                         "user_phone":user_phone,
                        //                         "user_image":user_image,
                        //                         "gender":widget.gender,
                        //                         "name": names,
                        //                         "booking_id":booking_id,
                        //                         "price":amount,
                        //                         "status":"pending",
                        //                         "mode":"offline",
                        //                         "booking_time":selectTime,
                        //                         "code":code,
                        //                       });
                        //                       Fluttertoast.showToast(msg: "Appointment Created");
                        //                       Navigator.pushAndRemoveUntil(context,
                        //                           MaterialPageRoute(builder: (context) => BHDashedBoardScreen()), (
                        //                               route) => false);
                        //                     }
                        //                     else{
                        //                       String orderId = DateTime.now().millisecondsSinceEpoch.toString();
                        //                       String ans = percent == 0
                        //                           ? '${amount - discount}'
                        //                           : "${amount-(percent*amount)/100}";
                        //                       var response = await PayumoneyProUnofficial.payUParams(
                        //                           email: user_email,
                        //                           firstName: user_name,
                        //                           merchantName: 'Salon Pe',
                        //                           isProduction: false,
                        //                           merchantKey:
                        //                           'aMjd3w', //You will find these details from payumoney dashboard
                        //                           merchantSalt: 'Mi1OuBYGhfhDYlXWlhmkwxqJ1STvZvbb',
                        //                           amount: ans,
                        //                           productInfo: 'Booking', // Enter Product Name
                        //                           transactionId: orderId, //Every Transaction should have a unique ID
                        //                           hashUrl: '',
                        //                           userCredentials: 'aMjd3w'"agryashu23@gmail.com",
                        //                           showLogs: true,
                        //                           userPhoneNumber: user_phone.substring(3));
                        //                       if (response['status'] == PayUParams.success){
                        //                         await FirebaseFirestore.instance.collection("bookings").doc(FirebaseAuth.instance.currentUser!.uid).collection("booking").add({
                        //                           "owner_id":widget.id,
                        //                           "booking_time":selectTime,
                        //                           "owner_name": owner_name,
                        //                           "owner_address":owner_address,
                        //                           "owner_phone":owner_phone,
                        //                           "owner_city":owner_city,
                        //                           "gender":widget.gender,
                        //                           "owner_image":owner_image,
                        //                           "name": names,
                        //                           "booking_id":booking_id,
                        //                           "price":amount,
                        //                           "status":"pending",
                        //                           "mode":"online",
                        //                           "switch":false,
                        //                           "created_at":now,
                        //                           "code":code,
                        //                         });
                        //                         await FirebaseFirestore.instance.collection("bookings").doc(FirebaseAuth.instance.currentUser!.uid).set({
                        //                           "a":"",
                        //                         });
                        //                         await FirebaseFirestore.instance.collection("salon_bookings").doc(widget.id).collection("booking").add({
                        //                           "created_at":now,
                        //                           "user_id":FirebaseAuth.instance.currentUser!.uid,
                        //                           "user_name":user_name,
                        //                           "user_phone":user_phone,
                        //                           "user_image":user_image,
                        //                           "gender":widget.gender,
                        //                           "name": names,
                        //                           "booking_id":booking_id,
                        //                           "price":amount,
                        //                           "status":"pending",
                        //                           "mode":"online",
                        //                           "booking_time":selectTime,
                        //                           "code":code,
                        //                         });
                        //                         Fluttertoast.showToast(msg: "Appointment Created");
                        //                         Navigator.pushAndRemoveUntil(context,
                        //                             MaterialPageRoute(builder: (context) => BHDashedBoardScreen()), (
                        //                                 route) => false);
                        //                       }
                        //                       if (response['status'] == PayUParams.failed){
                        //                         Fluttertoast.showToast(msg: "Payment Declined");
                        //                       }
                        //                     }
                        //                   },
                        //                   child: Row(
                        //                     mainAxisAlignment:MainAxisAlignment.center,
                        //                     children: [
                        //                       Text("Make Payment", style: TextStyle(color: whiteColor, fontSize: 17, fontWeight: FontWeight.bold)),
                        //                       10.width,
                        //                       Icon(Icons.arrow_forward,color:Colors.white)
                        //                     ],
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         );
                        //       });
                        //     });


                      }
                    },
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      currentStep == 0 ? BHBtnContinue : "Confirm",
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: Text("Select Date & Time",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: BHAppTextColorSecondary, fontSize: 15.w)),
            content: Container(
                width: context.width(),
                child: AppointmentStepper(
                    time: widget.time,
                    day: widget.day,
                    slot: widget.slot,
                    callback: (val) => setState(() => selectTime = val))),
            isActive: currentStep >= 0,
            state: currentStep >= 0 ? StepState.complete : StepState.disabled,
          ),
          Step(
            title: Text(BHStepperPayment,
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: BHAppTextColorSecondary, fontSize: 15.w)),
            content: paymentStepper(),
            isActive: currentStep >= 0,
            state: currentStep >= 1 ? StepState.complete : StepState.disabled,
          ),
          // Step(
          //   title: Text(BHStepperFinished, style: TextStyle(color: BHAppTextColorSecondary,fontSize: 13.w)),
          //   content: finishedStepper(),
          //   isActive: currentStep >= 0,
          //   state: currentStep >= 2 ? StepState.complete : StepState.disabled,
          // ),
        ],
        currentStep: currentStep,
        onStepTapped: (step) {
          currentStep = step;
        },
      ),
    );
  }
}

typedef void StringCallback(DateTime val);
