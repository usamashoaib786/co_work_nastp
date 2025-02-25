import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motion_toast/motion_toast.dart';

class ToastHelper {
  // Show a simple toast message
  static void showToast({String? msg, bool? error}) {
    Fluttertoast.showToast(
        msg: msg!,
        backgroundColor: error == true ? Colors.red : Colors.green,
        gravity: ToastGravity.TOP);
  }

  static void displaySuccessMotionToast({required BuildContext context, msg}) {
    MotionToast toast = MotionToast.success(
      animationType: AnimationType.fromLeft,
      position: MotionToastPosition.top,
      description: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 100, // Set a reasonable minimum width
          maxWidth: MediaQuery.of(context).size.width *
              0.9, // Use max 90% of screen width
        ),
        child: Text(
          '$msg',
          style: TextStyle(
              fontSize: 15, color: AppTheme.white, fontWeight: FontWeight.w700),
        ),
      ),
      dismissable: true,
    );
    toast.show(context);
  }

  static void displayErrorMotionToast({required BuildContext context, msg}) {
    MotionToast toast = MotionToast.error(
      animationType: AnimationType.fromLeft,
      position: MotionToastPosition.top,
      description: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 100, // Set a reasonable minimum width
          maxWidth: MediaQuery.of(context).size.width *
              0.9, // Use max 90% of screen width
        ),
        child: Text(
          '$msg',
          style: TextStyle(
              fontSize: 15, color: AppTheme.white, fontWeight: FontWeight.w700),
        ),
      ),
      dismissable: true,
    );
    toast.show(context);
  }
}
