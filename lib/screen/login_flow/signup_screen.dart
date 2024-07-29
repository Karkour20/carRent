// ignore_for_file: prefer_const_constructors, empty_catches, prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:carlink/utils/common.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:carlink/controller/signup_controller.dart';
import 'package:carlink/screen/login_flow/login_screen.dart';
import 'package:carlink/utils/App_content.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Custom_widget.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpController signUpController = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController fullName = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late ColorNotifire notifire;
  File? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> registerUser(String imageUrl) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    Map<String, dynamic> signUpData = {
      "name": fullName.text,
      "email": emailController.text,
      "personal_id_image_url": imageUrl,
    };
    String encodeMap = json.encode(signUpData);
    preferences.setString('SignUpdata', encodeMap);

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        await firestore.collection('users').doc(userCredential.user!.uid).set({
          "name": fullName.text,
          "email": emailController.text,
          "personal_id_image_url": imageUrl,
        });

        Fluttertoast.showToast(msg: "Registration successful!");
        Get.to(() => LoginScreen());
      } else {
        Fluttertoast.showToast(msg: "Registration failed. Please try again.");
      }
    } catch (e) {
      print("Error during registration: $e");
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previousState = prefs.getBool("setIsDark");
    notifire.setIsDark = previousState ?? false;
  }

  @override
  void initState() {
    super.initState();
    getdarkmodepreviousstate();
  }

  bool isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_image != null) {
      try {
        String fileName = 'personal_id/${DateTime.now().millisecondsSinceEpoch}.png';
        Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
        TaskSnapshot taskSnapshot = await uploadTask.timeout(const Duration(minutes: 5));
        return await taskSnapshot.ref.getDownloadURL();
      } catch (e) {
        if (e is FirebaseException) {
          print("FirebaseException: ${e.message}");
        } else if (e is TimeoutException) {
          print("TimeoutException: Upload timed out");
        } else {
          print("Unknown exception: $e");
        }
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: notifire.getbgcolor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _formKey,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () => Get.back(),
                        child: Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(6),
                          child: Image.asset(Appcontent.close, color: notifire.getwhiteblackcolor),
                        ),
                      ),
                      SizedBox(height: Get.size.height * 0.03),
                      Text(
                        "Sign Up".tr,
                        style: TextStyle(
                          fontFamily: FontFamily.europaBold,
                          color: notifire.getwhiteblackcolor,
                          fontSize: 28,
                        ),
                      ),
                      SizedBox(height: Get.size.height * 0.04),
                      textFormFild(
                        notifire,
                        controller: fullName,
                        keyboardType: TextInputType.name,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(Appcontent.user, height: 25, width: 25, color: greyColor),
                        ),
                        labelText: "Full Name".tr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name'.tr;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      textFormFild(
                        notifire,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset("assets/mail.png", height: 25, width: 25, color: greyColor),
                        ),
                        labelText: "Email".tr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email'.tr;
                          } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                            return 'Please enter a valid email address'.tr;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      GetBuilder<SignUpController>(builder: (context) {
                        return textFormFild(
                          notifire,
                          controller: passwordController,
                          obscureText: signUpController.showPassword,
                          suffixIcon: InkWell(
                            onTap: () => signUpController.showOfPassword(),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset(
                                signUpController.showPassword ? "assets/eye-off.png" : "assets/eye.png",
                                height: 25,
                                width: 25,
                                color: greyColor,
                              ),
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
                      SizedBox(height: 15),
                      _image == null
                          ? ElevatedButton(
                              onPressed: _pickImage,
                              child: Text("Upload Personal ID"),
                            )
                          : Image.file(_image!),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'By signing up, you agree to our '.tr, style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 15)),
                            TextSpan(text: 'Terms of Service '.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: onbordingBlue, fontSize: 15)),
                            TextSpan(text: 'and '.tr, style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 15)),
                            TextSpan(text: 'Privacy Policy.'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: onbordingBlue, fontSize: 15)),
                          ],
                        ),
                      ),
                      SizedBox(height: Get.size.height * 0.03),
                      GestButton(
                        height: 50,
                        Width: Get.size.width,
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        buttoncolor: onbordingBlue,
                        buttontext: "Sign Up".tr,
                        style: TextStyle(color: WhiteColor, fontFamily: FontFamily.europaBold, fontSize: 15),
                        onclick: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            String? imageUrl = await _uploadImage();
                            if (imageUrl != null) {
                              await registerUser(imageUrl);
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              Fluttertoast.showToast(msg: "Image upload failed. Please try again.");
                            }
                          }
                        },
                      ),
                      SizedBox(height: 13),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?".tr, style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 15)),
                          SizedBox(width: 5),
                          InkWell(
                            onTap: () => Get.to(LoginScreen()),
                            child: Text("Sign In".tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: onbordingBlue, fontSize: 15)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (isLoading) loader(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
