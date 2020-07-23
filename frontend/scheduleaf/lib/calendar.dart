import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'calendar_response.dart';

class Calendar extends StatefulWidget {
  final String username;
  Calendar({Key key, @required this.username}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState(username: username);
}

class _CalendarState extends State<Calendar> {
  int selectedIndex = 1;
  final String username;
  _CalendarState({Key key, @required this.username});

  Future<CalendarResponse> calendarResponse;

  CalendarResponse calendarData;

  DateTime startDate =
      DateTime(2020, 7, 20, 10, 0, 0); // TODO - don't hardcode?

  void onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void initState() {
    generateCalendar();
    super.initState();
  }

  generateCalendar() async {
    var temp = await generateCalendarRequest();
    setState(() {
      calendarData = temp;
    });
  }

  Future<CalendarResponse> generateCalendarRequest() async {
    final http.Response response = await http.get(
      'http://10.0.2.2:8000/tasks/generate/$username',
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
      throw Exception('Failed to update task list with username: $username');
    }
  }

  List<FlutterWeekViewEvent> generateEvents() {
    // handle initial load before request finishes
    if (calendarData == null) {
      return [];
    }

    List<FlutterWeekViewEvent> events = [];
    for (int i = 0; i < calendarData.taskList.length; i++) {
      CalendarTask task = calendarData.taskList[i];
      events.add(
        FlutterWeekViewEvent(
          title: task.title,
          description: task.description,
          start: convertIntervalToDate(task.scheduledStart, false),
          end: convertIntervalToDate(task.scheduledStart + task.duration, true),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black45,
              width: 2,
            ),
          ),
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
        leading: new Container(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.green,
        onTap: onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Text('Tasks'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('Calendar'),
          ),
        ],
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
            minimumTime: HourMinute(hour: 9, minute: 47),
            maximumTime: HourMinute(hour: 18, minute: 13),
            scrollToCurrentTime: false,
            userZoomable: false,
            dayViewStyleBuilder: (DateTime date) => DayViewStyle(
              currentTimeRuleColor: Colors.pink,
              currentTimeCircleColor: Colors.pink,
            ),
          ),
        ),
      ),
    );
  }
}
