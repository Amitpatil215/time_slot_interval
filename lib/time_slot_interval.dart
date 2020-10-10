library time_slot_interval;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/date_time_provider.dart';
import 'widgets/SlotIntervalGenerator.dart';

class TimeSlotIntervel extends StatelessWidget {
  @required
  final DateTime startTime;
  @required
  final DateTime endTime;
  @required
  final Duration step;
  final bool custom;

  TimeSlotIntervel({
    this.startTime,
    this.endTime,
    this.step,
    this.custom = false,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DateTimeProvider(),
      child: !custom
          ? SlotInteralGenerator(startTime, endTime, step)
          : Text("Hello"),
    );
  }
}
