import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_portal/utils/constants/image_string.dart';
import 'package:job_portal/views/bottom_nav_bar/student_bottom_nav_bar.dart';
import 'package:job_portal/views/user_profile/presentation/views/User_Notifications_Screen.dart';
import '../../../../ui_helper/ui_helper.dart';
import '../../../../widgets/widgets.dart';
import '../../../user_profile/presentation/views/User_messages_screen.dart';
import 'job_search_view.dart';

class JobFiltersScreen extends StatefulWidget {
  const JobFiltersScreen({super.key});

  @override
  State<JobFiltersScreen> createState() => _JobFiltersScreenState();
}

class _JobFiltersScreenState extends State<JobFiltersScreen> {
  bool value1 = false;

  bool value2 = false;

  TextEditingController profileController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController totalWorkExperienceController = TextEditingController();
  TextEditingController currentComController = TextEditingController();
  TextEditingController PackageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        // title: Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
        //   child: Text(
        //     "LOGO",
        //     style: TextStyle(
        //         fontSize: 20,
        //         fontFamily: "Inter",
        //         fontWeight: FontWeight.w700,
        //         color: TColors.primary),
        //   ),
        // ),
        title: SvgPicture.asset(
          ImageString.jobPortalLogo,
          height: 30,
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MessagesScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/message_icon.svg"),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationsScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/notifications_icon.svg"),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        height: 1000,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 58.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Job Filters",
                        style: mTextStyle32(mColor: Colors.black),
                      ),
                      Text(
                        "Help us match you with the best career opportunities",
                        style: mTextStyle12(),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Profile",
                  style: mTextStyle12(),
                ),
                SizedBox(
                  height: 2,
                ),
                CustomTextField(
                  controller: profileController,
                  hintText: "Eg.Marketing",
                  suffixIcon: Icons.keyboard_arrow_down_outlined,
                  fillColor: Colors.white,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Location",
                  style: mTextStyle12(),
                ),
                SizedBox(
                  height: 2,
                ),
                CustomTextField(
                  controller: locationController,
                  hintText: "Eg.Delhi",
                  suffixIcon: Icons.keyboard_arrow_down_outlined,
                  fillColor: Colors.white,
                ),
                // SizedBox(height: 20,),
                Row(
                  children: [
                    Checkbox(
                        value: value1,
                        onChanged: (bool? newValue) {
                          setState(() {
                            value1 = newValue!;
                          });
                        }),
                    Text(
                      "Remote",
                      style: mTextStyle12(),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Checkbox(
                        value: value2,
                        onChanged: (bool? newValue) {
                          setState(() {
                            value2 = newValue!;
                          });
                        }),
                    Text(
                      "Hybrid",
                      style: mTextStyle12(),
                    )
                  ],
                ),
                Text(
                  "Year of Experience",
                  style: mTextStyle12(),
                ),
                SizedBox(
                  height: 2,
                ),
                CustomTextField(
                  controller: totalWorkExperienceController,
                  hintText: "Total Experience",
                  suffixIcon: Icons.keyboard_arrow_down_outlined,
                  fillColor: Colors.white,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Company",
                  style: mTextStyle12(),
                ),
                SizedBox(
                  height: 2,
                ),
                CustomTextField(
                  controller: currentComController,
                  hintText: "Company Name",
                  suffixIcon: Icons.keyboard_arrow_down_outlined,
                  fillColor: Colors.white,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Annual Salary(In lakhs)",
                  style: mTextStyle12(),
                ),
                SizedBox(
                  height: 2,
                ),
                CustomTextField(
                  controller: PackageController,
                  hintText: "Eg.4,50,000",
                  suffixIcon: Icons.keyboard_arrow_down_outlined,
                  fillColor: Colors.white,
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    InkWell(
                        onTap: () {},
                        child: Text(
                          "Clear All",
                          style: mTextStyle12(
                            mFontWeight: FontWeight.w600,
                            mColor: AppColors.blueTextColor,
                          ),
                        )),
                    Spacer(),
                    nextButton(
                        title: "Apply",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Student_Bottom_Nav_bar()
                              )
                          );
                        })
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
