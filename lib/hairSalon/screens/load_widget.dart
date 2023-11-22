import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

import '../utils/BHColors.dart';
import '../utils/BHImages.dart';

class BHLoading extends StatelessWidget {
  const BHLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 80.w,
        height: 70.h,
        color: Colors.transparent,
        child: OverlayLoaderWithAppIcon(
            isLoading: true,
            appIconSize: 150,
            circularProgressColor: BHColorPrimary,
            overlayBackgroundColor: Colors.transparent,
            appIcon:  Image.asset(BHLogo,height: 60.h,width: 50.w,),
            child: Container(
              color: Colors.transparent,
            )),
      ),
    );
  }
}
