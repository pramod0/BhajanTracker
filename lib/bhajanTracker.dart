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
  bool go = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }


  void getCurrentUser() {
    user = (_auth.currentUser!.email) as String;
  }

  Duration _duration = const Duration(hours: 0, minutes: 0);

  DateTime _selectedDay = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
  DateTime _focusedDay = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
  CalendarFormat _calendarFormat = CalendarFormat.month;

  Set<String> bhajanDateSet = HashSet();

  void getUsersData(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    final data = snapshot.data?.docs;
    for (var maps in data!) {
      if (maps.get("user").toString() == _auth.currentUser?.email) {
        bhajanDateSet.add(maps.get("date"));
        // print(maps.get("user").toString());
        // print(maps.get("date").toString());
      }
    }
  }

  void addToFirebase(DateTime selectedDay) {
    // String? docID = _auth.currentUser?.email;
    // docID = (docID! + DateTime.now().toString());
    String? docID =DateTime.now().toString();
    _firestore.collection('dailytrack').doc(docID).set({
      'bhajan': true,
      'date': DateFormat('dd-MM-yyyy').format(selectedDay),
      'duration': _duration.inMinutes,
      'user': _auth.currentUser?.email,
      'timestamp': DateTime.now(),
    });
  }

  Center durationPicker() {
    return Center(
      child: Column(
        children: [
          DurationPicker(
            onChange: (val) {
              _duration = val;
            },
            duration: _duration,
          ),
          ElevatedButton(
              onPressed: () {
                print(_selectedDay);
                addToFirebase(_selectedDay);
                print(_selectedDay);
                // Duration? selectedDuration = showDurationPicker(
                //     context: context,
                //     initialTime: const Duration(minutes: 20)) as Duration?;
                //
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //     content: Text('Chose duration: $selectedDuration')));
              },
              child: const Text("Set Today's Duration"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                              if (!isSameDay(_selectedDay, selectedDay)) {
                                setState(
                                  () {
                                    _focusedDay = focusedDay;
                                    _selectedDay = selectedDay;
                                    // if (selectedDay ==
                                    //         DateTime.utc(
                                    //             DateTime.now().year,
                                    //             DateTime.now().month,
                                    //             (DateTime.now().day)) ||
                                    //     selectedDay ==
                                    //         DateTime.utc(
                                    //             DateTime.now().year,
                                    //             DateTime.now().month,
                                    //             (DateTime.now().day - 1))) {
                                    String d = DateFormat('dd-MM-yyyy')
                                        .format(selectedDay)
                                        .toString();
                                    if (!(bhajanDateSet.contains(d))) {
                                      go = true;
                                    }
                                    //}
                                  },
                                );
                              }
                            },
                          ),
                          ((!(bhajanDateSet.contains(DateFormat('dd-MM-yyyy')
                                          .format(_selectedDay)
                                          .toString()))) &&
                                      go) ==
                                  true
                              ? durationPicker()
                              : const Card(),
                        ])),
                  ),
                );
              })),
    );
  }
}
