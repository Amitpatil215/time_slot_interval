import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/date_time_provider.dart';

class SlotInteralGenerator extends StatelessWidget {
  static List<TimeOfDay> morningTime;
  static List<TimeOfDay> afterNoonTime;
  static List<TimeOfDay> eveningTime;
  static List<TimeOfDay> nightTime;
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

  void partOfDayWiseList(List<TimeOfDay> times) {
    morningTime = times
        .where((element) => element.hour >= 4 && element.hour < 12)
        .toList();
    afterNoonTime = times
        .where((element) => element.hour >= 12 && element.hour < 17)
        .toList();
    eveningTime = times
        .where((element) => element.hour >= 17 && element.hour < 21)
        .toList();
    nightTime = times
        .where((element) => element.hour >= 21 && element.hour < 24)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final times = getTimes(TimeOfDay.fromDateTime(_startTime),
            TimeOfDay.fromDateTime(_endTime), _step)
        .map((tod) => tod)
        .toList();
    partOfDayWiseList(times);
    var fetchedTime = Provider.of<DateTimeProvider>(context).fetchTime;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 7),
        child: Column(
          children: [
            if (morningTime.isNotEmpty)
              EachTimeSlotGenerate(
                times: morningTime,
                title: "Morning",
                selectedTime: fetchedTime,
                save: save,
              ),
            if (morningTime.isNotEmpty) SizedBox(height: 20),
            if (afterNoonTime.isNotEmpty)
              EachTimeSlotGenerate(
                times: afterNoonTime,
                title: "Afternoon",
                selectedTime: fetchedTime,
                save: save,
              ),
            if (afterNoonTime.isNotEmpty) SizedBox(height: 20),
            if (eveningTime.isNotEmpty)
              EachTimeSlotGenerate(
                times: eveningTime,
                title: "Evening",
                selectedTime: fetchedTime,
                save: save,
              ),
            if (eveningTime.isNotEmpty) SizedBox(height: 20),
            if (nightTime.isNotEmpty)
              EachTimeSlotGenerate(
                times: nightTime,
                title: "Night",
                selectedTime: fetchedTime,
                save: save,
              ),
          ],
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
    Key key,
    this.title,
    this.selectedTime,
    @required this.times,
    this.save,
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
