import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/admin/Admin_Bookings/show_other_bookings.dart';
import 'package:salon/admin/Admin_Feed/add_feed.dart';
import 'package:salon/admin/Admin_Notifications/add_notitfication.dart';
import 'package:salon/admin/Admin_Salons/choose_city.dart';
import 'package:salon/admin/add_categories.dart';
import 'package:salon/admin/admin_offers.dart';
import 'package:salon/admin/admin_payment.dart';
import 'package:salon/admin/admin_refund.dart';
import 'package:salon/admin/category/admin_service_category.dart';
import 'package:salon/admin/dashboard_screen.dart';
import 'package:salon/admin/Admin_Feed/show_feed.dart';
import 'package:salon/admin/Admin_Salons/show_salons.dart';
import 'package:salon/admin/users_list.dart';
import 'package:salon/provider.dart';

import '../hairSalon/screens/BHLoginScreen.dart';
import 'Admin_Employee/employee_category.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 230.w,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("images/hairSalon/bh_splash.jpeg"),
          ),
          DrawerListTile(
            title: "Dashboard",
            icon: Icons.dashboard,
            press: () {
              Navigator.of(context).pop();
            },
          ),
          DrawerListTile(
            title: "Salons",
            icon: Icons.shop_2_sharp,
            press: () {
              Navigator.of(context).pop();
              ChooseCity().launch(context);
            },
          ),
          DrawerListTile(
            title: "Users",
            icon: Icons.person,
            press: () {
              Navigator.of(context).pop();
              UsersList().launch(context);
            },
          ),
          DrawerListTile(
            title: "Add Feed",
            icon: Icons.newspaper,
            press: () {
              Navigator.of(context).pop();
              AddFeed().launch(context);
            },
          ),
          DrawerListTile(
            title: "Categories",
            icon: Icons.category_outlined,
            press: () {
              Navigator.of(context).pop();
              AddCategory().launch(context);
            },
          ),
          DrawerListTile(
            title: "Employees",
            icon: Icons.person,
            press: () {
              Navigator.of(context).pop();
              EmployeeCategory().launch(context);
            },
          ),
          DrawerListTile(
            title: "Notification",
            icon: Icons.notifications,
            press: () {
              Navigator.of(context).pop();
              AddNotifications().launch(context);
            },
          ),
          DrawerListTile(
            title: "Bookings",
            icon: Icons.book_online,
            press: () {
              Navigator.of(context).pop();
              ShowOtherBookings().launch(context);
            },
          ),
          DrawerListTile(
            title: "Service Category",
            icon: Icons.list_alt,
            press: () {
              Navigator.of(context).pop();
              AdminServiceCategory().launch(context);
            },
          ),
          DrawerListTile(
            title: "Refunds",
            icon: Icons.monetization_on,
            press: () {
              Navigator.of(context).pop();
              AdminRefund().launch(context);
            },
          ),
          DrawerListTile(
            title: "Salon Payments",
            icon: Icons.money,
            press: () {
              Navigator.of(context).pop();
              AdminPayment().launch(context);
            },
          ),
          DrawerListTile(
            title: "Offers",
            icon: Icons.local_offer_outlined,
            press: () {
              Navigator.of(context).pop();
              AdminOffers().launch(context);
            },
          ),
          DrawerListTile(
            title: "Logout",
            icon: Icons.settings,
            press: () async{
              FirebaseAuth.instance.signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('admin', false);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BHLoginScreen()), (route) => false);
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}