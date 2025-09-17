import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_portal/ui_helper/ui_helper.dart';

class DefaultPaymentGatewayScreen extends StatelessWidget {
  const DefaultPaymentGatewayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Payment")),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Select Payment Method"),
              SizedBox(
                height: 20,
              ),
              paymentOptionCard(
                  image: "assets/Icons/CreditCard.svg",
                  title: "Debit/Credit Card"),
              SizedBox(
                height: 20,
              ),
              paymentOptionCard(
                  image: "assets/Icons/Bank.svg", title: "Net Banking"),
              SizedBox(
                height: 20,
              ),
              paymentOptionCard(
                  image: "assets/Icons/PaypalLogo.svg", title: "PayPal"),
              SizedBox(
                height: 20,
              ),
              paymentOptionCard(
                  image: "assets/Icons/CurrencyInr.svg", title: "UPI"),
            ])));
  }
}

Widget paymentOptionCard(
    {required String image, required String title, VoidCallback? onTap}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
    ),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          SvgPicture.asset(
            image,
            color: AppColors.blueTextColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              title,
              style: mTextStyle15(mColor: AppColors.blueTextColor),
            ),
          ),
          Spacer(),
          InkWell(
              onTap: onTap,
              child: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.blueTextColor,
              ))
        ],
      ),
    ),
  );
}
