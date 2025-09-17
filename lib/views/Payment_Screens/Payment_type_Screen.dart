import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';
import 'package:job_portal/widgets/widgets.dart';

import '../../ui_helper/ui_helper.dart';
import 'Default_payment_gateway.dart';

class PaymentTypeScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Payment")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select Payment Method"),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 430,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 11.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/Icons/CreditCard.svg",
                            color: Color(0xff0F4D73),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Text(
                              "Debit/Credit Card",
                              style: mTextStyle15(mColor: Color(0xff0F4D73)),
                            ),
                          ),
                          Spacer(),
                          InkWell(
                              onTap: () {},
                              child: Icon(
                                Icons.keyboard_arrow_up,
                                color: Color(0xff0F4D73),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Card Number",
                        style: mTextStyle14(
                            mColor: TColors.primary,
                            mFontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      CustomTextField(
                        controller: paymentCardController,
                        hintText: "XXXX-XXXX-XXXX",
                        fillColor: Color(0xffFFF7FB),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text("CVV/CVC No.",
                              style: mTextStyle14(
                                  mColor: Color(0xff0F4D73),
                                  mFontWeight: FontWeight.w600)),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 70.0),
                            child: Text("Valid through",
                                style: mTextStyle14(
                                    mColor: Color(0xff0F4D73),
                                    mFontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: 165,
                              child: CustomTextField(
                                  controller: CVVController,
                                  hintText: "000",
                                  fillColor: Color(0xffFFF7FB))),
                          Spacer(),
                          SizedBox(
                              width: 165,
                              child: CustomTextField(
                                  controller: ValidUptoController,
                                  hintText: "MM/YYYY",
                                  fillColor: Color(0xffFFF7FB))),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(" Full Name "),
                      SizedBox(
                        height: 6,
                      ),
                      CustomTextField(
                          controller: nameController,
                          hintText: "Name",
                          fillColor: Color(0xffFFF7FB)),
                      SizedBox(
                        height: 15,
                      ),
                      commonRedContainer(text: "Send OTP"),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            "Save details for the future",
                            style: mTextStyle14(
                                mColor: Colors.black,
                                mFontWeight: FontWeight.w400),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
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
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
