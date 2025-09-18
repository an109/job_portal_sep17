import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/verify_otp_bloc/verify_otp_bloc.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/verify_otp_bloc/verify_otp_state.dart';
import 'package:job_portal/views/signup_university/presentation/views/detailed_university_signup_view.dart';
import '../../../../ui_helper/ui_helper.dart';
import '../../../../widgets/widgets.dart';
import '../../../login/presentation/views/login_page_first_view.dart';
import '../../../detailed_signup_student/presentation/views/signup_as_anyone_view.dart';
import '../../../signup_student/presentation/bloc/verify_otp_bloc/verify_otp_event.dart';
import '../blocs/university_signup_bloc.dart';

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

  // void resendOtp() {
  //   Map<String, dynamic> emailMap = {'email': widget.email};
  //   context.read<UniversitySignupBloc>().add(RemoteSignupSendOtpUniversity(emailMap));
  //   showSnackbar('OTP resent to your email.', context);
  //   startTimer();
  // }


  @override
  Widget build(BuildContext context) {
    // Pin theme configuration
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
                      // email: email,
                      email: "mmudgal67@gmail.com",
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.double_arrow),
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: 710,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              mSpacer(mHeight: 20.0),
              Text(
                "Verify your email",
                style: mTextStyle32(mColor: Color(0xff1A1C1E)),
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
              const SizedBox(
                height: 2,
              ),
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
                    Map<String, dynamic> emailOtpMap = {
                      "email": widget.email,
                      "otp": pin
                    };
                    context
                        .read<VerifyOtpBloc>()
                        .add(LoadVerifyOtp(emailOtpMap));
                  },
                ),
              ),
              mSpacer(),
              BlocListener<VerifyOtpBloc, VerifyOtpState>(
                listener: (context, state) {
                  if (state is VerifyOtpLoaded) {
                    final data = state.verifyOtpEntity;

                    if (data.message == "OTP verified successfully") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupAsAnyOne(
                            // basicUserInfoResponse: data,
                            email: widget.email,
                          ),
                        ),
                      );
                    } else {
                      showSnackbar("otp could not be verified.", context);
                    }
                  }
                },
                child: commonRedContainer(
                  text: "Verify Email",
                  onTap: () {
                    Map<String, dynamic> emailOtpMap = {
                      "email": widget.email,
                      "otp": _pinController.text
                    };
                    context
                        .read<VerifyOtpBloc>()
                        .add(LoadVerifyOtp(emailOtpMap));
                  },
                ),
              ),
              mSpacer(),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () {},
                        child: Text(
                          "Resend code",
                          style: mTextStyle12(mColor: AppColors.blueTextColor),
                        )),
                    Text(
                      " in 15 seconds",
                      style: mTextStyle12(),
                    )
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
              mSpacer(mHeight: 243.0),
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
            ]),
          ),
        ));
  }
}