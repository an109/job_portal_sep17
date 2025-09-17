import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/utils/constants/image_string.dart';
import 'package:job_portal/views/signup_recruiter/presentation/views/Recruiter_Analytics_Reports.dart';
import 'package:job_portal/views/signup_recruiter/presentation/views/Recruiter_Setting_Panel.dart';
import 'package:job_portal/views/recruiter_upcoming_interviews/presentation/view/Recruiter_Upcoming_Interviews.dart';
import 'package:job_portal/views/recruiter_pending_tasks/presentation/view/Recruiter_pending_tasks.dart';
import 'package:job_portal/views/recruiter_pipeline_candidates/presentation/view/Recruiter_pipeline_candidates.dart';
import 'package:job_portal/views/user_profile/presentation/views/User_messages_screen.dart';
import '../../../../UI_Helper/UI_Helper.dart';
import '../../../../injection_container.dart';
import '../../../../widgets/widgets.dart';
import '../../../post_opportunities/presentation/views/post_opportunity_screen.dart';
import '../../../recruiter_job_post/presentation/bloc/recruiter_job_post_bloc/recruiter_job_post_bloc.dart';
import '../../../recruiter_job_post/presentation/bloc/recruiter_job_post_bloc/recruiter_job_post_event.dart';
import '../../../user_profile/presentation/views/User_Notifications_Screen.dart';
import '../../../recruiter_job_post/presentation/view/Recruiter_total_job_posts.dart';
import '../bloc/recruiter_dashboard_bloc/Recruiter_Dashboard_Bloc.dart';
import '../bloc/recruiter_dashboard_bloc/Recruiter_Dashboard_Event.dart';
import '../bloc/recruiter_dashboard_bloc/Recruiter_Dashboard_State.dart';

class RecruiterDashboard extends StatefulWidget {
  const RecruiterDashboard({super.key});

  @override
  State<RecruiterDashboard> createState() => _RecruiterDashboardState();
}

class _RecruiterDashboardState extends State<RecruiterDashboard> {
  TextEditingController findingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<RecruiterDashboardBloc>().add(FetchTotalJobCount());
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.watch<RecruiterDashboardBloc>().state;

    int totalJobCount = 0;
    int pendingTasksCount = 0;
    int upcomingInterviewsCount = 0;
    bool loading = true;

    if (dashboardState is RecruiterDashboardLoaded) {
      totalJobCount = dashboardState.totalCount;
      pendingTasksCount = dashboardState.pendingTasksCount;
      upcomingInterviewsCount = dashboardState.upcomingInterviewsCount;
      loading = false;
    } else if (dashboardState is RecruiterDashboardInitial || dashboardState is RecruiterDashboardLoading) {
      loading = true;
    } else if (dashboardState is RecruiterDashboardError) {
      totalJobCount = 0;
      pendingTasksCount = 0;
      upcomingInterviewsCount = 0;
      loading = false;
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
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

      /// BODY PART
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 24.0, top: 7.0, left: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADING OF THE SCREEN
              Text(
                "DashBoard",
                style: mTextStyle32(mColor: Colors.black),
              ),
              const SizedBox(height: 15),

              /// Post A Job Button
              CustomButton1(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostInternshipsScreen()),
                  );
                },
                text: 'Post a Job',
              ),

              /// DASHBOARD CONTAINERS
              SizedBox(height: 25),

              // Total Job Post
              DashBoardConatiner(
                Heading: "Total Job Post",
                SubHeading: "Track and manage all your open roles in one place.",
                redButtonTitle: "Manage postings",
                notificationNum: "($totalJobCount)",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider<RecruiterJobPostBloc>(
                        create: (context) => sl<RecruiterJobPostBloc>()..add(FetchAllJobPosts()),
                        child: RecruiterTotalJobPosts(),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),

              // Pipeline candidates
              DashBoardConatiner(
                Heading: "Pipeline candidates",
                SubHeading: "Monitor every candidate’s journey through your hiring funnel.",
                redButtonTitle: "Manage pipelines",
                notificationNum: "(2)",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecruiterPipelineCandidates()),
                  );
                },
              ),
              SizedBox(height: 20),

              // Upcoming interviews
              DashBoardConatiner(
                Heading: "Upcoming interviews",
                SubHeading: "You have $upcomingInterviewsCount interviews scheduled for today..",
                redButtonTitle: "Review interviews",
                notificationNum: "($upcomingInterviewsCount)",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecruiterUpcomingInterviews()),
                  );
                },
              ),
              SizedBox(height: 20),

              // Pending tasks
              DashBoardConatiner(
                Heading: "Pending tasks",
                SubHeading: "You have $pendingTasksCount tasks waiting for your attention..",
                redButtonTitle: "Manage tasks",
                notificationNum: "($pendingTasksCount)",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecruiterPendingTasks()),
                  );
                },
              ),
              SizedBox(height: 20),

              // Analytics and Report
              DashBoardConatiner(
                Heading: "Analytics and Report",
                SubHeading: "Track hiring progress and performance in real time.",
                redButtonTitle: "view Details",
                notificationNum: "",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecruiterAnalyticsReports()),
                  );
                },
              ),
              SizedBox(height: 20),

              // Settings and access panel
              DashBoardConatiner(
                Heading: "Settings and access panel",
                SubHeading: "Manage your personal info and app preferences.",
                redButtonTitle: "view Details",
                notificationNum: "",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecruiterSettingPanel()),
                  );
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// WIDGET FOR DASHBOARD CONTAINERS
Widget DashBoardConatiner({
  required String Heading,
  required String SubHeading,
  required String redButtonTitle,
  required String notificationNum,
  required VoidCallback onTap,
}) {
  return Container(
    height: 110,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300, width: 1.0),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                Heading,
                style: mTextStyle14(mFontWeight: FontWeight.w600),
              ),
              Spacer(),
              InkWell(onTap: () {}, child: Icon(Icons.more_horiz))
            ],
          ),
          SizedBox(height: 9),
          Text(
            SubHeading,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.blueTextColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 12),
          Container(
            height: 26,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColors.mainRedColor,
            ),
            child: InkWell(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    redButtonTitle,
                    style: mTextStyle12(mColor: Colors.white),
                  ),
                  SizedBox(width: 3),
                  Text(
                    notificationNum,
                    style: mTextStyle12(mColor: Colors.white),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}