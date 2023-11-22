// import 'package:alt_sms_autofill/alt_sms_autofill.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:salon/hairSalon/screens/BHDashedBoardScreen.dart';
// import 'package:sms_autofill/sms_autofill.dart';
//
// import 'BHColors.dart';
// import 'BHConstants.dart';
// import 'common_utils.dart';
//
// class OtpScreen extends StatefulWidget {
//   const OtpScreen({Key? key, required this.phone}) : super(key: key);
//   final String phone;
//
//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }
//
// class _OtpScreenState extends State<OtpScreen> {
//   String otpCode = "";
//   String otp = "";
//   bool isLoaded = false;
//   final _formKey = GlobalKey<FormState>();
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   @override
//   void initState() {
//     super.initState();
//     initSmsListener();
//   }
//
//
//   Future<void> initSmsListener() async {
//     String? commingSms;
//     try {
//       commingSms = await AltSmsAutofill().listenForSms;
//     } on PlatformException {
//       commingSms = 'Failed to get Sms.';
//     }
//     if (!mounted) return;
//
//       otpCode = commingSms!;
//   }
//
//   @override
//   void dispose() {
//     AltSmsAutofill().unregisterListener();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: BHColorPrimary,
//         body: Stack(
//           children: [
//             Container(
//               margin: EdgeInsets.only(top: 14.h),
//               child: Align(
//                 alignment: Alignment.topCenter,
//                 child: Image.asset('images/hairSalon/bh_splash.jpeg',
//                     height: 170.h, width: 180.w),
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.only(top: 200),
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(15),
//                     topLeft: Radius.circular(15)),
//                 color: whiteColor,
//               ),
//               child: Column(
//                 children: [
//                   PinFieldAutoFill(
//                     currentCode: otpCode,
//                     decoration:  BoxLooseDecoration(
//                         radius: Radius.circular(12),
//                         strokeColorBuilder: FixedColorBuilder(
//                             Color(0xFF8C4A52))),
//                     codeLength: 6,
//                     onCodeChanged: (code) {
//                       print("OnCodeChanged : $code");
//                       otpCode = code.toString();
//                     },
//                     onCodeSubmitted: (val) {
//                       print("OnCodeSubmitted : $val");
//                     },
//                   ),
//                   20.height,
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: BHColorPrimary,
//                     ),
//                     width: MediaQuery.of(context).size.width,
//                     child: TextButton(
//                       onPressed: () async{
//                         setState(() {
//                           isLoaded = true;
//                         });
//                         if (_formKey.currentState!.validate()) {
//                           try {
//                             PhoneAuthCredential credential =
//                             PhoneAuthProvider.credential(
//                                 verificationId: CommonUtils.verify,
//                                 smsCode: otpCode);
//                             await auth.signInWithCredential(credential);
//                             setState(() {
//                               isLoaded = false;
//                             });
//                             Navigator.of(context).pushReplacement(MaterialPageRoute(
//                                 builder: (context) => BHDashedBoardScreen()));
//                           } catch (e) {
//                             setState(() {
//                               isLoaded = false;
//                             });
//                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                                 content: Text("Wrong OTP! Please enter again")));
//                             print("Wrong OTP");
//                           }
//                         }
//
//                       },
//                       // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//                       child: Text(BHBtnSignIn, style: TextStyle(color: whiteColor, fontSize: 17, fontWeight: FontWeight.bold)),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ));
//   }
// }
