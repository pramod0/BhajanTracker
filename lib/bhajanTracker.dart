import 'dart:collection';

import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';

//import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'package:bhajantracker/constants.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'constants.dart';

TextStyle kGoogleStyleTexts = GoogleFonts.openSans(
    fontWeight: FontWeight.w600, color: Colors.black, fontSize: 20.0);

final _firestore = FirebaseFirestore.instance;

class BhajanTrack extends StatefulWidget {
  static const String id = "bhajantrack";

  const BhajanTrack({super.key});

  @override
  _BhajanTrackState createState() => _BhajanTrackState();
}

class _BhajanTrackState extends State<BhajanTrack> {
  final _auth = FirebaseAuth.instance;
  late String user;
  bool showDurationCard = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    user = (_auth.currentUser!.email) as String;
  }

  static final Map<String, String> consistencyList = {
    "date": "",
    "duration": ""
  };
  Duration _duration = const Duration(hours: 0, minutes: 0);
  final Duration _default = const Duration(hours: 0, minutes: 0);

  DateTime _selectedDay = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _focusedDay = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  CalendarFormat _calendarFormat = CalendarFormat.month;

  Set<String> bhajanDateSet = HashSet();

  // QuerySnapshot collectionReference = FirebaseFirestore.instance
  //     .collection("dailytrack")
  //     .orderBy('date', descending: true) as QuerySnapshot<Object?>;
  var dura_date = List.generate(1, (i) => List.filled(2, null, growable: true));

  void getConsistency(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    final data = snapshot.data?.docs;
    for (var maps in data!) {
      if (maps.get("user").toString() == _auth.currentUser?.email) {
        consistencyList.addAll({
          "date": maps.get("date"),
          "duration": maps.get("duration").toString()
        });
      }
      print(consistencyList.toString());
    }
  }

  void getUsersData(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    final data = snapshot.data?.docs;
    for (var maps in data!) {
      if (maps.get("user").toString() == _auth.currentUser?.email) {
        bhajanDateSet.add(maps.get("date"));

        // print(maps.get("user").toString());
        // print(maps.get("date").toString());
      }
      //print("hello_${consistencyList.toString()}");
    }
    //print("hello_${consistencyList.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: hexToColor("#4D57C8"),
          body: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('dailytrack').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                getUsersData(snapshot);
                getConsistency(snapshot);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 1.0, // soften the shadow
                          spreadRadius: 0.5, //extend the shadow
                          offset: Offset(
                            0.0, // Move to right 10  horizontally
                            1.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Column(children: [
                          TableCalendar(
                            calendarStyle: CalendarStyle(
                              todayDecoration: BoxDecoration(
                                color: hexToColor("#FFBE68"),
                                shape: BoxShape.circle,
                              ),
                              outsideDaysVisible: false,
                              outsideDecoration: BoxDecoration(
                                color: hexToColor("#FFFFFF"),
                              ),
                              holidayDecoration: BoxDecoration(
                                color: hexToColor("#ffffff"),
                              ),
                              weekendDecoration: BoxDecoration(
                                color: hexToColor("#ffffff"),
                              ),
                              defaultDecoration: BoxDecoration(
                                color: hexToColor("#FFFFFF"),
                              ),
                              selectedDecoration: BoxDecoration(
                                color: hexToColor("#ED8B00"),
                                shape: BoxShape.rectangle,
                              ),
                            ),
                            headerStyle: const HeaderStyle(
                                headerPadding: EdgeInsets.all(12),
                                rightChevronVisible: false,
                                leftChevronVisible: false,
                                formatButtonVisible: false,
                                titleTextStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontSize: 20)),
                            firstDay: DateTime.utc(2022, 01, 01),
                            lastDay: DateTime.utc(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day),
                            focusedDay: _focusedDay,
                            calendarFormat: _calendarFormat,
                            onFormatChanged: (format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            },
                            selectedDayPredicate: (day) {
                              String date = DateFormat('dd-MM-yyyy')
                                  .format(day)
                                  .toString();
                              if (bhajanDateSet.contains(date)) {
                                return true;
                              }
                              return false;
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              print("selectedDay: " + selectedDay.toString());
                              print("focusedDay: " + focusedDay.toString());

                              String selectedDayString =
                                  DateFormat('dd-MM-yyyy')
                                      .format(selectedDay)
                                      .toString();
                              if (!(bhajanDateSet
                                  .contains(selectedDayString))) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialog(context),
                                );
                              }
                            },
                          ),
                        ])),
                  ),
                );
              })),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Set duration'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              TimeButton(duration: 1,),
              TimeButton(duration: 2,),
            ],
          ),
          TimeButton(duration: 5,),
          TimeButton(duration: 10,),
          TimeButton(duration: 15,),
          TimeButton(duration: 20,),
          TimeButton(duration: 25,),
          TimeButton(duration: 30,),
          TimeButton(duration: 45,),
          TimeButton(duration: 60,),


        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            String? docID =
                _auth.currentUser?.uid;
            docID =
            ("${docID!}_${DateTime.now().toString().replaceAll(" ", "_")}");
            //String? docID =DateTime.now().toString();
            await _firestore
                .collection('dailytrack')
                .doc(docID)
                .set({
              'bhajan': true,
              'date': DateFormat('dd-MM-yyyy')
                  .format(_selectedDay),
              'duration': _duration.inMinutes,
              'user': _auth.currentUser?.email,
              'timestamp': DateTime.now(),
            });
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class TimeButton extends StatelessWidget {
  int duration;

  TimeButton({super.key,required this.duration});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          print(duration);
        },
        child: const Text(("{this.duration} min")));
  }
}
