import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/views/recruiter_full_view_application/presentation/bloc/recruiter_full_view_application_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/views/User_Notifications_Screen.dart';
import '../../../../injection_container.dart';
import '../../../../ui_helper/ui_helper.dart';
import '../../../../utils/constants/image_string.dart';
import '../../../../widgets/widgets.dart';
import '../../../recruiter_full_view_application/presentation/view/Recruiter_View_Full_Application_screen.dart';
import '../../../recruiter_job_post/presentation/view/Recruiter_total_job_posts.dart';
import '../../../recruiter_schedule_interview/presentaion/view/Recruiter_schedule_interview_screen.dart';
import '../../../recruiter_send_assignment/presenation/view/Recruiter_send_assignment.dart';
import '../../../user_profile/presentation/views/User_messages_screen.dart';
import '../bloc/recruiter_application_bloc.dart';
import '../bloc/recruiter_application_event.dart';
import '../bloc/recruiter_application_state.dart';

class RecruiterApplicationsScreen extends StatefulWidget {
  final String postName;
  final int jobPostId;

  const RecruiterApplicationsScreen({
    Key? key,
    required this.postName,
    required this.jobPostId,
  }) : super(key: key);

  @override
  State<RecruiterApplicationsScreen> createState() => _RecruiterApplicationsScreenState();
}

class _RecruiterApplicationsScreenState extends State<RecruiterApplicationsScreen> {
  TextEditingController searchingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RecruiterApplicationBloc>().add(FetchRecruiterApplications(widget.jobPostId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),

      /// App bar
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: SvgPicture.asset(
          ImageString.jobPortalLogo,
          height: 30,
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationsScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/notifications_icon.svg"),
            ),
          ),
        ],
      ),

      /// Body Part
      body: BlocBuilder<RecruiterApplicationBloc, RecruiterApplicationState>(
        builder: (context, state) {
          if (state is RecruiterApplicationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RecruiterApplicationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${state.message}"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RecruiterApplicationBloc>().add(FetchRecruiterApplications(widget.jobPostId));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (state is RecruiterApplicationLoaded) {
            final applications = state.applications;

            if (applications.isEmpty) {
              return const Center(child: Text("No applications received yet."));
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 7.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Heading name
                    Text("Applications", style: mTextStyle32(mColor: Colors.black)),
                    const SizedBox(height: 7),
                    Text("${widget.postName} Internship"),
                    const SizedBox(height: 25),

                    /// Search Bar Row
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

                    // Dynamic List of Applications
                    ...applications.map((app) {
                      // Format applied date
                      String appliedAgo = "Just now";
                      if (app.appliedDate.isNotEmpty) {
                        final date = DateTime.tryParse(app.appliedDate);
                        if (date != null) {
                          final diff = DateTime.now().difference(date).inDays;
                          appliedAgo = diff == 0 ? "Today" : "$diff days ago";
                        }
                      }

                      return AppReceivedCard(
                        applicantName: app.applicantName,
                        Location: app.location,
                        total_exp: "${app.experience} years",
                        appliedDate: appliedAgo,
                        resumeMatch: app.matchPercentage > 70
                            ? "High"
                            : app.matchPercentage > 40
                            ? "Moderate"
                            : "Low",
                        bgColor: app.matchPercentage > 70
                            ? const Color(0xffDCF5E6)
                            : app.matchPercentage > 40
                            ? const Color(0xffFFF5E6)
                            : const Color(0xffF5E6E6),
                        tColor: app.matchPercentage > 70
                            ? const Color(0xff1DB32F)
                            : app.matchPercentage > 40
                            ? const Color(0xffFFAD29)
                            : const Color(0xffD32F2F),
                        onTap: () {
                          if (widget.jobPostId == null) return;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider<RecruiterFullViewApplicationBloc>(
                                create: (context) => sl<RecruiterFullViewApplicationBloc>(),
                                child: Recruiter_View_Full_Application_screen(
                                  applicantName: app.applicantName,
                                  appliedDate: app.appliedDate,
                                  jobId: widget.jobPostId,
                                  applicantId: app.applicationId,
                                ),
                              ),
                            ),
                          );
                        },
                        applicantId: app.applicationId,
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

///  Applications Received Card
class AppReceivedCard extends StatelessWidget {
  final String applicantName;
  final String Location;
  final String total_exp;
  final String appliedDate;
  final String resumeMatch;
  final Color bgColor;
  final Color tColor;
  final VoidCallback onTap;
  final int applicantId;

  const AppReceivedCard({
    Key? key,
    required this.applicantName,
    required this.Location,
    required this.total_exp,
    required this.appliedDate,
    required this.resumeMatch,
    required this.bgColor,
    required this.tColor,
    required this.onTap,
    required this.applicantId,
  }) : super(key: key);

  void _showActionsMenu(BuildContext context) {
    final RenderBox overlay = context.findRenderObject() as RenderBox;
    final Offset target = Offset(overlay.size.width - 40, 80); // Relative to card
    final Offset globalTarget = overlay.localToGlobal(target);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(globalTarget.dx, globalTarget.dy, 0, 0),
        Offset.zero & MediaQuery.of(context).size,
      ),
      items: const [
        PopupMenuItem(value: 'send_assignment', child: Text("Send Assignment")),
        PopupMenuItem(value: 'schedule_interview', child: Text("Schedule Interview")),
        PopupMenuItem(value: 'open_chat', child: Text("Open Chat")),
        PopupMenuItem(value: 'hire', child: Text("Hire")),
      ],
    ).then((value) {
      if (value == 'send_assignment') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SendAssignmentPage(
              candidateName: applicantName,
              applicantId: applicantId,
            ),
          ),
        );
      } else if (value == 'schedule_interview') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ScheduleInterviewPage(
                  candidateName: applicantName,
                  applicantId: applicantId,
                ),
            ),
        );
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showActionsMenu(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        height: 112,
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
                Text(
                  applicantName,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                colorContainer(resumeMatch: resumeMatch, bgColor: bgColor, tColor: tColor)
              ],
            ),
            const SizedBox(height: 4),
            Text(
              Location,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Total Work Experience: $total_exp",
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "Applied $appliedDate",
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w400),
                ),
                const Spacer(),
                SizedBox(
                  width: 160,
                  child: ViewAppContainer(
                    bgColor: AppColors.mainRedColor,
                    textColor: Colors.white,
                    title: "View Full Application",
                    onTap: onTap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Color containers of peach, red and green color
Widget colorContainer({required String resumeMatch, required Color bgColor, required Color tColor}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: tColor),
    ),
    child: Text(
      "Resume Match: $resumeMatch",
      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w400, color: tColor),
    ),
  );
}