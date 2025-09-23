import 'dart:async';
import 'dart:developer' as developer show log;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:job_portal/views/post_opportunities/presentation/views/post_opportunity_screen.dart';
import 'package:job_portal/views/signup_recruiter/presentation/bloc/verify_otp_recruiter_bloc/verify_otp_recruiter_bloc.dart';
import 'package:job_portal/views/signup_recruiter/presentation/bloc/verify_otp_recruiter_bloc/verify_otp_recruiter_event.dart';
import 'package:job_portal/views/signup_recruiter/presentation/bloc/verify_otp_recruiter_bloc/verify_otp_recruiter_state.dart';
import '../../../../injection_container.dart';
import '../../../../ui_helper/ui_helper.dart';
import '../../../../utils/storage/shared_preference.dart';
import '../../../../widgets/widgets.dart';
import '../../../company_register/presentation/view/company_profile_screen.dart';
import '../../../login/presentation/views/login_page_first_view.dart';
import '../bloc/recruiter_signup_bloc/recruiter_signup_bloc.dart';
import '../bloc/recruiter_signup_bloc/recruiter_singup_event.dart';

class RecruiterVerifyEmailScreen extends StatefulWidget {
  final String email;
  const RecruiterVerifyEmailScreen(this.email, {super.key});

  @override
  State<RecruiterVerifyEmailScreen> createState() => _RecruiterVerifyEmailScreenState();
}

class _RecruiterVerifyEmailScreenState extends State<RecruiterVerifyEmailScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  Timer? _timer;
  int _start = 15;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    setState(() {
      _canResend = false;
      _start = 15;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  void resendOtp() {
    Map<String, dynamic> emailMap = {'email': widget.email};
    context.read<RecruiterSignupBloc>().add(RecruiterSignupSendOtpEmail(emailMap));
    showSnackbar('OTP resent to your email.', context);
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Pin theme configuration
    final defaultPinTheme = PinTheme(
      width: screenWidth * 0.14,
      height: screenWidth * 0.14,
      textStyle: TextStyle(
        fontSize: screenWidth * 0.05,
        color: const Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(screenWidth * 0.02),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(screenWidth * 0.02),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(""),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PostInternshipsScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.double_arrow,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.025),
            Text(
              "Verify your email",
              style: mTextStyle32(
                mColor: const Color(0xff1A1C1E),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              "One Time Password (OTP) has been sent on ${widget.email}",
              style: mTextStyle12(),
            ),
            SizedBox(height: screenHeight * 0.032),
            Text(
              "Enter OTP to verify your email",
              style: mTextStyle12(),
            ),
            SizedBox(height: screenHeight * 0.0025),
            // Replaced CustomTextField with Pinput
            Center(
              child: Pinput(
                length: 4,
                controller: _pinController,
                focusNode: _pinFocusNode,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                showCursor: true,
                onCompleted: (pin) {
                  // Auto-submit when OTP is complete
                  developer.log('Printing email : ${widget.email}');
                  Map<String, dynamic> emailOtpMap = {
                    "email": widget.email,
                    "otp": pin
                  };
                  context
                      .read<VerifyOtpRecruiterBloc>()
                      .add(LoadVerifyRecruiterOtp(emailOtpMap));
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            BlocListener<VerifyOtpRecruiterBloc, VerifyOtpRecruiterState>(
                listener: (context, state) {
                  if (state is VerifyOtpRecruiterLoaded) {
                    final data = state.verifyOtpEntity;

                    if (data.message == "email verification successful") {
                      final String? token = data.token;
                      final String userType = data.user.user_role;

                      sl<PreferencesManager>().setToken(token!);
                      sl<PreferencesManager>().setUserType(userType);
                      sl<PreferencesManager>().setUserId(data.user.id.toString());

                      developer.log("🔐 Token saved: $token", name: "auth.token");
                      developer.log("👤 User Type: $userType", name: "auth.user");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  CompanyProfileScreen(),
                        ),
                      );
                    }
                  } else if (state is VerifyOtpRecruiterLoading) {
                    developer.log('Verify recruiter otp is loading.');
                  } else if (state is VerifyOtpRecruiterError) {
                    developer
                        .log('Verify recruiter otp ended up in some error.');
                  }
                },
                child: SizedBox()),
            SizedBox(
              width: double.infinity,
              child: commonRedContainer(
                text: "Verify Email",
                onTap: () {
                  developer.log('Printing email : ${widget.email}');

                  Map<String, dynamic> emailOtpMap = {
                    "email": widget.email,
                    "otp": _pinController.text
                  };

                  context
                      .read<VerifyOtpRecruiterBloc>()
                      .add(LoadVerifyRecruiterOtp(emailOtpMap));
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: _canResend ? resendOtp : null,
                    child: Text(
                      _canResend
                          ? "Resend code"
                          : "Resend in $_start seconds",
                      style: mTextStyle12(
                        mColor: _canResend
                            ? AppColors.blueTextColor
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.055),
            Center(
              child: Container(
                width: screenWidth * 0.7825,
                child: Text(
                  "Can't find our mail? Check your spam folder or promotions tab too!",
                  style: mTextStyle12(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: mTextStyle12(),
                ),
                InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LogInPage1()));
                    },
                    child: Text(
                      " Login",
                      style: mTextStyle12(
                          mColor: AppColors.blueTextColor,
                          mFontWeight: FontWeight.w600),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}