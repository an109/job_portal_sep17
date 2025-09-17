import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/ui_helper/ui_helper.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';
import 'package:job_portal/views/recruiter_application/presentation/view/Recruiter_Applications_Screen.dart';
import 'package:job_portal/widgets/widgets.dart';

import '../../../job_related/presentation/views/job_details_view.dart';
import '../../../recruiter_application/presentation/bloc/recruiter_application_bloc.dart';
import '../../../recruiter_application/presentation/bloc/recruiter_application_event.dart';
import '../../../recruiter_job_post/presentation/view/Recruiter_total_job_posts.dart';
import '../bloc/recruiter_pending_tasks_bloc.dart';
import '../bloc/recruiter_pending_tasks_event.dart';
import '../bloc/recruiter_pending_tasks_state.dart';

class RecruiterPendingTasks extends StatelessWidget {
  final TextEditingController findController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RecruiterPendingTasksBloc>()..add(FetchPendingTasks()),
      child: Scaffold(
        /// App bar
        appBar: buildCustomAppBar(titleText: "LOGO"),
        body: BlocBuilder<RecruiterPendingTasksBloc, RecruiterPendingTasksState>(
          builder: (context, state) {
            if (state is RecruiterPendingTasksLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is RecruiterPendingTasksFailed) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error: ${state.error}"),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<RecruiterPendingTasksBloc>().add(FetchPendingTasks());
                      },
                      child: Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            if (state is RecruiterPendingTasksSuccess) {
              // ✅ Extract real counts from API
              final int resumesToReview = state.data.resumeReview.count;
              final int interviewsToSchedule = state.data.interviewToSchedule.count;
              final int pendingOffers = state.data.offerLetterPending.count;

              return _buildUI(
                context,
                resumesToReview: resumesToReview,
                interviewsToSchedule: interviewsToSchedule,
                pendingOffers: pendingOffers,
                findController: findController,
              );
            }

            return Center(child: Text("Unknown state"));
          },
        ),
      ),
    );
  }

  Widget _buildUI(
      BuildContext context, {
        required int resumesToReview,
        required int interviewsToSchedule,
        required int pendingOffers,
        required TextEditingController findController,
      }) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pending Tasks",
              style: mTextStyle32(mColor: Colors.black),
            ),
            SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: findController,
                    hintText: "Search by name, role or keyword...",
                    fillColor: Colors.white,
                    suffixIcon: Icons.search,
                    onSuffixTap: () {},
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {},
                  child: SvgPicture.asset("assets/Icons/settings-sliders 1.svg"),
                ),
              ],
            ),
            SizedBox(height: 25),
            reviewResumeContainer(
              title: "Resumes to review",
              nApplications: resumesToReview.toString(),
              title_inside_greyContainer: "Resumes",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<RecruiterApplicationBloc>(
                      create: (context) => sl<RecruiterApplicationBloc>(),
                      child: RecruiterApplicationsScreen(
                        postName: "All Pending Applications",
                        jobPostId: 0,
                      ),
                    ),
                  ),
                );
              },
              viewContainer_text: "Review Now",
              buttonTap: () {},
            ),
            SizedBox(height: 25),
            reviewResumeContainer(
              title: "Interviews to Schedule",
              nApplications: interviewsToSchedule.toString(),
              title_inside_greyContainer: "Interview",
              onTap: () {
                // Navigate to schedule interview page
              },
              viewContainer_text: "Schedule Now",
              buttonTap: () {},
            ),
            SizedBox(height: 25),
            reviewResumeContainer(
              title: "Pending Offers",
              nApplications: pendingOffers.toString(),
              title_inside_greyContainer: "Offer",
              onTap: () {
                // Navigate to offer management
              },
              viewContainer_text: "Send Offer",
              buttonTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable Container for Pending Tasks
Widget reviewResumeContainer({
  required String title,
  required String nApplications,
  required String title_inside_greyContainer,
  required String viewContainer_text,
  required VoidCallback onTap,
  required VoidCallback buttonTap,
}) {
  return Container(
    height: 90,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(width: 1.0, color: Colors.grey.shade300),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title),
              Spacer(),
              SizedBox(
                height: 22,
                child: greyContainer(
                  text: '$nApplications $title_inside_greyContainer',
                  bgColor: Colors.grey.shade600,
                ),
              ),
              InkWell(onTap: buttonTap, child: Icon(Icons.more_vert)),
            ],
          ),
          SizedBox(height: 15),
          ViewAppContainer(
            title: viewContainer_text,
            onTap: onTap,
            bgColor: TColors.secondary,
            textColor: Colors.white,
          ),
        ],
      ),
    ),
  );
}