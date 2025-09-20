import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';
import 'package:job_portal/views/Recruiter_Profile_Screens/Recruiter_ProfileScreen1.dart';
import '../University_profile_screen/presentation/views/university_profile_screen1.dart';
import '../signup_recruiter/presentation/views/RecruiterApprovalScreen.dart';
import '../recruiter_dashboard/presentation/views/Recruiter_Dashboard.dart';
import '../feed/presentation/views/feed_view.dart';

class UniversityBottomNavBar extends StatefulWidget {
  @override
  State<UniversityBottomNavBar> createState() => _UniversityBottomNavBarState();
}

class _UniversityBottomNavBarState extends State<UniversityBottomNavBar> {
  var selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    List<Widget> navTo = [
      FeedScreen(),
      UniversityProfilescreen1(),
      RecruiterApprovalScreen(),
      UniversityProfilescreen1()
    ];
    return Scaffold(
      body: navTo[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/Icons/Feed_Icons.svg",
              color: (selectedIndex == 0) ? TColors.secondary : Colors.white,
            ),
            label: "Feed",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/Icons/dashboard_icon.svg",
              color: (selectedIndex == 1) ? TColors.secondary : Colors.white,
            ),
            label: "Promotion",
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/Icons/Approval_icon.svg",
                color: (selectedIndex == 2) ? TColors.secondary : Colors.white,
              ),
              label: "Approval"),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/Icons/nav_profile.svg",
                color: (selectedIndex == 3) ? TColors.secondary : Colors.white,
              ),
              label: "Profile")
        ],
        iconSize: 24,
        type: BottomNavigationBarType.fixed,
        backgroundColor: TColors.primary,
        // selectedIconTheme: Colors.white,
        selectedItemColor: TColors.secondary,
        unselectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: (value) {
          selectedIndex = value;
          setState(() {});
        },
      ),
    );
  }
}
