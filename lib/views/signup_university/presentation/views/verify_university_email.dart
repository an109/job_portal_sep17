import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/verify_otp_bloc/verify_otp_bloc.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/verify_otp_bloc/verify_otp_event.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/verify_otp_bloc/verify_otp_state.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/views/signup_as_anyone_view.dart';
import '../../../../ui_helper/ui_helper.dart';
import '../../../../widgets/widgets.dart';
import '../../../login/presentation/views/login_page_first_view.dart';
import '../../../signup_student/presentation/bloc/remote_signup_bloc/remote_signup_bloc.dart';
import '../../../signup_student/presentation/bloc/remote_signup_bloc/remote_signup_event.dart';
import '../../../signup_university/presentation/views/detailed_university_signup_view.dart';
import '../../../university_register/presentation/views/university_registration.dart';

class VerifyUniversityEmail extends StatefulWidget {
  final String email;
  const VerifyUniversityEmail({super.key, required this.email});

  @override
  State<VerifyUniversityEmail> createState() => _VerifyUniversityEmailState();
}

class _VerifyUniversityEmailState extends State<VerifyUniversityEmail> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  Timer? _timer;
  int _start = 25;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    setState(() {
      _canResend = false;
      _start = 25;
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

  void resendOtp() {
    Map<String, dynamic> emailMap = {'email': widget.email};
    context.read<RemoteSignupBloc>().add(RemoteSingupSendOtpEmail(emailMap));
    showSnackbar('OTP resent to your email.', context);
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  builder: (context) => DetailedUniversitySignupView(
                    email: widget.email,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.double_arrow),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height, // responsive height
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                mSpacer(mHeight: 20.0),
                Text(
                  "Verify your email",
                  style: mTextStyle32(mColor: const Color(0xff1A1C1E)),
                ),
                mSpacer(),
                Text(
                  "One Time Password (OTP) has been sent on ${widget.email}",
                  style: mTextStyle12(),
                ),
                mSpacer(mHeight: 26.0),
                Text(
                  "Enter OTP to verify your email",
                  style: mTextStyle12(),
                ),
                const SizedBox(height: 2),
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
                      Map<String, dynamic> emailOtpMap = {
                        "email": widget.email,
                        "otp": pin,
                      };
                      context.read<VerifyOtpBloc>().add(LoadVerifyOtp(emailOtpMap));
                    },
                  ),
                ),
                mSpacer(),
                BlocListener<VerifyOtpBloc, VerifyOtpState>(
                  listener: (context, state) {
                    if (state is VerifyOtpLoaded) {
                      final data = state.verifyOtpEntity;

                      if (data.message == "email verification successful") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UniversityFillDetailsScreen(),
                          ),
                        );
                      } else {
                        showSnackbar("OTP could not be verified.", context);
                      }
                    } else if (state is VerifyOtpError) {
                      showSnackbar("Failed to verify OTP. Please try again.", context);
                    }
                  },
                  child: commonRedContainer(
                    text: "Verify Email",
                    onTap: () {
                      String otp = _pinController.text;
                      if (otp.length != 4) {
                        showSnackbar("Please enter a valid 4-digit OTP", context);
                        return;
                      }
                      Map<String, dynamic> emailOtpMap = {
                        "email": widget.email,
                        "otp": otp,
                      };
                      context.read<VerifyOtpBloc>().add(LoadVerifyOtp(emailOtpMap));
                    },
                  ),
                ),
                mSpacer(),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: _canResend ? resendOtp : null,
                        child: Text(
                          _canResend ? "Resend code" : "Resend in $_start seconds",
                          style: mTextStyle12(
                            mColor: _canResend ? AppColors.blueTextColor : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                mSpacer(mHeight: 44.0),
                Center(
                  child: Container(
                    height: 36,
                    width: 313,
                    child: Text(
                      "Can't find our mail? Check your spam folder or promotions tab too",
                      style: mTextStyle12(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?", style: mTextStyle12()),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LogInPage1()),
                        );
                      },
                      child: Text(
                        " Login",
                        style: mTextStyle12(
                          mColor: AppColors.blueTextColor,
                          mFontWeight: FontWeight.w600,
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