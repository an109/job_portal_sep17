import 'dart:async';
import 'dart:developer' as developer show log;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
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
import '../../../signup_student/presentation/views/create_account.dart';
import 'package:job_portal/views/signup_recruiter/presentation/views/recruiter_verify_email_view.dart';
import 'package:job_portal/views/signup_student/presentation/views/signup_student2_view.dart';
import 'package:job_portal/views/signup_university/presentation/views/verify_university_email.dart';
import 'package:job_portal/views/company_register/presentation/view/company_profile_screen.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/views/signup_as_anyone_view.dart';
import 'package:job_portal/views/Bottom_Nav_Bar/Recruiter_Bottom_Nav_Bar.dart';

class LoginWithEmailOtpScreen extends StatefulWidget {
  const LoginWithEmailOtpScreen({super.key});

  @override
  State<LoginWithEmailOtpScreen> createState() => _LoginWithEmailOtpScreen();
}

class _LoginWithEmailOtpScreen extends State<LoginWithEmailOtpScreen> {
  final TextEditingController emailOTPController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  bool isLoading = false;
  bool showOtpField = false;
  Timer? _resendTimer;
  int _resendTime = 15;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _pinController.dispose();
    _pinFocusNode.dispose();
    emailOTPController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _resendTime = 15;
    });

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTime == 0) {
        timer.cancel();
      } else {
        setState(() {
          _resendTime--;
        });
      }
    });
  }

  void _resendOtp() {
    if (_formKey.currentState!.validate() && _resendTime == 0) {
      final emailMap = {'email': emailOTPController.text.trim()};
      context.read<RemoteLoginBloc>().add(RemoteLoginSentOtpData(emailMap));
      _startResendTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pin theme configuration for Pinput
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: SvgPicture.asset(
            ImageString.jobPortalLogo,
            height: 30,
            fit: BoxFit.contain,
            allowDrawingOutsideViewBox: true,
          ),
        ),
        backgroundColor: TColors.primary,
      ),
      body: BlocListener<RemoteLoginBloc, RemoteLoginState>(
        listener: (context, state) {
          if (state is RemoteLoginSendOtpLoaded) {
            // OTP sent successfully, show OTP field
            setState(() {
              showOtpField = true;
            });
            showSnackbar('OTP sent to your email', context);
            _startResendTimer();
          } else if (state is RemoteLoginSendOtpError) {
            showSnackbar('Failed to send OTP. Please try again.', context);
          } else if (state is RemoteLoginVerifyOtpLoaded) {
            final data = state.verifyOtpEntity;
            final prefs = sl<PreferencesManager>();

            if (data.message == 'OTP verified and Login successfully') {
              // Handle navigation based on profile_status and user_role
              _handleLoginSuccessNavigation(data, prefs);
            } else {
              showSnackbar('OTP verification failed', context);
            }
          } else if (state is RemoteLoginVerifyOtpError) {
            showSnackbar('Invalid OTP. Please try again.', context);
          }
        },
        child: Column(
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
                    const SizedBox(height: 3),
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

                    if (showOtpField) ...[
                      Text("Enter OTP",
                          style: mTextStyle14(mColor: Colors.grey.shade600)),
                      const SizedBox(height: 3),
                      Center(
                        child: Pinput(
                          length: 4,
                          controller: _pinController,
                          focusNode: _pinFocusNode,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          showCursor: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'OTP is required';
                            } else if (value.length != 4) {
                              return 'Enter a valid 4-digit OTP';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],

                    SizedBox(height: 30),
                    commonRedContainer(
                      text: showOtpField ? "Verify OTP" : "Get OTP",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          if (!showOtpField) {
                            // Request OTP
                            final emailMap = {
                              'email': emailOTPController.text.trim()
                            };
                            context.read<RemoteLoginBloc>().add(RemoteLoginSentOtpData(emailMap));
                          } else {
                            // Verify OTP
                            final emailOtpMap = {
                              'email': emailOTPController.text.trim(),
                              "otp": _pinController.text,
                            };
                            context.read<RemoteLoginBloc>().add(RemoteLoginVerifyOtpData(emailOtpMap));
                          }
                        }
                      },
                    ),

                    SizedBox(height: 20),
                    Center(
                      child: InkWell(
                        onTap: _resendOtp,
                        child: Text(
                          _resendTime > 0
                              ? "Resend code in $_resendTime seconds"
                              : "Resend code",
                          style: mTextStyle12(
                              mColor: _resendTime > 0
                                  ? Colors.grey
                                  : AppColors.blueTextColor
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        "Can't find our email? Check your spam folder or promotions tab too!",
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
      ),
    );
  }

  void _handleLoginSuccessNavigation(dynamic data, PreferencesManager prefs) {

    prefs.setToken(data.token ?? '');
    prefs.setUserId(data.user.id.toString());
    prefs.setUserType(data.user.user_role.toString());
    prefs.setString('temp_email', data.user.email);

    // If profile_status is 0 → Email not verified (shouldn't happen with OTP login)
    if (data.profile_status == 0) {
      showSnackbar('Email not verified. ', context);

      if (data.user.user_role == USERTYPE.STUDENT.name) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpStudent_2(Email: data.user.email),
          ),
        );
      } else if (data.user.user_role == USERTYPE.COMPANY.name) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecruiterVerifyEmailScreen(data.user.email),
          ),
        );
      } else if (data.user.user_role == USERTYPE.UNIVERSITY.name) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyUniversityEmail(email: data.user.email),
          ),
        );
      }
    }
    // If profile_status is 1 → Profile incomplete
    else if (data.profile_status == 1) {
      if (data.user.user_role == USERTYPE.STUDENT.name) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignupAsAnyOne(email: data.user.email),
          ),
        );
      } else if (data.user.user_role == USERTYPE.COMPANY.name) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompanyProfileScreen(),
          ),
        );
      }
      // Add university case
    }
    // If profile_status is 2 → Profile complete
    else if (data.profile_status == 2) {
      if (data.user.user_role == USERTYPE.STUDENT.name) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Student_Bottom_Nav_bar(),
          ),
              (route) => false,
        );
      } else if (data.user.user_role == USERTYPE.COMPANY.name) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => RecruiterBottomNavBar(),
          ),
              (route) => false,
        );
      }
      // Add university case if needed
    }

    showSnackbar('Login successful', context);
  }
}