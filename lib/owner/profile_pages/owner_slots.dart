import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/screens/load_widget.dart';

import '../../hairSalon/utils/BHColors.dart';
import 'owner_changeSlot.dart';

class OwnerTimeSlots extends StatefulWidget {
  static String tag = '/OwnerTimeSlots';

  const OwnerTimeSlots({Key? key}) : super(key: key);

  @override
  State<OwnerTimeSlots> createState() => _OwnerTimeSlotsState();
}

class _OwnerTimeSlotsState extends State<OwnerTimeSlots> {
  Widget TimeSlot(String title , String text,int index){
    return  Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      margin: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
      height: 90.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            title: Text(title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
            trailing: GestureDetector(
                onTap: ()async{
                    await OwnerChangeSlot(title:title, idx:index).launch(context);
                    setState(() {

                    });
                },
                child: Icon(Icons.edit_note_sharp,size: 35.w,color: Colors.blue,)),
          ),
          10.height,
          Text(text,style: TextStyle(fontSize: 18.w,color: BHColorPrimary,fontWeight: FontWeight.bold),)

        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: BHColorPrimary,
          title: Text("Time Slot"),
          centerTitle: true,
        ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("owners").doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder: (context,snapshot) {
          if(snapshot.hasData) {
            var value = snapshot.data!;
            return ListView.builder(
                itemCount:value['timeslots'].length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return TimeSlot(value["timeslots"][index]["title"],value["timeslots"][index]["timing"],index);
                }
            );
          }
          else{
            return Center(child: BHLoading());
          }
        }
      ),
    );
  }
}
