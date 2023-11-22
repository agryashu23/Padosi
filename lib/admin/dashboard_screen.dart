import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int users=0;
  int salons = 0;
  int bookings=0;
  int online=0;
  int offline =0;
  int completed=0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async{
    await FirebaseFirestore.instance.collection("bookings").get().then((value) {
      print(value);
      value.docs.forEach((element) {
        print(element.id);
        FirebaseFirestore.instance.collection("bookings").doc(element.id.toString()).collection("booking").get().then((value2) {
          value2.docs.forEach((element2) {
            setState(() {
              if(element2["status"]=="pending"){
                bookings+=1;
              }
              else{
                completed+=1;
              }

              if(element2['mode']=="online"){
                online+=int.parse(element2["price"].toString());
              }
              else{
                offline+=int.parse(element2["price"].toString());
              }
            });
          });
        });
      });
      setState(() {
        loading=false;
      });
    });

  }
  Future getList()async{
     await FirebaseFirestore.instance.collection("users").get().then((value) {
       users = value.docs.length;
     });
     await FirebaseFirestore.instance.collection("owners").get().then((value) {
       salons = value.docs.length;
     });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: loading?Center(child: CircularProgressIndicator(),):FutureBuilder(
        future: getList(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
    if (snapshot.connectionState == ConnectionState.done) {
      return Container(
        height: 520.h,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 80.h,
                    width: 150.w,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Total Users", style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.w,
                            fontWeight: FontWeight.bold),),
                        15.height,
                        Text(users.toString(), style: TextStyle(color: BHColorPrimary,
                            fontSize: 20.w,
                            fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 80.h,
                    width: 150.w,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Total Salons", style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.w,
                            fontWeight: FontWeight.bold),),
                        15.height,
                        Text(salons.toString(), style: TextStyle(color: BHColorPrimary,
                            fontSize: 20.w,
                            fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            20.height,
            Card(
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade100
                ),
                height: 90.h,
                width: 300.w,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Upcoming Bookings", style: TextStyle(color: Colors.black,
                        fontSize: 17.w,
                        fontWeight: FontWeight.bold),),
                    15.height,
                    Text(bookings.toString(), style: TextStyle(color: BHColorPrimary,
                        fontSize: 20.w,
                        fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ),
            20.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 80.h,
                    width: 150.w,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Online Payment", style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.w,
                            fontWeight: FontWeight.bold),),
                        15.height,
                        Text(online.toString(), style: TextStyle(color: BHColorPrimary,
                            fontSize: 20.w,
                            fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 80.h,
                    width: 150.w,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Offline Payment", style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.w,
                            fontWeight: FontWeight.bold),),
                        15.height,
                        Text(offline.toString(), style: TextStyle(color: BHColorPrimary,
                            fontSize: 20.w,
                            fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            20.height,
            Card(
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade100
                ),
                height: 90.h,
                width: 300.w,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Completed Bookings", style: TextStyle(color: Colors.black,
                        fontSize: 17.w,
                        fontWeight: FontWeight.bold),),
                    15.height,
                    Text(completed.toString()
                      , style: TextStyle(color: BHColorPrimary,
                        fontSize: 20.w,
                        fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    else{
      return Center(child: CircularProgressIndicator(),);
    }
        }
      ),
    );
  }
}
