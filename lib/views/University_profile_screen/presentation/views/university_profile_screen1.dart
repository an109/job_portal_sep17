import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';
import 'package:job_portal/views/University_profile_screen/presentation/views/university_profile_screen2.dart' hide sl;
import 'package:job_portal/views/login/presentation/views/login_page_first_view.dart';

import '../../../../UI_Helper/UI_Helper.dart';
import '../../../user_profile/presentation/views/User_Notifications_Screen.dart';
import '../../../user_profile/presentation/views/User_messages_screen.dart';
import '../../../user_profile/presentation/views/change_email_password_views/User_change_password_screen.dart';
import '../../../user_profile/presentation/views/change_email_password_views/change_email_view.dart';
import '../../../user_profile/presentation/views/user_job_applications_view.dart';
import '../../../user_profile/presentation/views/user_terms_and_conditions_view.dart';


class UniversityProfilescreen1 extends StatefulWidget {
  const UniversityProfilescreen1({super.key});

  @override
  State<UniversityProfilescreen1> createState() =>
      _UniversityProfilescreen1State();
}

class _UniversityProfilescreen1State extends State<UniversityProfilescreen1> {
  bool _isHelpSupportOpened = false;
  bool _isManageAccountOpened = false;

  @override
  Widget build(BuildContext context) {
    final prefs = sl<PreferencesManager>();
    final userName = prefs.getString(PreferencesManager.USER_NAME) ?? 'Recruiter Name';
    final userEmail = prefs.getString(PreferencesManager.USER_EMAIL) ?? 'recruiter@email.com';

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MessagesScreen()));
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
                      builder: (context) => NotificationsScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/notifications_icon.svg"),
            ),
          ),
        ],
      ),

      /// BODY PART
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              /// Profile Container
              Container(
                height: 98,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: TColors.primary),
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Container(
                      height: 58,
                      width: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: _getProfileImage(prefs),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 150, // Adjust as needed
                    child: Padding(
                      padding: const EdgeInsets.only(top: 28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prefs.getString(PreferencesManager.USER_NAME) ?? 'Recruiter Name',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            prefs.getString(PreferencesManager.USER_EMAIL) ?? 'recruiter@email.com',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 580,
                width: 383,
                decoration: BoxDecoration(
                  color: Color(0xffFFFFFC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      UserProfileEnteries(
                        mIcon: "assets/Icons/profile_in_circle.svg",
                        title: "My Profile",
                        desc: "Make Changes to my Profile",
                        mArrow: Icons.keyboard_arrow_right_outlined,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>UniversityProfilescreen2()));
                          /*if(widget.onCallBackFromProfileScreen2!=null){
                              widget.onCallBackFromProfileScreen2!();*/
                        },
                      ),
                      UserProfileEnteries(
                          mIcon: "assets/Icons/application_icon.svg",
                          title: "Activity Feed",
                          desc: "Your recent activity",
                          mArrow: Icons.keyboard_arrow_right_outlined,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentJobApplications()));
                          }),
                      UserProfileEnteries(
                        mIcon: "assets/Icons/terms_permission_icon.svg",
                        title: "Terms and Permissions",
                        mArrow: Icons.keyboard_arrow_right_outlined,
                      ),
                      UserProfileEnteries(
                          mIcon: "assets/Icons/notification_in_circle.svg",
                          title: "Terms and Conditions",
                          mArrow: Icons.keyboard_arrow_right_outlined,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>UserTermsAndConditionsScreen()));
                          }),
                      UserProfileEnteries(
                          mIcon: "",
                          title: "Help & Support",
                          mArrow: Icons.keyboard_arrow_right_outlined,
                          onTap: () {
                            setState(() {
                              _isHelpSupportOpened = !_isHelpSupportOpened;
                            });
                            //   Navigator.push(context, MaterialPageRoute(builder: (context)=>));
                          }),
                      if (_isHelpSupportOpened) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Column(
                            children: [
                              UserProfileEnteries(
                                  mIcon:
                                  "assets/Icons/Manage_account_icons.svg",
                                  title: "Raise your ticket"),
                              UserProfileEnteries(
                                  mIcon:
                                  "assets/Icons/Manage_account_icons.svg",
                                  title: "Chat with us!"),
                            ],
                          ),
                        )
                      ],
                      UserProfileEnteries(
                          mIcon: "assets/Icons/Manage_account_icons.svg",
                          title: "Manage Account",
                          mArrow: Icons.keyboard_arrow_right_outlined,
                          onTap: () {
                            setState(() {
                              _isManageAccountOpened = !_isManageAccountOpened;
                            });
                          }),
                      if (_isManageAccountOpened) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Column(
                            children: [
                              UserProfileEnteries(
                                  mIcon:
                                  "assets/Icons/Manage_account_icons.svg",
                                  title: "Change email",
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangeEmailView()));
                                  }),
                              UserProfileEnteries(
                                  mIcon:
                                  "assets/Icons/Manage_account_icons.svg",
                                  title: "Change password",
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>UserChangePasswordScreen()));
                                  }),
                              UserProfileEnteries(
                                  mIcon:
                                  "assets/Icons/Manage_account_icons.svg",
                                  title: "Delete my account")
                            ],
                          ),
                        )
                      ],
                      UserProfileEnteries(
                        mIcon: "assets/Icons/Log_out_icon.svg",
                        title: "Log Out",
                        desc: "Further secure your account for safety",
                        mArrow: Icons.keyboard_arrow_right_outlined,
                        onTap: () {
                          final _prefs = sl<PreferencesManager>();

                          _prefs.clear('recruiter_profile_pic');

                          _prefs.clear(PreferencesManager.USER_TYPE);
                          _prefs.clear(PreferencesManager.TOKEN);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LogInPage1()),
                                  (_) => false);
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
Widget UserProfileEnteries(
    {required String mIcon,
      required String title,
      String? desc,
      IconData? mArrow,
      VoidCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Row(
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: mIcon.isNotEmpty
              ? SvgPicture.asset(
            mIcon,
            height: 20,
            width: 20,
          )
              : SizedBox(), // Handle empty icon gracefully
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: mTextStyle14(),
              ),
              if (desc != null && desc.isNotEmpty) // Only show if exists
                Text(
                  desc,
                  style: mTextStyle12(),
                ),
            ],
          ),
        ),
        if (mArrow != null) // Only show arrow if provided
          Icon(mArrow, color: Colors.black),
      ],
    ),
  );
}
// Widget _getProfileImage(PreferencesManager prefs) {
//   final profilePicPath = prefs.getString('recruiter_profile_pic') ?? '';
//
//   if (profilePicPath.isNotEmpty) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(25),
//       child: Image.network(
//         profilePicPath,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) {
//           return SvgPicture.asset("assets/Icons/profile_icon.svg");
//         },
//       ),
//     );
//   } else {
//     return SvgPicture.asset("assets/Icons/profile_icon.svg");
//   }
// }
Widget _getProfileImage(PreferencesManager prefs) {
  final profilePicPath = prefs.getString('recruiter_profile_pic') ?? '';

  if (profilePicPath.isEmpty) {
    return SvgPicture.asset("assets/Icons/profile_icon.svg");
  }

  bool isLocalFile = profilePicPath.startsWith('/') || profilePicPath.contains(':\\'); // Simple check for local paths

  if (isLocalFile) {
    if (File(profilePicPath).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.file(
          File(profilePicPath),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return SvgPicture.asset("assets/Icons/profile_icon.svg");
          },
        ),
      );
    } else {
      // File was deleted or moved
      return SvgPicture.asset("assets/Icons/profile_icon.svg");
    }
  } else {
    // Assume it's a network URL
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Image.network(
        profilePicPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return SvgPicture.asset("assets/Icons/profile_icon.svg");
        },
      ),
    );
  }
}