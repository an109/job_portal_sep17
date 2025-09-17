import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/ui_helper/ui_helper.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';
import 'package:job_portal/views/recruiter_job_post/presentation/view/Recruiter_total_job_posts.dart';



import '../../../../widgets/widgets.dart';
import '../../../recruiter_pipeline_candidates/presentation/view/Recruiter_pipeline_candidates.dart';
import '../../data/models/recruiter_upcoming_interviews_response_model.dart';
import '../bloc/recruiter_upcoming_interviews_bloc.dart';
import '../bloc/recruiter_upcoming_interviews_event.dart';
import '../bloc/recruiter_upcoming_interviews_state.dart';

class RecruiterUpcomingInterviews extends StatefulWidget {
  const RecruiterUpcomingInterviews({Key? key}) : super(key: key);

  @override
  State<RecruiterUpcomingInterviews> createState() => _RecruiterUpcomingInterviewsState();
}

class _RecruiterUpcomingInterviewsState extends State<RecruiterUpcomingInterviews> {
  TextEditingController searchController = TextEditingController();

  int selectedTab = 0; // 0: Today, 1: This Week, 2: Custom

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RecruiterUpcomingInterviewsBloc>()..add(FetchUpcomingInterviews()),
      child: Scaffold(
        appBar: buildCustomAppBar(titleText: "LOGO"),
        body: BlocBuilder<RecruiterUpcomingInterviewsBloc, RecruiterUpcomingInterviewsState>(
          builder: (context, state) {
            if (state is RecruiterUpcomingInterviewsLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is RecruiterUpcomingInterviewsFailed) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error: ${state.error}"),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<RecruiterUpcomingInterviewsBloc>().add(FetchUpcomingInterviews());
                      },
                      child: Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            if (state is RecruiterUpcomingInterviewsSuccess) {
              final allInterviews = state.data;

              // Filter by tab
              final todayInterviews = _filterByToday(allInterviews);
              final thisWeekInterviews = _filterByThisWeek(allInterviews);

              // Filter by search
              final filteredInterviews = _filterInterviews(
                selectedTab == 0 ? todayInterviews : selectedTab == 1 ? thisWeekInterviews : allInterviews,
                searchController.text,
              );

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 24.0, top: 7.0, left: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upcoming Interviews",
                        style: mTextStyle32(mColor: Colors.black),
                      ),
                      SizedBox(height: 25),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: searchController,
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
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          optionContainer(
                            title: "Today",
                            textColor: selectedTab == 0 ? TColors.secondary : Color(0xff6C7278),
                            bgColor: selectedTab == 0 ? Color(0xffE0F8EB) : Colors.white,
                            nApplications: "(${todayInterviews.length})",
                            onTap: () {
                              setState(() {
                                selectedTab = 0;
                              });
                            },
                          ),
                          optionContainer(
                            title: "This Week",
                            textColor: selectedTab == 1 ? TColors.secondary : Color(0xff6C7278),
                            bgColor: selectedTab == 1 ? Color(0xffE0F8EB) : Colors.white,
                            nApplications: "(${thisWeekInterviews.length})",
                            onTap: () {
                              setState(() {
                                selectedTab = 1;
                              });
                            },
                          ),
                          optionContainer(
                            title: "Custom",
                            textColor: selectedTab == 2 ? TColors.secondary : Color(0xff6C7278),
                            bgColor: selectedTab == 2 ? Color(0xffE0F8EB) : Colors.white,
                            nApplications: "",
                            onTap: () {
                              setState(() {
                                selectedTab = 2;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      if (filteredInterviews.isEmpty)
                        Center(child: Text("No interviews found.")),
                      ...filteredInterviews.map((interview) {
                        final statusText = interview.status ?? "Confirmed";
                        final tColor = statusText.contains("pending")
                            ? Color(0xffFFA30F)
                            : Color(0xff00BB5E);
                        final bgColor = statusText.contains("pending")
                            ? Color(0xffFFF6E4)
                            : Color(0xffE0F8EB);

                        return InterviewCard(
                          applicantName: interview.name,
                          postName: interview.jobProfile,
                          Mode: interview.interviewType,
                          interview_date: interview.interviewDate,
                          interview_time: _formatTime(interview.startTime),
                          status: statusText,
                          tColor: tColor,
                          bgColor: bgColor,
                          viewContainerText: statusText.contains("pending")
                              ? "View Details"
                              : "Join Now",
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            }

            return SizedBox();
          },
        ),
      ),
    );
  }

  List<UpcomingInterviewResponseModel> _filterByToday(List<UpcomingInterviewResponseModel> interviews) {
    final now = DateTime.now();
    return interviews.where((i) {
      final date = DateTime.parse('${i.interviewDate}T${i.startTime}');
      return date.day == now.day && date.month == now.month && date.year == now.year;
    }).toList();
  }

  List<UpcomingInterviewResponseModel> _filterByThisWeek(List<UpcomingInterviewResponseModel> interviews) {
    final now = DateTime.now();
    final startOfWeek = now;
    final endOfWeek = now.add(Duration(days: 6));
    return interviews.where((i) {
      final date = DateTime.parse('${i.interviewDate}T${i.startTime}');
      return !date.isBefore(startOfWeek) && date.isBefore(endOfWeek.add(Duration(days: 1)));
    }).toList();
  }

  List<UpcomingInterviewResponseModel> _filterInterviews(
      List<UpcomingInterviewResponseModel> interviews,
      String query,
      ) {
    if (query.isEmpty) return interviews;

    return interviews.where((i) {
      final name = i.name.toLowerCase();
      final jobProfile = i.jobProfile.toLowerCase();
      return name.contains(query.toLowerCase()) || jobProfile.contains(query.toLowerCase());
    }).toList();
  }

  String _formatTime(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return time;
    int hour = int.tryParse(parts[0]) ?? 0;
    String minute = parts[1];
    String period = hour < 12 ? 'a.m' : 'p.m';
    if (hour == 0) hour = 12;
    if (hour > 12) hour -= 12;
    return '$hour:$minute $period';
  }
}

class InterviewCard extends StatelessWidget {
  final String applicantName;
  final String postName;
  final String Mode;
  final String interview_date;
  final String interview_time;
  final String status;
  final Color bgColor;
  final Color tColor;
  final String viewContainerText;

  const InterviewCard({
    Key? key,
    required this.applicantName,
    required this.postName,
    required this.Mode,
    required this.interview_date,
    required this.interview_time,
    required this.status,
    required this.bgColor,
    required this.tColor,
    required this.viewContainerText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(applicantName, style: mTextStyle14(mFontWeight: FontWeight.w600)),
              const Spacer(),
              optionContainer(title: status, textColor: tColor, bgColor: bgColor),
              Icon(Icons.more_vert),
            ],
          ),
          const SizedBox(height: 2),
          Text(postName, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400)),
          const SizedBox(height: 2),
          Text("Mode: $Mode", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                " $interview_date  $interview_time ",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
              ),
              const Spacer(),
              SizedBox(
                width: 160,
                child: ViewAppContainer(
                  title: viewContainerText,
                  bgColor: viewContainerText == "Join Now"
                      ? AppColors.blueTextColor
                      : TColors.secondary,
                  textColor: Colors.white,
                  onTap: () {
                    // Handle action
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}