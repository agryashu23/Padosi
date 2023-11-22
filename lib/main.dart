 import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/date_symbol_data_local.dart';
import 'hairSalon/screens/BHSplashScreen.dart';
import 'main/notification/notification_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('en', '').then((value) => null);
  NotificationService().initNotification();
  tz.initializeTimeZones();
  await Firebase.initializeApp();
  runApp(MyApp());
  //endregion
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  NotificationService notificationService =NotificationService();

  @override
  void initState() {
    super.initState();
    notificationService.initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context , child) {
        return
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BHSplashScreen(),
          // theme: !appStore.isDarkModeOn
          //     ? AppThemeData.lightTheme
          //     : AppThemeData.darkTheme,
        );
      }
        ),
    );
  }
}
