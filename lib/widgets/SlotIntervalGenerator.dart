import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/date_time_provider.dart';

class SlotInteralGenerator extends StatelessWidget {
  final DateTime _startTime;
  final DateTime _endTime;
  final Duration _step;
  final Function save;

  SlotInteralGenerator(this._startTime, this._endTime, this._step, this.save);

  Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }

  @override
  Widget build(BuildContext context) {
    final times = getTimes(TimeOfDay.fromDateTime(_startTime),
            TimeOfDay.fromDateTime(_endTime), _step)
        .map((tod) => tod)
        .toList();
    var fetchedTime = Provider.of<DateTimeProvider>(context).fetchTime;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 7),
        child: EachTimeSlotGenerate(
          times: times,
          title: "All time",
          selectedTime: fetchedTime,
          save: save,
        ),
      ),
    );
  }
}

class EachTimeSlotGenerate extends StatelessWidget {
  final String title;
  final TimeOfDay selectedTime;
  final List<TimeOfDay> times;
  final Function save;

  EachTimeSlotGenerate({
    Key? key,
    required this.title,
    required this.selectedTime,
    required this.times,
    required this.save,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(height: 10),
          Container(
            height: 40,
            width: double.infinity,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: times.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1 / 2,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) => GestureDetector(
                child: Container(
                  child: Center(
                      child: Text(
                    times.elementAt(index).format(context),
                    style: TextStyle(
                        fontWeight: selectedTime == times.elementAt(index)
                            ? FontWeight.bold
                            : null),
                  )),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey),
                    color: selectedTime == times.elementAt(index)
                        ? Colors.white
                        : null,
                  ),
                ),
                onTap: () {
                  Provider.of<DateTimeProvider>(context, listen: false)
                      .setTimeSelected(times.elementAt(index));
                  save(Provider.of<DateTimeProvider>(context, listen: false)
                      .fetchAppointmentDate);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
