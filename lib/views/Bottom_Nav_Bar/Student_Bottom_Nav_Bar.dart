import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';
import 'package:job_portal/views/AI_Prediction_Screens/AI_Prediction_Screens.dart';
import 'package:job_portal/views/feed/presentation/views/feed_view.dart';
import 'package:job_portal/views/job_related/presentation/views/job_search_view.dart';
import 'package:job_portal/views/user_profile/presentation/views/profile_view.dart';
import 'package:job_portal/ui_helper/ui_helper.dart';
import 'package:job_portal/widgets/widgets.dart';
import '../job_related/presentation/views/Company_filtered_jobs.dart';
import '../job_related/presentation/views/job_details_view.dart';

class Student_Bottom_Nav_bar extends StatefulWidget {
  const Student_Bottom_Nav_bar({super.key});

  @override
  State<Student_Bottom_Nav_bar> createState() => _Student_Bottom_Nav_barState();
}

class _Student_Bottom_Nav_barState extends State<Student_Bottom_Nav_bar> {
  int selected_index = 1;
  bool ShowFeedScreen2 = false;
  bool ShowUserProfileScreen2 = false;
  bool ShowJobDetailsScreen = false;
  bool showCompanyFilteredJobsScreen = false;
  TextEditingController addFeedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Widget> navTo = [
      FeedScreen(
        showFeed2: ShowFeedScreen2,
        onCallBackFromFeed2: () {
          setState(() {
            ShowFeedScreen2 = false;
          });
        },
      ),
      selected_index == 1
          ? (ShowJobDetailsScreen
              ? JobDetailsScreen(
                  onCallBack: () {
                    setState(() {
                      ShowJobDetailsScreen = false;
                    });
                  },
                  onShowCompanyJobs: () {
                    setState(() {
                      ShowJobDetailsScreen = false;
                      showCompanyFilteredJobsScreen = true;
                    });
                  },
                )
              : (showCompanyFilteredJobsScreen
                  ? CompanyFilteredJobsScreen(
                      onBack: () {
                        setState(() {
                          showCompanyFilteredJobsScreen = false;
                        });
                      },
                    )
                  : JobSearchScreen(
                      onCallBackFromJobDetailsPage: () {
                        setState(() {
                          ShowJobDetailsScreen = true;
                        });
                      },
                    )))
          : JobSearchScreen(),
      AIPredictionScreen(),
      UserProfileScreen1(
        showUserProfile2: ShowUserProfileScreen2,
        onCallBackFromProfileScreen2: () {
          setState(() {
            ShowUserProfileScreen2 = true;
          });
        },
      )
    ];

    return Scaffold(
      extendBody: true,
      // floatingActionButton: selected_index == 0
      //     ? Container(
      //         height: 44,
      //         width: 44,
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(26),
      //             color: TColors.secondary,
      //             border: Border.all(width: 2.6, color: Colors.white)),
      //         child: FloatingActionButton(
      //           onPressed: () {
      //             showModalBottomSheet(
      //               context: context,
      //               builder: (_) {
      //                 return Container(
      //                   height: 450,
      //                   width: double.infinity,
      //                   color: TColors.primary,
      //                   child: Padding(
      //                     padding: const EdgeInsets.symmetric(
      //                         horizontal: 24, vertical: 32),
      //                     child: Column(
      //                       children: [
      //                         Text(
      //                           "New Post",
      //                           style: mTextStyle32(),
      //                         ),
      //                         SizedBox(
      //                           height: 10,
      //                         ),
      //                         Text(
      //                           "Add value to your feed. What’s worth sharing?",
      //                           style: mTextStyle12(),
      //                         ),
      //                         SizedBox(
      //                           height: 16,
      //                         ),
      //                         Container(
      //                             height: 220,
      //                             width: 308,
      //                             decoration: BoxDecoration(
      //                                 borderRadius: BorderRadius.circular(14),
      //                                 color: Colors.black),
      //                             child: Stack(
      //                               children: [
      //                                 Positioned(
      //                                     bottom: 15,
      //                                     child: Padding(
      //                                       padding: const EdgeInsets.only(
      //                                           left: 12, right: 12),
      //                                       child: Container(
      //                                         height: 90,
      //                                         //  width: double.infinity,
      //                                         width: 285,
      //                                         decoration: BoxDecoration(
      //                                           color: Colors.white,
      //                                           borderRadius:
      //                                               BorderRadius.circular(11),
      //                                         ),
      //                                         child: Padding(
      //                                           padding:
      //                                               const EdgeInsets.symmetric(
      //                                                   vertical: 8.0),
      //                                           child: Column(
      //                                             children: [
      //                                               Container(
      //                                                 height: 25,
      //                                                 width: 120,
      //                                                 decoration: BoxDecoration(
      //                                                     borderRadius:
      //                                                         BorderRadius
      //                                                             .circular(12),
      //                                                     color: AppColors
      //                                                         .mainRedColor),
      //                                                 child: Row(
      //                                                   mainAxisAlignment:
      //                                                       MainAxisAlignment
      //                                                           .center,
      //                                                   children: [
      //                                                     InkWell(
      //                                                         onTap: () {},
      //                                                         child: Icon(
      //                                                           Icons.upload,
      //                                                           color: Colors
      //                                                               .white,
      //                                                           size: 18,
      //                                                         )),
      //                                                     Text("  Browse Files",
      //                                                         style: TextStyle(
      //                                                             fontWeight:
      //                                                                 FontWeight
      //                                                                     .w500,
      //                                                             fontSize: 9,
      //                                                             color: Colors
      //                                                                 .white))
      //                                                   ],
      //                                                 ),
      //                                               ),
      //                                               SizedBox(
      //                                                 height: 15,
      //                                               ),
      //                                               Text("Upload photos here",
      //                                                   style: TextStyle(
      //                                                       fontWeight:
      //                                                           FontWeight.w500,
      //                                                       fontSize: 9,
      //                                                       color: Colors
      //                                                           .grey.shade500))
      //                                             ],
      //                                           ),
      //                                         ),
      //                                       ),
      //                                     ))
      //                               ],
      //                             )),
      //                         SizedBox(
      //                           height: 10,
      //                         ),
      //                         SizedBox(
      //                             height: 36,
      //                             width: 308,
      //                             child: CustomTextField(
      //                               controller: addFeedController,
      //                               hintText: "Add Caption...",
      //                               suffixIcon: Icons.send,
      //                               onSuffixTap: () {
      //                                 setState(() {
      //                                   ShowFeedScreen2 = true;
      //                                 });
      //                                 Navigator.pop(context);
      //                               },
      //                             )),
      //                         SizedBox(
      //                           height: 5,
      //                         ),
      //                         Padding(
      //                           padding: const EdgeInsets.only(right: 30.0),
      //                           child: Row(
      //                             mainAxisAlignment: MainAxisAlignment.end,
      //                             children: [
      //                               InkWell(
      //                                   onTap: () {},
      //                                   child: Icon(
      //                                     Icons.more_horiz,
      //                                     color: Colors.white,
      //                                   )),
      //                             ],
      //                           ),
      //                         )
      //                       ],
      //                     ),
      //                   ),
      //                 );
      //               },
      //             );
      //           },
      //           backgroundColor: Colors.red,
      //           child: Icon(
      //             Icons.add,
      //             color: Colors.white,
      //             size: 24,
      //           ),
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(26),
      //           ),
      //         ),
      //       )
      //     : null,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: navTo[selected_index],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/Icons/Feed_Icons.svg",
                color: (selected_index == 0) ? TColors.secondary : Colors.white,
              ),
              label: "Feed"),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/Icons/Jobs.svg",
                color: (selected_index == 1) ? TColors.secondary : Colors.white,
              ),
              label: "Jobs"),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/Icons/AI_Icon.svg",
                color: (selected_index == 2) ? TColors.secondary : Colors.white,
              ),
              label: "AI Predictions"),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/Icons/nav_profile.svg",
                color: (selected_index == 3) ? TColors.secondary : Colors.white,
              ),
              label: "Profile")
        ],
        iconSize: 24,
        type: BottomNavigationBarType.fixed,
        backgroundColor: TColors.primary,
        // selectedIconTheme: Colors.white,
        selectedItemColor: TColors.secondary,
        unselectedItemColor: Colors.white,
        currentIndex: selected_index,
        onTap: (value) {
          selected_index = value;
          setState(() {});
        },
      ),
    );
  }
}
