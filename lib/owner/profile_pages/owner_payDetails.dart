import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';

class OwnerPayDetails extends StatefulWidget {
  const OwnerPayDetails({Key? key}) : super(key: key);

  @override
  State<OwnerPayDetails> createState() => _OwnerPayDetailsState();
}

class _OwnerPayDetailsState extends State<OwnerPayDetails> {
  int online=0;
  int offline=0;

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  getInfo() async{
    await FirebaseFirestore.instance.collection("payments").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      setState(() {
        online = value["online"];
        offline = value["offline"];
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    // getInfo();
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Details"),
        centerTitle: true,
        backgroundColor: BHColorPrimary,
      ),
      body:Column(
              children: [
                80.height,
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 25.w),
                  elevation: 5,
                  child: Column(
                    children: [
                      20.height,
                      Center(child: Text("Online Payment due-", style: TextStyle(
                          fontSize: 18.w, fontWeight: FontWeight.bold),)),
                      10.height,
                      Center(child: Text(online.toString(), style: TextStyle(
                          fontSize: 18.w,
                          fontWeight: FontWeight.bold,
                          color: BHColorPrimary),)),
                      20.height,

                    ],
                  ),
                ),
                80.height,
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 25.w),
                  elevation: 5,
                  child: Column(
                    children: [
                      20.height,

                      Center(child: Text("Offline Payment due-", style: TextStyle(
                          fontSize: 18.w, fontWeight: FontWeight.bold),)),
                      10.height,
                      Center(child: Text(offline.toString(), style: TextStyle(
                          fontSize: 18.w,
                          fontWeight: FontWeight.bold,
                          color: BHColorPrimary),)),
                      20.height,

                    ],
                  ),
                )


              ],
            ),
    );
  }

}
