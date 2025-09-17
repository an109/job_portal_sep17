import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/utils/constants/image_string.dart';
import '../../../../ui_helper/ui_helper.dart';
import '../../../../widgets/widgets.dart';
import '../../../login/presentation/views/login_page_first_view.dart';
import '../bloc/forgot_password_bloc.dart';
import '../bloc/forgot_password_event.dart';
import '../bloc/forgot_password_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController email_Controller = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController NewPassWordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset("assets/Icons/message_icon.svg"),
            padding: const EdgeInsets.only(right: 20.0),
          ),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset("assets/Icons/notifications_icon.svg"),
            padding: const EdgeInsets.only(right: 20.0),
          ),
        ],
      ),
      body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            showSnackbar(state.message, context);

            // ✅ Critical: Delay navigation and check if context is still valid
            Future.delayed(Duration.zero, () {
              if (!context.mounted) return; // ✅ Prevents error if screen was popped

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LogInPage1()),
              );
            });
          } else if (state is ForgotPasswordOtpSent) {
            showSnackbar(state.message, context);
          } else if (state is ForgotPasswordOtpFailed) {
            showSnackbar(state.error, context);
          } else if (state is ResetPasswordFailed) {
            showSnackbar(state.error, context);
          }
        },
        // listener: (context, state) {
        //   if (state is ForgotPasswordOtpSent) {
        //     showSnackbar(state.message, context);
        //   } else if (state is ResetPasswordSuccess) {
        //     showSnackbar(state.message, context);
        //     Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => LogInPage1(),
        //       ),
        //     );
        //   } else if (state is ForgotPasswordOtpFailed) {
        //     showSnackbar(state.error, context);
        //   } else if (state is ResetPasswordFailed) {
        //     showSnackbar(state.error, context);
        //   }
        // },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0, top: 7.0, left: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Forgot Password", style: mTextStyle32(mColor: Colors.black)),
                  const SizedBox(height: 20),
                  Text("Email", style: mTextStyle12()),
                  CustomTextField(
                    controller: email_Controller,
                    hintText: "AmanGupta@gmail.com",
                  ),
                  const SizedBox(height: 20),
                  commonRedContainer(
                    text: state is ForgotPasswordLoading ? "Sending..." : "Get OTP",
                    onTap: () {
                      final email = email_Controller.text.trim();
                      if (email.isEmpty) {
                        showSnackbar("Please enter email", context);
                        return;
                      }
                      // ✅ Send OTP
                      context.read<ForgotPasswordBloc>().add(
                        SendForgotPasswordEmail(email: email),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 20),
                  Text("Enter OTP to verify Email or Phone number", style: mTextStyle12()),
                  CustomTextField(
                    controller: otpController,
                    hintText: "Enter OTP",
                  ),
                  const SizedBox(height: 20),
                  Text("New Password", style: mTextStyle12()),
                  CustomTextField(
                    controller: passwordController,
                    hintText: "******",
                    suffixIcon: Icons.visibility_off_outlined,
                  ),
                  const SizedBox(height: 20),
                  Text("Re-type Password", style: mTextStyle12()),
                  CustomTextField(
                    controller: NewPassWordController,
                    hintText: "******",
                    suffixIcon: Icons.visibility_off_outlined,
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: SizedBox(
                      width: 150,
                      child: nextButton(
                        title: state is ResetPasswordLoading ? "Saving..." : "Save Changes",
                        onTap: () {
                          final email = email_Controller.text.trim();
                          final otp = otpController.text.trim();
                          final newPassword = passwordController.text.trim();
                          final confirmPassword = NewPassWordController.text.trim();

                          if (email.isEmpty || otp.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
                            showSnackbar("All fields are required", context);
                            return;
                          }
                          if (newPassword != confirmPassword) {
                            showSnackbar("Passwords do not match", context);
                            return;
                          }

                          context.read<ForgotPasswordBloc>().add(
                            ResetPasswordRequestEvent(
                              email: email,
                              otp: otp,
                              newPassword: newPassword,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String? _extractOtp(String message) {
    final match = RegExp(r'\d{4,6}').firstMatch(message);
    return match?.group(0);
  }
}