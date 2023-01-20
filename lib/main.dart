import 'package:bhajantracker/screens/addBhajan.dart';
import 'package:bhajantracker/screens/registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bhajantracker/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'screens/login.dart';
//import 'package:firebase_auth/firebase_auth.dart';

//import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Welcome(),
      routes: {
        Welcome.id: (context) => const Welcome(),
        Login.id: (context) => Login(),
        Registration.id: (context) => const Registration(),
        BhajanTrack.id: (context) => const BhajanTrack(),
      },
    );
  }
}
