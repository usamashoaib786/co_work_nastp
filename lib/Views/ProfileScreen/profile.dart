import 'dart:io';

import 'package:co_work_nastp/Helpers/app_text.dart';
import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:co_work_nastp/Helpers/custom_appbar.dart';
import 'package:co_work_nastp/Helpers/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _pickedFilePath;

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
      appBar: CustomAppBar(
        txt: "Settings",
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  height: 120,
                  width: 120,
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
                      GestureDetector(
                        onTap: () {
                          pickImage();
                        },
                        child: Align(
                          alignment: Alignment.bottomRight,
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
                padding: const EdgeInsets.only(top: 10.0, bottom: 5),
                child: AppText.appText("USAMA SHOAIB",
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    textColor: AppTheme.appColor),
              ),
              AppText.appText("usamashoaib313@gmail.com",
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  textColor: AppTheme.txtColor),
              SizedBox(
                height: 20,
              ),
              customColumn(txt: "Account Details"),
              customColumn(txt: "Payment Method"),
              customColumn(txt: "Payment History"),
              customColumn(txt: "Privacy"),
              customColumn(
                txt: "Logout",
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
        ),
      ),
    );
  }

  customColumn({txt, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Card(
          elevation: 5,
          child: SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.appText("$txt",
                      fontSize: 18, fontWeight: FontWeight.w700),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppTheme.appColor,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
