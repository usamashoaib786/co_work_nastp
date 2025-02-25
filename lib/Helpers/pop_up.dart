import 'package:co_work_nastp/Helpers/app_button.dart';
import 'package:co_work_nastp/Helpers/app_text.dart';
import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:co_work_nastp/Helpers/toaster.dart';
import 'package:co_work_nastp/Views/Auth%20Screens/sign_in.dart';
import 'package:co_work_nastp/config/dio/app_logger.dart';
import 'package:co_work_nastp/config/dio/dio.dart';
import 'package:co_work_nastp/config/keys/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomPopUp extends StatefulWidget {
  const CustomPopUp({
    super.key,
  });

  @override
  State<CustomPopUp> createState() => _CustomPopUpState();
}

class _CustomPopUpState extends State<CustomPopUp> {
  bool isLoading = false;
  late AppDio dio;
  AppLogger logger = AppLogger();
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        titlePadding: const EdgeInsets.all(0),
        shadowColor: Colors.blue,
        title: Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.appText('Logout',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textColor: Colors.black),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: AppText.appText('Are you sure you want to logout?',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textColor: Colors.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppButton.appButton("Cancel", onTap: () {
                      Navigator.pop(context);
                    },
                        context: context,
                        height: 30,
                        border: false,
                        width: 89,
                        backgroundColor: const Color(0xffBCACAC),
                        textColor: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                    AppButton.appButton("Logout", onTap: () {
                      logOut(context);
                    },
                        context: context,
                        height: 30,
                        width: 89,
                        border: false,
                        backgroundColor: AppTheme.appColor,
                        textColor: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  void logOut(context) async {
    setState(() {
      isLoading = true;
    });
    Response response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found

    int responseCode500 = 500; // Internal server error.

    try {
      response = await dio.post(path: AppUrls.logOut);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        ToastHelper.showToast(msg: "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        ToastHelper.showToast(msg: "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        ToastHelper.showToast(msg: "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        ToastHelper.showToast(msg: "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        if (responseData["status"] == false) {
          ToastHelper.showToast(msg: "${responseData["message"]}");
          setState(() {
            isLoading = false;
          });

          return;
        } else {
          ToastHelper.showToast(msg: "${responseData["message"]}");
          setState(() {
            isLoading = false;
          });
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.clear();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInScreen(),
              ),
              (route) => false);
        }
      }
    } catch (e) {
      ToastHelper.showToast(msg: "Something went Wrong.");
      setState(() {
        isLoading = false;
      });
    }
  }
}
