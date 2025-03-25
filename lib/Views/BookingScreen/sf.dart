import 'package:co_work_nastp/Views/BookingScreen/add_event_screen.dart';
import 'package:co_work_nastp/Views/BookingScreen/meeting_class.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:co_work_nastp/Helpers/toaster.dart';
import 'package:co_work_nastp/config/dio/app_logger.dart';
import 'package:co_work_nastp/config/dio/dio.dart';
import 'package:co_work_nastp/config/keys/urls.dart';
import 'package:dio/dio.dart';

class CalenderView extends StatefulWidget {
  final DateTime? selectedDate;
  final String? roomID;
  final String? locationId;

  const CalenderView(
      {super.key, this.selectedDate, this.roomID, this.locationId});

  @override
  State<CalenderView> createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  DateTime? selectedDate;
  List<Meeting> meetings = [];
  bool isLoading = false;
  late AppDio dio;
  AppLogger logger = AppLogger();

  @override
  void initState() {
    super.initState();
    dio = AppDio(context);
    logger.init();
    selectedDate = widget.selectedDate; // Initialize with widget's value
    getBookings(date: selectedDate, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar View", style: TextStyle(color: Colors.white, fontFamily: "Montserrat")),
        backgroundColor: AppTheme.appColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.appColor,
        onPressed: () => _showEventBottomSheet(),
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SfCalendar(
              key:
                  ValueKey(selectedDate), // Ensures widget rebuilds correctly
              view: CalendarView.day,
              headerHeight: 60,
              showDatePickerButton: true,
              initialDisplayDate: selectedDate,
              dataSource: MeetingDataSource(
                  List.from(meetings)), // Avoid reference issues
              timeSlotViewSettings: TimeSlotViewSettings(
                timeIntervalHeight: 60,
                timeRulerSize: 65,
                timeTextStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              headerStyle: CalendarHeaderStyle(
                backgroundColor: AppTheme.appColor,
                textStyle: TextStyle(color: AppTheme.white),
              ),
              selectionDecoration: BoxDecoration(
                color: AppTheme.appColor.withValues(alpha: 0.1),
                border: Border.all(color: AppTheme.appColor, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              onTap: (CalendarTapDetails details) {
                if (details.targetElement == CalendarElement.appointment) {
                  Meeting meeting = details.appointments!.first;
                  showEventDetailsDialog(meeting, context);
                } else if (details.targetElement ==
                    CalendarElement.calendarCell) {
                  DateTime selectedStartTime = details.date ?? DateTime.now();
                  DateTime selectedEndTime = selectedStartTime
                      .add(Duration(minutes: 60)); // Default duration
                  _showEventBottomSheet(
                    startTime: selectedStartTime,
                    endTime: selectedEndTime,
                  );
                }
              },
    
              onViewChanged: (ViewChangedDetails details) {
                if (details.visibleDates.isNotEmpty) {
                  DateTime newDate =
                      details.visibleDates.first; // Get first visible date
                  if (selectedDate != newDate) {
                    setState(() {
                      selectedDate = newDate;
                    });
                    getBookings(date: selectedDate, context: context);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEventBottomSheet({startTime, endTime}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return AddEventBottomSheet(
          startTime: startTime,
          endTime: endTime,
          selectedDate: selectedDate!,
          locationId: int.parse("${widget.locationId}"),
          roomID: int.parse("${widget.roomID}"),
        );
      },
    );
  }
////////////////////////////////////////// APIS ////////////////////////////////////

  void getBookings({date, context}) async {
    try {
      Response response = await dio.get(
          path:
              "${AppUrls.baseUrl}booking-schedule/filter?location_id=${widget.locationId}&room_id=${widget.roomID}&date=$date");
      if (response.statusCode == 200) {
        fetchMeetings(response.data);
      } else {
        ToastHelper.displayErrorMotionToast(
            context: context, msg: "${response.data["message"]}");
      }
    } catch (e) {
      ToastHelper.displayErrorMotionToast(
          context: context, msg: "Something went wrong.");
    }
  }

  Future<void> fetchMeetings(data) async {
    final List<dynamic> schedules = data["schedules"] ?? [];

    setState(() {
      meetings = schedules.map((schedule) {
        DateTime utcStartTime =
            DateTime.tryParse(schedule['startTime'] ?? "") ?? DateTime.now();
        DateTime utcEndTime = DateTime.tryParse(schedule['endTime'] ?? "") ??
            DateTime.now().add(Duration(hours: 1));

        // ✅ Convert UTC to Pakistan Standard Time (UTC+5)
        DateTime pakStartTime = utcStartTime.toLocal();
        DateTime pakEndTime = utcEndTime.toLocal();
        return Meeting(
          schedule['title'] ?? "Untitled Event",
          pakStartTime,
          pakEndTime,
          Colors.blue,
          false,
          schedule['persons'] ?? 1,
        );
      }).toList();
    });
  }
}
