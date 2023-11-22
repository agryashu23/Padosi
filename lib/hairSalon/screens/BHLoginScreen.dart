import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/admin/admin_home.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../owner/forms/owner_stepper.dart';
import '../../owner/owner_dahboard.dart';
import '../utils/BHColors.dart';
import '../utils/BHConstants.dart';
import '../utils/widget_constant.dart';
import 'BHDashedBoardScreen.dart';
import 'load_widget.dart';

class BHLoginScreen extends StatefulWidget {
  static String tag = '/LoginScreen';


  @override
  BHLoginScreenState createState() => BHLoginScreenState();
}

class BHLoginScreenState extends State<BHLoginScreen> {
  TextEditingController phoneNo = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController salonName = TextEditingController();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode salonFocusNode = FocusNode();
  String code="";
  String appSignature = "";
  bool salon = false;
  bool loading = false;
  String verifiId="";
  String admin ="";
  bool owner= false;
  bool step =false;
  bool user= false;

  @override
  void dispose() {
    super.dispose();
    SmsAutoFill().unregisterListener();
  }

  // Future<void> initSmsListener() async {
  //   String? commingSms;
  //   try {
  //     commingSms = await AltSmsAutofill().listenForSms;
  //   } on PlatformException {
  //     commingSms = 'Failed to get Sms.';
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     code = commingSms!.substring(0,7).trim();
  //   });
  // }
  _listenSmsCode() async {
    await SmsAutoFill().listenForCode();
  }


  @override
  Widget build(BuildContext context) {
    // changeStatusColor(BHColorPrimary);
    return loading?Scaffold(body: BHLoading()):SafeArea(
      child: Scaffold(
        backgroundColor: BHColorPrimary,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 8.h),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset('images/hairSalon/bh_splash.jpeg', height: 190.h, width: 200.w),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 200),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                  color: whiteColor,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      salon?TextCenter(EdgeInsets.only(top: 5.h,left: 10.w), "Enter Salon Name-", Colors.black54):Container(),
                      salon?Container(
                        height: 30.h,
                        margin: EdgeInsets.only(left: 10.w,bottom: 15.h),
                        child: TextFormField(
                          controller: salonName,
                          focusNode: salonFocusNode,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(color: blackColor),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: BHColorPrimary)),
                            labelStyle: TextStyle(color: BHGreyColor, fontSize: 14),
                          ),
                        ),
                      ):Container(),
                      TextCenter(EdgeInsets.only(top: 10.w,left: 10.w), "Login with Phone Number", Colors.grey),
                      Container(
                        margin: EdgeInsets.only(left: 10.w),
                        child: TextFormField(
                          controller: phoneNo,
                          focusNode: phoneFocusNode,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(color: blackColor),
                          decoration: InputDecoration(
                            prefixText: "+91  ",
                            prefixStyle: TextStyle(fontSize: 15.w),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: BHAppDividerColor)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: BHColorPrimary)),
                            labelText: "Mobile No.",
                            labelStyle: TextStyle(color: BHGreyColor, fontSize: 14),
                          ),
                          onChanged: (val){
                            if(val.length==10){
                              FocusManager.instance.primaryFocus?.unfocus();
                            }
                          },
                          validator: (value) {
                            if (phoneNo.text.length == 10) {
                              return null;
                            }
                            return "Enter Valid PhoneNumber";
                          },
                        ),
                      ),
                      20.height,
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: BHColorPrimary,

                        ),
                        width: MediaQuery.of(context).size.width*0.3,
                        child: TextButton(
                          onPressed: () async{
                            if (phoneNo.text.length == 10) {
                              setState(() {
                                loading=true;
                              });
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber:'+91${phoneNo.text.trimRight()}',
                                verificationCompleted:
                                    (PhoneAuthCredential credential) {
                                  setState(() {
                                    loading=false;
                                  });
                                },
                                verificationFailed:
                                    (FirebaseAuthException e) {
                                  setState(() {
                                    loading=false;
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Enter Correct Mobile Number')));
                                },
                                codeSent: (String verificationId,
                                    int? resendToken) async {
                                  setState(() {
                                    loading=false;
                                    verifiId = verificationId;
                                  });

                                },
                                codeAutoRetrievalTimeout:
                                    (String verId) {
                                  setState(() {
                                    loading=false;
                                    verifiId = verId;
                                  });
                                },
                              );
                              appSignature = await SmsAutoFill().getAppSignature;
                              Future.delayed(const Duration(seconds: 2)).then((val) {
                                _listenSmsCode();
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please Enter Correct Mobile Number')));
                            }
                          },
                          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          child: Text("Send OTP", style: TextStyle(color: whiteColor, fontSize: 17, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      30.height,

                      Container(
                        margin: EdgeInsets.only(left: 10.w),
                        alignment: Alignment.centerLeft,
                        child: Text("Enter OTP", style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold)),

                      ),
                      7.height,
                      // OtpTextField(
                      //   numberOfFields: 6,
                      //   focusedBorderColor: BHColorPrimary,
                      //   enabledBorderColor: Colors.black12,
                      //   disabledBorderColor: Colors.black,
                      //   textStyle: TextStyle(
                      //       fontWeight: FontWeight.bold, fontSize: 16.w),
                      //   //set to true to show as box or false to show as dash
                      //   showFieldAsBox: true,
                      //   borderWidth: 1.5,
                      //   //runs when a code is typed in
                      //   fieldWidth: 45.w,
                      //   margin: EdgeInsets.only(right: 7.w),
                      //   keyboardType: TextInputType.number,
                      //   fillColor: Colors.black,
                      //   borderRadius: BorderRadius.circular(10),
                      //   onSubmit: (String verificationCode) {
                      //     setState(() {
                      //       code  = verificationCode;
                      //     });
                      //     print(code);
                      //   }, // end onSubmit
                      // ),
                      PinFieldAutoFill(
                        currentCode: code,
                        cursor: Cursor(color: Colors.black,width: 2.w,height: 15.h,enabled: true),
                        decoration:  BoxLooseDecoration(
                            radius: Radius.circular(12),
                            strokeColorBuilder: FixedColorBuilder(
                                Color(0xFF8C4A52))),
                        codeLength: 6,
                        onCodeChanged: (codes) {
                          code = codes.toString();
                          if(codes!.length==6){
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                        },
                        onCodeSubmitted: (val) {
                            code = val.toString();
                        },
                      ),
                      10.height,
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       BHForgotPasswordScreen().launch(context);
                      //     },
                      //     child: Text("Login as Salon", style: TextStyle(color: BHColorPrimary, fontSize: 14,decoration: TextDecoration.underline)),
                      //   ),
                      // ),
                      // 20.height,
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Checkbox(
                              checkColor: Colors.red,
                              activeColor: Colors.black12,
                              value: salon,
                              onChanged: (value) {
                                setState(() {
                                  salon = value!;
                                });
                              },
                            ),
                            Text('Login as Salon ', style: TextStyle(color: BHColorPrimary, fontSize: 17,decoration: TextDecoration.underline) ),
                          ]
                      ),
                      10.height,
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: BHColorPrimary,

                        ),
                        width: MediaQuery.of(context).size.width,
                        child: TextButton(
                          onPressed: () async{
                            if(phoneNo.text.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.tealAccent,
                                duration: Duration(seconds: 2),
                                content: Text("Enter Correct Mobile Number"),));
                            }
                            else{
                              print(code);
                              PhoneAuthCredential phoneCredential =
                              PhoneAuthProvider.credential(
                                verificationId: verifiId,
                                smsCode: code,
                              );
                              signInWithPhoneCredential(phoneCredential);
                            }
                          },
                          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          child: Text(BHBtnSignIn, style: TextStyle(color: whiteColor, fontSize: 17, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void signInWithPhoneCredential(PhoneAuthCredential phoneCredential) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


    if(salon && salonName.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Please Enter Valid Salon Name"),));
    }

    else {
      setState(() {
        loading=true;
      });
      try {
        final authCredential =
        await FirebaseAuth.instance.signInWithCredential(phoneCredential);

        await FirebaseFirestore.instance.collection("admin").doc("login").get().then((value) {
          setState(() {
            admin = value["phone"];
          });
        });
        setState(() {
          loading = false;
        });
        if (authCredential.user != null) {
          var ownerstep = await FirebaseFirestore.instance.collection("owners").doc(authCredential.user!.uid.toString()).get();
          if(ownerstep.exists ){
            setState(() {
              owner=true;
            });
            if(ownerstep.data()!.containsKey("premium")){
              setState(() {
                step=true;
              });
            }
          }
          var userStep = await FirebaseFirestore.instance.collection("users").doc(authCredential.user!.uid.toString()).get();
          if(userStep.exists){
            setState(() {
              user = true;
            });
          }
          //-------//
          if(phoneNo.text.toString()==admin){
            prefs.setBool('admin', true);
            setState(() {
              loading = false;
            });
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => AdminHome()), (
                    route) => false);
          }
          else if (salon) {
            if(owner &&step){
              prefs.setBool('step', true);
              prefs.setBool('owner', true);
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => OwnerDashedBoard()), (
                      route) => false);
            }
            else if(owner){
              prefs.setBool('owner', true);
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => OwnerStepper()), (
                      route) => false);
            }
            else{
              FirebaseFirestore.instance.collection("owners").doc(
                  FirebaseAuth.instance.currentUser!.uid).set({
                "phone": FirebaseAuth.instance.currentUser!.phoneNumber,
                "id": FirebaseAuth.instance.currentUser!.uid,
                "salon_name":salonName.text,
                "reviews":0.0,
              });
              prefs.setBool('owner', true);
              setState(() {
                loading = false;
              });
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => OwnerStepper()), (
                      route) => false);
            }
          }
          else if(user){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) => BHDashedBoardScreen()), (route) => false);
          }
          else {
            FirebaseFirestore.instance.collection("users").doc(
                FirebaseAuth.instance.currentUser!.uid).set({
              "phone": FirebaseAuth.instance.currentUser!.phoneNumber,
              "id": FirebaseAuth.instance.currentUser!.uid,
              "rewards":0,
              "name":"",
              "image":"",
            });
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) => BHDashedBoardScreen()), (route) => false);
          }
        }
      }
      on FirebaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.tealAccent,
          duration: Duration(seconds: 2),
          content: Text("Enter Correct OTP"),));
        setState(() {
          loading = false;
        });
      }
    }
  }
}
