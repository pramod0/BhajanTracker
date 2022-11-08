import 'dart:collection';

import 'package:bhajantracker/bhajanTracker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bhajantracker/bhajanTracker.dart';

import 'constants.dart';

final _firestore = FirebaseFirestore.instance;

class Home extends StatefulWidget {
  static const String id = "home";

  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = FirebaseAuth.instance;
  late String user;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    //getConsistency(snapshot);
  }

  void getCurrentUser() {
    user = (_auth.currentUser!.email) as String;
  }

  late final Map<String, String>? consistencyMap = {"duration": "", "date": ""};

  static late final List<String> values;

  //Set<String> bhajanDateSet = HashSet();

  // QuerySnapshot collectionReference = FirebaseFirestore.instance
  //     .collection("dailytrack")
  //     .orderBy('date', descending: true) as QuerySnapshot<Object?>;
  //var dura_date=List.generate(1, (i) => List.filled(2, null, growable: true));

  void getConsistency(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    final data = snapshot.data?.docs;
    for (var maps in data!) {
      if (maps.get("user").toString() == _auth.currentUser?.email) {
        consistencyMap?.addAll({
          "date": maps.get("date"),
          "duration": maps.get("duration").toString()
        });
        // print(consistencyMap.toString());
        // consistencyList.add(consistencyMap!);
      }
    }
  }

  // void getUsersData(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
  //   final data = snapshot.data?.docs;
  //   for (var maps in data!) {
  //     if (maps.get("user").toString() == _auth.currentUser?.email) {
  //       bhajanDateSet.add(maps.get("date"));
  //
  //       // print(maps.get("user").toString());
  //       // print(maps.get("date").toString());
  //     }
  //     //print("hello_${consistencyList.toString()}");
  //   }
  //   //print("hello_${consistencyList.toString()}");
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: hexToColor("#3A4553"),
            body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('dailytrack').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                        );
                      }
                      getConsistency(snapshot);

                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const SizedBox(
                              height: 48.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Material(
                                elevation: 5.0,
                                color: Colors.deepOrangeAccent,
                                borderRadius: BorderRadius.circular(30.0),
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, BhajanTrack.id);
                                  },
                                  minWidth: 200.0,
                                  height: 42.0,
                                  child: const Text(
                                    'ADD Bhajan',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 48.0,
                            ),
                            const Text("Your Consistency"),
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                // <-- this will disable scroll
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: consistencyMap?.values.length,
                                itemBuilder: (BuildContext context, int index) {
                                  print(consistencyMap?.values);
                                  //values=consistencyMap?.values.toList();
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    shadowColor: Colors.black38,
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 15.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              consistencyMap!
                                                  .values
                                                  .first.toString(),
                                            ),
                                          ]),
                                    ),
                                  );
                                }),
                          ]);
                    }))));
  }
}
