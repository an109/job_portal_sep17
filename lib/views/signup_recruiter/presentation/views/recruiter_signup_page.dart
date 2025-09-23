import 'dart:developer' as developer show log;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/utils/constants/enums.dart';
import 'package:job_portal/views/signup_recruiter/presentation/bloc/recruiter_signup_bloc/recruiter_signup_bloc.dart';
import 'package:job_portal/views/signup_recruiter/presentation/bloc/recruiter_signup_bloc/recruiter_signup_state.dart';
import 'package:job_portal/views/signup_recruiter/presentation/bloc/recruiter_signup_bloc/recruiter_singup_event.dart';
import 'package:job_portal/views/signup_recruiter/presentation/views/recruiter_verify_email_view.dart';
import '../../../../injection_container.dart';
import '../../../../ui_helper/ui_helper.dart';
import '../../../../utils/storage/shared_preference.dart';
import '../../../../widgets/widgets.dart';
import '../../../login/presentation/views/login_page_first_view.dart';
import '../../../user_profile/presentation/views/user_terms_and_conditions_view.dart';

class RecruiterSignupPage extends StatefulWidget {
  const RecruiterSignupPage({super.key});

  @override
  State<RecruiterSignupPage> createState() => _RecruiterSignupPageState();
}

class _RecruiterSignupPageState extends State<RecruiterSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final eController = TextEditingController();
  final pController = TextEditingController();
  final phoneController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  bool isLoading = false;
  bool isChecked = false;

  Map<String, dynamic> createSignupParams() {
    Map<String, dynamic> registerationMap = {
      "first_name": firstNameController.text.trim(),
      "last_name": lastNameController.text.trim(),
      "email": eController.text.trim(),
      "phone": phoneController.text.trim(),
      "password": pController.text.trim(),
      "user_role": USERTYPE.COMPANY.name
    };

    return registerationMap;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(""),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Text("Sign Up",
                      style: TextStyle(
                          color: const Color(0xff1A1C1E),
                          fontWeight: FontWeight.w900,
                          fontFamily: "Inter",
                          fontSize: 53)),
                  SizedBox(height: screenHeight * 0.02),
                  Text("Create an account to continue!",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  SizedBox(height: screenHeight * 0.03),

                  // First Name Field
                  Text("First Name", style: TextStyle(fontSize: 15)),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: firstNameController,
                    hintText: "Aman",
                    suffixIcon: Icons.person,
                    validator: (value) => value == null || value.isEmpty
                        ? 'First name required'
                        : null,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Last Name Field
                  Text("Last Name", style: TextStyle(fontSize: 15)),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: lastNameController,
                    hintText: "Gupta",
                    validator: (value) => value == null || value.isEmpty
                        ? 'Last name required'
                        : null,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Phone Number Field
                  Text("Phone Number", style: TextStyle(fontSize: 15)),
                  CustomPhoneField(
                    controller: phoneController,
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  // Email Field
                  Text("Official Email", style: TextStyle(fontSize: 15)),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: eController,
                    hintText: "abc@gmail.com",
                    suffixIcon: Icons.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Email required';
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                        return 'Enter a valid email';
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Password Field
                  Text("Password", style: TextStyle(fontSize: 15)),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: pController,
                    hintText: "∗∗∗∗∗∗∗∗∗∗",
                    isPasswordField: true,
                    suffixIcon: Icons.visibility_off_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      } else if (value.length < 7) {
                        return 'Password must be at least 6 characters';
                      } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return 'Must include at least one uppercase letter';
                      } else if (!RegExp(r'[a-z]').hasMatch(value)) {
                        return 'Must include at least one lowercase letter';
                      } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                        return 'Must include at least one number';
                      } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value))  {
                        return 'Must include at least one symbol';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Terms and Conditions Checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (val) {
                          setState(() {
                            isChecked = val ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "By signing up, you agree to our ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                WidgetSpan(
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            insetPadding: EdgeInsets.all(screenWidth * 0.04),
                                            child: SizedBox(
                                              height: screenHeight * 0.7,
                                              width: screenWidth * 0.9,
                                              child: const UserTermsAndConditionsScreen(),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      "Terms and Conditions",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: const Color.fromARGB(255, 17, 24, 39),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Register Button with BlocListener
                  BlocListener<RecruiterSignupBloc, RecruiterSignupState>(
                    listener: (context, state) {
                      if (state is RecruiterSignupLoaded) {
                        final data = state.signUpUserEntity;

                        if (data.message == "User registered") {
                          developer.log('Navigating on successful signup.');

                          final prefs = sl<PreferencesManager>();
                          prefs.setString(PreferencesManager.USER_NAME,
                              "${firstNameController.text.trim()} ${lastNameController.text.trim()}");
                          prefs.setString(PreferencesManager.USER_EMAIL, eController.text.trim());

                          Map<String, dynamic> emailMap = {
                            "email": eController.text.trim()
                          };
                          context
                              .read<RecruiterSignupBloc>()
                              .add(RecruiterSignupSendOtpEmail(emailMap));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecruiterVerifyEmailScreen(
                                  eController.text.trim()),
                            ),
                          );
                        } else if (data.message == "Email already exists") {
                          showSnackbar('Email already exists', context);
                          // navigating only for testing purpose (remove this later)
                          Map<String, dynamic> emailMap = {
                            "email": eController.text.trim()
                          };
                          context
                              .read<RecruiterSignupBloc>()
                              .add(RecruiterSignupSendOtpEmail(emailMap));

                        } else {
                          showSnackbar(
                              'Unknown error while recruiter signup.', context);
                        }
                      } else if (state is RecruiterSignupSendOtpLoaded) {
                        final data = state.sendOtpEmail;
                        // Handle OTP sent state if needed
                      } else if (state is RecruiterSignupError) {
                        showSnackbar('Error during signup process', context);
                      }
                    },
                    child: commonRedContainer(
                      text: "Register",
                      onTap: isChecked
                          ? () {
                        if (_formKey.currentState!.validate()) {
                          final registerationMap = createSignupParams();
                          developer
                              .log('Recruiter params log : $registerationMap');
                          context
                              .read<RecruiterSignupBloc>()
                              .add(RecruiterSignupData(registerationMap));
                        } else {
                          showSnackbar('Please fill all the details correctly.', context);
                        }
                      }
                          : null,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),

                  // Divider and Google Signup
                  dividerLine(),
                  SizedBox(height: screenHeight * 0.02),
                  belowBars(
                    text: "Sign up with Google",
                    imgUrl: "assets/Icons/google.svg",
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // Already have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?", style: mTextStyle12()),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LogInPage1(),
                            ),
                          );
                        },
                        child: Text(
                          " Login",
                          style: mTextStyle14(
                            mColor: AppColors.blueTextColor,
                            mFontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}