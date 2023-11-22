import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/admin/Admin_Notifications/show_notifications.dart';

import '../../hairSalon/utils/BHColors.dart';

class AddNotifications extends StatefulWidget {
  const AddNotifications({Key? key}) : super(key: key);

  @override
  State<AddNotifications> createState() => _AddNotificationsState();
}

class _AddNotificationsState extends State<AddNotifications> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add Notifications"),
        backgroundColor: BHColorPrimary,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: (){
              ShowNotifications().launch(context);
            },
            child: Container(
              margin: EdgeInsets.only(right: 10.w,top: 6.h,bottom: 6.h),
              color: Colors.blue.shade500,
              width: 70.w,
              alignment: Alignment.center,
              child: Text("Show"),
            ),
          )
        ],
      ),
      body:Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            8.height,
            Text("Title",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.w,letterSpacing: 0.4),),
            8.height,
            TextFormField(
              controller: titleController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey)),
                fillColor: Colors.grey.shade200,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                hintText: "Add Title",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Color(0xff8d8d8d),
                ),
                prefixIconColor: Color(0xff4f4f4f),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: BHColorPrimary)),
              ),
            ),
            20.height,
            Text("Subject",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 19.w,letterSpacing: 0.4),),
            8.height,
            TextFormField(
              controller: subtitleController,
              keyboardType: TextInputType.text,
              maxLines: 3,
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey)),
                fillColor: Colors.grey.shade200,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                hintText: "Add Subject",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Color(0xff8d8d8d),
                ),
                prefixIconColor: Color(0xff4f4f4f),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: BHColorPrimary)),
              ),
            ),
            10.height,
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: BHColorPrimary,
              ),
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                onPressed: () async{
                  if(titleController.text.isEmpty || subtitleController.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text("Enter All Details"),));
                  }
                  else{
                    await FirebaseFirestore.instance.collection("notifications").add({
                        "title":titleController.text,
                        "subtitle":subtitleController.text
                    });
                  }
                },
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Text("Create Notification", style: TextStyle(color: whiteColor, fontSize: 17, fontWeight: FontWeight.bold)),
              ),
            ),



          ],
        ),
      ),
    );
  }
}
