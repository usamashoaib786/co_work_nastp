import 'package:co_work_nastp/Helpers/app_button.dart';
import 'package:co_work_nastp/Helpers/app_field.dart';
import 'package:co_work_nastp/Helpers/app_text.dart';
import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:co_work_nastp/Helpers/custom_appbar.dart';
import 'package:co_work_nastp/Helpers/screen_size.dart';
import 'package:co_work_nastp/Helpers/toaster.dart';
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
  final TextEditingController _controller = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  bool? filter;
  List<Map<String, dynamic>> filteredBookings = [];
  @override
  void initState() {
    super.initState();
    dio = AppDio(context);
    logger.init();
    fetchBookings();
  }

  void filterBookingsByDateRange() {
    if (fromDate == null || toDate == null) return;

    setState(() {
      filteredBookings = _bookings.where((booking) {
        DateTime bookingDate = DateTime.parse(booking['date']);
        return bookingDate.isAfter(fromDate!.subtract(Duration(days: 1))) &&
            bookingDate.isBefore(toDate!.add(Duration(days: 1)));
      }).toList();
      filter = true;
    });
  }

  /// Fetches all bookings from API
  Future<void> fetchBookings() async {
    setState(() => _isLoading = true);
    try {
      final response = await dio.get(path: AppUrls.bookingStatus);
      List<dynamic> schedules = response.data['schedules'];
      setState(() {
        _bookings =
            schedules.map((schedule) => _mapSchedule(schedule)).toList();
        filteredBookings = List.from(_bookings); // Copy data for filtering
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  /// Hits API to search bookings by name
  void searchBookings(String query) async {
    if (query.isEmpty) {
      fetchBookings();
      return;
    }
    setState(() => _isLoading = true);
    try {
      final response = await dio.get(
          path:
              "https://api.coworkatnastp.com/api/booking-schedule/search?query=$query");
      List<dynamic> schedules = response.data['results'];
      setState(() {
        _bookings =
            schedules.map((schedule) => _mapSchedule(schedule)).toList();
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Map<String, dynamic> _mapSchedule(dynamic schedule) {
    return {
      "date": formatDate(schedule['date']),
      "floor": schedule['floor']?['name'] ?? 'N/A',
      "room": schedule['room']?['name'] ?? 'N/A',
      "startTime": formatTime(schedule['startTime']),
      "endTime": formatTime(schedule['endTime']),
      "status": schedule['status'] ?? 'N/A',
      "title": schedule['title'],
      "event_id": schedule['event_id'],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        txt: "Bookings",
        leadIcon: true,
        buttonColor: AppTheme.appColor,
        color: AppTheme.black,
        cicleColor: AppTheme.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomAppFormField(
                  texthint: "Search...",
                  border: false,
                  prefixIcon: Icon(
                    Icons.search,
                    size: 30,
                  ),
                  controller: _controller,
                  width: ScreenSize(context).width * 0.7,
                  bgcolor: const Color(0xffF4F4F4),
                  onChanged: (value) {
                    searchBookings(value);
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    showDateFilterBottomSheet(context);
                  },
                  child: Container(
                    height: 60,
                    width: ScreenSize(context).width * 0.20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffF4F4F4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset("assets/images/filter.png", height: 15),
                        AppText.appText(
                          "Filter",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (fromDate != null && toDate != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: Colors.black, fontSize: 16), // Default style
                        children: [
                          TextSpan(
                            text: DateFormat('yyyy-MM-dd').format(fromDate!),
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.bold), // Bold for From Date
                          ),
                          TextSpan(
                            text: "   to   ", // Normal text for "to"
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: DateFormat('yyyy-MM-dd').format(toDate!),
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.bold), // Bold for To Date
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : filter == true
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: filteredBookings.length,
                          itemBuilder: (context, index) {
                            final booking = filteredBookings[index];
                            return builder(booking: booking);
                          },
                        ),
                      )
                    : _hasError
                        ? Center(
                            child: Column(
                              children: [
                                Text("Failed to load data!",
                                    style: TextStyle(fontSize: 18)),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: fetchBookings,
                                  child: Text("Retry"),
                                ),
                              ],
                            ),
                          )
                        : _bookings.isEmpty
                            ? Center(
                                child: Text("No bookings available",
                                    style: TextStyle(fontSize: 18)))
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: _bookings.length,
                                  itemBuilder: (context, index) {
                                    final booking = _bookings[index];
                                    return builder(booking: booking);
                                  },
                                ),
                              ),
          ],
        ),
      ),
    );
  }

  void showDateFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Select Date Range",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  SizedBox(height: 10),

                  // From Date Picker
                  ListTile(
                    title: Text(fromDate == null
                        ? "Select From Date"
                        : "From:   ${DateFormat('yyyy-MM-dd').format(fromDate!)}"),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: fromDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (pickedDate != null) {
                        setState(() => fromDate = pickedDate);
                      }
                    },
                  ),

                  // To Date Picker
                  ListTile(
                    title: Text(toDate == null
                        ? "Select To Date"
                        : "To:   ${DateFormat('yyyy-MM-dd').format(toDate!)}"),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: toDate ?? DateTime.now(),
                        firstDate: fromDate ?? DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (pickedDate != null) {
                        setState(() => toDate = pickedDate);
                      }
                    },
                  ),

                  SizedBox(height: 20),

                  // Apply Button

                  AppButton.appButton(
                    context: context,
                    "Apply Filter",
                    onTap: () {
                      if (fromDate != null && toDate != null) {
                        filterBookingsByDateRange();
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String formatDate(String isoDate) {
    DateTime date = DateTime.parse(isoDate);
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String formatTime(String isoTime) {
    DateTime utcTime = DateTime.parse(isoTime).toUtc();
    DateTime pakTime = utcTime.add(const Duration(hours: 5));
    return "${pakTime.hour % 12 == 0 ? 12 : pakTime.hour % 12}:${pakTime.minute.toString().padLeft(2, '0')} ${pakTime.hour >= 12 ? "PM" : "AM"}";
  }

  /// Returns color based on booking status
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color.fromARGB(255, 192, 191, 187)   ;
      case 'approved':
        return AppTheme.appColor;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget customRow({txt1, txt2, txt3, txt4, img1, img2}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: ScreenSize(context).width * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: const Color(0xffF4F4F4)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image(image: AssetImage("$img1")),
                    )),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.appText("$txt1",
                        fontSize: 12,
                        textColor: Color(0xff757575),
                        fontWeight: FontWeight.w500),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: AppText.appText(
                        "$txt2",
                        fontSize: 12,
                        textColor: Colors.black,
                        fontWeight: FontWeight.w500,
                        softWrap: true,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            width: ScreenSize(context).width * 0.4,
            child: Column(
              children: [
                Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: const Color(0xffF4F4F4)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image(image: AssetImage("$img2")),
                    )),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.appText("$txt3",
                        fontSize: 12,
                        textColor: Color(0xff757575),
                        fontWeight: FontWeight.w500),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: AppText.appText(
                        "$txt4",
                        fontSize: 12,
                        textColor: Colors.black,
                        fontWeight: FontWeight.w500,
                        softWrap: true,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget builder({booking}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        color: AppTheme.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Container(
          height: 330,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 52,
                decoration: BoxDecoration(
                    color: AppTheme.appColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 1,
                        height: 1,
                      ),
                      AppText.appText(capitalize(booking['title']),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          textColor: AppTheme.white),
                      PopupMenuButton<String>(
                        color: AppTheme.white,
                        padding: EdgeInsets.all(0),
                        iconColor: AppTheme.white,
                        onSelected: (value) {
                          if (value == 'Delete') {
                            showCancelBookingDialog(context,
                                id: booking["event_id"]);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: "Delete",
                            child: Text("Delete"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              customRow(
                  txt1: "Date:",
                  txt2: "${booking['date']}",
                  txt3: "Time:",
                  txt4: " ${booking['startTime']} - ${booking['endTime']}",
                  img1: "assets/images/calendar.png",
                  img2: "assets/images/clock.png"),
              customRow(
                  txt1: "Room:",
                  txt2: "${booking['room']}",
                  img1: "assets/images/room.png",
                  txt3: "Floor:",
                  txt4: "${booking['floor']}",
                  img2: "assets/images/floor.png"),
              Container(
                height: 1,
                width: ScreenSize(context).width,
                color: Color(0xffD8D8D8),
              ),
              Center(
                child: Container(
                  width: 130,
                  height: 50,
                  decoration: BoxDecoration(
                    color: getStatusColor(booking['status']),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: AppText.appText(
                      capitalize(booking['status']),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      textColor: AppTheme.white,
                    ),
                  ),
                ),
              ),
              SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  void showCancelBookingDialog(BuildContext context, {id}) {
    print("object$id");
    showDialog(
      context: context,
      barrierDismissible: true, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          contentPadding: EdgeInsets.all(20), // Spacing inside the dialog
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are you sure you want to cancel this booking?",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // No, Keep Booking Button
                  Expanded(
                    child: AppButton.appButton(onTap: () {
                      Navigator.pop(context);
                    },
                        context: context,
                        "No",
                        fontSize: 14,
                        width: ScreenSize(context).width * 0.2,
                        height: 40,
                        backgroundColor: Colors.transparent,
                        border: true,
                        textColor: AppTheme.appColor,
                        fontWeight: FontWeight.w500),
                  ),

                  SizedBox(width: 10),
                  // Yes, Cancel Button
                  Expanded(
                    child: AppButton.appButton(onTap: () {
                      Navigator.pop(context);
                      delBooking(id: id);
                    },
                        context: context,
                        "Yes",
                        fontSize: 14,
                        width: ScreenSize(context).width * 0.2,
                        height: 40,
                        backgroundColor: Colors.red,
                        border: false,
                        borderColor: Colors.transparent,
                        textColor: AppTheme.white,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void delBooking({id}) async {
    setState(() => _isLoading = true);
    try {
      final response = await dio.delete(
          path: "https://api.coworkatnastp.com/api/booking-schedule/$id");
      if (response.statusCode == 200) {
        ToastHelper.displaySuccessMotionToast(
            context: context, msg: "Deleted successfully!");
        setState(() {
          fetchBookings();
          _isLoading = false;
          _hasError = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }
}
