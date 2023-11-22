import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';
import 'package:salon/admin/admin_home.dart';
import 'package:salon/hairSalon/screens/BHDashedBoardScreen.dart';
import 'package:salon/owner/forms/owner_stepper.dart';
import 'package:salon/owner/owner_dahboard.dart';

import '../utils/BHImages.dart';
import 'BHLoginScreen.dart';
import 'BHWalkThroughScreen.dart';

class BHSplashScreen extends StatefulWidget {
  static String tag = '/BHSplashScreen';

  @override
  BHSplashScreenState createState() => BHSplashScreenState();
}

class BHSplashScreenState extends State<BHSplashScreen> {
  bool owner =false;
  bool step =false;
  bool admin = false;
  getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('owner')){
      owner = prefs.getBool('owner')!;
    }
    if(prefs.containsKey('step')){
      step= prefs.getBool('step')!;
    }
    if(prefs.containsKey('admin')){
      admin= prefs.getBool('admin')!;
    }
  }

  @override
  void initState() {
    super.initState();
    getBoolValuesSF();
    Timer(Duration(seconds: 2), () {
      if(FirebaseAuth.instance.currentUser!=null){
        if(admin){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AdminHome()));
        }
        else if(owner && step){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OwnerDashedBoard()));
        }
        else if(owner){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OwnerStepper()));
        }
        else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BHDashedBoardScreen()));
        }
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BHWalkThroughScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("images/hairSalon/bh_logo.jpeg", height: 320.h, width: 310.w),
      ),
    );
  }
}