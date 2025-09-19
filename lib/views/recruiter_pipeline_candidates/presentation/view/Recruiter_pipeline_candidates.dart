import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/ui_helper/ui_helper.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';
import 'package:job_portal/views/recruiter_job_post/presentation/view/Recruiter_total_job_posts.dart';


import '../../../../widgets/widgets.dart';
import '../../data/models/recruiter_pipeline_candidates_response_model.dart';
import '../bloc/recruiter_pipeline_candidates_bloc.dart';
import '../bloc/recruiter_pipeline_candidates_event.dart';
import '../bloc/recruiter_pipeline_candidates_state.dart';

class RecruiterPipelineCandidates extends StatefulWidget {
  const RecruiterPipelineCandidates({Key? key}) : super(key: key);

  @override
  State<RecruiterPipelineCandidates> createState() => _RecruiterPipelineCandidatesState();
}

class _RecruiterPipelineCandidatesState extends State<RecruiterPipelineCandidates> {
  final TextEditingController fdController = TextEditingController();
  String? selectedStatus; // Tracks currently selected filter

  @override
  void initState() {
    super.initState();
    context.read<RecruiterPipelineCandidatesBloc>().add(FetchPipelineCandidates());
  }

  void _onFilterTap(String? status) {
    setState(() {
      selectedStatus = selectedStatus == status ? null : status; // Toggle off if same
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RecruiterPipelineCandidatesBloc>()..add(FetchPipelineCandidates()),
      child: Scaffold(
        appBar: buildCustomAppBar(titleText: "LOGO"),
        body: BlocBuilder<RecruiterPipelineCandidatesBloc, RecruiterPipelineCandidatesState>(
          builder: (context, state) {
            if (state is RecruiterPipelineCandidatesLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is RecruiterPipelineCandidatesFailed) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error: ${state.error}"),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<RecruiterPipelineCandidatesBloc>().add(FetchPipelineCandidates());
                      },
                      child: Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            if (state is RecruiterPipelineCandidatesSuccess) {
              final candidates = state.data.pipeline;

              // Filter candidates based on selected status
              final filteredCandidates = selectedStatus == null
                  ? candidates
                  : candidates.where((c) => c.status == selectedStatus).toList();

              // Count by status (for badges)
              final appliedCount = candidates.where((c) => c.status == "Applied").length;
              final screeningCount = candidates.where((c) => c.status == "Screening").length;
              final interviewCount = candidates.where((c) => c.status == "Interview").length;
              final offeredCount = candidates.where((c) => c.status == "Offered").length;
              final hiredCount = candidates.where((c) => c.status == "Hired").length;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 24.0, top: 7.0, left: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pipeline Candidates", style: mTextStyle32(mColor: Colors.black)),
                      SizedBox(height: 25),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: fdController,
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
                        children: [
                          InkWell(
                            onTap: () => _onFilterTap("Applied"),
                            child: optionContainer(
                              title: "Applied",
                              nApplications: "($appliedCount)",
                              textColor: selectedStatus == "Applied" ? Colors.white : Color(0xff6C7278),
                              bgColor: selectedStatus == "Applied" ? Colors.blue : Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () => _onFilterTap("Screening"),
                            child: optionContainer(
                              title: "Screening",
                              nApplications: "($screeningCount)",
                              textColor: selectedStatus == "Screening" ? Colors.white : Color(0xff6C7278),
                              bgColor: selectedStatus == "Screening" ? Colors.blue : Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () => _onFilterTap("Interview"),
                            child: optionContainer(
                              title: "Interview",
                              nApplications: "($interviewCount)",
                              textColor: selectedStatus == "Interview" ? Colors.white : Color(0xff6C7278),
                              bgColor: selectedStatus == "Interview" ? Colors.blue : Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () => _onFilterTap("Offered"),
                            child: optionContainer(
                              title: "Offered",
                              nApplications: "($offeredCount)",
                              textColor: selectedStatus == "Offered" ? Colors.white : Color(0xff6C7278),
                              bgColor: selectedStatus == "Offered" ? Colors.blue : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: InkWell(
                          onTap: () => _onFilterTap("Hired"),
                          child: optionContainer(
                            title: "Hired",
                            nApplications: "($hiredCount)",
                            textColor: selectedStatus == "Hired" ? Colors.white : AppColors.blueTextColor,
                            bgColor: selectedStatus == "Hired" ? Colors.green : Colors.blue.shade100,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (filteredCandidates.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "No candidates match the selected filter.",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        ...filteredCandidates.map((candidate) {
                          final statusText = candidate.status;
                          final tColor = statusText == "Hired" ? Color(0xff00BC5E) : Color(0xffFFA30F);
                          final bgColor = statusText == "Hired" ? Color(0xffE0F8EB) : Color(0xffFFF6E4);

                          return AppReceivedCard(
                            applicantName: '${candidate.user.firstName} ${candidate.user.lastName}',
                            postName: candidate.job.jobRole.title,
                            total_exp: candidate.user.totalExperience == "0" ? "Fresher" : "${candidate.user.totalExperience} years",
                            appliedDate: "3", // Replace with real logic later
                            status: statusText,
                            tColor: tColor,
                            bgColor: bgColor,
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
}


