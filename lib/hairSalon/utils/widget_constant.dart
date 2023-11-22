import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/screens/BHLoginScreen.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';
import '../../main/utils/shimmer.dart';
import 'BHColors.dart';
import 'BHConstants.dart';


Widget TextCenter(EdgeInsets margin , String text , Color color){
  return Container(
    margin: margin,
    alignment: Alignment.centerLeft,
    child: Text(text, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.bold)),

  );
}

Widget ProfileOwner(IconData icon ,String text ){
     return Container(
       color: Colors.white,
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Row(
             children: [
               Container(
                 decoration:BoxDecoration(borderRadius: BorderRadius.circular(50),
                     color: BHColorPrimary),
                 padding: EdgeInsets.all(7),
                 child: Icon(
                   icon,
                   color: Colors.white,
                   size: 25.w,
                 ),
               ),
               8.width,
               Text(text,
                   style: TextStyle(
                       color: BHAppTextColorSecondary,
                       fontSize: 15.w,fontWeight: FontWeight.bold)),
             ],
           ),
           // Image.asset(BHInformationIcon, height: 23, width: 23,color: BHColorPrimary),
           Icon(Icons.arrow_forward_ios,size: 18.w,)
         ],
       ),
     );
}
Future getLocations(String address)async{
  List<Location> locations = await locationFromAddress(address);
  return locations;
}

Widget labelText(String s) {
  return Container(
    margin: EdgeInsets.only(left: 25.w, top: 15.h),
    child: Text(
      s,
      style: TextStyle(
          color: Colors.black,
          fontSize: 14.w,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2),
    ),
  );
}
Widget buildShimmerItems() => Container(
  height: 300.h,
  child:   ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
      itemCount: 3,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return const ShimmerWidget();
      }),
);

Widget forms({required TextEditingController controller, required String choice}) {
  return Container(
    margin: EdgeInsets.only(left: 20.w, right: 20.w,top: 0),
    child: TextFormField(
      controller: controller,
      keyboardType: choice=="Number"?TextInputType.number:TextInputType.text,
      decoration: InputDecoration(
        prefixStyle: TextStyle(fontSize: 16),
        fillColor: Colors.grey.shade200,
        isDense:true,
        contentPadding:
        EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
        hintStyle: TextStyle(
          fontSize: 15,
          color: Color(0xff8d8d8d),
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        prefixIconColor: Color(0xff4f4f4f),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: BHAppDividerColor)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: BHAppDividerColor)),
      ),
      validator: (value) {
        if (value != null) {
          return null;
        } else
          return 'Field cannot be empty';
      },
    ),
  );
}
Future<bool> onWillPop(BuildContext context) async {
  return (
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('Do you want to exit an App'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
              child: new Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // <-- SEE HERE
              child: new Text('Yes'),
            ),
          ],
        ),
      )) ??
      false;
}

Future onPrevBtn(BuildContext context) async {
  return (
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('Do you want to return to login screen?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: new Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) => BHLoginScreen()), (route) => false);
                },
              child: new Text('Yes'),
            ),
          ],
        ),
      )) ??
      false;
}
Future<bool> handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    Fluttertoast.showToast(
        msg: "Location services are disabled. Please enable the services", timeInSecForIosWeb: 4);
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Fluttertoast.showToast(
          msg: "Location permissions are denied", timeInSecForIosWeb: 4);
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    Fluttertoast.showToast(
        msg: "Location permissions are permanently denied, we cannot request permissions.", timeInSecForIosWeb: 4);
    return false;
  }
  return true;
}
  Widget showTimings(String day , String timings){
  return Container(
    padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 5.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(day, style: TextStyle(color: Colors.black, fontSize: 14)),
        Text(timings, style: TextStyle(color: BHAppTextColorSecondary, fontSize: 14))
      ],
    ),
  );
}

Widget prevNext(String title){
  return Container(
    alignment: Alignment.center,
    margin: EdgeInsets.symmetric(vertical: 5.h,horizontal: 5.w),
    padding: EdgeInsets.symmetric(vertical: 10.h),
    width: 80.w,
    decoration: BoxDecoration(
        color: Colors.blueAccent, borderRadius: BorderRadius.circular(5)),
    child:
    Text(title, style: TextStyle(color: whiteColor, fontSize: 15.w)),
  );
}

Widget multiLineForm({required TextEditingController controller, required int lines}){
  return Container(
    margin: EdgeInsets.only(left: 20.w, right: 20.w),
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      maxLines: lines,
      decoration: InputDecoration(
        fillColor: Colors.grey.shade200,
        isDense: true,
        contentPadding:
        EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
        hintStyle: TextStyle(
          fontSize: 15,
          color: Color(0xff8d8d8d),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        prefixIconColor: Color(0xff4f4f4f),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: BHAppDividerColor)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: BHAppDividerColor)),
      ),
      validator: (value) {
        if (value != null) {
          return null;
        } else{
          return 'Field cannot be empty';
        }
      },
    ),
  );
}

Widget BoxForms(TextEditingController controller ,String hint,String choice){
  return TextFormField(
    controller: controller,
    keyboardType: choice=="alpha"?TextInputType.text:TextInputType.number,
    decoration: InputDecoration(
      border: new OutlineInputBorder(
          borderSide: new BorderSide(color: Colors.grey)),
      fillColor: Colors.grey.shade200,
      contentPadding:
      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 15,
        color: Color(0xff8d8d8d),
      ),
      prefixIconColor: Color(0xff4f4f4f),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: BHColorPrimary)),
    ),
    validator: (value) {
      if (value=="") {
        return 'Field Cannot be Empty!';
      }
      return null;
    },
  );
}






