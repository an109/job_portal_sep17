import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/injection_container.dart'; // for sl
// import 'package:job_portal/views/signup_recruiter/presentation/views/Recruiter_Applications_Screen.dart';
import 'package:job_portal/widgets/widgets.dart';

import '../../../../ui_helper/ui_helper.dart';
import '../../../recruiter_application/presentation/view/Recruiter_Applications_Screen.dart';
import '../bloc/recruiter_full_view_application_bloc.dart';
import '../bloc/recruiter_full_view_application_event.dart';
import '../bloc/recruiter_full_view_application_state.dart';
import '../../domain/entities/recruiter_full_view_application_entity.dart';

class Recruiter_View_Full_Application_screen extends StatelessWidget {
  final int jobId;
  final int applicantId;
  final String applicantName;
  final String appliedDate;

  const Recruiter_View_Full_Application_screen({
    super.key,
    required this.jobId,
    required this.applicantId,
    required this.applicantName,
    required this.appliedDate,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RecruiterFullViewApplicationBloc>()
        ..add(FetchRecruiterFullViewApplications(jobId, applicantId)),
      child: Scaffold(
        appBar: buildCustomAppBar(titleText: "Logo"),
        body: BlocBuilder<RecruiterFullViewApplicationBloc, RecruiterFullViewApplicationState>(
          builder: (context, state) {
            if (state is RecruiterFullViewApplicationLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is RecruiterFullViewApplicationSuccess) {
              final applicant = state.applicant;
              final details = applicant.applicationDetails;

              return _buildSuccessUI(
                context: context,
                applicantName: applicantName,
                appliedDate: appliedDate,
                location: "New Delhi", // TODO: get from API if available
                totalWorkExperience: "Fresher",
                skills: details.project.isNotEmpty ? details.project : "Not specified",
                languages: "Hindi, English", // TODO: get from API if available
                availability: details.confirmAvailability,
                whyShouldWeHireYou: details.whyShouldWeHireYou,
                project: details.project,
                githubLink: details.githubLink,
                portfolioLink: details.portfolioLink,
                additionalDetails: details.additionalDetails,
              );
            }

            if (state is RecruiterFullViewApplicationFailed) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error: ${state.message}"),
                    ElevatedButton(
                      onPressed: () {
                        context.read<RecruiterFullViewApplicationBloc>().add(
                          FetchRecruiterFullViewApplications(jobId, applicantId),
                        );
                      },
                      child: Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            // Fallback
            return Center(child: Text("Unknown state"));
          },
        ),
      ),
    );
  }

  Widget _buildSuccessUI({
    required BuildContext context,
    required String applicantName,
    required String appliedDate,
    required String location,
    required String totalWorkExperience,
    required String skills,
    required String languages,
    required String availability,
    required String whyShouldWeHireYou,
    required String project,
    required String githubLink,
    required String portfolioLink,
    required String additionalDetails,
  }) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(right: 24.0, top: 7.0, left: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Applications",
              style: mTextStyle32(mColor: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              "Graphic Design internship",
              style: mTextStyle14(mColor: Color(0xff6C7278)),
            ),
            SizedBox(height: 25),

            /// Applicant intro container
            introContainer(
              Name: applicantName,
              status: "Moderate",
              bgColor: Color(0xffFFF6E4),
              tColor: Color(0xffFFAD29),
              location: location,
              TWX: totalWorkExperience,
              appliedDate: appliedDate,
              Skills: skills,
              languages: languages,
            ),
            SizedBox(height: 12),

            /// Screening Questions Container
            ScreeningQuestionsContainer(
              Availability: availability,
              WhyShouldWeHireYou: whyShouldWeHireYou,
            ),
            SizedBox(height: 10),

            ApplicantResumeContainer(
              project: project,
              githubLink: githubLink,
              portfolioLink: portfolioLink,
              additionalDetails: additionalDetails,
            ),
            SizedBox(height: 20),

            /// Action Buttons
            Row(
              children: [
                Icon(Icons.more_horiz),
                Spacer(),
                _buildActionButton(
                  text: "Hire",
                  bgColor: Color(0xffC0F0D8),
                  borderColor: Color(0xff1DB32F),
                  textColor: Color(0xff1DB32F),
                ),
                SizedBox(width: 10),
                _buildActionButton(
                  text: "Not Interested",
                  bgColor: Color(0xffFFD7CA),
                  borderColor: Color(0xffF03729),
                  textColor: Color(0xffF03729),
                ),
                SizedBox(width: 10),
                _buildActionButton(
                  text: "Shortlisted",
                  bgColor: Color(0xffD2DFFA),
                  borderColor: Color(0xff1D61E7),
                  textColor: Color(0xff1D61E7),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      height: 30,
      width: text == "Shortlisted" ? 80 : null,
      padding: text == "Shortlisted" ? null : EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: borderColor, width: 1.0),
        color: bgColor,
      ),
      child: Center(
        child: Text(
          text,
          style: mTextStyle12(mColor: textColor),
        ),
      ),
    );
  }
}



/// APPLICANT INTRO CONTAINER
Widget introContainer(
    {required String Name,
      required String status,
      required Color bgColor,
      required Color tColor,
      required String location,
      required String TWX,
      required String appliedDate,
      required String Skills,
      required String languages}) {
  return Container(
    height: 125,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(width: 1, color: Colors.grey.shade300),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                Name,
                style: mTextStyle15(
                    mColor: Colors.black, mFontWeight: FontWeight.w600),
              ),
              Spacer(),
              colorContainer(
                  resumeMatch: status, bgColor: bgColor, tColor: tColor)
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            location,
            style: TextStyle(fontSize: 10),
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Text("Total work experience:$TWX ",
                  style: TextStyle(fontSize: 10)),
              Spacer(),
              Text("Applied on:$appliedDate ", style: TextStyle(fontSize: 10))
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "skills: $Skills ",
            style: mTextStyle12(
                mColor: Color(0xff544C4C), mFontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "Languages: $languages",
            style: mTextStyle12(
                mColor: Color(0xff544C4C), mFontWeight: FontWeight.w400),
          ),
        ],
      ),
    ),
  );
}

/// Screening Questions Container

Widget ScreeningQuestionsContainer({
  required String Availability,
  required String WhyShouldWeHireYou,
}) {
  return Container(
    height: 150,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(width: 1, color: Colors.grey.shade300),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Screening Questions",
              style: mTextStyle15(
                  mColor: Colors.black, mFontWeight: FontWeight.w600)),
          SizedBox(height: 6),
          _buildQuestion("Availability", Availability),
          SizedBox(height: 6),
          _buildQuestion("Why should we hire you?", WhyShouldWeHireYou),
        ],
      ),
    ),
  );
}

Widget _buildQuestion(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: mTextStyle12(
              mColor: Color(0xff544C4C), mFontWeight: FontWeight.w400)),
      SizedBox(height: 2),
      Text(value,
          style: mTextStyle12(
              mColor: Color(0xff544C4C), mFontWeight: FontWeight.w400)),
      SizedBox(height: 6),
    ],
  );
}


/// Resume Container
Widget ApplicantResumeContainer({
  required String project,
  required String githubLink,
  required String portfolioLink,
  required String additionalDetails,
}) {
  return Container(
    height: 550,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(width: 1, color: Colors.grey.shade300),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Resume",
              style: mTextStyle15(
                  mColor: Colors.black, mFontWeight: FontWeight.w600)),
          SizedBox(height: 6),
          Text("Education",
              style: mTextStyle12(
                  mColor: AppColors.blueTextColor,
                  mFontWeight: FontWeight.w400)),
          SizedBox(height: 20),
          Text("Internships",
              style: mTextStyle12(
                  mColor: AppColors.blueTextColor,
                  mFontWeight: FontWeight.w400)),
          SizedBox(height: 20),
          Text("Projects",
              style: mTextStyle12(
                  mColor: AppColors.blueTextColor,
                  mFontWeight: FontWeight.w400)),
          Text(project),
          SizedBox(height: 20),
          Text("Additional Details",
              style: mTextStyle12(
                  mColor: AppColors.blueTextColor,
                  mFontWeight: FontWeight.w400)),
          Text(additionalDetails),
          SizedBox(height: 20),
          Text("GitHub: $githubLink"),
          Text("Portfolio: $portfolioLink"),
          SizedBox(height: 20),
          Text("Uploaded Resume",
              style: mTextStyle12(
                  mColor: AppColors.blueTextColor,
                  mFontWeight: FontWeight.w400)),
          SizedBox(height: 20),
          Text("Contacts",
              style: mTextStyle12(
                  mColor: AppColors.blueTextColor,
                  mFontWeight: FontWeight.w400)),
        ],
      ),
    ),
  );
}
