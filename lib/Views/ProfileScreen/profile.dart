import 'dart:io';

import 'package:co_work_nastp/Helpers/app_button.dart';
import 'package:co_work_nastp/Helpers/app_text.dart';
import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:co_work_nastp/Helpers/pop_up.dart';
import 'package:co_work_nastp/Helpers/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _pickedFilePath;
  bool? isEdit = false;
  pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedFilePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.appText("Profile",
            fontWeight: FontWeight.w700, fontSize: 26),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
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
        ],
      ),
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
                            side:
                                BorderSide(width: 2, color: AppTheme.appColor),
                            borderRadius: BorderRadius.circular(100)),
                        child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                                color: AppTheme.appColor,
                                shape: BoxShape.circle),
                            child: _pickedFilePath != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.file(
                                      File(_pickedFilePath!),
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
                padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                child: AppText.appText("USAMA SHOAIB",
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    textColor: AppTheme.appColor),
              ),
              _buildProfileOption(Icons.email, "Talhamasnsha@gmail.com",
                  "assets/images/email.png"),
              _buildProfileOption(
                  Icons.phone, "0320-9469594", "assets/images/phone.png"),
              _buildProfileOption(
                  Icons.location_on, "Lahore", "assets/images/loc.png"),
              _buildProfileOption(
                  Icons.settings, "Settings", "assets/images/settings.png"),
              _buildProfileOption(Icons.help, "Help", "assets/images/help.png"),
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
              SizedBox(
                height: 30,
              ),
              if (isEdit == true)
                Column(
                  children: [
                    AppButton.appButton("Update", context: context, width: 261),
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
      height: 65,
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
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    img,
                    height: 22,
                  ),
                )),
            SizedBox(
              width: 15,
            ),
            AppText.appText(text, fontSize: 18, fontWeight: FontWeight.w600)
          ],
        ),
      ),
    );
  }
}
