import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/ui_helper/ui_helper.dart';
import 'package:job_portal/views/login/presentation/views/login_page_first_view.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/remote_signup_bloc/remote_signup_bloc.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/remote_signup_bloc/remote_signup_event.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/remote_signup_bloc/remote_signup_state.dart';
import 'package:job_portal/views/signup_student/presentation/views/signup_student2_view.dart';
import 'package:job_portal/views/signup_university/presentation/views/verify_university_email.dart';
import 'package:job_portal/widgets/widgets.dart';

import '../../../user_profile/presentation/views/user_terms_and_conditions_view.dart';

class SignupUniversityView extends StatefulWidget {
  const SignupUniversityView({super.key});

  @override
  State<SignupUniversityView> createState() => _SignupUniversityViewState();
}

class _SignupUniversityViewState extends State<SignupUniversityView> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(""),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(
                    color: const Color(0xff1A1C1E),
                    fontWeight: FontWeight.w900,
                    fontFamily: "Inter",
                    fontSize: 53,
                  ),
                ),
                mSpacer(),
                Text(
                  "Create an account to continue!",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                mSpacer(mHeight: 24.0),

                // First Name
                Text("First Name", style: TextStyle(fontSize: 15)),
                CustomTextField(
                  controller: firstNameController,
                  hintText: "Aman",
                  suffixIcon: Icons.person,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'First name required' : null,
                ),
                mSpacer(mHeight: 15.0),

                // Last Name
                Text("Last Name", style: TextStyle(fontSize: 15)),
                CustomTextField(
                  controller: surnameController,
                  hintText: "Gupta",
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Last name required' : null,
                ),
                mSpacer(mHeight: 15.0),

                // Phone Number
                Text("Phone Number", style: TextStyle(fontSize: 15)),
                CustomPhoneField(
                  controller: phoneController,
                ),
                mSpacer(mHeight: 0.0),

                // Email
                Text("Email", style: TextStyle(fontSize: 15)),
                CustomTextField(
                  controller: emailController,
                  hintText: "abc@gmail.com",
                  suffixIcon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Email required';
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                      return 'Enter a valid email';
                    return null;
                  },
                ),
                mSpacer(mHeight: 15.0),

                // Password
                Text("Password", style: TextStyle(fontSize: 15)),
                CustomTextField(
                  controller: passwordController,
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
                    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                      return 'Must include at least one symbol';
                    }
                    return null;
                  },
                ),
                mSpacer(),

                // Terms and Conditions Checkbox
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              "By signing up, you agree to our ",
                              style: TextStyle(fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    insetPadding: const EdgeInsets.all(16),
                                    child: SizedBox(
                                      height:
                                      MediaQuery.of(context).size.height * 0.7,
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      child: const UserTermsAndConditionsScreen(),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text(
                              "Terms and Conditions",
                              style: mTextStyle14(
                                mFontWeight: FontWeight.w700,
                                mColor: const Color.fromARGB(255, 17, 24, 39),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                mSpacer(),

                // BlocListener and Register Button
                BlocListener<RemoteSignupBloc, RemoteSignupState>(
                  listener: (context, state) {
                    if (state is RemoteSignupError) {
                      showSnackbar('Some error occured while signing up.', context);
                    } else if (state is RemoteSignupDone) {
                      final data = state.signUpUserResponse;

                      if (data.message == 'Email already exists') {
                        showSnackbar('Email already exists', context);
                        Map<String, dynamic> emailMap = {
                          'email': emailController.text.trim()
                        };
                        context
                            .read<RemoteSignupBloc>()
                            .add(RemoteSingupSendOtpEmail(emailMap));
                      } else {
                        Map<String, dynamic> emailMap = {};
                        if (data.user != null) {
                          emailMap.addAll({'email': data.user!.email});
                        }
                        context
                            .read<RemoteSignupBloc>()
                            .add(RemoteSingupSendOtpEmail(emailMap));
                      }
                    } else if (state is RemoteSignupSendOtpEmailDone) {
                      final data = state.sendOtp;

                      if (data.message == "OTP sent successfully to your email") {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => VerifyUniversityEmail(
                                email: emailController.text.trim())));
                      }
                    } else if (state is RemoteSignupSendOtpEmailError) {
                      showSnackbar(
                          'Some error occured while sending otp. Please try resending otp.',
                          context);
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => VerifyUniversityEmail(
                      //         email: emailController.text.trim())));
                    }
                  },
                  child: commonRedContainer(
                    text: "Register",
                    onTap: isChecked
                        ? () {
                      if (_formKey.currentState!.validate()) {
                        final body = {
                          "first_name": firstNameController.text.trim(),
                          "last_name": surnameController.text.trim(),
                          "email": emailController.text.trim(),
                          "phone": phoneController.text.trim(),
                          "password": passwordController.text,
                          "user_role": "university", // or your user role for university
                        };

                        context
                            .read<RemoteSignupBloc>()
                            .add(RemoteSignupData(body));
                        // Navigate to VerifyUniversityEmail after signup
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VerifyUniversityEmail(
                              email: emailController.text.trim(),
                            ),
                          ),
                        );
                      }
                    }
                        : null,
                  ),
                ),

                mSpacer(mHeight: 20.0),

                dividerLine(),
                mSpacer(),

                belowBars(
                  text: "Sign up with Google",
                  imgUrl: "assets/Icons/google.svg",
                ),

                mSpacer(mHeight: 40.0),

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
                          mColor: AppColors.blueTextColor,
                          mFontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}