import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Bhajan {
  bool? bhajan;
  String? date;
  int? duration;
  DateTime? timestamp;
  String? user;

  Bhajan({this.bhajan, this.date, this.duration, this.timestamp, this.user});

  // Bhajan.fromSnapshot(AsyncSnapshot<QuerySnapshot> snapshot)
  //     : this.fromMap(
  //     snapshot.data! as Map<String, dynamic>
  // );

  Bhajan.fromMap(Map<String, dynamic> map)  :
        bhajan = map['bhajan'],
        date = map['date'],
        duration = map['duration'],
        timestamp = DateTime.parse(map['timestamp'].toString()),
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
