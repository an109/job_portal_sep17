import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:job_portal/views/login/presentation/views/login_page_first_view.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/remote_signup_bloc/remote_signup_bloc.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/remote_signup_bloc/remote_signup_event.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/remote_signup_bloc/remote_signup_state.dart';
import 'package:job_portal/views/signup_student/presentation/views/signup_student2_view.dart';
import '../../../../ui_helper/ui_helper.dart';
import '../../../../widgets/widgets.dart';
import 'dart:developer' as developer show log;

import '../../../user_profile/presentation/views/user_terms_and_conditions_view.dart';

class SignUpStudent1 extends StatefulWidget {
  final String user_type;

  const SignUpStudent1({super.key, required this.user_type});

  @override
  State<SignUpStudent1> createState() => _SignUpStudent1State();
}

class _SignUpStudent1State extends State<SignUpStudent1> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = false;
  bool isChecked = false;

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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06), // Responsive padding
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Sign Up",
                    style: TextStyle(color: const Color(0xff1A1C1E), fontWeight: FontWeight.w900, fontFamily: "Inter", fontSize: 53)),
                SizedBox(height: screenHeight * 0.02), // Responsive spacing
                Text("Create an account to continue!", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700 )),
                SizedBox(height: screenHeight * 0.03), // Responsive spacing
                Text("First Name", style: TextStyle(fontSize: 15)),
                SizedBox(height: screenHeight * 0.01), // Responsive spacing
                CustomTextField(
                  controller: firstNameController,
                  hintText: "Aman",
                  suffixIcon: Icons.person,
                  validator: (value) => value == null || value.isEmpty
                      ? 'First name required'
                      : null,
                ),
                SizedBox(height: screenHeight * 0.02), // Responsive spacing
                Text("Last Name", style: TextStyle(fontSize: 15)),
                SizedBox(height: screenHeight * 0.01), // Responsive spacing
                CustomTextField(
                  controller: surnameController,
                  hintText: "Gupta",
                  validator: (value) => value == null || value.isEmpty
                      ? 'Last name required'
                      : null,
                ),
                SizedBox(height: screenHeight * 0.02), // Responsive spacing
                Text("Phone Number", style: TextStyle(fontSize: 15)),
                CustomPhoneField(
                  controller: phoneController,
                ),
                SizedBox(height: screenHeight * 0.01), // Responsive spacing
                Text("Email", style: TextStyle(fontSize: 15)),
                SizedBox(height: screenHeight * 0.01), // Responsive spacing
                CustomTextField(
                  controller: emailController,
                  hintText: "abc@gmail.com" ,
                  suffixIcon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Email required';
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                      return 'Enter a valid email';
                    return null;
                  },
                ),

                SizedBox(height: screenHeight * 0.02), // Responsive spacing
                Text("Password", style: TextStyle(fontSize: 15)),
                SizedBox(height: screenHeight * 0.01), // Responsive spacing
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
                    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value))  {
                      return 'Must include at least one symbol';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02), // Responsive spacing
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
                                    insetPadding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
                                    child: SizedBox(
                                      height: screenHeight * 0.7, // Responsive height
                                      width: screenWidth * 0.9, // Responsive width
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

                SizedBox(height: screenHeight * 0.02), // Responsive spacing
                BlocListener<RemoteSignupBloc, RemoteSignupState>(
                  listener: (context, state) {
                    if (state is RemoteSignupError) {
                      showSnackbar(
                          'Some error occured while signing up.', context);
                    } else if (state is RemoteSignupDone) {
                      final data = state.signUpUserResponse;

                      if (data.message == 'Email already exists') {
                        showSnackbar('Email already exists', context);
                      } else {
                        Map<String, dynamic> emailMap = {};
                        if (data.user != null) {
                          emailMap.addAll({'email': data.user!.email});
                        }
                        final _prefs = sl<PreferencesManager>();
                        _prefs.setUserId(data.user?.id.toString() ?? '00');
                        _prefs.setToken(data.token ?? '');
                        _prefs.setUserType(data.user!.user_role);
                        context
                            .read<RemoteSignupBloc>()
                            .add(RemoteSingupSendOtpEmail(emailMap));
                      }
                    } else if (state is RemoteSignupSendOtpEmailDone) {
                      final data = state.sendOtp;

                      if (data.message ==
                          "OTP sent successfully to your email") {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SignUpStudent_2(
                                Email: emailController.text.trim())));
                      }
                    } else if (state is RemoteSignupSendOtpEmailError) {
                      showSnackbar(
                          'Some error occured while sending otp. Please try resending otp.',
                          context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignUpStudent_2(
                              Email: emailController.text.trim())));
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
                          "user_role": widget.user_type,
                        };

                        final prefs = sl<PreferencesManager>();
                        prefs.setString('temp_first_name', firstNameController.text.trim());
                        prefs.setString('temp_last_name', surnameController.text.trim());
                        prefs.setString('temp_email', emailController.text.trim());
                        prefs.setString('temp_phone', phoneController.text.trim());

                        developer.log('Registeration map print : $body');
                        context.read<RemoteSignupBloc>().add(RemoteSignupData(body));
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SignUpStudent_2(
                              Email: emailController.text.trim(),
                            ),
                          ),
                        );
                      }
                    }
                        : null,
                  ),
                ),

                SizedBox(height: screenHeight * 0.025), // Responsive spacing
                dividerLine(),
                SizedBox(height: screenHeight * 0.02), // Responsive spacing
                belowBars(
                  text: "Sign up with Google",
                  imgUrl: "assets/Icons/google.svg",
                ),
                SizedBox(height: screenHeight * 0.05), // Responsive spacing
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
                SizedBox(height: screenHeight * 0.025), // Responsive spacing
              ],
            ),
          ),
        ),
      ),
    );
  }
}