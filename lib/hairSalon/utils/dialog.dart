import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/BHLoginScreen.dart';
import 'BHColors.dart';
import 'BHConstants.dart';


Future  ShowDialog1(BuildContext context) async {
  return AwesomeDialog(
    context: context,
    animType: AnimType.scale,
    dialogType: DialogType.info,
    title: BHTxtLogoutDialog,
    titleTextStyle: TextStyle(fontSize: 16, color: BHAppTextColorPrimary),
    desc:  BHTxtLogoutMsg,
    descTextStyle: TextStyle(fontSize: 14, color: BHAppTextColorSecondary),
    btnOkColor: Colors.blue,
    btnOkOnPress: () async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('owner', false);
      prefs.setBool('step', false);
      FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BHLoginScreen()), (route) => false);
    },
    btnCancelOnPress: (){
    },
  )..show();
}

Future  ShowDialog3(BuildContext context) async {
  return AwesomeDialog(
    context: context,
    animType: AnimType.scale,
    dialogType: DialogType.info,
    title: BHTxtLogoutDialog,
    titleTextStyle: TextStyle(fontSize: 16, color: BHAppTextColorPrimary),
    desc:  BHTxtLogoutMsg,
    descTextStyle: TextStyle(fontSize: 14, color: BHAppTextColorSecondary),
    btnOkColor: Colors.blue,
    btnOkOnPress: () async{
      FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BHLoginScreen()), (route) => false);
    },
    btnCancelOnPress: (){
    },
  )..show();
}

Future  ShowDialog4(BuildContext context) async {
  return AwesomeDialog(
    context: context,
    animType: AnimType.scale,
    dialogType: DialogType.success,
    title: "Appointment Created",
    titleTextStyle: TextStyle(fontSize: 16, color: BHAppTextColorPrimary),
    descTextStyle: TextStyle(fontSize: 14, color: BHAppTextColorSecondary),
  )..show();
}