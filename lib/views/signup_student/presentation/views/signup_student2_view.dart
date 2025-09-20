import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/remote_signup_bloc/remote_signup_bloc.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/remote_signup_bloc/remote_signup_event.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/verify_otp_bloc/verify_otp_bloc.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/verify_otp_bloc/verify_otp_event.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/verify_otp_bloc/verify_otp_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../injection_container.dart';
import '../../../../ui_helper/ui_helper.dart';
import '../../../../utils/resourses/data_state.dart';
import '../../../../widgets/widgets.dart';
import '../../../detailed_signup_student/domain/repository/detailed_signup_repository.dart';
import '../../../login/presentation/views/login_page_first_view.dart';
import '../../../detailed_signup_student/presentation/views/signup_as_anyone_view.dart';

class SignUpStudent_2 extends StatefulWidget {
  final String Email;
  const SignUpStudent_2({super.key, required this.Email});

  @override
  State<SignUpStudent_2> createState() => _SignUpStudent_2State();
}

class _SignUpStudent_2State extends State<SignUpStudent_2> {
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

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  void resendOtp() {
    Map<String, dynamic> emailMap = {'email': widget.Email};
    context.read<RemoteSignupBloc>().add(RemoteSingupSendOtpEmail(emailMap));
    showSnackbar('OTP resent to your email.', context);
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    // Default pin theme
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

    // Focused pin theme
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    // Submitted pin theme
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
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: 710,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mSpacer(mHeight: 20.0),
                    Text("Verify your email",
                        style: mTextStyle32(mColor: const Color(0xff1A1C1E))),
                    mSpacer(),
                    Text(
                      "One Time Password (OTP) has been sent on ${widget.Email}",
                      style: mTextStyle12(),
                    ),
                    mSpacer(mHeight: 26.0),
                    Text("Enter OTP to verify your email",
                        style: mTextStyle12()),
                    const SizedBox(height: 2),

                    // Pinput for OTP entry
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
                            "email": widget.Email,
                            "otp": pin,
                          };
                          developer.log(' Sending OTP verification for: ${widget.Email}');
                          context.read<VerifyOtpBloc>().add(LoadVerifyOtp(emailOtpMap));
                        },
                      ),
                    ),

                    mSpacer(),
                    BlocListener<VerifyOtpBloc, VerifyOtpState>(
                      listener: (context, state) async {
                        if (state is VerifyOtpLoaded) {
                          final data = state.verifyOtpEntity;

                          if (data.message == "email verification successful") {
                            developer.log(' OTP verified. Fetching master/all API...');

                            unawaited(Future.microtask(() async {
                              try {
                                final repository = sl<DetailedSignupRepository>();
                                final result = await repository.getMasterAllData();

                                if (result is DataSuccess) {
                                  final masterData = result.data;

                                  // Save to SharedPreferences
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.setString('master_api_all_data', jsonEncode(masterData));

                                  // Log full response
                                  developer.log(' Master API Response:');
                                  developer.log(jsonEncode(masterData));

                                  developer.log(' master/all API data cached successfully.');
                                } else if (result is DataFailed) {
                                  developer.log(' Failed to fetch master/all: ${result.error}');
                                }
                              } catch (e, s) {
                                developer.log(' Critical error: $e');
                                developer.log(' Stack: $s');
                              }
                            }));

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupAsAnyOne(email: widget.Email),
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
                            "email": widget.Email,
                            "otp": otp,
                          };
                          developer.log(' Sending OTP verification for: ${widget.Email}');
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
                            style: mTextStyle12(
                              mColor: AppColors.blueTextColor,
                              mFontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                  ]),
            ),
          ),
        ));
  }
}