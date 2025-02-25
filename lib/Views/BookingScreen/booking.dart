// import 'package:co_work_nastp/Helpers/app_field.dart';
import 'package:co_work_nastp/Helpers/app_text.dart';
import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:co_work_nastp/Helpers/custom_appbar.dart';
import 'package:co_work_nastp/Helpers/toaster.dart';
import 'package:co_work_nastp/Helpers/utils.dart';
import 'package:co_work_nastp/Views/BookingScreen/sf.dart';
import 'package:co_work_nastp/config/dio/app_logger.dart';
import 'package:co_work_nastp/config/dio/dio.dart';
import 'package:co_work_nastp/config/keys/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool isLoading = false;
  late AppDio dio;
  String? selectedLocationId; // Store selected location ID
  String? selectedRoomId; // Store selected location ID
  List<Map<String, dynamic>> locationData = [];
  List<Map<String, dynamic>> roomData = [];
  AppLogger logger = AppLogger();

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getLocation(context);
    super.initState();
  }

  void getLocation(context) async {
    try {
      Response response = await dio.get(path: AppUrls.getLocation);
      if (response.statusCode == 200) {
        setState(() {
          locationData =
              List<Map<String, dynamic>>.from(response.data["locations"]);
          if (kDebugMode) {
            print("object$locationData");
          }
        });
      } else if (response.statusCode == 401) {
        navigateFunction(context: context);
      } else {
        ToastHelper.displayErrorMotionToast(
            context: context, msg: "${response.data["message"]}");
      }
    } catch (e) {
      ToastHelper.displayErrorMotionToast(
          context: context, msg: "Something went wrong.");
    }
  }

  void getRoom(context, id) async {
    try {
      Response response = await dio.get(
          path: "${AppUrls.baseUrl}booking-schedule/filter?location_id=$id");
      if (response.statusCode == 200) {
        setState(() {
          roomData = List<Map<String, dynamic>>.from(response.data["rooms"]);
        });
      } else if (response.statusCode == 401) {
        navigateFunction(context: context);
      } else {
        ToastHelper.displayErrorMotionToast(
            context: context, msg: "${response.data["message"]}");
      }
    } catch (e) {
      ToastHelper.displayErrorMotionToast(
          context: context, msg: "Something went wrong.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss keyboard on tap
      },
      child: Scaffold(
        appBar: CustomAppBar(
          txt: "Meeting Room Booking",
          color: AppTheme.appColor,
          leadIcon: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.appText(
                  'Select Location',
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                    hint: Text("Choose a Location"),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: AppTheme.borderCOlor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: AppTheme.borderCOlor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: AppTheme.borderCOlor),
                      ),
                    ),
                    items: locationData
                        .map((location) => DropdownMenuItem(
                              value: location["id"].toString(), // Store ID
                              child: Text(location["name"]),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedLocationId = value; // Save selected location ID
                        getRoom(context, selectedLocationId);
                      });
                    }),
                SizedBox(height: 20),
                AppText.appText(
                  'Select Room',
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                    hint: Text("Choose a room"),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: AppTheme.borderCOlor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: AppTheme.borderCOlor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: AppTheme.borderCOlor),
                      ),
                    ),
                    items: roomData
                        .map((room) => DropdownMenuItem(
                              value: room["id"].toString(), // Store ID
                              child: Text(room["name"]),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRoomId = value; // Save selected location ID
                      });
                    }),
                SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    child: SfCalendar(
                      view: CalendarView.month,
                      todayHighlightColor:
                          AppTheme.appColor, // Highlight today's date
                      selectionDecoration: BoxDecoration(
                        border: Border.all(color: AppTheme.appColor, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      headerStyle: CalendarHeaderStyle(
                        textAlign: TextAlign.center,
                        backgroundColor: AppTheme.appColor,
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.white,
                        ),
                      ),
                      viewHeaderStyle: ViewHeaderStyle(
                        backgroundColor: AppTheme.appColor
                            .withValues(alpha: 0.1), // Light background for weekdays
                        dayTextStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      cellBorderColor:
                          Colors.transparent, // Remove grid borders
                      monthViewSettings: MonthViewSettings(
                          appointmentDisplayMode:
                              MonthAppointmentDisplayMode.indicator,
                          showTrailingAndLeadingDates:
                              false // Adjust number of weeks visible in the month view
                          ),
                      onTap: (CalendarTapDetails details) {
                        if (selectedLocationId != null &&
                            selectedRoomId != null) {
                          if (details.targetElement ==
                              CalendarElement.calendarCell) {
                            DateTime selectedDate = details.date!;
                            push(
                                context,
                                CalenderView(
                                  selectedDate: selectedDate,
                                  roomID: "$selectedRoomId",
                                  locationId: "$selectedLocationId",
                                ));
                          }
                        } else {
                          ToastHelper.displayErrorMotionToast(
                              context: context, msg: "Please Select Id's");
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
