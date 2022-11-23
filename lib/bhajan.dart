import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Bhajan {
  late bool bhajan;
  late String date;
  late int duration;
  Timestamp? timestamp;
  String? user;

  Bhajan({required this.bhajan,required this.date,required this.duration, this.timestamp, this.user});

  // Bhajan.fromSnapshot(AsyncSnapshot<QuerySnapshot> snapshot)
  //     : this.fromMap(
  //     snapshot.data! as Map<String, dynamic>
  // );

  Bhajan.fromMap(Map<String, dynamic> map)  :
        bhajan = map['bhajan'],
        date = map['date'],
        duration = map['duration'],
        timestamp = map['timestamp'],
        user = map['user'];

  Bhajan.fromJson(Map<String, dynamic> json) {
    bhajan = json['bhajan'];
    date = json['date'];
    duration = json['duration'];
    timestamp = json['timestamp'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bhajan'] = this.bhajan;
    data['date'] = this.date;
    data['duration'] = this.duration;
    data['timestamp'] = this.timestamp;
    data['user'] = this.user;
    return data;
  }

  @override
  String toString() {
    return this.date.toString() + " : " + this.duration.toString();
  }
}
