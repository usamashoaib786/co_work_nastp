import 'package:co_work_nastp/Helpers/app_button.dart';
import 'package:co_work_nastp/Helpers/app_field.dart';
import 'package:co_work_nastp/Helpers/app_text.dart';
import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:co_work_nastp/Helpers/custom_appbar.dart';
import 'package:co_work_nastp/Helpers/screen_size.dart';
import 'package:co_work_nastp/Helpers/utils.dart';
import 'package:co_work_nastp/Views/Pay%20Now%20Screen/done_screen.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String selectedPaymentMethod = "Card"; // Default selected payment method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appColor,
      appBar: CustomAppBar(
        txt: "Payment",
        cicleColor: AppTheme.white,
        color: AppTheme.white,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 150,
            child: Center(
              child: AppText.appText(
                "\$120.00",
                fontSize: 56,
                fontWeight: FontWeight.w700,
                textColor: AppTheme.white,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      AppText.appText(
                        "Doctor Channeling Payment Method",
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedPaymentMethod = "Card";
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                decoration: BoxDecoration(
                                  color: selectedPaymentMethod == "Card"
                                      ? AppTheme.appColor
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Center(
                                  child: AppText.appText(
                                    "Card Payment",
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    textColor: selectedPaymentMethod == "Card"
                                        ? AppTheme.white
                                        : AppTheme.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedPaymentMethod = "Cash";
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                decoration: BoxDecoration(
                                  color: selectedPaymentMethod == "Cash"
                                      ? AppTheme.appColor
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Center(
                                  child: AppText.appText(
                                    "Cash Payment",
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    textColor: selectedPaymentMethod == "Cash"
                                        ? AppTheme.white
                                        : AppTheme.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (selectedPaymentMethod == "Card") ...[
                        // Card Payment Fields
                        AppText.appText(
                          "Card Number",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 15),
                        CustomAppFormField(
                          texthint: "1234 8896 1145 0896",
                          controller: _cardController,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText.appText(
                                    "Expiry Date",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const SizedBox(height: 15),
                                  CustomAppFormField(
                                    texthint: "10/02/2022",
                                    controller: _dateController,
                                    width: ScreenSize(context).width * 0.45,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText.appText(
                                    "CVV",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const SizedBox(height: 15),
                                  CustomAppFormField(
                                    texthint: "106",
                                    controller: _cvcController,
                                    width: ScreenSize(context).width * 0.45,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        AppText.appText(
                          "Name",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 8),
                        CustomAppFormField(
                          texthint: "Usama Shoaib",
                          controller: _nameController,
                        ),
                      ] else ...[
                        // Cash Payment Instructions
                        AppText.appText(
                          "Cash Payment Instructions",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 15),
                        AppText.appText(
                          "Please pay the amount in cash to the reception.",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          textColor: AppTheme.appColor,
                        ),
                      ],
                      selectedPaymentMethod == "Card"
                          ? const SizedBox(height: 20)
                          : const SizedBox(height: 100),
                      Center(
                        child: AppButton.appButton(
                          "Pay Now",
                          context: context,
                          onTap: () {
                            if (selectedPaymentMethod == "Card") {
                             push(context, ThankYouScreen());
                            } else {
                              // Handle Cash Payment logic
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
