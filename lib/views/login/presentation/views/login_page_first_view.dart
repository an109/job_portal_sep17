import 'dart:convert';
import 'dart:developer' as developer show log;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/utils/constants/enums.dart';
import 'package:job_portal/utils/constants/image_string.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';
import 'package:job_portal/views/bottom_nav_bar/student_bottom_nav_bar.dart';
import 'package:job_portal/views/login/presentation/bloc/remote_login_bloc.dart';
import 'package:job_portal/views/login/presentation/bloc/remote_login_event.dart';
import 'package:job_portal/views/login/presentation/bloc/remote_login_state.dart';
import 'package:job_portal/views/signup_recruiter/presentation/views/recruiter_verify_email_view.dart';
import 'package:job_portal/views/signup_student/presentation/views/signup_student2_view.dart';
import 'package:job_portal/views/signup_university/presentation/views/verify_university_email.dart';
import '../../../../ui_helper/ui_helper.dart';
import '../../../../widgets/widgets.dart';
import '../../../Bottom_Nav_Bar/Recruiter_Bottom_Nav_Bar.dart';
import '../../../Common_Screens/presentation/bloc/forgot_password_bloc.dart';
import '../../../Common_Screens/presentation/view/Forgot_password_Screen.dart';
import '../../../company_register/presentation/view/company_profile_screen.dart';
import '../../../detailed_signup_student/presentation/views/signup_as_anyone_view.dart';
import 'login_with_email_otp_view.dart';
import '../../../signup_student/presentation/views/create_account.dart';

class LogInPage1 extends StatefulWidget {
  @override
  State<LogInPage1> createState() => _SignInPage_1State();
}

class _SignInPage_1State extends State<LogInPage1> {
  String token = "";
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Form key

  bool rememberMeValue = true;

  Future<void> sendOtpEmail(String email) async {
    final response = await http.post(
      Uri.parse('https://leafyscape.com/api/otp/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      developer.log('OTP API Response: ${response.body}');
      throw Exception('Failed to send OTP');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // foregroundColor: Colors.transparent,
        // surfaceTintColor: Colors.transparent,
        // shadowColor: Colors.transparent,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SvgPicture.asset(
            ImageString.jobPortalLogo,
            height: 30,
            // width: 40,
            fit: BoxFit.contain,
            allowDrawingOutsideViewBox: true,
          ),
        ),
        backgroundColor: TColors.primary,
        // backgroundColor: TColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              signInHeader(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateAccount(),
                    ),
                  );
                },
              ),
              mSpacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email", style: mTextStyle14()),
                      CustomTextField(
                        controller: emailController,
                        hintText: "abc@gmail.com",
                        fillColor: Colors.white,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      mSpacer(mHeight: 16.0),
                      Text("Password", style: mTextStyle14()),
                      CustomTextField(
                        controller: passwordController,
                        hintText: "*******",
                        suffixIcon: Icons.visibility_off_outlined,
                        fillColor: Colors.white,
                        isPasswordField: true,
                        // isObscure: true,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      mSpacer(mHeight: 16.0),
                      RememberMeRow(
                        onForgotPasswordTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => sl<ForgotPasswordBloc>(),
                                child: const ForgotPasswordScreen(),
                              ),
                            ),
                          );
                        },
                        onRememberMeChanged: (value) {
                          rememberMeValue = value;
                          print("Remember me: $rememberMeValue");
                        },
                      ),
                      mSpacer(mHeight: 30.0),
                      // BlocListener<RemoteLoginBloc, RemoteLoginState>(
                      //   listener: (context, state) {
                      //     if (state is RemoteLoginError) {
                      //       showSnackbar(
                      //           'There was an error logging in.', context);
                      //     } else if (state is RemoteLoginLoaded) {
                      //       final data = state.loginUserResponse;
                      //       final prefs = sl<PreferencesManager>();
                      //       prefs.setToken(data.token);
                      //       prefs.setUserId(data.user.id.toString());
                      //
                      //       ///-----  save name and email
                      //       prefs.setString(PreferencesManager.USER_NAME, "${data.user.first_name} ${data.user.last_name}");
                      //       prefs.setString(PreferencesManager.USER_EMAIL, data.user.email);
                      //       ///------
                      //
                      //       if (rememberMeValue) {
                      //         prefs.setUserType(data.user.user_role);
                      //       }
                      //
                      //       if (data.message == 'Login successful') {
                      //         showSnackbar('Login successful', context);
                      //         developer.log('Login data : ${data.toString()}');
                      //         developer.log(
                      //             'User Type on login : ${data.user.user_role.toString()}');
                      //
                      //         if (data.user.user_role ==
                      //             USERTYPE.STUDENT.name) {
                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) =>
                      //               const Student_Bottom_Nav_bar(),
                      //             ),
                      //           );
                      //         } else if (data.user.user_role ==
                      //             USERTYPE.COMPANY.name) {
                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) =>
                      //                RecruiterBottomNavBar(),
                      //             ),
                      //           );
                      //         }
                      //       }
                      //     }
                      //   },
                      //   child: commonRedContainer(
                      //     text: "Log In",
                      //     onTap: () async {
                      //       if (_formKey.currentState!.validate()) {
                      //         final loginMap = {
                      //           "email": emailController.text.trim(),
                      //           "password": passwordController.text.trim(),
                      //         };
                      //
                      //         developer
                      //             .log('Login Map : ${loginMap.toString()}');
                      //
                      //         context
                      //             .read<RemoteLoginBloc>()
                      //             .add(RemoteLoginData(loginMap));
                      //       }
                      //     },
                      //   ),
                      // ),
                      BlocListener<RemoteLoginBloc, RemoteLoginState>(
                        listener: (context, state) async {

                          if (state is RemoteLoginError) {
                            showSnackbar('There was an error logging in.', context);
                          } else if (state is RemoteLoginLoaded) {
                            final data = state.loginUserResponse;
                            final prefs = sl<PreferencesManager>();

                            // --- CASE 1: profile_status = 0 → Email not verified ---
                            if (data.profile_status == 0) {
                              if (data.user == null) {
                                showSnackbar('Invalid response from server', context);
                                return;
                              }
                              final email = data.email;
                              final role = data.user_role;

                              if (email == null || role == null) {
                                showSnackbar('Missing email or role', context);
                                return;
                              }

                              // Save email temporarily (you may not need role if screens are separate)
                              final prefs = sl<PreferencesManager>();
                              prefs.setString('temp_email', email);

                              // Call API to send OTP
                              try {
                                await sendOtpEmail(email);


                                if (role == USERTYPE.STUDENT.name) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUpStudent_2(Email: email), 
                                    ),
                                  );
                                } else if (role == USERTYPE.COMPANY.name) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecruiterVerifyEmailScreen(email), 
                                    ),
                                  );
                                } else if (role == USERTYPE.UNIVERSITY.name) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VerifyUniversityEmail(email: email), 
                                    ),
                                  );
                                } else {
                                  showSnackbar('Unknown user role', context);
                                }
                              } catch (e) {
                                showSnackbar('Failed to send OTP. Please try again.', context);
                                developer.log('OTP Send Error: $e');
                              }
                            }

                            // --- CASE 2: profile_status = 1 → Profile incomplete ---
                            else if (data.profile_status == 1 && data.user != null) {
                              final user = data.user!;
                              prefs.setToken(data.token!);
                              prefs.setUserId(user.id.toString());
                              prefs.setString(PreferencesManager.USER_NAME, "${user.first_name} ${user.last_name}");
                              prefs.setString(PreferencesManager.USER_EMAIL, user.email);
                              if (rememberMeValue) {
                                prefs.setUserType(user.user_role);
                              }

                              // Navigate to detailed signup based on role
                              if (user.user_role == USERTYPE.STUDENT.name) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupAsAnyOne(email: PreferencesManager.USER_EMAIL), // <-- Create this
                                  ),
                                );
                              } else if (user.user_role == USERTYPE.COMPANY.name) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CompanyProfileScreen(),
                                  ),
                                );
                              } else if (user.user_role == USERTYPE.UNIVERSITY.name) {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => UniversityDetailedSignupScreen(), // <-- Create this
                                //   ),
                                // );
                              }
                            }

                            // --- CASE 3: profile_status = 2 → Profile complete ---
                            else if (data.profile_status == 2 && data.user != null) {
                              final user = data.user!;
                              prefs.setToken(data.token!);
                              prefs.setUserId(user.id.toString());
                              prefs.setString(PreferencesManager.USER_NAME, "${user.first_name} ${user.last_name}");
                              prefs.setString(PreferencesManager.USER_EMAIL, user.email);
                              if (rememberMeValue) {
                                prefs.setUserType(user.user_role);
                              }

                              // Navigate to dashboard based on role
                              if (user.user_role == USERTYPE.STUDENT.name) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Student_Bottom_Nav_bar(),
                                  ),
                                      (route) => false,
                                );
                              } else if (user.user_role == USERTYPE.COMPANY.name) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>  RecruiterBottomNavBar(),
                                  ),
                                      (route) => false,
                                );
                              } else if (user.user_role == USERTYPE.UNIVERSITY.name) {
                                // Navigator.pushAndRemoveUntil(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => const UniversityBottomNavBar(), // <-- Create if needed
                                //   ),
                                //       (route) => false,
                                // );
                              }
                            }

                            // Optional: Show success message for profile_status 1 or 2
                            if (data.profile_status != 0) {
                              showSnackbar('Login successful', context);
                              developer.log('Login data: ${data.toString()}');
                              developer.log('User Role: ${data.user?.user_role}');
                            }
                          }
                        },
                        child: commonRedContainer(
                          text: "Log In",
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              final loginMap = {
                                "email": emailController.text.trim(),
                                "password": passwordController.text.trim(),
                              };
                              developer.log('Login Map: ${loginMap.toString()}');
                              context.read<RemoteLoginBloc>().add(RemoteLoginData(loginMap));
                            }
                          },
                        ),
                      ),

                      mSpacer(mHeight: 30.0),
                      dividerLine(),
                      mSpacer(),
                      belowBars(
                        text: "Continue with Google",
                        imgUrl: "assets/Icons/google.svg",
                        onTap: () {},
                      ),
                      mSpacer(),
                      belowBars(
                        text: "Login with OTP",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginWithEmailOtpScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 200),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
