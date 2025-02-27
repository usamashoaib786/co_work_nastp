import 'package:co_work_nastp/Helpers/app_text.dart';
import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:co_work_nastp/Helpers/custom_appbar.dart';
import 'package:co_work_nastp/Helpers/screen_size.dart';
import 'package:co_work_nastp/config/dio/app_logger.dart';
import 'package:co_work_nastp/config/dio/dio.dart';
import 'package:co_work_nastp/config/keys/urls.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingStatus extends StatefulWidget {
  const BookingStatus({super.key});

  @override
  State<BookingStatus> createState() => _BookingStatusState();
}

class _BookingStatusState extends State<BookingStatus> {
  List<Map<String, dynamic>> _bookings = [];
  bool _isLoading = true;
  bool _hasError = false;
  AppLogger logger = AppLogger();
  late AppDio dio;

  @override
  void initState() {
    super.initState();
    dio = AppDio(context);
    logger.init();
    fetchBookings();
  }

  /// Fetches booking data from API
  Future<void> fetchBookings() async {
    try {
      final response = await dio.get(path: AppUrls.bookingStatus);
      debugPrint("Full API Response: ${response.data}");

      List<dynamic> schedules = response.data['schedules'];

      setState(() {
        _bookings = schedules.map((schedule) {
          return {
            "date": formatDate(schedule['date']),
            "floor": schedule['floor']?['name'] ?? 'N/A',
            "room": schedule['room']?['name'] ?? 'N/A',
            "startTime": formatTime(schedule['startTime']),
            "endTime": formatTime(schedule['endTime']),
            "status": schedule['status'] ?? 'N/A',
          };
        }).toList();

        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      debugPrint("Error fetching data: $e");
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        txt: "Booking Status",
        leadIcon: true,
        bgcolor: AppTheme.appColor,
        color: AppTheme.white,
        cicleColor: AppTheme.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Failed to load data!",
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: fetchBookings,
                        child: Text("Retry"),
                      )
                    ],
                  ),
                )
              : _bookings.isEmpty
                  ? Center(
                      child: Text("No bookings available",
                          style: TextStyle(fontSize: 18)),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: _bookings.length,
                        itemBuilder: (context, index) {
                          final booking = _bookings[index];
                          return Padding(

                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 10,
                              child: Container(
                                height: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 230, 242, 255),
                                      Color.fromARGB(255, 117, 145, 152)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      customRow(
                                          txt1: "Date:",
                                          txt2: "${booking['date']}",
                                          icon: Icons.door_back_door),
                                      customRow(
                                          txt1: "Time:",
                                          txt2:
                                              " ${booking['startTime']} - ${booking['endTime']}",
                                          icon: Icons.door_back_door),
                                      customRow(
                                          txt1: "Room:",
                                          txt2: "${booking['room']}",
                                          icon: Icons.door_back_door),
                                      customRow(
                                          txt1: "Floor:",
                                          txt2: "${booking['floor']}",
                                          icon: Icons.apartment),
                                      Center(
                                        child: Container(
                                          width: ScreenSize(context).width * 0.5,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: getStatusColor(
                                                  booking['status']),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: AppTheme.appColor,
                                                  width: 1)),
                                          child: Center(
                                            child: AppText.appText(
                                              "${booking['status']}",
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              textColor: AppTheme.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }

  /// Converts ISO date string to readable format
  String formatDate(String isoDate) {
    DateTime date = DateTime.parse(isoDate);
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Converts UTC time to Pakistan Time (UTC+5)
  String formatTime(String isoTime) {
    DateTime utcTime = DateTime.parse(isoTime).toUtc();
    DateTime pakTime = utcTime.add(const Duration(hours: 5));
    return "${pakTime.hour % 12 == 0 ? 12 : pakTime.hour % 12}:${pakTime.minute.toString().padLeft(2, '0')} ${pakTime.hour >= 12 ? "PM" : "AM"}";
  }

  /// Returns color based on booking status
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color.fromARGB(255, 235, 195, 134);
      case 'approved':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget customRow({txt1, txt2, icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.appColor, size: 18),
            SizedBox(width: 10),
            AppText.appText("$txt1",
                fontSize: 20,
                textColor: Colors.black,
                fontWeight: FontWeight.w600)
          ],
        ),
        AppText.appText("$txt2",
            fontSize: 16, textColor: Colors.black, fontWeight: FontWeight.w400)
      ],
    );
  }
}
