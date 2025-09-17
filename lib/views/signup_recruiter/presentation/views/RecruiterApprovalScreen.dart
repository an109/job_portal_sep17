import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';

import '../../../../ui_helper/ui_helper.dart';
import '../../../../widgets/widgets.dart';
import '../../../recruiter_pipeline_candidates/presentation/view/Recruiter_pipeline_candidates.dart';
import 'package:job_portal/views/recruiter_job_post/presentation/view/Recruiter_total_job_posts.dart';


class RecruiterApprovalScreen extends StatelessWidget {
  TextEditingController searchItController = TextEditingController();

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
                        "Approvals",
                        style: mTextStyle32(mColor: Colors.black),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: CustomTextField(
                                controller: searchItController,
                                hintText: "Search by name, role or keyword...",
                                fillColor: Colors.white,
                                suffixIcon: Icons.search,
                                onSuffixTap: () {},
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                              onTap: () {},
                              child: SvgPicture.asset(
                                  "assets/Icons/settings-sliders 1.svg")),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          optionContainer(
                              title: "Pending",
                              textColor: Color(0xff6C7278),
                              bgColor: Color(0xffFFF7FB),
                              nApplications: "(1)"),
                          optionContainer(
                              title: "Approved",
                              textColor: Color(0xff6C7278),
                              bgColor: Color(0xffFFF7FB),
                              nApplications: "(1)"),
                          optionContainer(
                              title: "Rejected",
                              textColor: Color(0xff6C7278),
                              bgColor: Color(0xffFFF7FB),
                              nApplications: ""),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ApprovalCard(
                          applicantName: "Sanya Arora",
                          status: "Confirmed",
                          viewContainerText: "View Profile",
                          /* bgColor: Colors.green.shade100,
                     tColor: Colors.green,*/
                          postName: "UX/UI designer",
                          ApprovalDate: "2/05/2025"),
                      SizedBox(
                        height: 20,
                      ),
                      ApprovalCard(
                          applicantName: "Sanya Arora",
                          status: "Rejected",
                          viewContainerText: "View Application",
                          /* bgColor:
                     tColor: Colors.green,*/
                          postName: "UX/UI designer",
                          ApprovalDate: "2/05/2025"),
                    ]))));
  }
}

class ApprovalCard extends StatelessWidget {
  String applicantName;
  String postName;
  String ApprovalDate;
  String status;
  /* Color bgColor;
  Color tColor;*/
  String viewContainerText;

  ApprovalCard(
      {required this.applicantName,
        required this.status,
        required this.viewContainerText,
        /* required this.bgColor,
    required this.tColor,*/
        required this.postName,
        required this.ApprovalDate});

  // Define status colors
  Color getStatusBgColor() {
    switch (status) {
      case 'Confirmed':
        return Colors.green.shade100;
      case 'Pending':
        return Color(0xFFFFF2E5); // peach shade
      case 'Rejected':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color getStatusTextColor() {
    switch (status) {
      case 'Confirmed':
        return Colors.green;
      case 'Pending':
        return Color(0xFFEC9B3B); // matching peach/dark orange
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Name + Resume Match
          Row(
            children: [
              Text(applicantName,
                  style: mTextStyle14(mFontWeight: FontWeight.w600)),
              const Spacer(),
              optionContainer(
                  title: status,
                  textColor: getStatusTextColor(),
                  bgColor: getStatusBgColor()),
              Icon(Icons.more_vert),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            postName,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                "Sent on: $ApprovalDate ",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Container(
                width: 160,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black12)),
                child: ViewAppContainer(
                  title: viewContainerText,
                  bgColor: viewContainerText == "View Profile"
                      ? Color(0xffFFF7FB)
                      : TColors.secondary,
                  textColor: viewContainerText == "View Profile"
                      ? Color(0xff6C7278)
                      : Colors.white,
                  onTap: () {
                    /// Handle
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
