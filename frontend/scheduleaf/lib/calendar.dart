import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'calendar_response.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Future<CalendarResponse> calendarResponse;

  CalendarResponse calendarData;

  DateTime startDate =
      DateTime(2020, 7, 20, 10, 0, 0); // TODO - don't hardcode?

  @override
  void initState() {
    calendarResponse = generateCalendar();
    print("response received");
    calendarResponse.then((calendarObj) => calendarData = calendarObj);
    super.initState();
  }

  Future<CalendarResponse> generateCalendar() async {
    final http.Response response = await http.get(
      'http://10.0.2.2:8000/tasks/generate/' + 'will', // TODO - username
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return CalendarResponse.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update task list');
    }
  }

  List<FlutterWeekViewEvent> generateEvents() {
    List<FlutterWeekViewEvent> events = [];
    for (int i = 0; i < calendarData.taskList.length; i++) {
      CalendarTask task = calendarData.taskList[i];
      events.add(
        FlutterWeekViewEvent(
          title: task.title,
          description: task.description,
          start: convertIntervalToDate(task.scheduledStart, false),
          end: convertIntervalToDate(task.scheduledStart + task.duration, true),
          backgroundColor: Colors.green,
        ),
      );
    }
    return events;
  }

  DateTime convertIntervalToDate(int interval, isDeadline) {
    // day from 0-4 represented by integer division of 32 intervals in a day
    int dayInt = interval ~/ 32;

    // subtract out the full days from the interval, find how many full hours there are
    int hourInterval = interval - (32 * dayInt);
    int hourInt = hourInterval ~/ 4;

    // the remaining intervals are for minutes
    int minInterval = hourInterval - (4 * hourInt);
    int minInt = 15 * minInterval;

    DateTime date =
        startDate.add(Duration(days: dayInt, hours: hourInt, minutes: minInt));

    // if the datetime to be found is for a deadline and it is at the start
    // of a day, move to the end of the previous day by subtracting 16 hours
    if (isDeadline && hourInt == 0) {
      date.subtract(Duration(hours: 16));
    }

    return date;
  }

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
              startDate,
              startDate.add(Duration(days: 1)),
              startDate.add(Duration(days: 2)),
              startDate.add(Duration(days: 3)),
              startDate.add(Duration(days: 4))
            ],
            events: generateEvents(),
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
