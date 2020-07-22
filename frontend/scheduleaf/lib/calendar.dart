import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime date = DateTime(2020, 7, 20); // TODO - don't hardcode?

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
      ),
      body: Center(
        child: Container(
          child: WeekView(
            dates: [
              date,
              date.add(Duration(days: 1)),
              date.add(Duration(days: 2)),
              date.add(Duration(days: 3)),
              date.add(Duration(days: 4))
            ],
            events: [
              FlutterWeekViewEvent(
                title: 'An event 1',
                description: 'A description 1',
                start: date.subtract(Duration(hours: 25)),
                end: date.add(Duration(hours: 18, minutes: 30)),
                backgroundColor: Colors.green,
              ),
              FlutterWeekViewEvent(
                title: 'An event 2',
                description: 'A description 2',
                start: date.add(Duration(hours: 19)),
                end: date.add(Duration(hours: 22)),
              ),
              FlutterWeekViewEvent(
                title: 'An event 3',
                description: 'A description 3',
                start: date.add(Duration(hours: 23, minutes: 30)),
                end: date.add(Duration(hours: 25, minutes: 30)),
              ),
              FlutterWeekViewEvent(
                title: 'An event 4',
                description: 'A description 4',
                start: date.add(Duration(hours: 20)),
                end: date.add(Duration(hours: 21)),
              ),
              FlutterWeekViewEvent(
                title: 'An event 5',
                description: 'A description 5',
                start: date.add(Duration(hours: 20)),
                end: date.add(Duration(hours: 21)),
              ),
            ],
            style: const WeekViewStyle(),
            minimumTime: HourMinute(hour: 9, minute: 45),
            maximumTime: HourMinute(hour: 18, minute: 15),
            scrollToCurrentTime: false,
            userZoomable: false,
          ),
        ),
      ),
    );
  }
}
