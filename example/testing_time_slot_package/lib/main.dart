import 'package:flutter/material.dart';
import 'package:time_slot_interval/time_slot_interval.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: TimeSlotIntervel(
            endTime: DateTime(2020, 9, 7, 23, 30),
            startTime: DateTime(2020, 9, 7, 2, 30),
            step: Duration(minutes: 30),
            custom: false,
          ),
        ),
      ),
    );
  }
}
