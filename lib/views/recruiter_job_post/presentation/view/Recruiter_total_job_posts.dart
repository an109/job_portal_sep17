import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../UI_Helper/UI_Helper.dart';
import '../../../../injection_container.dart';
import '../../../../utils/constants/image_string.dart';
import '../../../../widgets/widgets.dart';
import '../../../bottom_nav_bar/recruiter_bottom_nav_bar.dart';
import '../../../job_related/presentation/views/job_details_view.dart';
import '../../../recruiter_application/presentation/bloc/recruiter_application_bloc.dart';
import '../../../recruiter_application/presentation/view/Recruiter_Applications_Screen.dart';
import '../../../user_profile/presentation/views/User_Notifications_Screen.dart';
import '../../../user_profile/presentation/views/User_messages_screen.dart';
import '../bloc/recruiter_job_post_bloc/recruiter_job_post_bloc.dart';
import '../bloc/recruiter_job_post_bloc/recruiter_job_post_event.dart';
import '../bloc/recruiter_job_post_bloc/recruiter_job_post_state.dart';

class RecruiterTotalJobPosts extends StatefulWidget {
  @override
  State<RecruiterTotalJobPosts> createState() => _RecruiterTotalJobPostsState();
}

class _RecruiterTotalJobPostsState extends State<RecruiterTotalJobPosts> {
  TextEditingController seController = TextEditingController();


  @override
  void initState() {
    super.initState();
    final bloc = context.read<RecruiterJobPostBloc>();
    bloc.add(FetchAllJobPosts());
  }

  @override
  Widget build(BuildContext context) {
    // final bloc = context.read<RecruiterJobPostBloc>();
    // Future.microtask(() => bloc.add(FetchAllJobPosts()));

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: SvgPicture.asset(
          ImageString.jobPortalLogo,
          height: 30,
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessagesScreen()),
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
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/notifications_icon.svg"),
            ),
          ),
        ],
      ),

      /// BODY
      body: BlocBuilder<RecruiterJobPostBloc, RecruiterJobPostState>(
        builder: (context, state) {

          print("BlocBuilder: State = $state");

          if (state is RecruiterJobPostInitial || state is RecruiterJobPostLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RecruiterJobPostError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${state.message}"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<RecruiterJobPostBloc>().add(FetchAllJobPosts(),
                    ),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (state is RecruiterJobPostLoaded) {
            final jobs = state.jobPosts
                .where((job) => job != null)
                .map((job) => job!)
                .toList();

            if (jobs.isEmpty) {
              return Column(
                children: [
                  Expanded(
                    child: Center(child: Text("You haven't posted any jobs yet.")),
                  ),
                ],
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(right: 24.0, top: 7.0, left: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Jobs Posted",
                      style: mTextStyle32(mColor: Colors.black),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 80,
                            child: SearchTextField(onTextChanged: (value) {
                              print("Search query: $value");
                            }),
                          ),
                        ),
                        const SizedBox(width: 18),
                        InkWell(
                          onTap: () {},
                          child: SvgPicture.asset("assets/Icons/settings-sliders 1.svg"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    // Dynamic job cards from API
                    ...jobs.map((job) {
                      String subHeadingText = '';
                      final DateTime? deadline = job.lastApplicationDate;

                      if (deadline is DateTime) {
                        final day = deadline.day.toString().padLeft(2, '0');
                        final month = deadline.month.toString().padLeft(2, '0');
                        final year = deadline.year;
                        final formattedDate = '$day/$month/$year';
                        subHeadingText = job.status == "Active"
                            ? "Last date to receive application is $formattedDate."
                            : "Last date to apply was $formattedDate.";
                      } else {
                        subHeadingText = "No deadline set";
                      }

                      return TotalJobPostsCard(
                        heading: job.jobRole,
                        subHeading: subHeadingText,
                        status: job.status,
                        nApplications: "(${job.totalApplications})",
                        buttonTitle: "View Application",
                        totalViews: job.views,
                        jobPostId: job.jobId,
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
/// Total job posts container
class TotalJobPostsCard extends StatelessWidget {
  final String heading;
  final String? subHeading;
  final String status;
  final String nApplications;
  final String buttonTitle;
  final int totalViews;
  final int? jobPostId;

  const TotalJobPostsCard({
    super.key,
    required this.heading,
    this.subHeading,
    required this.status,
    required this.nApplications,
    required this.buttonTitle,
    required this.totalViews,
    this.jobPostId,
  });

  @override
  Widget build(BuildContext context) {
    bool isActive = status == "Active";

    return Container(
      height: 110,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  heading,
                  style: mTextStyle12(mFontWeight: FontWeight.w600),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {},
                  child: Icon(Icons.more_horiz),
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(
              subHeading ?? "",
              style: TextStyle(
                fontSize: 11,
                color: AppColors.blueTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 26,
                  child: greyContainer(
                    text: status,
                    bgColor: isActive
                        ? const Color(0xff1DB32F)
                        : Colors.grey.shade500,
                  ),
                ),
                const SizedBox(width: 15),
                numSeenContainer(nSeen: totalViews),
                const Spacer(),
                ViewAppContainer(
                  bgColor: AppColors.mainRedColor,
                  textColor: Colors.white,
                  title: buttonTitle,
                    nApplications: nApplications,
                    onTap: () {
                      if (jobPostId == null) {
                        print("No jobId available");
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider<RecruiterApplicationBloc>(
                            create: (context) => sl<RecruiterApplicationBloc>(),
                            child: RecruiterApplicationsScreen(
                              postName: heading,
                              jobPostId: jobPostId!,
                            ),
                          ),
                        ),
                      );
                    }
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
/// Widget ViewApplication Container
class ViewAppContainer extends StatelessWidget {
  final String title;
  final String? nApplications;
  VoidCallback onTap;
  Color bgColor;
  Color textColor;

  ViewAppContainer({
    super.key,
    required this.title,
    this.nApplications,
    required this.onTap,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: bgColor,
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: mTextStyle14(mColor: textColor),
            ),
            Text(
              nApplications ?? "",
              style: mTextStyle14(mColor: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
/// Grey number of views container
Widget numSeenContainer({required int nSeen}) {
  return Container(
    width: 80,
    height: 26,
    decoration: BoxDecoration(
      color: const Color(0xffEFF0F6),
      borderRadius: BorderRadius.circular(26),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/Icons/fi-rr-eye.svg",
          height: 12,
          width: 12,
        ),
        const SizedBox(width: 6),
        Text(
          nSeen.toString(),
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSize12Color,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    ),
  );
}