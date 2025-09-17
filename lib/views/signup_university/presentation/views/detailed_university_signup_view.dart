import 'dart:developer' as developer show log;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/utils/constants/enums.dart';
import 'package:job_portal/utils/constants/image_string.dart';
import 'package:job_portal/views/detailed_signup_student/domain/entities/metadata_entities.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/signup_as_anyone_bloc/detailed_signup_bloc.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/signup_as_anyone_bloc/detailed_signup_event.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/signup_as_anyone_bloc/detailed_signup_state.dart';
import 'package:job_portal/views/login/presentation/views/login_page_first_view.dart';
import 'package:job_portal/views/signup_university/presentation/blocs/university_signup_bloc.dart';
import 'package:job_portal/views/signup_university/presentation/blocs/university_signup_event.dart';
import 'package:job_portal/views/signup_university/presentation/blocs/university_signup_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../ui_helper/ui_helper.dart';
import '../../../../widgets/widgets.dart';

class DetailedUniversitySignupView extends StatefulWidget {
  final String email;
  Map<String, dynamic> params = {};

  DetailedUniversitySignupView({
    super.key,
    required this.email,
  });
  @override
  State<DetailedUniversitySignupView> createState() =>
      _DetailedUniversitySignupViewState();
}

class _DetailedUniversitySignupViewState
    extends State<DetailedUniversitySignupView> {
  String selectedOption = '';
  String? selectedCourse;

  final _formKey = GlobalKey<FormState>();

  ///FOR COLLEGE DROPDOWN

  OverlayEntry? _collegeOverLayEntry;

  String selectedCollege = '';
  List<CourseEntity> coursesList = [];
  List<String> selectedCourses = [];

  @override
  void dispose() {
    _collegeOverLayEntry?.remove();
    collegeController.dispose();
    super.dispose();
  }

  /// TEXT FIELDS USED
  final clgNameController = TextEditingController();
  final websiteController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final pinCodeController = TextEditingController();
  final collegeController = TextEditingController();

  // API CALLED TO FETCH BASIC USER DATA
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final bloc = context.read<DetailedSignupBloc>();
    // final emailMap = {'email': 'dikshavashist2007@gmail.com'};
    final emailMap = {'email': widget.email};
    // bloc.add(DetailedSignupGetCollegeDetails(emailMap));
    bloc.add(DetailedSignupGetBasicUserInfo(emailMap));
    context.read<UniversitySignupBloc>().add(const LoadCourses());
    super.didChangeDependencies();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("user_email");
    if (email == null) {
      print("No email found in SharedPreferences.");
    } else {
      print("Retrieved email: $email");
    } //  Email from login screen

    if (email != null && email.isNotEmpty) {
      // context.read<FetchUserBloc>().add(FetchUserDetailsEvent(email: email));
    } else {
      print("No email found in SharedPreferences.");
    }
  }

  @override
  Widget build(BuildContext context) {
    /// MAIN UI PERSPECTIVE CODE
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(""),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocListener<DetailedSignupBloc, DetailedSignupState>(
                  listener: (context, state) {
                    if (state is DetailedSignupGetBasicUserInfoLoaded) {
                      final data = state.basicUserInfoResponse;
                      setState(() {
                        clgNameController.text = data.user.first_name;
                        emailController.text = data.user.email;
                        phoneController.text = data.user.phone;
                      });
                      final emailMap = {'email': widget.email};
                      context
                          .read<DetailedSignupBloc>()
                          .add(DetailedSignupGetCollegeDetails(emailMap));
                    }
                  },
                  child: const SizedBox(),
                ),
                BlocListener<UniversitySignupBloc, UniversitySignupState>(
                  listener: (context, state) {
                    if (state is CoursesLoaded) {
                      final data = state.coursesListResponse;

                      setState(() {
                        coursesList = data.courses;
                        developer.log("First course : ${coursesList.first}");
                      });
                    }
                  },
                  child: const SizedBox(),
                ),

                /// HEADER
                // Text(
                //   "Logo",
                //   style: mTextStyle15(
                //       mColor: Color(0xff032466), mFontWeight: FontWeight.w700),
                // ),
                SvgPicture.asset(
                  ImageString.jobPortalLogo,
                  height: 30,
                  fit: BoxFit.contain,
                  allowDrawingOutsideViewBox: true, // optional
                ),
                mSpacer17(),
                Container(
                  height: 70,
                  width: double.infinity,
                  child: Text(
                    "Let's get started! ",
                    style: mTextStyle32(mColor: Color(0xff1A1C1E)),
                  ),
                ),

                // BODY PART
                Text(
                  "College Name",
                  style: mTextStyle14(),
                ),
                mSpacer(mHeight: 2.0),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: clgNameController,
                        hintText: "NCU",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'College name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                mSpacer17(),

                Text(
                  "Address",
                  style: mTextStyle14(),
                ),
                mSpacer(mHeight: 2.0),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: addressController,
                        hintText: "Address",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Address is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                mSpacer17(),

                Text(
                  "Pin Code",
                  style: mTextStyle14(),
                ),
                mSpacer(mHeight: 2.0),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: pinCodeController,
                        hintText: "Pin Code",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Pincode is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                mSpacer17(),

                /// PHONE NUMBER TEXTFIELD
                Text(
                  "Phone Number",
                  style: mTextStyle14(),
                ),
                // CustomTextField(
                //   controller: phoneController,
                //   hintText: "",
                //   validator: (value) {
                //     if (value == null || value.trim().isEmpty) {
                //       return 'Phone Number is required';
                //     }
                //     return null;
                //   },
                // ),
                CustomPhoneField(
                  controller: phoneController,
                ),
                // mSpacer17(),

                /// EMAIL TEXTFIELD
                Text(
                  "Email",
                  style: mTextStyle14(),
                ),
                mSpacer(mHeight: 2.0),
                CustomTextField(
                  controller: emailController,
                  hintText: "amangupta@gmail.com",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),
                mSpacer17(),

                Text(
                  "Website",
                  style: mTextStyle14(),
                ),
                mSpacer(mHeight: 2.0),
                CustomTextField(
                  controller: websiteController,
                  hintText: "website.com",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Website is required';
                    }
                    return null;
                  },
                ),
                mSpacer17(),
                Text(
                  'Courses',
                  style: mTextStyle14(),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: coursesList.map((course) {
                    final isSelected = selectedCourses.contains(course);
                    return courseName(
                      name: course.name,
                      bgColor:
                          isSelected ? const Color(0xff1961F3) : Colors.white,
                      textColor: isSelected ? Colors.white : Colors.black,
                      borderColor:
                          isSelected ? const Color(0xff1961F3) : Colors.grey,
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedCourses.remove(course.name);
                          } else {
                            selectedCourses.add(course.name);
                          }
                        });
                      }, // optional or remove if unused
                    );
                  }).toList(),
                ),

                mSpacer(mHeight: 2.0),

                mSpacer(mHeight: 25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?", style: mTextStyle12()),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LogInPage1()),
                        );
                      },
                      child: Text(
                        " Login",
                        style: mTextStyle14(
                          // mColor: Color.fromARGB(255, 77, 129, 231),
                          mColor: AppColors.blueTextColor,
                          mFontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  ],
                ),
                mSpacer(mHeight: 25.0),

                /// END PART
                commonRedContainer(
                  text: "Register",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      developer.log('Valid Form');
                      // fillDataIntoParams();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => SignupPageYourSkills(
                      //       params: widget.params,
                      //     ),
                      //   ),
                      // );
                    } else {
                      showSnackbar(
                          'Please fill all the required fields.', context);
                    }
                  },
                ),
                mSpacer(mHeight: 25.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("By signing up, you agree to our",
                        style: mTextStyle12()),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        " Terms and Conditions",
                        style: mTextStyle14(
                          mFontWeight: FontWeight.w700,
                          mColor: const Color.fromARGB(255, 17, 24, 39),
                        ),
                      ),
                    )
                  ],
                ),
                mSpacer(mHeight: 20.0),
                // const SizedBox(
                //   height: 220,
                // ),

                const SizedBox(height: 20),
                mSpacer(mHeight: 25.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void fillDataIntoParams() {
  //   widget.params.addAll({
  //     DETAILEDPROFILEPARAMS.user_id.name: '59',
  //     DETAILEDPROFILEPARAMS.first_name.name: clgNameController.text,
  //     DETAILEDPROFILEPARAMS.email.name: emailController.text,
  //     DETAILEDPROFILEPARAMS.phone.name: phoneController.text,
  //     DETAILEDPROFILEPARAMS.dob.name: DOBController.text,
  //     DETAILEDPROFILEPARAMS.city.name: cityController.text,
  //     DETAILEDPROFILEPARAMS.jobLocation.name: JobLocationController.text,
  //     DETAILEDPROFILEPARAMS.gender.name: genderController.text,
  //     DETAILEDPROFILEPARAMS.user_type.name: selectedOption,
  //     // total experience
  //   });
  //   // Remove all mutually exclusive keys first
  //   widget.params
  //     ..remove(DETAILEDPROFILEPARAMS.educationStandard.name)
  //     ..remove(DETAILEDPROFILEPARAMS.course.name)
  //     ..remove(DETAILEDPROFILEPARAMS.college_name.name)
  //     ..remove(DETAILEDPROFILEPARAMS.specialization.name)
  //     ..remove(DETAILEDPROFILEPARAMS.start_year.name)
  //     ..remove(DETAILEDPROFILEPARAMS.end_year.name)
  //     ..remove(DETAILEDPROFILEPARAMS.experiences.name);
  //   if (selectedOption == JOBSEEKERTYPE.SchoolStudent.name) {
  //     widget.params.addAll({});
  //   } else if (selectedOption == JOBSEEKERTYPE.CollegeStudent.name ||
  //       selectedOption == JOBSEEKERTYPE.Fresher.name) {
  //     widget.params.addAll({
  //       DETAILEDPROFILEPARAMS.course.name: selectedCourse,
  //       DETAILEDPROFILEPARAMS.college_name.name: selectedCollege,
  //       DETAILEDPROFILEPARAMS.start_year.name: startCourseYearController.text,
  //       DETAILEDPROFILEPARAMS.end_year.name: endCourseYearController.text,
  //     });
  //   } else if (selectedOption == JOBSEEKERTYPE.WorkingProffesional.name) {
  //     widget.params.addAll({
  //       DETAILEDPROFILEPARAMS.experiences.name: [
  //         {
  //           DETAILEDPROFILEPARAMS.user_id.name: '59',
  //           DETAILEDPROFILEPARAMS.company.name: current_company.text,
  //           DETAILEDPROFILEPARAMS.start_date.name: startJobYearController.text,
  //           DETAILEDPROFILEPARAMS.end_date.name: endJobYearController.text,
  //         }
  //       ],
  //     });
  //   }
  //   developer
  //       .log('Params detials in sign up as anyone screen : ${widget.params}');
  // }
}

/// Drop down for years
class DatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const DatePickerField({
    required this.controller,
    this.hintText = 'Select Date',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
        suffixIcon: const Icon(
          Icons.calendar_today,
          size: 16,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1970),
          lastDate: DateTime(2100),
        );

        if (picked != null) {
          controller.text =
              '${picked.day} ${_monthName(picked.month)} ${picked.year}';
        }
      },
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month];
  }
}
