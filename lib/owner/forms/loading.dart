import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';

import '../../hairSalon/utils/BHImages.dart';


class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.width(),
        height: context.height(),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 180.w,
              height: 150.h,
              color: Colors.white,
              child: OverlayLoaderWithAppIcon(
                  isLoading: true,
                  appIconSize: 150,
                  circularProgressColor: BHColorPrimary,
                  overlayBackgroundColor: Colors.white,
                  appIcon:  Image.asset(BHLogo,height: 90.h,width: 100.w,),
                  child: Container(
                    color: Colors.white,
                  )),
            ),
            Text("Please Wait,",style: TextStyle(fontSize: 17.w,fontWeight: FontWeight.bold),),
            Text("We are creating your Salon",style: TextStyle(fontSize: 17.w,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}
