import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import '../../../detailed_signup_student/data/data_source/detailed_api_service.dart';
import '../../../detailed_signup_student/data/repository/detailed_signup_repository_impl.dart';
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
  final List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (index) => FocusNode());
  Timer? _timer;
  int _start = 15;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();

    // Set up focus node listeners
    for (int i = 0; i < _otpFocusNodes.length; i++) {
      _otpFocusNodes[i].addListener(() {
        if (_otpFocusNodes[i].hasFocus && _otpControllers[i].text.isEmpty) {
          // Move focus to the first empty field
          for (int j = 0; j < _otpControllers.length; j++) {
            if (_otpControllers[j].text.isEmpty) {
              FocusScope.of(context).requestFocus(_otpFocusNodes[j]);
              break;
            }
          }
        }
      });
    }
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
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void resendOtp() {
    Map<String, dynamic> emailMap = {'email': widget.Email};
    context.read<RemoteSignupBloc>().add(RemoteSingupSendOtpEmail(emailMap));
    showSnackbar('OTP resent to your email.', context);
    startTimer();
  }

  String getOtp() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void _handleOtpInput(String value, int index) {
    if (value.length == 1) {
      // Move to next field if available
      if (index < 3) {
        FocusScope.of(context).requestFocus(_otpFocusNodes[index + 1]);
      } else {
        // Last field - remove focus
        _otpFocusNodes[index].unfocus();
      }
    } else if (value.isEmpty) {
      // Move to previous field if available
      if (index > 0) {
        FocusScope.of(context).requestFocus(_otpFocusNodes[index - 1]);
      }
    }
  }

  void _handlePaste(String value) {
    // Only accept if value is exactly 4 digits
    if (value.length == 4 && int.tryParse(value) != null) {
      for (int i = 0; i < 4; i++) {
        _otpControllers[i].text = value[i];
      }
      // Move focus to the last field
      FocusScope.of(context).requestFocus(_otpFocusNodes[3]);
    }
  }

  @override
  Widget build(BuildContext context) {
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

                    // OTP Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(4, (index) {
                        return SizedBox(
                          width: 60,
                          height: 60,
                          child: TextFormField(
                            controller: _otpControllers[index],
                            focusNode: _otpFocusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (value) => _handleOtpInput(value, index),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onTap: () {
                              // Select all text when tapped
                              _otpControllers[index].selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: _otpControllers[index].text.length,
                              );
                            },
                          ),
                        );
                      }),
                    ),

                    // Paste button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () async {
                          ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
                          if (data != null && data.text != null) {
                            _handlePaste(data.text!);
                          }
                        },
                        child: Text(
                          "Paste",
                          style: TextStyle(
                            color: AppColors.blueTextColor,
                          ),
                        ),
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
                          String otp = getOtp();
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