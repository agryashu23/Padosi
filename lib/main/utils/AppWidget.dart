import 'package:flutter/material.dart';

// AppStore appStore = AppStore();

// void changeStatusColor(Color color) async {
//   try {
//     await FlutterStatusbarcolor.setStatusBarColor(color, animate: true);
//     FlutterStatusbarcolor.setStatusBarWhiteForeground(
//         useWhiteForeground(color));
//   } on Exception catch (e) {
//     print(e);
//   }
// }

Widget commonCacheImageWidget(String url, double height,
    {double? width, BoxFit? fit}) {
  if (url.startsWith('https')) {
      return Image.network(url, height: height, width: width, fit: fit);
  } else {
    return Image.asset(url, height: height, width: width, fit: fit);
  }
}

//




 Widget Function(BuildContext, String) placeholderWidgetFn() =>
    (_, s) => placeholderWidget();

Widget placeholderWidget() =>
    Image.asset('images/LikeButton/image/grey.jpg', fit: BoxFit.cover);


