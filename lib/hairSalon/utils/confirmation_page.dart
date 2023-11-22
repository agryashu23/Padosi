import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

import 'BHColors.dart';


class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage({Key? key}) : super(key: key);

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            100.height,
            Lottie.asset('images/hairSalon/success.json',repeat: false),
            Text("Booking Confirmed!",style: TextStyle(fontSize: 18.w,fontWeight: FontWeight.bold),),
            10.height,
            Text("You will be assigned a worker very soon.",style: TextStyle(fontSize: 16.w,fontWeight: FontWeight.w400,color: Colors.grey),),
            50.height,
            Container(
              margin: EdgeInsets.symmetric(horizontal: 70.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: BHColorPrimary,
              ),
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                onPressed: () async{
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back_ios_new_outlined,color: Colors.white,),
                    5.width,
                    Text("Return to Homepage", style: TextStyle(color: whiteColor, fontSize: 14.w, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),

          ],
        ),
      )
    );
  }
}
