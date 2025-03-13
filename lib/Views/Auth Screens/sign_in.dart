import 'package:co_work_nastp/Helpers/app_button.dart';
import 'package:co_work_nastp/Helpers/app_field.dart';
import 'package:co_work_nastp/Helpers/app_text.dart';
import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:co_work_nastp/Helpers/pref_keys.dart';
import 'package:co_work_nastp/Helpers/toaster.dart';
import 'package:co_work_nastp/Views/OnBorad/onboard_screen.dart';
import 'package:co_work_nastp/config/dio/app_logger.dart';
import 'package:co_work_nastp/config/dio/dio.dart';
import 'package:co_work_nastp/config/keys/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? emailError;
  String? passwordError;
  bool isLoading = false;
  late AppDio dio;
  AppLogger logger = AppLogger();

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    super.initState();
  }

  void validateAndSignIn() {
    setState(() {
      emailError = null;
      passwordError = null;
    });

    if (_emailController.text.isEmpty) {
      setState(() {
        emailError = "Enter Email";
      });
      return;
    } else {
      final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailPattern.hasMatch(_emailController.text)) {
        setState(() {
          emailError = "Please enter a valid email address";
        });
        return;
      }
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        passwordError = "Enter Password";
      });
      return;
    }

    signIn(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image(
            image: AssetImage("assets/images/loginTop.png"),
            color: AppTheme.appColor,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage("assets/images/person.png"),
                            height: 46,
                          ),
                          SizedBox(width: 20),
                          AppText.appText("LOGIN",
                              fontSize: 42, fontWeight: FontWeight.w500),
                        ],
                      ),
                    ),
                    Image(
                      image: AssetImage("assets/images/loginCenter.png"),
                      height: 200,
                    ),
                    SizedBox(height: 30),

                    /// Email Field with Error
                    CustomAppFormField(
                      texthint: "Email",
                      controller: _emailController,
                    ),
                    if (emailError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            emailError!,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      ),

                    SizedBox(height: 30),

                    /// Password Field with Error
                    CustomAppPasswordfield(
                      texthint: "Password",
                      controller: _passwordController,
                    ),
                    if (passwordError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            passwordError!,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      ),

                    SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppText.appText("Forgot your password?",
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ],
                    ),

                    SizedBox(height: 30),

                    isLoading
                        ? CircularProgressIndicator()
                        : AppButton.appButton(
                            "Login",
                            onTap: validateAndSignIn,
                            context: context,
                          ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void signIn(context) async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> params = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };

    try {
      Response response = await dio.post(path: "https://api.coworkatnastp.com/api/branch/login", data: params);
      var responseData = response.data;

      if (response.statusCode == 200) {
        ToastHelper.displaySuccessMotionToast(
            context: context, msg: "${responseData["message"]}");

        setState(() {
          isLoading = false;
        });

        var finalData = responseData["data"];

        var token = finalData["token"];
        var user = finalData["id"];
        var userName = finalData["name"];
        var userType = finalData["type"];
        var userRole = finalData["type"];
        print("object$userRole");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(PrefKey.authorization, token ?? '');
        prefs.setString(PrefKey.id, user.toString());
        prefs.setString(PrefKey.fullName, userName);
        prefs.setString(PrefKey.userType, userType);
        prefs.setString(PrefKey.userRole, userRole);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const OnBoardScreen()),
          (route) => false,
        );
      } else {
        setState(() {
          isLoading = false;
        });
        ToastHelper.displayErrorMotionToast(
            context: context, msg: "${responseData["message"]}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Something went wrong: $e");
      }
         ToastHelper.displayErrorMotionToast(
            context: context, msg: "Something went wrong");
      setState(() {
        isLoading = false;
      });
    }
  }

}
