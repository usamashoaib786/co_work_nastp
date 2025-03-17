import 'package:co_work_nastp/Helpers/app_text.dart';
import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:co_work_nastp/Helpers/pref_keys.dart';
import 'package:co_work_nastp/Helpers/toaster.dart';
import 'package:co_work_nastp/Helpers/utils.dart';
import 'package:co_work_nastp/Views/BookingScreen/booking.dart';
import 'package:co_work_nastp/Views/BookingScreen/booking_status.dart';
import 'package:co_work_nastp/Views/HomeScreen/home_widgets.dart';
import 'package:co_work_nastp/Views/HomeScreen/slider.dart';
import 'package:co_work_nastp/config/dio/app_logger.dart';
import 'package:co_work_nastp/config/dio/dio.dart';
import 'package:co_work_nastp/config/keys/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List wrapImg = [
    "assets/images/bookingCon.png",
    "assets/images/schedualMeeting.png",
    "assets/images/billingDetails.png",
    "assets/images/chat.png",
  ];
  List wrapText = [
    "Bookings",
    "Schedual Meeting Room",
    "Billing Details",
    "Notifications",
  ];

  String? userName;
  int index = 0;
  late AppDio dio;
  Map<String, dynamic>? conData;
  AppLogger logger = AppLogger();
  Future<List<dynamic>>? availableRoomsFuture;

  @override
  void initState() {
    super.initState();
    dio = AppDio(context);
    logger.init();
    getUserData();
    getConDetails(context);
    availableRoomsFuture = getAvailableRooms(context); // Fetch rooms once
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userName = pref.getString(PrefKey.fullName);
    });
  }

  Future<List<dynamic>> getAvailableRooms(context) async {
    try {
      Response response = await dio.get(path: AppUrls.availRooms);
      if (response.statusCode == 200) {
        return response.data["floors"];
      } else if (response.statusCode == 401) {
        navigateFunction(context: context);
        return [];
      } else {
        ToastHelper.displayErrorMotionToast(
            context: context, msg: "${response.data["message"]}");
        return [];
      }
    } catch (e) {
      ToastHelper.displayErrorMotionToast(
          context: context, msg: "Something went wrong.");
      return [];
    }
  }

  void getConDetails(context) async {
    try {
      Response response = await dio.get(path: AppUrls.homeCon);
      if (response.statusCode == 200 && mounted) {
        setState(() {
          conData = response.data;
        });
      } else if (response.statusCode == 401 && mounted) {
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 290,
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    color: AppTheme.appColor,
                    child: Homewidgets.homeAppBar(name: userName),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Homewidgets.bookingContainer(
                          txt1: "Available Bookings",
                          txt2: "Ready for booking today",
                          counts: conData == null
                              ? "..."
                              : "${conData!["totalBookings"]}",
                        ),
                        SizedBox(width: 40),
                        Homewidgets.bookingContainer(
                          txt1: "Remaining Bookings",
                          txt2: "Left for the day",
                          counts: conData == null
                              ? "..."
                              : "${conData!["remainingbookings"]}",
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  HomeSlider(),
                  Wrap(
                    runSpacing: 15,
                    children: [
                      for (int i = 0; i < 4; i++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              index = i;
                              List screenList = [
                                BookingStatus(),
                                BookingScreen(
                                  button: true,
                                )
                              ];
                              push(context, screenList[i]);
                            });
                          },
                          child: Card(
                            elevation: 10,
                            child: Container(
                              height: 100,
                              width: 164,
                              decoration: BoxDecoration(
                                color: index == i
                                    ? AppTheme.appColor
                                    : AppTheme.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    wrapImg[i],
                                    height: 40,
                                    color: index != i
                                        ? AppTheme.appColor
                                        : AppTheme.white,
                                  ),
                                  AppText.appText(
                                    wrapText[i],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    textColor: index == i
                                        ? AppTheme.white
                                        : AppTheme.black,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppText.appText("Available Rooms",
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ],
                    ),
                  ),
                  FutureBuilder<List<dynamic>>(
                    future: availableRoomsFuture, // Use stored future
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error loading rooms."));
                      } else if (snapshot.data!.isEmpty) {
                        return Center(child: Text("No rooms available."));
                      } else {
                        return ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var floor = snapshot.data![index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var room in floor['rooms'])
                                  Homewidgets.roomsContainer(
                                    context: context,
                                    room: room,
                                    floorName: floor['name'],
                                  ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
