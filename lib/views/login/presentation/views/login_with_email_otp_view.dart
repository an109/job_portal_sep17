import 'dart:developer' as developer show log;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/ui_helper/ui_helper.dart';
import 'package:job_portal/utils/constants/enums.dart';
import 'package:job_portal/utils/constants/image_string.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';
import 'package:job_portal/views/bottom_nav_bar/student_bottom_nav_bar.dart';
import 'package:job_portal/views/login/presentation/bloc/remote_login_bloc.dart';
import 'package:job_portal/views/login/presentation/bloc/remote_login_event.dart';
import 'package:job_portal/views/login/presentation/bloc/remote_login_state.dart';
import 'package:job_portal/widgets/widgets.dart';
import '../../../recruiter_dashboard/presentation/views/Recruiter_Dashboard.dart';
import '../../../signup_student/presentation/views/create_account.dart';

class LoginWithEmailOtpScreen extends StatefulWidget {
  const LoginWithEmailOtpScreen({super.key});

  @override
  State<LoginWithEmailOtpScreen> createState() => _LoginWithEmailOtpScreen();
}

class _LoginWithEmailOtpScreen extends State<LoginWithEmailOtpScreen> {
  TextEditingController emailOTPController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  bool showOtpField = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: SvgPicture.asset(
            // ImageString.progressBar1,
            ImageString.jobPortalLogo,
            height: 30,
            fit: BoxFit.contain,
            allowDrawingOutsideViewBox: true, // optional
          ),
        ),
        backgroundColor: TColors.primary,
      ),
      body: Column(
        children: [
          signInHeader(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateAccount()),
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
                  Text("Enter your Email",
                      style: mTextStyle14(mColor: Colors.grey.shade600)),
                  const SizedBox(
                    height: 3,
                  ),
                  CustomTextField(
                    controller: emailOTPController,
                    hintText: "Enter your email",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  if (showOtpField)
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("OTP",
                            style: mTextStyle14(mColor: Colors.grey.shade600)),
                        const SizedBox(
                          height: 3,
                        ),
                        CustomTextField(
                          controller: otpController,
                          hintText: "OTP",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'OTP is required';
                            } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                              return 'Enter a valid OTP';
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  SizedBox(height: 30),
                  BlocListener<RemoteLoginBloc, RemoteLoginState>(
                    listener: (context, state) {
                      if (state is RemoteLoginSendOtpLoaded) {
                        final data = state.sendOtpEmailEntity;

                        developer.log("Please show otp field.");
                        setState(() {
                          showOtpField = true;
                        });
                      } else if (state is RemoteLoginSendOtpLoading) {
                        developer
                            .log("Please wait we are trying to send you otp.");
                      } else if (state is RemoteLoginSendOtpError) {
                        developer.log(
                            "We are sorry. Some error occured in sending you otp.\nPlease try again.");
                      } else if (state is RemoteLoginVerifyOtpLoaded) {
                        final data = state.verifyOtpEntity;

                        final prefs = sl<PreferencesManager>();
                        prefs.setToken(data.token ?? '');
                        prefs.setUserId(data.user.id.toString());
                        prefs.setUserType(data.user.user_role.toString());

                        if (data.message ==
                            'OTP verified and Login successfully') {
                          showSnackbar('Login successful', context);
                          developer.log('Login data : ${data.toString()}');

                          if (data.user.user_role == USERTYPE.STUDENT.name) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const Student_Bottom_Nav_bar(),
                              ),
                            );
                          } else if (data.user.user_role ==
                              USERTYPE.COMPANY.name) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RecruiterDashboard(),
                              ),
                            );
                          }
                        }
                      } else if (state is RemoteLoginVerifyOtpLoading) {
                        developer.log('Please wait we are verifying otp.');
                      } else if (state is RemoteLoginVerifyOtpError) {
                        developer
                            .log('There was some error in verifying your otp.');
                      }
                    },
                    child: commonRedContainer(
                      text: showOtpField ? "Log in" : "Get OTP",
                      onTap: () {
                        // context.read<SendOTPBloc>().add(
                        //     TriggerSendOTPEvent(email: emailOTPController.text.trim()));
                        if (!showOtpField) {
                          if (_formKey.currentState!.validate()) {
                            final emailMap = {
                              'email': emailOTPController.text.trim()
                            };
                            context
                                .read<RemoteLoginBloc>()
                                .add(RemoteLoginSentOtpData(emailMap));
                          }
                        } else {
                          if (_formKey.currentState!.validate()) {
                            final emailOtpMap = {
                              'email': emailOTPController.text.trim(),
                              "otp": otpController.text.trim(),
                            };
                            context
                                .read<RemoteLoginBloc>()
                                .add(RemoteLoginVerifyOtpData(emailOtpMap));
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: InkWell(
                      onTap: () {},
                      child: Text(
                        "Resend code in 15 seconds",
                        style: mTextStyle12(mColor: AppColors.blueTextColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      "Can’t find our email? Check your spam folder or promotions tab too!",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
