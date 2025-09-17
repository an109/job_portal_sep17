import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/verify_otp_bloc/verify_otp_bloc.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/verify_otp_bloc/verify_otp_state.dart';
import 'package:job_portal/views/signup_university/presentation/views/detailed_university_signup_view.dart';
import '../../../../ui_helper/ui_helper.dart';
import '../../../../widgets/widgets.dart';
import '../../../login/presentation/views/login_page_first_view.dart';
import '../../../detailed_signup_student/presentation/views/signup_as_anyone_view.dart';

class VerifyUniversityEmail extends StatelessWidget {
  final String email;
  VerifyUniversityEmail({super.key, required this.email});
  TextEditingController enterOTP = TextEditingController();

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
                "One Time Password (OTP) has been sent on ${email}",
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
              SizedBox(
                width: double.infinity,
                child: CustomTextField(
                  controller: enterOTP,
                  hintText: "Enter OTP",
                  fillColor: Colors.white,
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
                            email: email,
                          ),
                        ),
                      );
                    } else {
                      showSnackbar("otp could not be verified.", context);
                    }
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => SignupAsAnyOne(
                    //       basicUserInfoResponse: data,
                    //     ),
                    //   ),
                    // );
                  }
                },
                child: commonRedContainer(
                  text: "Verify Email",
                  onTap: () {
                    // final emailMap = {'email': 'johndoe@example.com'};
                    Map<String, dynamic> emailOtpMap = {
                      "email": email,
                      "otp": enterOTP.text.trim()
                    };
                    // context
                    //     .read<VerifyOtpBloc>()
                    //     .add(LoadVerifyOtp(emailOtpMap));

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
