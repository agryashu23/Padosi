import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';
// import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Raise Your Queries"),
          centerTitle: true,
          backgroundColor: BHColorPrimary,
        ),
        body: Column(
          children: [
            Center(
              child: Container(
                  margin: EdgeInsets.only(top: 20.h),
                  child: Image.asset('images/hairSalon/bh_splash.jpeg',height: 110.h,width: 120.h,)),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
              child: TextFormField(
                controller: subjectController,
                autofocus: false,
                decoration: InputDecoration(
                    labelText: "Subject",
                    contentPadding:
                    EdgeInsets.only(left: 20.w, top: 15.w, bottom: 15.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    hintText: "Enter the Subject",
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'Raleway')),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
              child: TextFormField(
                controller: messageController,
                autofocus: false,
                textAlign: TextAlign.center,
                maxLength: 150,
                maxLines: 4,
                decoration: InputDecoration(
                    labelText: "Message",
                    contentPadding:
                    EdgeInsets.only(left: 20.w, top: 15.w, bottom: 15.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    hintText: "Enter the Message",
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'Raleway')),
              ),
            ),
            GestureDetector(
              onTap: ()async{
                final Email email = Email(
                  body: messageController.text,
                  subject: subjectController.text,
                  recipients: ['agryashu23@gmail.com'],
                  cc: ['agryashu23@gmail.com'],
                  bcc: ['agryashu23@gmail.comm'],
                  isHTML: false,
                );

                await FlutterEmailSender.send(email);
              },
              child: Container(
                alignment: Alignment.center,
                height: 45.h,
                width: 170.w,
                decoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "Submit",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.0),
                  child: Text(
                    'OR',
                    style: TextStyle(
                        color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10.0),
              child: Text(
                'Contact Us -',
                style: TextStyle(
                    color: Colors.black54, fontSize: 22.w,fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: ()async{
                    final link = WhatsAppUnilink(
                      phoneNumber: '+916205818799',
                      text: "Hey! I have query about padosi app.",
                    );
                    await UrlLauncher.launch('$link');
                  },
                  child: SizedBox(
                    height: 60.h,
                    width: 60.w,
                    child: Image.asset('images/hairSalon/whats_app.png',height: 90.h,width: 100.h,)),
                ),
                GestureDetector(
                  onTap: ()async{
                    UrlLauncher.launch("tel:+916205818799");
                  },
                  child: Icon(Icons.phone,color: Colors.blue,size: 40.w,)
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
