import 'package:co_work_nastp/Helpers/app_button.dart';
import 'package:co_work_nastp/Helpers/app_text.dart';
import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:co_work_nastp/Helpers/utils.dart';
import 'package:co_work_nastp/Views/Bottom%20Navigation%20bar/bottom_nav_view.dart';
import 'package:flutter/material.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEFF7FF),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0, bottom: 40),
            child: Center(
              child: Image(
                image: AssetImage(
                  "assets/images/onBoard.png",
                ),
                height: 163,
              ),
            ),
          ),
          Spacer(),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 303,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/onBoard border.png",
                  ),
                  fit: BoxFit.cover),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText.appText(
                    'Book a Room &',
                    fontSize: 36,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.black,
                  ),
                  AppText.appText(
                    'Seats',
                    fontSize: 34,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.appColor,
                  ),
                  AppText.appText(
                    'On Demand',
                    fontSize: 36,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.black,
                  ),
                  const SizedBox(height: 20),
                  AppText.appText(
                    'Find Rooms & Event Near You',
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    textColor: AppTheme.txtColor,
                  ),
                  const SizedBox(height: 50),
                  AppButton.appButton("Get Started", onTap: () {
                    push(context, BottomNavView());
                  }, context: context)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
