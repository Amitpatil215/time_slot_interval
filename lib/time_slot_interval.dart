library time_slot_interval;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './provider/date_time_provider.dart';
import 'widgets/SlotIntervalGenerator.dart';

typedef OnTapValueSetter<T> = void Function(T newValue);

class TimeSlotIntervelDefault extends StatelessWidget {
  /// Starting Time

  final DateTime startTime;

  final DateTime endTime;

  /// Difference between two dateTime

  final Duration step;

  /// The callback that is called when the time slot is tapped.

  final OnTapValueSetter<DateTime> onTap;

  TimeSlotIntervelDefault({
    required this.startTime,
    required this.endTime,
    required this.step,
    required this.onTap,
  });

  void _save(value) {
    onTap(value);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DateTimeProvider(),
        child: SlotInteralGenerator(startTime, endTime, step, _save));
  }
}
