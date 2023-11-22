import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';

class HorizontalCouponExample2 extends StatelessWidget {
  HorizontalCouponExample2(this.percent , this.off);
  final String percent;
  final String off;

  @override
  Widget build(BuildContext context) {
   Color primaryColor = Color(0xfff1e3d3);

    return CouponCard(
      height: 80.h,
      backgroundColor: primaryColor,
      clockwise: true,
      curvePosition: 70.w,
      curveRadius: 20,
      curveAxis: Axis.vertical,
      borderRadius: 10,
      firstChild: Container(
        decoration:  BoxDecoration(
          color: BHColorPrimary.withAlpha(180),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${percent}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.w,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'OFF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(color: Colors.white54, height: 0),
            const Expanded(
              child: Center(
                child: Text(
                  'No Coupon\nRequired',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      secondChild: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get Flat ${percent}% OFF on first 5 App Bookings',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            Divider(
              height: 10.h,
            ),
            Text(
              'Get discount of upto \u{20B9}${off} OFF after 5 Bookings completed',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.w,
                color: Color(0xffd88c9a),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}