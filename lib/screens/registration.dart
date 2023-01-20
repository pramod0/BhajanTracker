import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bhajantracker/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../screens/addBhajan.dart';
import 'login.dart';

class Registration extends StatefulWidget {
  static const String id = 'registration';

  const Registration({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance.collection("users");
  final _googleSignIn = GoogleSignIn();
  bool _showPassword = false;

  final TextEditingController emailController =
      TextEditingController(text: "thisamit@gmail.com");
  final TextEditingController codeController =
      TextEditingController(text: "SY0406");
  final TextEditingController passwordController =
      TextEditingController(text: "amit@123");
  bool showSpinner = false;

  void _toggleVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: hexToColor("#3F4553"),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Jai Swaminarayan",
                            style: kGoogleStyleTexts.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                              color: hexToColor("#FFFFDD"),
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "WeeklyForum Code",
                            style: kGoogleStyleTexts.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: hexToColor("#0091E6"),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 45.0,
                      child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: codeController,
                          onSaved: (val) => {
                                setState(
                                  () {
                                    if (kDebugMode) {
                                      print("code$val");
                                    }
                                    codeController.text = val!;
                                  },
                                ),
                              },
                          keyboardType: TextInputType.text,
                          style: kGoogleStyleTexts.copyWith(
                              color: hexToColor("#ffffff"), fontSize: 15.0),
                          maxLines: 1,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: hexToColor("#0065A0"),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: hexToColor("#0065A0"))),
                            fillColor: const Color.fromARGB(30, 173, 205, 219),
                            filled: true,
                            hintText: AppStrings.codeHint,
                            hintStyle: kGoogleStyleTexts.copyWith(
                                color: hexToColor("#5F93B1"),
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Email ID",
                            style: kGoogleStyleTexts.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: hexToColor("#0091E6"),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 45.0,
                      child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: emailController,
                          onSaved: (val) => {
                                setState(
                                  () {
                                    emailController.text = val!;
                                  },
                                ),
                              },
                          keyboardType: TextInputType.emailAddress,
                          style: kGoogleStyleTexts.copyWith(
                              color: hexToColor("#ffffff"), fontSize: 15.0),
                          maxLines: 1,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: hexToColor("#0065A0"),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: hexToColor("#0065A0"))),
                            fillColor: const Color.fromARGB(30, 173, 205, 219),
                            filled: true,
                            hintText: AppStrings.userEmailHintText,
                            hintStyle: kGoogleStyleTexts.copyWith(
                                color: hexToColor("#5F93B1"),
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppStrings.userPassword,
                            style: kGoogleStyleTexts.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: hexToColor("#0091E6"),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 45.0,
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.justify,
                        controller: passwordController,
                        onSaved: (val) => {
                          setState(
                            () {
                              if (kDebugMode) {
                                print("pass$val");
                              }
                              passwordController.text = val!;
                            },
                          ),
                        },
                        keyboardType: TextInputType.text,
                        style: kGoogleStyleTexts.copyWith(
                            color: hexToColor("#ffffff"), fontSize: 15.0),
                        maxLines: 1,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: hexToColor("#0065A0"),
                              width: 1.0,
                            ),
                          ),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5.0)),
                              borderSide:
                                  BorderSide(color: hexToColor("#0065A0"))),
                          fillColor: const Color.fromARGB(30, 173, 205, 219),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              _toggleVisibility();
                            },
                            child: Icon(
                              _showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: hexToColor("#0065A0"),
                              size: 22,
                            ),
                          ),
                          filled: true,
                          hintText: AppStrings.userPasswordHintText,
                          hintStyle: kGoogleStyleTexts.copyWith(
                              color: hexToColor("#5F93B1"),
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 55,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: hexToColor("#0065A0"),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        var user = await _auth.createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        var docID = user.user?.uid;
                        await _firestore.doc(docID).set({
                          "userEmailID": user.user?.email,
                          "userUID": user.user?.uid,
                          "sabhaCode": codeController.text,
                        }).whenComplete(
                          () => {
                            Navigator.pushNamed(context, Login.id),
                            setState(
                              () {
                                showSpinner = false;
                              },
                            )
                          },
                        );
                      } catch (e) {
                        if (kDebugMode) {
                          print(e);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                        ));
                      } finally {
                        setState(() {
                          showSpinner = false;
                          passwordController.text = "";
                        });
                      }
                    },
                    child: Text(
                      "Register",
                      style: kGoogleStyleTexts.copyWith(
                          color: Colors.white, fontSize: 18.0),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AppStrings {
  static const String loginNowText = "Login";
  static const String userName = 'Username';
  static const String userPassword = 'Password';
  static const String loginButtonText = 'Login';
  static const String loginText = "Heading goes here";
  static const String userEmailHintText = "Eg. person0@email.com";
  static const String userPasswordHintText = "Eg. xyZab@23";
  static const String codeHint = "Eg. AB0101";
  static const String qoute =
      "When you catch a glimpse of your potential, that's when passion is born.";
}
