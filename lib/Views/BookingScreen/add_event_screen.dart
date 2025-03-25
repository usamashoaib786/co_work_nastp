import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:co_work_nastp/Helpers/screen_size.dart';
import 'package:co_work_nastp/Helpers/utils.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:co_work_nastp/Helpers/app_field.dart';
import 'package:co_work_nastp/Helpers/app_text.dart';
import 'package:co_work_nastp/Helpers/toaster.dart';
import 'package:co_work_nastp/config/dio/app_logger.dart';
import 'package:co_work_nastp/config/dio/dio.dart';
import 'package:co_work_nastp/config/keys/urls.dart';

class AddEventBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final int roomID;
  final int locationId;
  final DateTime? startTime;
  final DateTime? endTime;

  const AddEventBottomSheet({
    super.key,
    required this.selectedDate,
    required this.roomID,
    required this.locationId,
    this.startTime,
    this.endTime,
  });

  @override
  State<AddEventBottomSheet> createState() => _AddEventBottomSheetState();
}

class _AddEventBottomSheetState extends State<AddEventBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _personController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  bool isLoading = false;
  late AppDio dio;
  AppLogger logger = AppLogger();

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    selectedDate = widget.selectedDate;
    startTime = widget.startTime != null
        ? TimeOfDay.fromDateTime(widget.startTime!)
        : TimeOfDay.now();
    endTime = widget.endTime != null
        ? TimeOfDay.fromDateTime(widget.endTime!)
        : TimeOfDay.now().replacing(minute: TimeOfDay.now().minute);
    super.initState();
  }

  /// Opens Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  /// Opens Time Picker
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? TimeOfDay.now() : startTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
          endTime = null; // Reset end time when start time changes
        } else {
          if (startTime != null &&
              (picked.hour > startTime!.hour ||
                  (picked.hour == startTime!.hour &&
                      picked.minute > startTime!.minute))) {
            int totalMinutes = (picked.hour * 60 + picked.minute) -
                (startTime!.hour * 60 + startTime!.minute);

            if (totalMinutes > 60) {
              ToastHelper.displayErrorMotionToast(
                  context: context, msg: "Booking cannot exceed 1 hour.");
            } else {
              endTime = picked;
            }
          } else {
            ToastHelper.displayErrorMotionToast(
                context: context, msg: "End time must be after start time.");
          }
        }
      });
    }
  }

  /// Returns the total duration in "X hours Y minutes" format
  String getTotalDuration() {
    if (startTime != null && endTime != null) {
      int startMinutes = startTime!.hour * 60 + startTime!.minute;
      int endMinutes = endTime!.hour * 60 + endTime!.minute;
      int totalMinutes = endMinutes - startMinutes;

      int hours = totalMinutes ~/ 60;
      int minutes = totalMinutes % 60;

      return "${hours > 0 ? '$hours hour${hours > 1 ? 's' : ''} ' : ''}$minutes minute${minutes > 1 ? 's' : ''}";
    }
    return "";
  }

  /// Converts DateTime to ISO 8601 UTC format
  String? _convertToIso8601(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return null;

    DateTime localDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    return localDateTime.toUtc().toIso8601String();
  }

  /// Books the event via API
  void bookEvent({context}) async {
    if (_titleController.text.isEmpty ||
        startTime == null ||
        endTime == null ||
        _personController.text.isEmpty ||
        selectedDate == null) {
      ToastHelper.displayErrorMotionToast(
          context: context, msg: "Please select all fields");
      return;
    }

    // ✅ Check if selectedDate is before today
    DateTime today = DateTime.now();
    if (selectedDate!.isBefore(DateTime(today.year, today.month, today.day))) {
      ToastHelper.displayErrorMotionToast(
          context: context, msg: "You cannot book for past dates.");
      return;
    }

    setState(() => isLoading = true);

    int? locationId = int.tryParse("${widget.locationId}");
    int? roomId = int.tryParse("${widget.roomID}");
    int? persons = int.tryParse(_personController.text);

    if (locationId == null || roomId == null || persons == null) {
      ToastHelper.displayErrorMotionToast(
          context: context, msg: "Invalid input. Please check your fields.");
      setState(() => isLoading = false);
      return;
    }

    Map<String, dynamic> params = {
      "location_id": widget.locationId,
      "room_id": widget.roomID,
      "title": _titleController.text,
      "startTime": _convertToIso8601(selectedDate, startTime),
      "endTime": _convertToIso8601(selectedDate, endTime),
      "date": "${selectedDate?.toIso8601String()}Z",
      "persons": int.parse(_personController.text),
    };

    try {
      Response response =
          await dio.post(path: AppUrls.createBooking, data: params);
      if (response.statusCode == 201) {
        ToastHelper.displaySuccessMotionToast(
            context: context, msg: "Booking created successfully!");

        // Navigator.pop(context, params);
        Navigator.pop(context, true);
      } else if (response.statusCode == 401) {
        navigateFunction(context: context);
      } else {
        ToastHelper.displayErrorMotionToast(
            context: context, msg: "Error: ${response.data["message"]}");
      }
    } catch (e) {
      ToastHelper.displayErrorMotionToast(
          context: context, msg: "Something went wrong.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: FocusScope(
            child: SizedBox(
              height: ScreenSize(context).height * 0.8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: AppText.appText("Cancel",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  textColor: Colors.red)),
                          GestureDetector(
                              onTap: () {
                                bookEvent(context: context);
                              },
                              child: AppText.appText("Save",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  textColor: Colors.green))
                        ],
                      ),
                      const SizedBox(height: 20),
                      FloatingLabelTextField(
                          label: "Title", controller: _titleController),
                      const SizedBox(height: 20),
                      FloatingLabelTextField(
                          label: "Persons", controller: _personController),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText.appText('Selected Date',
                              fontWeight: FontWeight.w700, fontSize: 18),
                          GestureDetector(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: AppText.appText(
                                selectedDate!
                                    .toLocal()
                                    .toString()
                                    .split(" ")[0],
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText.appText('Start time',
                              fontWeight: FontWeight.w700, fontSize: 18),
                          GestureDetector(
                            onTap: () => _selectTime(context, true),
                            child: AppText.appText(
                                startTime?.format(context) ??
                                    TimeOfDay.now().format(context),
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText.appText('End Time',
                              fontWeight: FontWeight.w700, fontSize: 18),
                          GestureDetector(
                            onTap: () => _selectTime(context, false),
                            child: AppText.appText(
                                endTime?.format(context) ??
                                    TimeOfDay.now().format(context),
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      if (startTime != null && endTime != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText.appText('Total Duration:',
                                fontWeight: FontWeight.w700, fontSize: 18),
                            AppText.appText(
                              getTotalDuration(),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              textColor: AppTheme.appColor,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Show a blurred background with a loader when isLoading is true
        if (isLoading)
          Positioned.fill(
            child: Container(
              color:
                  Colors.black.withAlpha(5), // Semi-transparent background
              child: Center(
                child: CircularProgressIndicator(
                    color: AppTheme.appColor), // Loader in the center
              ),
            ),
          ),
      ],
    );
  }

  // /// Creates a container for pickers
  // Widget _pickerContainer(String text) {
  //   return Container(
  //     height: 50,
  //     width: 120,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(10),
  //       border: Border.all(color: AppTheme.txtColor),
  //     ),
  //     cld: Center(
  //       child: AppText.appText(text, fontWeight: FontWeight.w600, fontSize: 16),
  //     ),
  //   );
  // }
}
