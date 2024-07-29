import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Custom_widget.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:carlink/controller/login_controller.dart';
import 'package:carlink/screen/login_flow/resetpassword_screen.dart';
import 'package:carlink/screen/login_flow/signup_screen.dart';
import 'package:carlink/screen/bottombar/bottombar_screen.dart';
import 'package:carlink/screen/bottombar/carinfo_screeen.dart';
import '../../utils/App_content.dart';
import '../../utils/config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late ColorNotifire notifire;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    getdarkmodepreviousstate();
  }

  Future<void> getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previousState = prefs.getBool("setIsDark");
    notifire.setIsDark = previousState ?? false;
  }

  Future<void> resetNew() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', true);
    prefs.setBool('bottomsheet', true);
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Store user details in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('UserEmail', email);
      prefs.setBool('isLoggedIn', true);

      // Navigate based on user type
      // You can customize this based on your app's logic
      if (userCredential.user != null) {
        Fluttertoast.showToast(msg: 'Login successful');
        resetNew();
        Get.offAll(BottomBarScreen()); // or CarInfoScreen() based on your logic
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Login failed: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: notifire.getbgcolor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(6),
                    child: Image.asset(Appcontent.close, color: notifire.getwhiteblackcolor),
                  ),
                ),
                SizedBox(height: Get.size.height * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Sign in to carlink".tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 28,),), SizedBox(height: 8,),
                      Text("Welcome back! Please enter your details.".tr, style: TextStyle(fontFamily: FontFamily.europaWoff, fontSize: 15, color: greyScale,),),
                      SizedBox(height: Get.size.height * 0.04),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: notifire.getblackwhitecolor,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Email'.tr,
                          hintStyle: TextStyle(color: greyColor, fontSize: 14, fontFamily: FontFamily.europaWoff),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: onbordingBlue),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: onbordingBlue),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        style: TextStyle(color: notifire.getwhiteblackcolor, fontFamily: FontFamily.europaBold),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email'.tr;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      GetBuilder<LoginController>(builder: (context) {
                        return textFormFild(
                          notifire,
                          controller: passwordController,
                          obscureText: loginController.showPassword,
                          suffixIcon: InkWell(
                            onTap: () {
                              loginController.showOfPassword();
                            },
                            child: !loginController.showPassword
                                ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset("assets/eye.png", height: 25, width: 25, color: greyColor),
                            )
                                : Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset("assets/eye-off.png", height: 25, width: 25, color: greyColor),
                            ),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset("assets/lock.png", height: 25, width: 25, color: greyColor),
                          ),
                          labelText: "Password".tr,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password'.tr;
                            }
                            return null;
                          },
                        );
                      }),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Get.to(ResetPasswordScreen());
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: 'Forgot password? '.tr, style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 15)),
                              TextSpan(text: 'Reset it'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: onbordingBlue, fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: Get.size.height * 0.03),
                      GestButton(
                        height: 50,
                        Width: Get.size.width,
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        buttoncolor: onbordingBlue,
                        buttontext: "Sign In".tr,
                        style: TextStyle(color: WhiteColor, fontFamily: FontFamily.europaBold, fontSize: 15),
                        onclick: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            login(emailController.text, passwordController.text);
                          } else {
                            Fluttertoast.showToast(msg: 'Please enter valid credentials');
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 10,),
                          Text("Don’t have an account?".tr, style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 15)),
                          SizedBox(width: 5),
                          TextButton(
                            onPressed: () {
                              Get.to(SignUpScreen());
                            },
                            child: Text("Sign Up".tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: onbordingBlue, fontSize: 15)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
