import 'dart:io';
import 'package:co_work_nastp/Helpers/app_button.dart';
import 'package:co_work_nastp/Helpers/app_field.dart';
import 'package:co_work_nastp/Helpers/app_text.dart';
import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:co_work_nastp/Helpers/custom_appbar.dart';
import 'package:co_work_nastp/Helpers/pop_up.dart';
import 'package:co_work_nastp/Helpers/pref_keys.dart';
import 'package:co_work_nastp/Helpers/screen_size.dart';
import 'package:co_work_nastp/Helpers/toaster.dart';
import 'package:co_work_nastp/Helpers/utils.dart';
import 'package:co_work_nastp/Views/Bottom%20Navigation%20bar/bottom_nav_view.dart';
import 'package:co_work_nastp/config/dio/app_logger.dart';
import 'package:co_work_nastp/config/dio/dio.dart';
import 'package:co_work_nastp/config/keys/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? pickedFilePath;
  bool? isEdit = false;
  String? userName;
  String? userEmail;
  String? userPhoneNum;
  String? userPic;
  final TextEditingController _lableController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedFilePath = image.path;
      });
    }
  }

  bool isLoading = false;
  late AppDio dio;
  AppLogger logger = AppLogger();
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getLocalProfile();
    super.initState();
  }

  getLocalProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userName = pref.getString(PrefKey.fullName);
      userEmail = pref.getString(PrefKey.email);
      userPhoneNum = pref.getString(PrefKey.phone);
      userPic = pref.getString(PrefKey.profilePic);
      _lableController.text = userName!;
      _phoneController.text = userPhoneNum!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(txt: "Profile", leadIcon: true, onTap: () {
          pushUntil(context, BottomNavView());
          }, action: [
        PopupMenuButton<String>(
          color: AppTheme.white,
          onSelected: (value) {
            if (value == 'edit') {
              setState(() {
                isEdit = true;
              });
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: "edit",
              child: Text("Edit"),
            ),
          ],
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: 140,
                  width: 140,
                  child: Stack(
                    children: [
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 2, color: AppTheme.appColor),
                            borderRadius: BorderRadius.circular(100)),
                        child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                                color: AppTheme.appColor,
                                shape: BoxShape.circle),
                            child: userPic != null
                                ? Image.network(
                                    userPic!,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return Icon(Icons.person,
                                          size: 50, color: AppTheme.white);
                                    },
                                  )
                                : pickedFilePath != null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.file(
                                          File(pickedFilePath!),
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Icon(
                                          Icons.person,
                                          color: AppTheme.white,
                                          size: 30,
                                        ))),
                      ),
                      if (isEdit == true)
                        GestureDetector(
                          onTap: () {
                            pickImage();
                          },
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.white),
                                child: Icon(Icons.camera_alt),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 30),
                child: AppText.appText("$userName",
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    textColor: AppTheme.black),
              ),
              if (isEdit == false)
                Column(
                  children: [
                    _buildProfileOption(
                        Icons.email, "$userEmail", "assets/images/email.png"),
                    _buildProfileOption(Icons.phone, "$userPhoneNum",
                        "assets/images/phone.png"),
                    _buildProfileOption(Icons.settings, "Settings",
                        "assets/images/settings.png"),
                    _buildProfileOption(
                        Icons.help, "Help", "assets/images/help.png"),
                    _buildProfileOption(
                      Icons.logout,
                      "Logout",
                      "assets/images/logOut.png",
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const CustomPopUp();
                          },
                        );
                      },
                    ),
                  ],
                ),
              if (isEdit == true)
                Column(
                  children: [
                    EditField(
                        label: "User Name",
                        hintText: "Usama Shoaib",
                        controller: _lableController),
                    EditField(
                        label: "Phone Number",
                        hintText: "03134598073",
                        controller: _phoneController),
                    EditField(
                        label: "Password",
                        hintText: "Password",
                        isPassword: true,
                        controller: _passwordController),
                    EditField(
                        label: "Confirm Password",
                        hintText: "Confirm Password",
                        isPassword: true,
                        controller: _confirmPassController),
                  ],
                ),
              SizedBox(
                height: 30,
              ),
              if (isEdit == true)
                Column(
                  children: [
                    AppButton.appButton("Update", onTap: () {
                      if (pickedFilePath != null ||
                          _lableController.text.isNotEmpty ||
                          _phoneController.text.isNotEmpty ||
                          _passwordController.text.isNotEmpty ||
                          _confirmPassController.text.isNotEmpty) {
                        updateProfile(context: context);
                      } else {
                        setState(() {
                          isEdit = false;
                        });
                      }
                    }, context: context, width: 261),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String text, String img,
      {Function()? onTap}) {
    return SizedBox(
      height: 75,
      width: ScreenSize(context).width,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xffE4E4E4)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    img,
                    height: 22,
                  ),
                )),
            SizedBox(
              width: 20,
            ),
            AppText.appText(text, fontSize: 18, fontWeight: FontWeight.w600)
          ],
        ),
      ),
    );
  }

  /////////////////////////////  API"S ///////////////////////////
  void getProfile({context}) async {
    try {
      Response response = await dio.get(path: AppUrls.getProfile);
      if (response.statusCode == 200) {
        setState(() async {
          var profileData = response.data["data"];
          var userName = profileData["name"];
          var userMail = profileData["email"];
          var userNumber = profileData["phone_no"];
          SharedPreferences prefs = await SharedPreferences.getInstance();

          prefs.setString(PrefKey.fullName, userName);
          prefs.setString(PrefKey.email, userMail);
          prefs.setString(PrefKey.phone, userNumber);
          _lableController.text = userName!;
          _phoneController.text = userPhoneNum!;

          getLocalProfile();
        });
      } else if (response.statusCode == 401) {
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

  void updateProfile({context}) async {
    try {
      // Prepare FormData
      FormData formData = FormData.fromMap({
        "name": _lableController.text,
        "password": _passwordController.text,
        "password_confirmation": _confirmPassController.text,
        "phone_no": _phoneController.text,
        "profile_image": pickedFilePath != null
            ? await MultipartFile.fromFile(pickedFilePath!,
                filename: pickedFilePath!.split('/').last)
            : null, // Send image if selected
      });

      Response response = await dio.post(
        path: AppUrls.updateProfile,
        data: formData,
      );
      if (response.statusCode == 200) {
        ToastHelper.displaySuccessMotionToast(
            context: context, msg: "Update successfully!");
        setState(() {
          isEdit = false;
          getProfile();
        });
      } else if (response.statusCode == 401) {
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
}
