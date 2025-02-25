import 'package:co_work_nastp/Helpers/app_button.dart';
import 'package:co_work_nastp/Helpers/app_text.dart';
import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:flutter/material.dart';

class HomeSlider extends StatefulWidget {
  const HomeSlider({super.key});

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<String> imgList = [
    "assets/images/slider.png",
    "assets/images/slider.png",
    "assets/images/slider.png",
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          SizedBox(
            height: 170,
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: imgList.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        width: 340,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/slider.png', // Replace with your image URL
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.appText(
                                'Get Special Offer',
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                textColor: Colors.white,
                              ),
                              Row(
                                children: [
                                  AppText.appText(
                                    'Upto',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    textColor: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  AppText.appText(
                                    '40%',
                                    fontSize: 32,
                                    fontWeight: FontWeight.w500,
                                    textColor: Colors.white,
                                  ),
                                ],
                              ),
                              AppText.appText(
                                'on Meeting Room Booking',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                textColor: Colors.white,
                              ),
                            ],
                          ),
                          Positioned(
                              bottom: 10,
                              right: 10,
                              child: AppButton.appButton("Claim",
                                  fontSize: 16,
                                  height: 26,
                                  width: 73,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppTheme.white,
                                  backgroundColor: AppTheme.appColor, context: context))
                        ])),
                    index == imgList.length
                        ? SizedBox(
                            width: 20,
                          )
                        : SizedBox.shrink()
                  ],
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              imgList.length,
              (index) => buildDot(index, context),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 10,
      width: _currentIndex == index ? 20 : 10,
      decoration: BoxDecoration(
        color: _currentIndex == index ? AppTheme.appColor : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
