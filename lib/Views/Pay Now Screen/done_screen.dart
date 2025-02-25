import 'package:co_work_nastp/Helpers/app_button.dart';
import 'package:co_work_nastp/Helpers/app_text.dart';
import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:co_work_nastp/Helpers/utils.dart';
import 'package:co_work_nastp/Views/Bottom%20Navigation%20bar/bottom_nav_view.dart';
import 'package:flutter/material.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(),
          ),
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: AppTheme.appColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              size: 120,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          AppText.appText(
            "Thank You",
            fontSize: 30,
            fontWeight: FontWeight.w800,
            textColor: AppTheme.appColor,
          ),
          SizedBox(height: 8),
          // Subheading Text
          AppText.appText(
            "Your Appointment Created",
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: AppButton.appButton(
                "Back",
                context: context,
                onTap: () {
                  pushReplacement(context, BottomNavView());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
