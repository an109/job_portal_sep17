import 'dart:developer' as developer show log;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/utils/constants/image_string.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';
import 'package:job_portal/views/login/presentation/views/login_page_first_view.dart';
import 'package:job_portal/views/user_profile/data/models/public_profile_model.dart';
import 'package:job_portal/views/user_profile/domain/entities/public_profile_entity.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/profile_bloc/profile_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/profile_bloc/profile_state.dart';
import 'package:job_portal/views/user_profile/presentation/views/User_Notifications_Screen.dart';
import 'package:job_portal/views/user_profile/presentation/views/change_email_password_views/change_email_view.dart';
import 'package:job_portal/views/user_profile/presentation/views/change_email_password_views/User_change_password_screen.dart';
import 'package:job_portal/views/user_profile/presentation/views/User_messages_screen.dart';
import 'package:job_portal/views/user_profile/presentation/views/chat_with_us_view.dart';
import 'package:job_portal/views/user_profile/presentation/views/log_out_dialog.dart';
import 'package:job_portal/views/user_profile/presentation/views/my_profile_view.dart';
import 'package:job_portal/views/user_profile/presentation/views/public_profile_view.dart';
import 'package:job_portal/views/user_profile/presentation/views/raise_ticket_view.dart';
import 'package:job_portal/views/user_profile/presentation/views/user_terms_and_conditions_view.dart';
import '../../../../ui_helper/ui_helper.dart';
import 'user_job_applications_view.dart';

class UserProfileScreen1 extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final showUserProfile2;
  final VoidCallback? onCallBackFromProfileScreen2;

  const UserProfileScreen1(
      {super.key,
      this.showUserProfile2 = false,
      this.onCallBackFromProfileScreen2});

  @override
  State<UserProfileScreen1> createState() => _UserProfileScreen1State();
}

class _UserProfileScreen1State extends State<UserProfileScreen1> {
  bool _isHelpSupportOpened = false;
  bool _isManageAccountOpened = false;

  late PublicProfileEntity userProfile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ignore: unused_local_variable
    final _prefs = sl<PreferencesManager>();

    final user_id = _prefs.getUserId();

    final bloc = context.read<ProfileBloc>();
    bloc.add(LoadPublicProfile(user_id ?? '77'));
  }

  bool showProfile2 = false;

  void navigateToProfile2() {
    setState(() {
      showProfile2 = true;
    });
  }

  void goBackFromProfile2() {
    setState(() {
      showProfile2 = false;
    });
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2), // for dimmed effect

      // builder: (context) => BlocProvider.value(
      //   value: context.read<MyProfileBloc>(),
      //   child: EditCareerObjectiveView(career_objective: career_objective),
      // ),

      builder: (context) {
        return const LogOutDialogView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (showProfile2) {
      return UserProfileScreen2(onBack: goBackFromProfile2);
    }

    return Scaffold(
      backgroundColor: Colors.white,

      /// APP HEADING
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {},
          child: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MessagesScreen(),
                ),
              );
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
                  builder: (context) => const NotificationsScreen(),
                ),
              );
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
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is PublicProfileLoaded) {
                    final profileData = state.publicProfile.publicProfile;
                    userProfile = profileData;
                    // developer
                    //     .log("Public profile loaded ${profileData.first_name}");
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: Container(
                        height: 90,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: TColors.primary,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: SvgPicture.asset(
                                  "assets/Icons/profile_icon.svg",
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "${profileData.first_name} ${profileData.last_name}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  // const Spacer(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "@${profileData.first_name.toLowerCase()}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 215, 215, 215),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UserPublicProfileScreen(
                                            userProfile: state.publicProfile,
                                            selfProfile: true,
                                          ),
                                        ),
                                      ).then((value) {
                                        final _prefs = sl<PreferencesManager>();

                                        final user_id = _prefs.getUserId();

                                        final bloc =
                                            context.read<ProfileBloc>();
                                        bloc.add(
                                            LoadPublicProfile(user_id ?? '77'));
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          height: 15,
                                          ImageString.eyeIcon,
                                          // fit: BoxFit.scaleDown,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Text(
                                          'Profile',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  } else if (state is PublicProfileLoading) {
                    developer.log("Public profile loading");
                    return const Center(
                      // child: Text('Public profile loading'),
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PublicProfileError) {
                    developer.log("Public profile error");
                    return Center(
                      child: Text(
                        'Oops... Try again later.',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text('Unhandled state : Profile view : $state'),
                    );
                  }
                },
                // child: const SizedBox(),
              ),

              const SizedBox(
                height: 18,
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  color: const Color(0xffFFFFFC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      UserProfileEnteries(
                        mIcon: "assets/Icons/profile_in_circle.svg",
                        title: "My Profile",
                        desc: "Make Changes to my Profile",
                        mArrow: Icons.keyboard_arrow_right_outlined,
                        onTap: () {
                          // if (widget.onCallBackFromProfileScreen2 != null) {
                          //   widget.onCallBackFromProfileScreen2!();
                          // }

                          navigateToProfile2();
                        },
                      ),
                      UserProfileEnteries(
                        mIcon: "assets/Icons/application_icon.svg",
                        title: "My Applications",
                        desc: "Manage your Applications",
                        mArrow: Icons.keyboard_arrow_right_outlined,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const StudentJobApplications(),
                            ),
                          );
                        },
                      ),
                      UserProfileEnteries(
                        mIcon: "assets/Icons/notification_in_circle.svg",
                        title: "Terms and Conditions",
                        mArrow: Icons.keyboard_arrow_right_outlined,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const UserTermsAndConditionsScreen(),
                            ),
                          );
                        },
                      ),
                      UserProfileEnteries(
                        mIcon: "assets/Icons/notification_in_circle.svg",
                        title: "Help & Support",
                        mArrow: Icons.keyboard_arrow_right_outlined,
                        onTap: () {
                          setState(() {
                            _isHelpSupportOpened = !_isHelpSupportOpened;
                          });
                          //   Navigator.push(context, MaterialPageRoute(builder: (context)=>));
                        },
                      ),
                      if (_isHelpSupportOpened) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Column(
                            children: [
                              UserProfileEnteries(
                                mIcon: "assets/Icons/Manage_account_icons.svg",
                                title: "Raise your ticket",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RaiseTicketView(
                                        userProfile: userProfile,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              UserProfileEnteries(
                                  mIcon:
                                      "assets/Icons/Manage_account_icons.svg",
                                  title: "Chat with us!",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ChatWithUsView(),
                                      ),
                                    );
                                  }),
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
                        },
                      ),
                      if (_isManageAccountOpened) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Column(
                            children: [
                              UserProfileEnteries(
                                mIcon: "assets/Icons/Manage_account_icons.svg",
                                title: "Change email",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChangeEmailView(),
                                    ),
                                  );
                                },
                              ),
                              UserProfileEnteries(
                                mIcon: "assets/Icons/Manage_account_icons.svg",
                                title: "Change password",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserChangePasswordScreen(),
                                    ),
                                  );
                                },
                              ),
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
                          _showLogoutDialog(context);
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

/// Widget for entries of the profile column
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
          height: 80,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SvgPicture.asset(mIcon),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              if (desc != null)
                Text(
                  desc,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 150, 150, 150)),
                )
            ],
          ),
        ),
        IconButton(onPressed: onTap, icon: Icon(mArrow))
      ],
    ),
  );
}
