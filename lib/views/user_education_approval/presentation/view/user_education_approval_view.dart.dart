import 'dart:developer' as developer show log;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/views/signup_as_anyone_view.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/signup_as_anyone_bloc/detailed_signup_bloc.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/signup_as_anyone_bloc/detailed_signup_event.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/signup_as_anyone_bloc/detailed_signup_state.dart';
import 'package:job_portal/views/detailed_signup_student/domain/entities/metadata_entities.dart';
import 'package:job_portal/views/user_education_approval/presentation/bloc/user_education_approval_bloc.dart';
import 'package:job_portal/views/user_education_approval/presentation/bloc/user_education_approval_event.dart';
import 'package:job_portal/views/user_education_approval/presentation/bloc/user_education_approval_state.dart';
import 'package:job_portal/views/user_education_approval/data/models/user_education_request_model.dart';
import 'package:job_portal/views/user_profile/domain/entities/user_details_entity.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_state.dart';
import '../../../../../ui_helper/ui_helper.dart';
import '../../../../../widgets/widgets.dart';

class UserEducationApprovalScreen extends StatefulWidget {
  final List<UserEducationEntity> eduList;
  const UserEducationApprovalScreen({super.key, required this.eduList});

  @override
  State<UserEducationApprovalScreen> createState() =>
      _UserEducationApprovalScreenState();
}

class _UserEducationApprovalScreenState
    extends State<UserEducationApprovalScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController searchCourseController = TextEditingController();
  List<String> addedEducationLevels = [];
  List<EducationCardData> educationControllers = [];
  List<SpecializationEntity> specializations = [];

  void prefillEducationData(List<UserEducationEntity> eduList) {
    developer.log("Prefilling education data with ${eduList.length} items");
    setState(() {
      addedEducationLevels.clear();
      educationControllers.clear();

      for (final edu in eduList) {
        developer.log("Adding education entry: level=${edu.level}, college=${edu.schoolCollege?.name ?? "College"}");

        addedEducationLevels.add(edu.level);

        educationControllers.add(
          EducationCardData(
            level: edu.level,
            selectedSchoolCollegeId: edu.school_college_id,
            selectedCourseId: edu.course_id,
            selectedSpecializationId: edu.specialization_id,
            education_certificate: edu.education_certificate,
            schoolOrCollegeController: TextEditingController(
              text: edu.schoolCollege?.name ?? "",
            ),
            boardOrUniversityController: TextEditingController(
              text: edu.board_or_university,
            ),
            specializationController: TextEditingController(
              text: edu.specialization?.name ?? "",
            ),
            startYearController: TextEditingController(
              text: edu.start_year,
            ),
            endYearController: TextEditingController(
              text: edu.end_year,
            ),
            percentageOrCgpaController: TextEditingController(
              text: edu.percentage_or_cgpa,
            ),
          ),
        );
      }
    });
  }

  List<Map<String, dynamic>> createEducationMap() {
    return educationControllers.map((edu) {
      return {
        "level": edu.level,
        "school_college_id": edu.selectedSchoolCollegeId ?? 0,
        "board_or_university": edu.boardOrUniversityController.text.trim(),
        "course_id": edu.selectedCourseId ?? 0,
        "specialization_id": edu.selectedSpecializationId ?? 0, // <- fix here
        "start_year": edu.startYearController.text.trim(),
        "end_year": edu.endYearController.text.trim(),
        "percentage_or_cgpa": edu.percentageOrCgpaController.text.trim(),
        "education_certificate": edu.education_certificate ?? "dummy.pdf",
        'schoolOrCollege': edu.schoolOrCollegeController.text.trim(),
      };
    }).toList();
  }


  @override
  void initState() {
    super.initState();
    developer.log("initState called");
    prefillEducationData(widget.eduList);
    Future.microtask(() {
      context.read<DetailedSignupBloc>().add(
        DetailedSignupGetCollegeDetails({}),
      );
    });
  }

  void addEducationEntry(String level, {int? course_id}) {
    developer.log("Adding new education entry: $level with course_id=$course_id");
    setState(() {
      addedEducationLevels.add(level);
      educationControllers.add(EducationCardData(
        level: level,
        selectedCourseId: course_id,
        schoolOrCollegeController: TextEditingController(),
        boardOrUniversityController: TextEditingController(),
        startYearController: TextEditingController(),
        endYearController: TextEditingController(),
        percentageOrCgpaController: TextEditingController(),
        specializationController: TextEditingController(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    developer.log("Building UserEducationApprovalScreen");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: () {
              developer.log("Message icon tapped");
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/message_icon.svg"),
            ),
          ),
          InkWell(
            onTap: () {
              developer.log("Notification icon tapped");
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/notifications_icon.svg"),
            ),
          ),
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => sl<UserEducationApprovalBloc>(),
          ),
        ],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Education",
                    style: mTextStyle32(mColor: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<DetailedSignupBloc, DetailedSignupState>(
                    builder: (context, state) {
                      if (state is DetailedSignupGetCollegeDetailsLoading) {
                        developer.log("College details loading");
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is DetailedSignupGetCollegeDetailsLoaded) {
                        developer.log("College details loaded, courses count=${state.coursesListResponse.courses.length}");
                        final courses = state.coursesListResponse.courses;
                        return CustomAutocompleteGeneric<CourseEntity>(
                          options: courses,
                          label:
                          'Select your education level (e.g. 10th, 12th, B.Tech)',
                          onSelected: (course) {
                            developer.log("Course selected: ${course.name}, id=${course.id}");
                            searchCourseController.text = course.name;
                            if (!addedEducationLevels.contains(course.name)) {
                              addEducationEntry(course.name,
                                  course_id: course.id);
                            }
                            context.read<DetailedSignupBloc>().add(
                              DetailedSignupGetSpecializations(course.id.toString()),
                            );
                            // context.read<DetailedSignupBloc>().add(
                            //   DetailedSignupGetSpecializations(
                            //       course.id.toString()),
                            // );
                            developer.log('get DetailedSignupGetSpecializations');
                          },
                          displayStringForOption: (course) => course.name,
                        );
                      }
                      developer.log("College details fallback - showing text field");
                      return CustomTextField(
                        controller: searchCourseController,
                        hintText:
                        'Select your education level (e.g. 10th, 12th, B.Tech)',
                        suffixIcon: Icons.search,
                        fillColor: Colors.white,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 24),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: educationControllers.length,
                    itemBuilder: (context, index) {
                      final edu = educationControllers[index];
                      developer.log(
                          "Rendering EducationFillingCard for ${edu.level}, index=$index");

                      return EducationFillingCard(
                        courseNameText: edu.level,
                        collegeNameController: edu.schoolOrCollegeController,
                        specializationController: edu.specializationController,
                        startYearController: edu.startYearController,
                        endYearController: edu.endYearController,
                        specializations: specializations,
                        onSelectCollegeId: (id) {
                          developer.log(
                              "College selected for ${edu.level}, collegeId=$id");
                          edu.selectedSchoolCollegeId = id;
                        },
                        onSelectSpecializationId: (id) {
                          developer.log(
                              "Specialization selected for ${edu.level}, specializationId=$id");
                          edu.selectedSpecializationId = id;
                        },
                        onTapCross: () {
                          developer.log("Removing education entry: ${edu.level}");
                          setState(() {
                            addedEducationLevels.remove(edu.level);
                            educationControllers.removeAt(index);
                          });
                        },
                        education_certificate: edu.education_certificate,
                        index: index,
                        onFileSelected: (file) {
                          setState(() {
                            edu.certificateFile = file;
                            edu.education_certificate = file?.name;
                          });
                        },
                      );
                    },
                  ),
                  BlocListener<UserEducationApprovalBloc,
                      UserEducationApprovalState>(
                    listener: (context, state) {
                      if (state is UserEducationApprovalUpdated) {
                        developer.log("UserEducationApprovalUpdated received");
                        showSnackbar("Education updated successfully", context);
                        Navigator.pop(context, true);
                      } else if (state is UserEducationApprovalError) {
                        developer.log(
                            "UserEducationApprovalError: ${state.message}");
                        showSnackbar(state.message, context);
                      }
                    },
                    child: const SizedBox(),
                  ),
                  Center(
                    child: SizedBox(
                      width: 150,
                      child: nextButton(
                        title: "Save Changes",
                        onTap: () {
                          developer.log("Save Changes button tapped");
                          if (_formKey.currentState!.validate()) {
                            final list = createEducationMap();
                            developer.log("Education map created: $list");
                            final request = UserEducationRequest(
                              educations: list.map((e) => EducationItem(
                                level: e['level'] as String,
                                school_college_id: e['school_college_id'] as int,
                                board_or_university:
                                e['board_or_university'] as String,
                                course_id: e['course_id'] as int,
                                specialization_id:
                                e['specialization_id'] as int,
                                start_year: e['start_year'] as String,
                                end_year: e['end_year'] as String,
                                percentage_or_cgpa:
                                e['percentage_or_cgpa'] as String,
                                education_certificate:
                                e['education_certificate'] as String,
                              )).toList(),
                            );
                            Navigator.pop(context, true);
                            final user_id = sl<PreferencesManager>().getUserId();
                            developer.log(
                                "Dispatching UpdateUserEducation for user_id=$user_id");
                            context.read<UserEducationApprovalBloc>().add(
                                UpdateUserEducation(
                                    int.parse(user_id ?? '0'), request));
                          } else {
                            developer.log("Form validation failed");
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please complete all fields")),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EducationFillingCard extends StatefulWidget {
  final String courseNameText;
  final TextEditingController collegeNameController;
  final TextEditingController specializationController;
  final TextEditingController startYearController;
  final TextEditingController endYearController;
  final List<SpecializationEntity> specializations;
  final String? education_certificate;
  final VoidCallback onTapCross;
  final String? Function(String?)? validator;
  final void Function(int)? onSelectCollegeId;
  final void Function(int)? onSelectSpecializationId;
  final int index;
  final void Function(PlatformFile?) onFileSelected;

  const EducationFillingCard({
    super.key,
    required this.courseNameText,
    required this.collegeNameController,
    required this.specializationController,
    required this.startYearController,
    required this.endYearController,
    required this.specializations,
    required this.onTapCross,
    this.education_certificate,
    this.validator,
    this.onSelectCollegeId,
    this.onSelectSpecializationId,
    required this.index,
    required this.onFileSelected,
  });

  @override
  State<EducationFillingCard> createState() => _EducationFillingCardState();
}

class _EducationFillingCardState extends State<EducationFillingCard> {
  @override
  Widget build(BuildContext context) {
    final bgColor = widget.index % 3 == 0
        ? const Color(0xFFE8F5E8)
        : widget.index % 3 == 1
        ? const Color(0xFFF3E5F5)
        : const Color(0xFFE3F2FD);

    developer.log(
        "Building EducationFillingCard for ${widget.courseNameText}, index=${widget.index}");

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(29, 179, 47, 0.1),
            border: Border.all(color: const Color.fromRGBO(29, 179, 47, 0.2)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    courseName(
                      name: widget.courseNameText,
                      bgColor: const Color(0xff1961F3),
                      mIcon: Icons.cancel,
                      onTap: () {
                        developer.log(
                            "Cross button tapped for ${widget.courseNameText}");
                        widget.onTapCross();
                      },
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                        );

                        if (result != null) {
                          PlatformFile file = result.files.first;
                          widget.onFileSelected(file);
                          developer.log(
                              "File selected: ${file.name}, size: ${file.size}");
                        } else {
                          developer.log("User cancelled file picker");
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              "assets/Icons/certificate.svg",
                              color: Colors.grey,
                              // Fallback to a default icon if certificate.svg is missing
                              //onError: (e, st) => const Icon(Icons.error),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.education_certificate != null
                                  ? "Change Certificate"
                                  : "Upload Certificate",
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text("College Name", style: mTextStyle12()),
                BlocBuilder<DetailedSignupBloc, DetailedSignupState>(
                  buildWhen: (previous, current) =>
                  current is DetailedSignupGetCollegeDetailsLoading ||
                      current is DetailedSignupGetCollegeDetailsLoaded ||
                      current is DetailedSignupSpecializationLoading ||
                      current is DetailedSignupSpecializationLoaded,
                  builder: (context, state) {
                    List<CollegeEntity> colleges = [];
                    if (state is DetailedSignupGetCollegeDetailsLoaded) {
                      developer.log(
                          "College autocomplete loaded for ${widget.courseNameText}");
                      colleges = state.collegesListResponse.colleges;
                    } else if (state is DetailedSignupSpecializationLoaded &&
                        state.collegesListResponse != null) {
                      developer.log(
                          "College autocomplete loaded from specialization state for ${widget.courseNameText}");
                      colleges = state.collegesListResponse!.colleges;
                    }
                    if (colleges.isNotEmpty) {
                      return CustomAutocompleteGeneric<CollegeEntity>(
                        options: colleges,
                        label: "Eg. Delhi Technological University",
                        onSelected: (college) {
                          developer.log(
                              "College selected: ${college.name}, id=${college.id}");
                          widget.collegeNameController.text = college.name;
                          if (widget.onSelectCollegeId != null) {
                            widget.onSelectCollegeId!(college.id);
                          }
                        },
                        initialText: widget.collegeNameController.text,
                        displayStringForOption: (college) => college.name,
                      );
                    } else if (state is DetailedSignupGetCollegeDetailsLoading ||
                        state is DetailedSignupSpecializationLoading) {
                      developer.log("College autocomplete loading...");
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                            height: 36,
                            width: 36,
                            child: CircularProgressIndicator()),
                      );
                    }
                    developer.log(
                        "College autocomplete fallback for ${widget.courseNameText}");
                    return CustomTextField(
                      controller: widget.collegeNameController,
                      hintText: "Eg. Delhi Technological University",
                      fillColor: Colors.white,
                      validator: widget.validator,
                    );
                  },
                ),
                const SizedBox(height: 10),
                Text("Specialization", style: mTextStyle12()),
                BlocBuilder<DetailedSignupBloc, DetailedSignupState>(
                  buildWhen: (previous, current) =>
                  current is DetailedSignupSpecializationLoading ||
                      current is DetailedSignupSpecializationLoaded,
                  builder: (context, state) {
                    if (state is DetailedSignupSpecializationLoaded) {
                      final specializations = state.specializationListResponse;
                      developer.log("Specializations loaded: ${specializations.length}");
                      developer.log("Specializations : ${specializations}");
                      return CustomAutocompleteGeneric<SpecializationEntity>(
                        options: specializations,
                        label: "Eg. Computer Science",
                        onSelected: (specialization) {
                          developer.log(
                              "Specialization selected: ${specialization.name}, id=${specialization.id}");
                          widget.specializationController.text =
                              specialization.name ?? '';
                          if (widget.onSelectSpecializationId != null) {
                            widget.onSelectSpecializationId!(
                                specialization.id ?? 0);
                          }
                        },
                        initialText: widget.specializationController.text,
                        displayStringForOption: (specialization) =>
                        specialization.name ?? '',
                      );
                    } else if (state is DetailedSignupSpecializationLoading) {
                      developer.log("Specializations loading...");
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          height: 36,
                          width: 36,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    developer.log("Specialization autocomplete fallback");
                    return CustomTextField(
                      controller: widget.specializationController,
                      hintText: "Eg. Computer Science",
                      fillColor: Colors.white,
                      validator: widget.validator,
                    );
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text("Start year", style: mTextStyle12()),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 110.0),
                      child: Text("End year", style: mTextStyle12()),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: DatePickerField(
                        controller: widget.startYearController,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: DatePickerField(
                        controller: widget.endYearController,
                        fillColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class EducationCardData {
  String level;
  TextEditingController schoolOrCollegeController;
  TextEditingController boardOrUniversityController;
  TextEditingController startYearController;
  TextEditingController endYearController;
  TextEditingController percentageOrCgpaController;
  int? selectedSchoolCollegeId;
  int? selectedCourseId;
  int? selectedSpecializationId;
  String? education_certificate;
  PlatformFile? certificateFile;
  TextEditingController specializationController;

  EducationCardData({
    required this.level,
    required this.schoolOrCollegeController,
    required this.boardOrUniversityController,
    required this.startYearController,
    required this.endYearController,
    required this.percentageOrCgpaController,
    this.selectedSchoolCollegeId,
    this.selectedCourseId,
    this.selectedSpecializationId,
    this.education_certificate,
    this.certificateFile,
    required this.specializationController,
  });
}