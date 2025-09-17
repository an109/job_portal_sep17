import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_portal/widgets/widgets.dart';

import '../../ui_helper/ui_helper.dart';

class RecruiterPaymentScreen extends StatelessWidget {
  const RecruiterPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildCustomAppBar(titleText: "Logo"),
        body: Padding(
            padding: const EdgeInsets.only(right: 24.0, top: 7.0, left: 24.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Payment",
                style: mTextStyle32(mColor: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Select Payment Method",
                style: mTextStyle12(),
              ),
              SizedBox(
                height: 25,
              ),
              paymentOptionContainer(text: "Debit/Credit card", onTap: () {}),
              SizedBox(
                height: 25,
              ),
              paymentOptionContainer(text: "UPI", onTap: () {}),
            ])));
  }
}

Widget paymentOptionContainer(
    {required String text, required VoidCallback onTap}) {
  return Container(
    height: 46,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(width: 1.0, color: Colors.grey.shade300),
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 11.0),
      child: Row(
        children: [
          SvgPicture.asset("assets/Icons/school_student.svg"),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              text,
              style: mTextStyle14(),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 11.0),
            child:
                InkWell(onTap: onTap, child: Icon(Icons.keyboard_arrow_down)),
          )
        ],
      ),
    ),
  );
}
