import 'dart:developer' as developer show log;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/utils/constants/constants.dart';
import 'package:job_portal/utils/constants/image_string.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';
import 'package:job_portal/views/bottom_nav_bar/student_bottom_nav_bar.dart';
import 'package:job_portal/views/job_related/presentation/bloc/job_apply_bloc/job_apply_bloc.dart';
import 'package:job_portal/views/job_related/presentation/bloc/job_apply_bloc/job_apply_event.dart';
import 'package:job_portal/views/job_related/presentation/bloc/job_apply_bloc/job_apply_state.dart';
import 'package:job_portal/views/user_authentication_and_approval_screens/presentation/view/user_auth_view.dart';
import 'package:job_portal/views/user_profile/presentation/views/User_Notifications_Screen.dart';
import 'package:job_portal/views/user_profile/presentation/views/User_messages_screen.dart';
import 'package:job_portal/views/job_related/presentation/bloc/job_details_bloc/job_details_bloc.dart';
import 'package:job_portal/views/job_related/presentation/bloc/job_details_bloc/job_details_event.dart';
import 'package:job_portal/views/job_related/presentation/bloc/job_details_bloc/job_details_state.dart';
import '../../../../ui_helper/ui_helper.dart';
import '../../../../utils/constants/urls.dart';
import '../../../../widgets/widgets.dart';

class JobDetailsScreen extends StatefulWidget {
  final VoidCallback? onCallBack;
  final VoidCallback? onShowCompanyJobs;
  final int? job_id;
  const JobDetailsScreen(
      {super.key, this.onCallBack, this.onShowCompanyJobs, this.job_id});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  String messageWhileLoadingDetails = '';
  bool areDetailsLoaded = false;
  bool hasApplied = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final map = {'job_id': widget.job_id.toString()};
    developer.log('Loading job details for job_id: ${widget.job_id}');
    context.read<JobDetailsBloc>().add(LoadJobDetail(map));
  }

  void showCustomSnackBar(BuildContext context) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.4),
                  offset: Offset(0, 5),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Red Circle Icon with white "X"
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(width: 2, color: Colors.red)),
                  padding: const EdgeInsets.all(2),
                  child: const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Aadhaar not verified. Please verify to proceed with your job application.",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          developer.log('User tapped to verify Aadhaar');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserAuthScreen()));
                        },
                        child: Text(
                          "Tap to verify now.",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            decoration: TextDecoration.underline,
                            decorationColor:
                            Theme.of(context).colorScheme.secondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-remove after 5 seconds
    Future.delayed(Duration(seconds: 15), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

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
              developer.log('User tapped Messages icon');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MessagesScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/message_icon.svg"),
            ),
          ),
          InkWell(
            onTap: () {
              developer.log('User tapped Notifications icon');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationsScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/notifications_icon.svg"),
            ),
          ),
        ],
      ),

      /// BODY CONTENT
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5.0),
          child: BlocBuilder<JobDetailsBloc, JobDetailsState>(
            builder: (context, state) {
              developer.log('JobDetailsScreen state: ${state.runtimeType}');

              if (state is JobDetailsInitial) {
                // Handle initial state - show loading
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(height: 20),
                      Text("Loading job details..."),
                    ],
                  ),
                );
              }
              else if (state is JobDetailsLoaded) {
                final data = state.jobDetailsEntity;
                developer.log('Job details loaded successfully: ${state.jobDetailsEntity}');
                developer.log('Job Profile: ${data.jobProfile}');
                developer.log('Company Name: ${data.company_name}');
                developer.log('Job Description: ${data.job_description}');
                developer.log('City Choice: ${data.cityChoice}');
                developer.log('Salary: ${data.salary}');
                developer.log('Has Applied: ${data.has_applied}');

                // Update state only if it's different to avoid unnecessary rebuilds
                if (hasApplied != data.has_applied) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      hasApplied = data.has_applied;
                      areDetailsLoaded = true;
                    });
                  });
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color(0xffEDF1F3), width: 1.0),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                height: 60,
                                width: 60,
                                child: data.logo_url != null && data.logo_url!.isNotEmpty
                                    ? Image.network(
                                  Urls.getFullImageUrl(data.logo_url!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    developer.log('❌ Failed to load logo: ${data.logo_url}');
                                    return Image.asset(
                                      ImageString.placeHolderImage,
                                      color: Colors.grey[300],
                                      fit: BoxFit.cover,
                                    );
                                  },
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                )
                                    : Image.asset(
                                  ImageString.placeHolderImage,
                                  color: Colors.grey[300],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0, left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.jobProfile ?? 'No Job Profile',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  data.company_name,
                                  style: mTextStyle14(),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    greyContainer(
                                        text: 'Actively Hiring',
                                        bgColor: TColors.secondary),
                                    SizedBox(
                                      width: 18,
                                    ),
                                    greyContainer(
                                        text: data.postedDaysAgo,
                                        bgColor: Color(0xffEFF0F6))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        jobRelatedOptions(
                            title: "INR ${data.salary}"),
                        jobRelatedOptions(
                            title: data.candidate_preferences ??
                                'Candidate Preference'),
                        jobRelatedOptions(
                          title: data.job_type == "Remote"
                              ? "Remote"
                              : (data.cityChoice != null && data.cityChoice!.isNotEmpty
                              ? data.cityChoice!.join(", ")
                              : 'City Choice'),
                        ),
                        jobRelatedOptions(title: "45 Applicants"),
                      ],
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Your Role",
                      style: mTextStyle14(mFontWeight: FontWeight.w600),
                    ),
                    Text("• ${data.job_description ?? 'No description available'}"),
                    SizedBox(
                      height: 11,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("About ${data.company_name}",
                              style:
                              mTextStyle14(mFontWeight: FontWeight.w600)),
                          const SizedBox(
                            height: 15,
                          ),
                          InkWell(
                              onTap: () {
                                if (widget.onShowCompanyJobs != null) {
                                  widget.onShowCompanyJobs!();
                                }
                              },
                              child: Text(
                                  "More Job openings at ${data.company_name}",
                                  style: mTextStyle14().copyWith(
                                    color: AppColors.blueTextColor,
                                  ))),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(data.aboutCompany ?? 'No company info available'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                );
              } else if (state is JobDetailsLoading) {
                developer.log('Job details are loading...');
                messageWhileLoadingDetails =
                'Hold tight we are loading details for you...';
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(messageWhileLoadingDetails),
                    ],
                  ),
                );
              } else if (state is JobDetailsError) {
                developer.log('Error loading job details: ${state.toString()}');
                messageWhileLoadingDetails =
                'Oops. There was some error loading details.';
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(messageWhileLoadingDetails),
                    ],
                  ),
                );
              } else {
                developer.log('Unhandled state: $state');
                return Center(
                  child: Text('Unhandled state : $state'),
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: BlocBuilder<JobDetailsBloc, JobDetailsState>(
          builder: (context, state) {
            bool currentHasApplied = hasApplied;

            if (state is JobDetailsLoaded) {
              currentHasApplied = state.jobDetailsEntity.has_applied;
            }

            return BlocListener<JobApplyBloc, JobApplyState>(
              listener: (context, applyState) {
                if (applyState is JobApplyLoading) {
                  developer.log('Job apply loading');
                } else if (applyState is JobApplyLoaded) {
                  developer.log('Job apply loaded: ${applyState.jobApplyEntity.message}');
                  showSnackbar(applyState.jobApplyEntity.message, context);

                  // Update the UI by reloading job details to get updated has_applied status
                  final map = {'job_id': widget.job_id.toString()};
                  context.read<JobDetailsBloc>().add(LoadJobDetail(map));

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Student_Bottom_Nav_bar()
                    ),
                  );
                } else if (applyState is JobApplyError) {
                  developer.log('Job apply error: ${applyState.toString()}');
                  showCustomSnackBar(context);
                }
              },
              child: currentHasApplied
                  ? ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("You have already applied for this job"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text("Already Applied"),
              )
                  : InkWell(
                onTap: () {
                  developer.log('User tapped Apply button');
                  if (state is JobDetailsLoaded) {
                    context
                        .read<JobApplyBloc>()
                        .add(LoadJobApply(widget.job_id.toString()));
                  }
                },
                child: commonRedContainer(text: "Apply"),
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget greyContainer(
    {required String text,
      required Color bgColor,
      Color? txtClr,
      bool? border}) {
  return Container(
    width: 100,
    padding: const EdgeInsets.symmetric(horizontal: 6.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(90),
        border: border != null
            ? Border.all(color: const Color.fromARGB(255, 225, 225, 225))
            : null),
    child: Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 12,
        color: txtClr ??
            (bgColor == const Color(0xffEFF0F6)
                ? const Color(0xff6C7278)
                : Colors.white),
      ),
    ),
  );
}

Widget jobRelatedOptions({required String title}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(26),
      border: Border.all(color: const Color(0xffEFF0F6), width: 1.0),
    ),
    child: Text(
      title,
      softWrap: true,
      style: const TextStyle(
        fontSize: 11,
        color: Color(0xff6C7278),
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}