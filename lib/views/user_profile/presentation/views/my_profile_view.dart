import 'dart:developer' as developer show log;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/utils/constants/image_string.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:job_portal/utils/upload_file_get_url/presentation/bloc/upload_file_bloc.dart';
import 'package:job_portal/utils/upload_file_get_url/presentation/bloc/upload_file_event.dart';
import 'package:job_portal/utils/upload_file_get_url/presentation/bloc/upload_file_state.dart';
import 'package:job_portal/views/user_authentication_and_approval_screens/presentation/view/user_auth_view.dart';
import 'package:job_portal/views/user_profile/domain/entities/user_details_entity.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_state.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/upload_resume_bloc/upload_resume_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/upload_resume_bloc/upload_resume_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/upload_resume_bloc/upload_resume_state.dart';
import 'package:job_portal/views/user_profile/presentation/views/choose_your_template_view.dart';
import 'package:job_portal/views/user_profile/presentation/views/profile_editing_views/edit_about_view.dart';
import 'package:job_portal/views/user_profile/presentation/views/profile_editing_views/edit_career_objective_view.dart';
import 'package:job_portal/views/user_profile/presentation/views/profile_editing_views/edit_language_view.dart';
import '../../../../Widgets/widgets.dart';
import '../../../../ui_helper/ui_helper.dart';
import '../../../../utils/constants/urls.dart';
import '../../../detailed_signup_student/presentation/bloc/signup_as_anyone_bloc/detailed_signup_bloc.dart';
import '../../../user_education_approval/presentation/view/user_education_approval_view.dart.dart';
import '../bloc/your_experience_bloc/your_experience_bloc.dart';
import 'profile_editing_views/user_work_experience_view.dart';
import '../../../user_skill_approval/presentation/view/user_skills_approval_view.dart';
import 'User_Notifications_Screen.dart';
import 'User_messages_screen.dart';
import 'dart:core';
import 'package:http_parser/http_parser.dart'; // for MediaType

class UserProfileScreen2 extends StatefulWidget {
  final VoidCallback? onBack;
  const UserProfileScreen2({super.key, this.onBack});

  @override
  State<UserProfileScreen2> createState() => _UserProfileScreen2State();
}

class _UserProfileScreen2State extends State<UserProfileScreen2> {
  var userProfileDetails;

  bool shouldUploadResume = true;
  String _profilePicPath = "";

  @override
  void initState() {
    super.initState();
    // sl<PreferencesManager>().setString('user_profile_pic', _profilePicPath);
    final prefs = sl<PreferencesManager>();
    _profilePicPath = prefs.getString('user_profile_pic') ?? '';
  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    final bloc = context.read<MyProfileBloc>();

    // ignore: unused_local_variable
    final _prefs = sl<PreferencesManager>();

    final user_id = _prefs.getUserId();

    bloc.add(LoadMyProfileDetails(user_id ?? '6'));
  }

  void _showEditAboutDialog(BuildContext context, String currentAbout) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2), // for dimmed effect

      builder: (context) => BlocProvider.value(
        value: context.read<MyProfileBloc>(),
        child: EditAboutDialog(about: currentAbout),
      ),
    ).then(
      (updatedAbout) {
        if (updatedAbout != null) {
          // Use updated about string
          print("Updated About: $updatedAbout");

          final bloc = context.read<MyProfileBloc>();

          // ignore: unused_local_variable
          final _prefs = sl<PreferencesManager>();

          final user_id = _prefs.getUserId();

          bloc.add(LoadMyProfileDetails(user_id ?? '6'));
        }
      },
    );
  }

  void _showEditCareerObjectiveDialog(
      BuildContext context, String career_objective) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2), // for dimmed effect

      builder: (context) => BlocProvider.value(
        value: context.read<MyProfileBloc>(),
        child: EditCareerObjectiveView(career_objective: career_objective),
      ),
    ).then(
      (updatedAbout) {
        if (updatedAbout != null) {
          // Use updated about string
          print("Updated career_objective: $career_objective");

          final bloc = context.read<MyProfileBloc>();

          // ignore: unused_local_variable
          final _prefs = sl<PreferencesManager>();

          final user_id = _prefs.getUserId();

          bloc.add(LoadMyProfileDetails(user_id ?? '6'));
        }
      },
    );
  }
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);

      try {
        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
        });

        context.read<UploadFileBloc>().add(
            LoadUploadFile(formData, uploadType: 'profile_pic'));
      } catch (e) {
        showSnackbar('Upload failed: $e', context);
      }
    }
  }

  void _showEditLanguageDialog(BuildContext context, String language) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2), // for dimmed effect

      builder: (context) => BlocProvider.value(
        value: context.read<MyProfileBloc>(),
        child: EditLanguageView(language: language),
      ),
    ).then(
      (updatedAbout) {
        if (updatedAbout != null) {
          // Use updated about string
          print("Updated language: $language");

          final bloc = context.read<MyProfileBloc>();

          // ignore: unused_local_variable
          final _prefs = sl<PreferencesManager>();

          final user_id = _prefs.getUserId();

          bloc.add(LoadMyProfileDetails(user_id ?? '6'));
        }
      },
    );
  }

  Future<void> uploadResume(PlatformFile file) async {
    // var formData = FormData();

    final fileName = file.path!.split('/').last;

    print('File name: $fileName');
    print('Extension: ${fileName.split('.').last}');

    final formData = FormData.fromMap({
      'resume': await MultipartFile.fromFile(
        file.path!, filename: fileName,
        contentType: MediaType('application', 'pdf'), // explicitly set MIME
      ),
    });
    if (shouldUploadResume) {
      context.read<UploadFileBloc>().add(
          LoadUploadFile(formData, uploadType: 'resume'));
    } else {
      shouldUploadResume = true;
    }
  }

  Future<void> updateProfileApi(Map<String, dynamic> map) async {
    final _prefs = sl<PreferencesManager>();
    final user_id = _prefs.getUserId();

    context.read<MyProfileBloc>().add(LoadUpdateProfile(user_id ?? '6', map));
  }

  List<bool> workExperienceStatus(List<UserExperienceEntity> userExperince) {
    List<bool> statusList = [];
    for (int i = 0; i < userExperince.length; i++) {
      if (userExperince[i].status == 'pending') {
        statusList.add(false);
      } else if (userExperince[i].status == 'approved') {
        statusList.add(true);
      } else {
        statusList.add(false);
      }
    }

    return statusList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// APP HEADING
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(onPressed: widget.onBack),
        actions: [
          InkWell(
            onTap: () {
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
      body: SingleChildScrollView(
        child: Column(
          children: [

            Center(
              child: Stack(
                children: [
                  Container(
                    height: 88,
                    width: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: ClipOval(
                      child: _profilePicPath.isNotEmpty
                          ? Image.network(
                        Urls.getFullImageUrl(_profilePicPath),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder();
                        },
                      )
                          : _buildPlaceholder(),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
                          ],
                        ),
                        child: Icon(Icons.edit, size: 16, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // resumeCard(null),
            BlocBuilder<MyProfileBloc, MyProfileState>(
              builder: (context, state) {
                if (state is MyProfileDetailsLoaded) {
                  developer.log('MyProfileDetailsLoaded');
                  final data = state.userDetailEntity;

                  // developer.log('user skills : ${data.skills.first.domain}');

                  return Column(
                    children: [
                      Text(
                        // "Aman Gupta",
                        "${data.first_name} ${data.last_name}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(
                          // "Aman@gmail.com",
                          "${data.email} ",
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 171, 171, 171))),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "About",
                              style:
                                  mTextStyle14(mColor: const Color(0xff544C4C)),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                                // "Hi, I am Aman working as a designer from 3 years...",
                                data.aboutUs ?? "Add about yourself...",
                                style: mTextStyle14(
                                  mColor: const Color(0xff9095A0),
                                )),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      _showEditAboutDialog(
                                          context, data.aboutUs ?? "");
                                    },
                                    child: Text("View / Edit About",
                                        style: mTextStyle14(
                                            mColor: AppColors.blueTextColor))),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Career Objective",
                              style:
                                  mTextStyle14(mColor: const Color(0xff544C4C)),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                                data.career_objective ??
                                    "Add your career objective.",
                                style: mTextStyle14(
                                  mColor: const Color(0xff9095A0),
                                )),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                // InkWell(
                                //     onTap: () {},
                                //     child: Text(
                                //       "View/",
                                //       style: mTextStyle14(
                                //           mColor: AppColors.blueTextColor),
                                //     )),
                                InkWell(
                                    onTap: () {
                                      _showEditCareerObjectiveDialog(
                                          context, data.career_objective ?? "");
                                    },
                                    child: Text("View / Edit",
                                        style: mTextStyle14(
                                            mColor: AppColors.blueTextColor))),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Resume",
                              style:
                                  mTextStyle14(mColor: const Color(0xff544C4C)),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            if (data.resume != null)
                              resumeCardForUrl(data.resume!),
                            BlocBuilder<UploadResumeBloc, UploadResumeState>(
                                builder: (context, state) {
                              if (state is PickResumeLoaded) {
                                final resume = state.file;
                                developer.log(
                                    'Resume file name : ${resume.files.first.name}');

                                uploadResume(resume.files.first);

                                return resumeCard(resume);
                              } else if (state is PickResumeNoFilePicked) {
                                return const Text('No file picked');
                              } else if (state is PickResumeLoading) {
                                developer.log('Resume file loading');
                                return const SizedBox();
                              } else if (state is PickResumeError) {
                                developer
                                    .log('Error while picking resume file.');
                                return const SizedBox();
                              } else {
                                return const SizedBox();
                              }
                            }),
                            BlocListener<UploadFileBloc, UploadFileState>(
                              listener: (context, state) {
                                if (state is UploadFileLoaded) {
                                  final resumeUrl = state.uploadFileEntity;
                                  final uploadType = state.uploadType;
                                  final url = state.uploadFileEntity.url.first;
                                  if (uploadType == 'profile_pic') {
                                  sl<PreferencesManager>().setString('user_profile_pic', url);
                                  setState(() {
                                    _profilePicPath = url;
                                  });
                                  showSnackbar('Profile picture updated', context);
                                  }
                                  else if (uploadType == 'resume') {
                                    // 👇 Handle resume
                                    showSnackbar('Resume uploaded successfully', context);
                                    context.read<UploadResumeBloc>().add(ResetUploadResume());
                                    updateProfileApi({'resume': url}); // ✅ Save to profile
                                  }

                                  context.read<UploadResumeBloc>().add(ResetUploadResume());
                                  final map = {'resume': resumeUrl.url.first};
                                  developer.log('Resume url : ${resumeUrl.url.first}');
                                  updateProfileApi(map);
                                } else if (state is UploadFileLoading) {
                                  developer.log('Upload File Loading');
                                } else if (state is UploadFileError) {
                                  developer.log('Upload File error');
                                }
                              },
                              child: SizedBox(),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                // InkWell(
                                //   onTap: () {
                                //     // context
                                //     //     .read<MyProfileBloc>()
                                //     //     .add(const PickResume());
                                //   },
                                //   child: Text(
                                //     "View /",
                                //     style: mTextStyle14(
                                //         mColor: AppColors.blueTextColor),
                                //   ),
                                // ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ChooseYourTemplateScreen(),
                                      ),
                                    );
                                    context
                                        .read<UploadResumeBloc>()
                                        .add(const PickResume());
                                  },
                                  child: Text(
                                    " Edit ",
                                    style: mTextStyle14(
                                      mColor: AppColors.blueTextColor,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    context
                                        .read<UploadResumeBloc>()
                                        .add(const PickResume());
                                  },
                                  child: Text(
                                    "/ Add",
                                    style: mTextStyle14(
                                      mColor: AppColors.blueTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            profileSection(
                              title: "Skills",
                              items: data.skills.map((s) => s.domain).toList(),
                              statusList: [
                                false,
                                false,
                                true,
                                false,
                              ],
                              onEditTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserSkillsApprovalScreen(
                                            skillList: data.skills),
                                  ),
                                ).then((value) {});
                              },
                              editText: "Add Skills",
                            ),
                            profileSection(
                              title: "Work Experience",
                              items: data.experiences
                                  .where((e) => (e.current_company ?? '').isNotEmpty)
                                  .map((e) => e.current_company ?? '')
                                  .toList(),

                              statusList:
                                  workExperienceStatus(data.experiences),
                              onEditTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider(
                                      create: (_) => sl<YourExperienceBloc>(), // Get from get_it
                                      child: UserExperienceApprovalScreen(userExperience: data.experiences),

                                    ),
                                  ),
                                ).then((value) {
                                  final bloc = context.read<MyProfileBloc>();
                                  final _prefs = sl<PreferencesManager>();
                                  final user_id = _prefs.getUserId();
                                  bloc.add(LoadMyProfileDetails(user_id ?? '6'));
                                });
                              },
                              editText: "Add Work Experience",
                            ),
                            profileSection(
                              title: "Education",
                              items: data.educations
                                  .where((e) => e.level.isNotEmpty)
                                  .map((e) => e.level)
                                  .toList(),
                              statusList: [
                                false,
                                false,
                                true,
                              ],
                              onEditTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => BlocProvider.value(
                                //       value: context.read<DetailedSignupBloc>(),
                                //       child: UserEducationApprovalScreen(
                                //         eduList: data.educations,
                                //       ),
                                //     ),
                                //   ),
                                // );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider.value(
                                      value: context.read<DetailedSignupBloc>(),
                                      child: UserEducationApprovalScreen(
                                        eduList: data.educations,
                                      ),
                                    ),
                                  ),
                                ).then((value) async {
                                  if (value == true) { // return true if education updated
                                    final bloc = context.read<MyProfileBloc>();
                                    final _prefs = sl<PreferencesManager>();
                                    final user_id = _prefs.getUserId();

                                    // Small delay to make sure backend update is complete
                                    await Future.delayed(Duration(milliseconds: 300));

                                    bloc.add(LoadMyProfileDetails(user_id ?? '6'));
                                  }
                                });


                              },

                              editText: "Add Education",
                            ),
                            profileSection(
                              title: "Languages you know",
                              items: data.language?.split(',').toList() ??
                                  ['Language'],
                              statusList: List<bool>.generate(
                                  data.language?.split(',').length ?? 0,
                                  (int index) => true,
                                  growable: true),
                              onEditTap: () {
                                _showEditLanguageDialog(
                                    context, data.language ?? "");
                              },
                              editText: "Add Language",
                            ),
                            profileSection(
                              title: "Authentication",
                              items: ["Email", "Phone No.", "Aadhar"],
                              statusList: [
                                data.is_email_verified ?? true,
                                data.is_phone_verified ?? true,
                                data.isAadhaarVerified ?? true,
                              ],
                              onEditTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserAuthScreen(
                                            phoneNumber: data.phone)));
                              },
                              editText: "Get Verified",
                              isGetVerified:
                                  true, // Only show "Get Verified" without "Edit/"
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 130,
                      )
                    ],
                  );
                } else if (state is MyProfileDetailsLoading) {
                  developer.log('MyProfileDetailsLoading');
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 150,
                          ),
                          CircularProgressIndicator(),
                          // Text('MyProfileDetailsLoading')
                        ],
                      ),
                    ),
                  );
                } else if (state is MyProfileDetailsError) {
                  developer.log('MyProfileDetailsError');
                  return const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        Text('MyProfileDetailsError')
                      ],
                    ),
                  );
                } else if (state is UpdateProfileLoaded) {
                  final bloc = context.read<MyProfileBloc>();

                  // ignore: unused_local_variable
                  final _prefs = sl<PreferencesManager>();

                  final user_id = _prefs.getUserId();
                  shouldUploadResume = false;

                  bloc.add(LoadMyProfileDetails(user_id ?? '6'));
                  return SizedBox();
                } else {
                  return Center(
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        Text('Unhandeled State : $state')
                      ],
                    ),
                  );
                }
              },
              // child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget for common Column
Widget profileSection({
  required String title,
  required List<String> items,
  required VoidCallback onEditTap,
  required String editText,
  bool isGetVerified = false,
  List<bool>? statusList, // nullable list of booleans
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 15),
      Text(title, style: mTextStyle14(mColor: const Color(0xff544C4C))),
      const SizedBox(height: 3),
      Wrap(
        spacing: 11,
        runSpacing: 8,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final status = statusList != null && index < statusList.length
              ? statusList[index]
              : null;

          Color dotColor;
          if (status == true) {
            dotColor = Colors.green;
          } else if (status == false) {
            dotColor = Colors.red;
          } else {
            dotColor = Colors.grey; // default/fallback color
          }

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, color: dotColor, size: 6),
              const SizedBox(width: 3),
              Text(item, style: mTextStyle14(mColor: const Color(0xff9095A0))),
            ],
          );
        }),
      ),
      const SizedBox(height: 3),
      Row(
        children: [
          InkWell(
            onTap: onEditTap,
            child: Text(
              // isGetVerified ? editText : "Edit/",
              isGetVerified ? editText : "",
              style: mTextStyle14(mColor: AppColors.blueTextColor),
            ),
          ),
          if (!isGetVerified)
            InkWell(
              onTap: onEditTap,
              child: Text(
                editText,
                style: mTextStyle14(
                    mColor: AppColors.blueTextColor,
                    mFontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    ],
  );
}

Widget resumeCard(FilePickerResult file) {
  return Container(
    decoration: BoxDecoration(
        border:
            Border.all(color: const Color.fromRGBO(84, 76, 76, 1), width: 0.4),
        borderRadius: BorderRadius.circular(6)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 12, 0),
            child: SvgPicture.asset(ImageString.pdfSvg),
          ),
          Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                file.files.first.name,
                style: const TextStyle(color: Color.fromRGBO(84, 76, 76, 1)),
              ),
              Text(
                formatBytesSimple(file.files.first.size),
                style: const TextStyle(color: Color.fromRGBO(84, 76, 76, 0.75)),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget resumeCardForUrl(String name) {
  final formattedName = name.split('_').last;
  return Container(
    decoration: BoxDecoration(
        border:
            Border.all(color: const Color.fromRGBO(84, 76, 76, 1), width: 0.4),
        borderRadius: BorderRadius.circular(6)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 12, 0),
            child: SvgPicture.asset(ImageString.pdfSvg),
          ),
          Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedName,
                style: const TextStyle(color: Color.fromRGBO(84, 76, 76, 1)),
              ),
              Text(
                '12.12 KB',
                style: const TextStyle(color: Color.fromRGBO(84, 76, 76, 0.75)),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

String formatBytesSimple(int bytes) {
  if (bytes < 1024) {
    return '$bytes B';
  } else if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(2)} KB';
  } else {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}
Widget _buildPlaceholder() {
  return Container(
    color: Colors.grey.shade200,
    child: Icon(Icons.person, size: 40, color: Colors.grey.shade600),
  );
}
