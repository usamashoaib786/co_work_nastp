import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:co_work_nastp/Views/BookingScreen/booking.dart';
import 'package:co_work_nastp/Views/HomeScreen/home_screen.dart';
import 'package:co_work_nastp/Views/MessageScreen/message.dart';
import 'package:co_work_nastp/Views/ProfileScreen/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavView extends StatefulWidget {
  const BottomNavView({super.key});

  @override
  State<BottomNavView> createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const BookingScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 75,

        animationCurve: Curves.easeOut,
        animationDuration: Duration(milliseconds: 400),
        color: AppTheme.appColor, // Semi-transparent background
        backgroundColor: Colors.transparent,
        index: _currentIndex,
        items: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Image.asset(
              "assets/images/home.png",
              color: AppTheme.white,
              height: 24,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Image.asset(
              "assets/images/booking.png",
              color: AppTheme.white,
              height: 24,
            ),
          ),
          Image.asset(
            "assets/images/message.png",
            color: AppTheme.white,
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Image.asset(
              "assets/images/profile.png",
              color: AppTheme.white,
              height: 24,
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _screens[_currentIndex],
    );
  }
}
