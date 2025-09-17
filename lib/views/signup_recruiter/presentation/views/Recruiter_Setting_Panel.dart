import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../ui_helper/ui_helper.dart';
import '../../../../widgets/widgets.dart';

class RecruiterSettingPanel extends StatelessWidget {
  TextEditingController searchOnlyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildCustomAppBar(titleText: "LOGO"),
        body: SingleChildScrollView(
            child: Padding(
                padding:
                    const EdgeInsets.only(right: 24.0, top: 7.0, left: 24.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Settings and access panel ",
                        style: mTextStyle32(mColor: Colors.black),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: CustomTextField(
                            controller: searchOnlyController,
                            hintText: "Search Reports or Stats",
                            fillColor: Colors.white,
                          )),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                              onTap: () {},
                              child: SvgPicture.asset(
                                  "assets/Icons/settings-sliders 1.svg"))
                        ],
                      ),
                    ]))));
  }
}
