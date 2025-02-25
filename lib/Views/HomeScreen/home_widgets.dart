import 'package:co_work_nastp/Helpers/app_button.dart';
import 'package:co_work_nastp/Helpers/app_text.dart';
import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:co_work_nastp/Helpers/screen_size.dart';
import 'package:flutter/material.dart';

class Homewidgets {
  static bookingContainer({txt1, txt2, counts}) {
    return Container(
      height: 150,
      width: 140,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppTheme.white,
          border: Border.all(width: 1, color: AppTheme.borderCOlor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 23,
                  width: 23,
                  decoration: BoxDecoration(
                      color: AppTheme.appColor, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(
                      "assets/images/bookCon.png",
                      color: AppTheme.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                AppText.appText("$txt1",
                    fontSize: 9, fontWeight: FontWeight.w400),
                AppText.appText("$counts",
                    fontSize: 30, fontWeight: FontWeight.w800),
                AppText.appText("$txt2",
                    fontSize: 7, fontWeight: FontWeight.w400),
              ],
            ),
          ),
          SizedBox(
            height: 16,
            width: 140,
            child: Image.asset(
              "assets/images/homeBookingLine.png",
              fit: BoxFit.fill,
              color: AppTheme.appColor,
            ),
          ),
        ],
      ),
    );
  }

  /////////////////////////////////////////
  static homeAppBar({name}) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 50.0, left: 20, right: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
              ),
              const SizedBox(
                width: 15,
              ),
              SizedBox(
                height: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.appText("$name",
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        textColor: AppTheme.white),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/location.png",
                          height: 22,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        AppText.appText("Gullberg II Lahore",
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            textColor: AppTheme.white),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppTheme.appColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  "assets/images/bell.png",
                  color: AppTheme.white,
                  height: 24,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

//////////////////////////////////////////////////

  static roomsContainer(
      {context,
      required final Map<String, dynamic> room,
      required final String floorName}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        height: 100,
        width: ScreenSize(context).width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(width: 1, color: AppTheme.borderCOlor)),
        child: Row(
          children: [
            Container(
              height: 100,
              width: 120,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/roomCon.png"),
                      fit: BoxFit.fill)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.appText("Room ${room["id"]}",
                                fontSize: 16, fontWeight: FontWeight.w500),
                            AppText.appText("${room['name']}",
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                                textColor: AppTheme.txtColor),
                          ],
                        ),
                        AppButton.appButton("Schedual",
                            textColor: AppTheme.white,
                            backgroundColor: AppTheme.appColor,
                            height: 25,
                            width: 75,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            context: context)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.appText("Floor",
                                fontSize: 10, fontWeight: FontWeight.w500),
                            AppText.appText(floorName,
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                                textColor: AppTheme.txtColor),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.appText("Seats",
                                fontSize: 10, fontWeight: FontWeight.w500),
                            AppText.appText("12",
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                                textColor: AppTheme.txtColor),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.appText("Amenities",
                                fontSize: 10, fontWeight: FontWeight.w500),
                            AppText.appText("Tv/AC",
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                                textColor: AppTheme.txtColor),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
