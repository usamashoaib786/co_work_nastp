import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Meeting {
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  int persons;

  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay,
      this.persons);
}

/// Data source for the calendar
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) => appointments![index].from;

  @override
  DateTime getEndTime(int index) => appointments![index].to;

  @override
  String getSubject(int index) => appointments![index].eventName;

  @override
  Color getColor(int index) => appointments![index].background;

  @override
  bool isAllDay(int index) => appointments![index].isAllDay;
}



void showEventDetailsDialog(Meeting meeting, context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Colors.white,
      title: Text(
        meeting.eventName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppTheme.appColor,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("🕒 Start: ${DateFormat('hh:mm a').format(meeting.from)}"),
          Text("⏳ End: ${DateFormat('hh:mm a').format(meeting.to)}"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Close",
            style: TextStyle(color: AppTheme.appColor),
          ),
        ),
      ],
    ),
  );
}
