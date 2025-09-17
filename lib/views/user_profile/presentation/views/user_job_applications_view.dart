import 'dart:developer' as developer show log;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/ui_helper/ui_helper.dart';
import 'package:job_portal/views/job_related/presentation/views/job_details_view.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/job_applications_bloc/job_application_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/job_applications_bloc/job_applications_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/job_applications_bloc/job_applications_state.dart';

import '../../../../utils/constants/urls.dart';

class StudentJobApplications extends StatefulWidget {
  const StudentJobApplications({super.key});

  @override
  State<StudentJobApplications> createState() => _StudentJobApplicationsState();
}

class _StudentJobApplicationsState extends State<StudentJobApplications> {
  int _selectedTab = 0; // 0: All, 1: Applied/Ongoing, 2: Skills Missing, 3: Hired, 4: Rejected
  final List<String> _tabTitles = [
    "All",
    "Applied/Ongoing",
    "Skills Missing",
    "Hired",
    "Rejected"
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    developer.log("🔄 [StudentJobApplications] didChangeDependencies called");

    final bloc = context.read<JobApplicationBloc>();
    developer.log("📤 [StudentJobApplications] Dispatching LoadAllApplications event");

    bloc.add(const LoadAllApplications());
  }

  // Filter applications based on selected tab
  List<dynamic> _filterApplications(List<dynamic> applications) {
    switch (_selectedTab) {
      case 0: // All
        return applications;
      case 1: // Applied/Ongoing
        return applications.where((app) =>
        app.status == "Application Sent" || app.status == "Applied" || app.status == "Ongoing").toList();
      case 2: // Skills Missing
        return applications.where((app) =>
        app.status == "Skills Missing").toList();
      case 3: // Hired
        return applications.where((app) =>
        app.status == "Hired").toList();
      case 4: // Rejected
        return applications.where((app) =>
        app.status == "Rejected").toList();
      default:
        return applications;
    }
  }

  @override
  Widget build(BuildContext context) {
    developer.log(" [StudentJobApplications] Building UI");

    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              developer.log(" [AppBar] Message icon tapped");
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/message_icon.svg"),
            ),
          ),
          InkWell(
            onTap: () {
              developer.log(" [AppBar] Notifications icon tapped");
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/notifications_icon.svg"),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Text(
              "My Applications",
              style: mTextStyle32(mColor: Colors.black),
            ),
          ),

          // Tab Filter Row
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _tabTitles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: FilterChip(
                    label: Text(_tabTitles[index]),
                    selected: _selectedTab == index,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedTab = selected ? index : 0;
                      });
                    },
                    selectedColor: Color(0xffE0F8EB),
                    labelStyle: TextStyle(
                      color: _selectedTab == index ? Color(0xff22C55E) : Color(0xff6C7278),
                      fontWeight: FontWeight.w500,
                    ),
                    backgroundColor: Colors.white,
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: _selectedTab == index ? Color(0xff22C55E) : Color(0xffD1D5DB),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 16),

          BlocBuilder<JobApplicationBloc, JobApplicationsState>(
            builder: (context, state) {
              developer.log(" [BlocBuilder] Current state: $state");

              if (state is JobApplicationsLoaded) {
                final data = state.applications;
                developer.log(" [BlocBuilder] Loaded ${data.applications.length} applications");

                // Filter applications based on selected tab
                final filteredApplications = _filterApplications(data.applications);
                developer.log(" [TabFilter] Showing ${filteredApplications.length} applications for tab ${_tabTitles[_selectedTab]}");

                if (filteredApplications.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Text(
                        "No ${_tabTitles[_selectedTab].toLowerCase()} applications",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: filteredApplications.length,
                    itemBuilder: (context, index) {
                      final item = filteredApplications[index];
                      developer.log(
                          " [ListView] Rendering application ${index + 1}/${filteredApplications.length} "
                              "Company: ${item.company_name}, Status: ${item.status}, "
                              "Applicants: ${item.applicantCount}, Date: ${item.applied_date}");

                      return Column(
                        children: [
                          AppStatusCard(
                            comName: item.company_name,
                            nApplicants: item.applicantCount.toString(),
                            mDate: item.applied_date,
                            statusText: item.status,
                            companyLogo: item.company_logo,
                            jobId: item.job_post_id.toString(),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => JobDetailsScreen(job_id: item.job_post_id),
                                  ),
                              );
                            },
                          ),
                          SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                );
              } else if (state is JobApplicationsLoading) {
                developer.log(" [BlocBuilder] State = JobApplicationsLoading");
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is JobApplicationsError) {
                developer.log(">>>>>>>>>>>>>>> [BlocBuilder] State = JobApplicationsError");
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                developer.log("⚠️ [BlocBuilder] State = Unknown $state");
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

/// Widget for Application status cards (keep your existing AppStatusCard implementation)
class AppStatusCard extends StatelessWidget {
  final String comName, nApplicants, mDate, statusText;
  final String? companyLogo;
  final String jobId;
  final VoidCallback? onTap;

  AppStatusCard({
    required this.comName,
    required this.nApplicants,
    required this.mDate,
    required this.statusText,
    required this.jobId,
    this.companyLogo,
    this.onTap,
  });

  Color getStatusColor() {
    switch (statusText) {
      case "Hired":
        return Color(0xff22C55E); // Green
      case "Application Sent":
        return Color(0xffF59E0B); // Amber
      case "Skills Missing":
        return Color(0xffEF4444); // Red
      default:
        return Color(0xff6B7280); // Gray
    }
  }

  Color getStatusBackgroundColor() {
    switch (statusText) {
      case "Hired":
        return Color(0xffDCFCE7); // Light green
      case "Application Sent":
        return Color(0xffFEF3C7); // Light amber
      case "Skills Missing":
        return Color(0xffFEE2E2); // Light red
      default:
        return Color(0xffF3F4F6); // Light gray
    }
  }

  IconData getStatusIcon() {
    switch (statusText) {
      case "Hired":
        return Icons.check_circle;
      case "Application Sent":
        return Icons.send;
      case "Skills Missing":
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor();
    final statusBgColor = getStatusBackgroundColor();
    final statusIcon = getStatusIcon();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: onTap ?? () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => JobDetailsScreen(job_id: int.tryParse(jobId) ?? 0,
                  )));
        },

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Company Logo
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade100, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          Urls.getFullImageUrl(companyLogo),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.business, color: Colors.grey.shade400);
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 12),

                    // Company Name and Applicants
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                        ],
                      ),
                    ),

                    // Status Badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            statusIcon,
                            size: 14,
                            color: statusColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Divider
                Divider(height: 1, color: Colors.grey.shade200),

                SizedBox(height: 12),

                // Applied Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "$nApplicants applicants",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(width: 18),
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500),
                    SizedBox(width: 6),
                    Text(
                      "Applied on $mDate",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}