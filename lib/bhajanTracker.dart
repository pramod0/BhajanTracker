//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

TextStyle kGoogleStyleTexts = GoogleFonts.openSans(
    fontWeight: FontWeight.w600, color: Colors.black, fontSize: 20.0);

final _firestore = FirebaseFirestore.instance;

class BhajanTrack extends StatefulWidget {
  const BhajanTrack({super.key});

  @override
  _BhajanTrackState createState() => _BhajanTrackState();
}

class _BhajanTrackState extends State<BhajanTrack> {
  final _auth = FirebaseAuth.instance;
  DateTime _selectedDay = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
  DateTime _focusedDay = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
  CalendarFormat _calendarFormat = CalendarFormat.week;

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor("#FFBE68"),
        title: const Text(
          "Bhajan",
          style: TextStyle(color: Colors.black, fontSize: 20.0),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
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
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TableCalendar(
                calendarBuilders: CalendarBuilders(

                ),

                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: hexToColor("#FFBE68"),
                    shape: BoxShape.circle,
                  ),
                  outsideDaysVisible: true,
                  outsideDecoration: BoxDecoration(
                    color: hexToColor("#FEAE30"),
                  ),
                  holidayDecoration: BoxDecoration(
                    color: hexToColor("#FEAE30"),
                  ),
                    weekendDecoration: BoxDecoration(
                      color: hexToColor("#FEAE30"),
                    ),
                    defaultDecoration: BoxDecoration(
                      color: hexToColor("#FEAE30"),
                    ),
                    selectedDecoration: BoxDecoration(
                      color: hexToColor("#FFBE68"),
                      shape: BoxShape.rectangle,
                    ),
                    selectedTextStyle: const TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                        fontSize: 16)),
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
                lastDay: DateTime.utc(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day),
                focusedDay: _selectedDay,
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay) &&
                          selectedDay ==
                              DateTime.utc(DateTime.now().year,
                                  DateTime.now().month, (DateTime.now().day)) ||
                      selectedDay ==
                          DateTime.utc(DateTime.now().year,
                              DateTime.now().month, (DateTime.now().day - 1))) {
                    setState(
                      () {
                        _focusedDay = focusedDay;
                        _selectedDay = selectedDay;
                        final user = _auth.signInAnonymously();
                        print(
                            _firestore.doc("dailytrack/ybJWOpm4Gbe4y6dKncFA"));
                        _firestore.collection('dailytrack').add({
                          'bhajan': true,
                          'bhajanTS': DateTime.now(),
                          'swadhyay': true,
                          'swadhyayTS': DateTime.now(),
                          'pooja': true,
                          'poojaTS': DateTime.now(),
                        });
                        // _db
                        //     .collection('jobs')
                        //     .where("categoryId", isEqualTo: categoryId)
                        //     .getDocuments()
                        //     .then((v) {
                        // try{
                        // v.documents[0].data.update('isApproved', (bool) => true,ifAbsent: ()=>true);
                        print("hello$_firestore");
                        //_selectedEvents = _getEventsForDay(selectedDay);
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }

// List<Map<String, String>> _getEventsForDay(DateTime day) {
//   List<Map<String, String>> subjectAttendanceMap = [];
//   widget.scheduleRecords?.map((record) => {
//     if(record.date == day){
//       // print("PRAMOD "+record.details.toString())
//       subjectAttendanceMap.add(record.details)
//     }
//   }).toList();
//
//   return subjectAttendanceMap;
// }
}
