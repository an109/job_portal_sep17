import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';
import 'package:job_portal/views/Recruiter_Profile_Screens/Recruiter_ProfileScreen1.dart';
import '../signup_recruiter/presentation/views/RecruiterApprovalScreen.dart';
import '../recruiter_dashboard/presentation/views/Recruiter_Dashboard.dart';
import '../feed/presentation/views/feed_view.dart';

class RecruiterBottomNavBar extends StatefulWidget {
  @override
  State<RecruiterBottomNavBar> createState() => _RecruiterBottomNavBarState();
}

class _RecruiterBottomNavBarState extends State<RecruiterBottomNavBar> {
  var selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    List<Widget> navTo = [
      FeedScreen(),
      RecruiterDashboard(),
      RecruiterApprovalScreen(),
      RecruiterProfilescreen1()
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
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/Icons/Approval_icon.svg",
                color: (selectedIndex == 2) ? TColors.secondary : Colors.white,
              ),
              label: "Approvals"),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/Icons/nav_profile.svg",
                color: (selectedIndex == 3) ? TColors.secondary : Colors.white,
              ),
              label: "Approvals")
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
