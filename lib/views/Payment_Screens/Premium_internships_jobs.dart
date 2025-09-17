import 'package:flutter/material.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';
import 'package:job_portal/widgets/widgets.dart';

import '../../ui_helper/ui_helper.dart';
import '../recruiter_job_post/presentation/view/Recruiter_total_job_posts.dart';

class PremiumInternships_Jobs extends StatelessWidget {
  const PremiumInternships_Jobs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildCustomAppBar(titleText: "Logo"),
        body: Padding(
            padding: const EdgeInsets.only(right: 24.0, top: 7.0, left: 24.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Text(
                    "Payment",
                    style: mTextStyle32(mColor: Colors.black),
                  ),
                  Text(" premium",
                      style: mTextStyle32(mColor: TColors.secondary)),
                ],
              ),
              Text(
                "internships and Jobs",
                style: mTextStyle32(mColor: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              premiumPlansContainer(
                  discountPrice: "999", originalPrice: "1,299"),
              SizedBox(
                height: 20,
              ),
              premiumPlansContainer(
                  discountPrice: "1,499", originalPrice: "1,999")
            ])));
  }
}

Widget premiumPlansContainer(
    {required String discountPrice, required String originalPrice}) {
  return Container(
    height: 120,
    width: double.infinity,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.grey.shade300)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("*"),
              Text(
                "   Job Listings",
                style: mTextStyle12(
                    mFontWeight: FontWeight.w600, mColor: Colors.black),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: optionContainer(
                    title: "Save 15%",
                    textColor: AppColors.blueTextColor,
                    bgColor: Color(0xffE8F0FC)),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "INR $discountPrice",
                style: mTextStyle15(
                    mFontWeight: FontWeight.w600, mColor: Colors.black),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(originalPrice),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
              height: 22,
              width: 200,
              child: ViewAppContainer(
                title: "Buy Now",
                bgColor: TColors.secondary,
                textColor: Colors.white,
                onTap: () {},
              ))
        ],
      ),
    ),
  );
}
