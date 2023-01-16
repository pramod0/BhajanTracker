import 'dart:collection';

import 'package:bhajantracker/bhajanTracker.dart';
import 'package:bhajantracker/registration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bhajantracker/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Login extends StatefulWidget {
  static const String id = 'login_screen';

  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextStyle kGoogleStyleTexts = GoogleFonts.nunito(
      fontWeight: FontWeight.w600, color: Colors.black, fontSize: 20.0);
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final TextEditingController userNameController =
      TextEditingController(text: "SY0406");
  final TextEditingController passwordController =
      TextEditingController(text: "amit@123");
  bool showspinner = false;
  bool _showPassword = false;

  // late String code = "GK0808";
  // late String emailOrCode = "GK0808";
  // late String password = "gsh#RH3jA";

  Set<String> usersEmailSet = HashSet();
  static final Map<String, String> usersDocList = {
    "code": "",
    "email": "",
    "uid": ""
  };

  void _toggleVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  bool isEmail(String em) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    return ((regex.hasMatch(em)) ? true : false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor("#3F4553"),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Sabha Code/ Email ID",
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
                          controller: userNameController,
                          onSaved: (val) =>
                          {
                            userNameController.text = val!,
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
                        passwordController.text = val!,
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
                        bool iem = isEmail(userNameController.text);
                        if (kDebugMode) {
                          print("hello$iem");
                        }
                        if (iem) {
                          await _auth
                              .signInWithEmailAndPassword(
                                email: userNameController.text,
                                password: passwordController.text,
                              )
                              .whenComplete(
                                () => {
                                  print(
                                      "${userNameController.text} ${passwordController.text}"),
                                  Navigator.pushNamed(context, BhajanTrack.id),
                                },
                              );
                        } else {
                          _firestore
                              .collection("users")
                              .get()
                              .then((QuerySnapshot querySnapshot) async {
                            for (var doc in querySnapshot.docs) {
                              usersDocList.addAll({
                                "code": doc["sabhaCode"].toString(),
                                "email": doc["userEmailID"].toString(),
                                "uid": doc["userUID"].toString()
                              });
                              if (usersDocList
                                  .containsValue(userNameController.text)) {
                                var emailOrCode = doc["userEmailID"].toString();
                                passwordController.text =
                                    passwordController.text;
                                print(
                                    "${userNameController.text} ${passwordController.text}");
                                if (kDebugMode) {
                                  print(doc.data().toString());
                                }
                                await _auth.signInWithEmailAndPassword(
                                  email: emailOrCode.toString(),
                                  password: passwordController.text,
                                );
                                Navigator.pushNamed(context, BhajanTrack.id);
                              }
                            }
                          });
                        }
                        //_auth.setPersistence(Persistence.LOCAL);

                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          String errorMessage =
                              "No user exists with this email/code.";
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(errorMessage),
                          ));
                        } else if (e.code == 'wrong-password') {
                          String errorMessage = "The password is incorrect.";
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(errorMessage),
                          ));
                        }
                      } catch (e) {
                        if (kDebugMode) {
                          print(e);
                        }
                      } finally {
                        setState(() {
                          showSpinner = false;
                          passwordController.text = "";
                        });
                      }
                    },
                    child: Text(
                      "Login",
                      style: kGoogleStyleTexts.copyWith(
                          color: Colors.white, fontSize: 18.0),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {super.key,
      required this.title,
      required this.colour,
      required this.onPressed});

  final Color colour;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
