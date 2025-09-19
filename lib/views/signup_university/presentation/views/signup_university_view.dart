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

class SignupUniversityView extends StatelessWidget {
  SignupUniversityView({super.key});

  final _formKey = GlobalKey<FormState>();
  final clgNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = false;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(""),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VerifyUniversityEmail(
                      email: emailController.text.trim())));
            },
            icon: const Icon(Icons.double_arrow),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sign Up",
                  style: TextStyle(color: const Color(0xff1A1C1E), fontWeight: FontWeight.w900, fontFamily: "Inter", fontSize: 53)),
              mSpacer(),
              Text("Create an account to continue!", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700 )),
              mSpacer(mHeight: 24.0),
              Text("College Name", style: mTextStyle12()),
              CustomTextField(
                controller: clgNameController,
                hintText: "NCU",
                suffixIcon: Icons.person,
                // fillColor: const Color(0xffFFF7FB),
                validator: (value) => value == null || value.isEmpty
                    ? 'College name required'
                    : null,
              ),
              // mSpacer(mHeight: 15.0),
              // Text("Last Name", style: mTextStyle12()),
              // CustomTextField(
              //   controller: surnameController,
              //   hintText: "Gupta",
              //   fillColor: Color(0xffFFF7FB),
              //   validator: (value) => value == null || value.isEmpty
              //       ? 'Last name required'
              //       : null,
              // ),
              mSpacer(mHeight: 15.0),
              Text("Email", style: mTextStyle12()),
              CustomTextField(
                controller: emailController,
                hintText: "abc@gmail.com",
                suffixIcon: Icons.email,
                // fillColor: Color(0xffFFF7FB),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email required';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                    return 'Enter a valid email';
                  return null;
                },
              ),
              mSpacer(mHeight: 15.0),
              Text("Password", style: mTextStyle12()),
              CustomTextField(
                controller: passwordController,
                hintText: "*******",
                isPasswordField: true,
                suffixIcon: Icons.visibility_off_outlined,
                // fillColor: Color(0xffFFF7FB),
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
              mSpacer(mHeight: 15.0),
              Text("Phone Number", style: mTextStyle12()),
              // CustomTextField(
              //   controller: phoneController,
              //   hintText: "7895674320",
              //   keyboardType: TextInputType.number,
              //   suffixIcon: Icons.call,
              //   fillColor: Color(0xffFFF7FB),
              //   validator: (value) {
              //     if (value == null || value.isEmpty)
              //       return 'Phone Number required';
              //     if (value.length < 10 || value.length > 10)
              //       return 'Phone Number must be 10 digits';
              //     return null;
              //   },
              // ),
              CustomPhoneField(
                controller: phoneController,
              ),
              mSpacer(),

              BlocListener<RemoteSignupBloc, RemoteSignupState>(
                listener: (context, state) {
                  if (state is RemoteSignupError) {
                    showSnackbar(
                        'Some error occured while signing up.', context);
                  } else if (state is RemoteSignupDone) {
                    final data = state.signUpUserResponse;

                    // developer.log(data.message);

                    if (data.message == 'Email already exists') {
                      showSnackbar('Email already exists', context);
                      // this is for temp testing of send otp api
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
                      // commented cuz adding send otp email call here.
                      // showSnackbar('Please verify email.', context);
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => SignUpStudent_2(
                      //         Email: emailController.text.trim())));
                    }
                  } else if (state is RemoteSignupSendOtpEmailDone) {
                    final data = state.sendOtp;

                    if (data.message == "OTP sent successfully to your email") {
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
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      final body = {
                        "college_name": clgNameController.text.trim(),
                        "email": emailController.text.trim(),
                        "phone": phoneController.text.trim(),
                        "password": passwordController.text,
                      };

                      // developer.log('Registeration map print : $body');
                      context
                          .read<RemoteSignupBloc>()
                          .add(RemoteSignupData(body));
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => VerifyUniversityEmail(
                            email: emailController.text.trim(),
                          ),
                        ),
                      );
                    }
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => VerifyUniversityEmail(
                    //       email: emailController.text.trim(),
                    //     ),
                    //   ),
                    // );
                  },
                ),
              ),
              mSpacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("By signing up, you agree to our",
                      style: mTextStyle12()),
                  // InkWell(
                  //   onTap: () {},
                  //   child: Text(
                  //     " Terms and Conditions",
                  //     style: mTextStyle14(
                  //       mFontWeight: FontWeight.w700,
                  //       mColor: Color.fromARGB(255, 17, 24, 39),
                  //     ),
                  //   ),
                  // )
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
                              height: MediaQuery.of(context).size.height * 0.7,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: UserTermsAndConditionsScreen(), // reuse your existing screen
                            ),
                          );
                        },
                      );
                    },
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
              const SizedBox(
                height: 220,
              ),
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
