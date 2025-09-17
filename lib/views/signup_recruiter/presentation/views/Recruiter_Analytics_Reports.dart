import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';
import 'package:job_portal/widgets/widgets.dart';

import '../../../../ui_helper/ui_helper.dart';

class RecruiterAnalyticsReports extends StatelessWidget {
  TextEditingController serController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App bar
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            "LOGO",
            style: TextStyle(
                fontSize: 20,
                fontFamily: "Inter",
                fontWeight: FontWeight.w700,
                color: TColors.primary),
          ),
        ),

        /// Icons
        actions: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/message_icon.svg"),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/notifications_icon.svg"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 24.0, top: 7.0, left: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Analytics and Reports",
                style: mTextStyle32(mColor: Colors.black),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Expanded(
                      child: CustomTextField(
                    controller: serController,
                    hintText: "Search Reports or Stats",
                    fillColor: Colors.white,
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                      onTap: () {},
                      child: SvgPicture.asset(
                          "assets/Icons/settings-sliders 1.svg"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
