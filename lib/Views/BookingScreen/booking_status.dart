import 'package:co_work_nastp/Helpers/app_text.dart';
import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:co_work_nastp/Helpers/custom_appbar.dart';
import 'package:co_work_nastp/config/dio/app_logger.dart';
import 'package:co_work_nastp/config/dio/dio.dart';
import 'package:co_work_nastp/config/keys/urls.dart';
import 'package:flutter/material.dart';

class BookingStatus extends StatefulWidget {
  const BookingStatus({super.key});

  @override
  State<BookingStatus> createState() => _BookingStatusState();
}

class _BookingStatusState extends State<BookingStatus> {
  late MyData _data;
  bool _isLoading = true;
  AppLogger logger = AppLogger();
  late AppDio dio;
  int _totalRows = 0; // Track total rows

  @override
  void initState() {
    super.initState();
    dio = AppDio(context);
    logger.init();
    _data = MyData(dio, onRowCountChanged: (count) {
      setState(() {
        _totalRows = count;
      });
    });
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    await _data.fetchData();
    setState(() {
      _isLoading = false;
    });
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
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical, // Enable vertical scrolling
                      child: _totalRows > 12
                          ? PaginatedDataTable(
                              source: _data,
                              columns: _buildColumns(),
                              columnSpacing: 30,
                              rowsPerPage: 12,
                            )
                          : DataTable(
                              columns: _buildColumns(),
                              rows: _data.getAllRows(),
                            ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      DataColumn(
          label: AppText.appText('S. No',
              fontSize: 18, fontWeight: FontWeight.bold)),
      DataColumn(
          label: AppText.appText('Date',
              fontSize: 18, fontWeight: FontWeight.bold)),
      DataColumn(
          label: AppText.appText('Floor',
              fontSize: 18, fontWeight: FontWeight.bold)),
      DataColumn(
          label: AppText.appText('Room',
              fontSize: 18, fontWeight: FontWeight.bold)),
      DataColumn(
          label: AppText.appText('Start Time',
              fontSize: 18, fontWeight: FontWeight.bold)),
      DataColumn(
          label: AppText.appText('End Time',
              fontSize: 18, fontWeight: FontWeight.bold)),
      DataColumn(
          label: AppText.appText('Status',
              fontSize: 18, fontWeight: FontWeight.bold)),
    ];
  }
}

// DataTable Source
class MyData extends DataTableSource {
  final List<Map<String, dynamic>> _data = [];
  final AppDio dio;
  final Function(int) onRowCountChanged; // Callback for row count

  MyData(this.dio, {required this.onRowCountChanged});

  Future<void> fetchData() async {
    try {
      final response = await dio.get(path: AppUrls.bookingStatus);

      debugPrint("Full API Response: ${response.data}");

      final responseData = response.data;
      List<dynamic> schedules = responseData['schedules'];

      _data.clear();
      for (int index = 0; index < schedules.length; index++) {
        var schedule = schedules[index];

        _data.add({
          "serialNo": index + 1,
          "date": formatDate(schedule['date']),
          "floor": schedule['floor']?['name'] ?? 'N/A',
          "room": schedule['room']?['name'] ?? 'N/A',
          "startTime": formatTime(schedule['startTime']),
          "endTime": formatTime(schedule['endTime']),
          "status": schedule['status'] ?? 'N/A',
        });
      }

      onRowCountChanged(_data.length); // Update row count
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return _buildDataRow(index);
  }

  // Convert all rows for DataTable (non-paginated)
  List<DataRow> getAllRows() {
    return List.generate(_data.length, (index) => _buildDataRow(index));
  }

  DataRow _buildDataRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_data[index]['serialNo'].toString())),
      DataCell(Text(_data[index]["date"].toString())),
      DataCell(Text(_data[index]["floor"].toString())),
      DataCell(Text(_data[index]["room"].toString())),
      DataCell(Text(_data[index]["startTime"].toString())),
      DataCell(Text(_data[index]["endTime"].toString())),
      DataCell(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: getStatusColor(_data[index]["status"]),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            _data[index]["status"].toString(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ]);
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// Helper Functions
String formatDate(String isoDate) {
  DateTime date = DateTime.parse(isoDate);
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

// ✅ Updated function to convert UTC to Pakistan Time (UTC+5)
String formatTime(String isoTime) {
  DateTime utcTime = DateTime.parse(isoTime).toUtc(); // Ensure it's in UTC
  DateTime pakTime = utcTime.add(const Duration(hours: 5)); // Convert to Pakistan Time (UTC+5)

  return "${pakTime.hour % 12 == 0 ? 12 : pakTime.hour % 12}:${pakTime.minute.toString().padLeft(2, '0')} ${pakTime.hour >= 12 ? "PM" : "AM"}";
}
