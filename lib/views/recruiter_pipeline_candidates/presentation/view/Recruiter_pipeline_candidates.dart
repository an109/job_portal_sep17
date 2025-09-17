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

  @override
  void initState() {
    super.initState();
    context.read<RecruiterPipelineCandidatesBloc>().add(FetchPipelineCandidates());
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

              // Count by status
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
                          optionContainer(
                            title: "Applied",
                            nApplications: "($appliedCount)",
                            textColor: Color(0xff6C7278),
                            bgColor: Colors.white,
                          ),
                          optionContainer(
                            title: "Screening",
                            nApplications: "($screeningCount)",
                            textColor: Color(0xff6C7278),
                            bgColor: Colors.white,
                          ),
                          optionContainer(
                            title: "Interview",
                            nApplications: "($interviewCount)",
                            textColor: Color(0xff6C7278),
                            bgColor: Colors.white,
                          ),
                          optionContainer(
                            title: "Offered",
                            nApplications: "($offeredCount)",
                            textColor: Color(0xff6C7278),
                            bgColor: Colors.white,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: optionContainer(
                          title: "Hired",
                          nApplications: "($hiredCount)",
                          textColor: AppColors.blueTextColor,
                          bgColor: Colors.blue.shade100,
                        ),
                      ),
                      SizedBox(height: 20),
                      ...candidates.map((candidate) {
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

/// Pipeline Candidates Container

// class AppReceivedCard extends StatelessWidget {
//   String applicantName;
//   String postName;
//   String total_exp;
//   String appliedDate;
//   String status;
//   Color bgColor;
//   Color tColor;
//
//   AppReceivedCard({
//     required this.applicantName,
//     required this.postName,
//     required this.total_exp,
//     required this.appliedDate,
//     required this.status,
//     required this.bgColor,
//     required this.tColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade300, width: 1.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(applicantName, style: mTextStyle14(mFontWeight: FontWeight.w600)),
//               Spacer(),
//               optionContainer(title: status, textColor: tColor, bgColor: bgColor),
//               Icon(Icons.more_vert),
//             ],
//           ),
//           SizedBox(height: 4),
//           Text(postName, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
//           SizedBox(height: 2),
//           Text("Total Work Experience: $total_exp", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400)),
//           Row(
//             children: [
//               Text("Applied $appliedDate days ago", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400)),
//               Spacer(),
//               SizedBox(
//                 width: 160,
//                 child: ViewAppContainer(
//                   bgColor: TColors.secondary,
//                   textColor: Colors.white,
//                   title: "View Full Application",
//                   onTap: () {},
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }