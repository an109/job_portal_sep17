import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';

import '../../../../ui_helper/ui_helper.dart';
import '../../../../widgets/widgets.dart';
import '../../../job_related/presentation/views/job_search_view.dart';
import '../../../signup_student/presentation/views/create_account.dart';

class EnterEmailOTpScreen extends StatefulWidget {
  final String email;
  EnterEmailOTpScreen({required this.email});
  @override
  State<EnterEmailOTpScreen> createState() => _EnterEmailOTpScreen();
}

class _EnterEmailOTpScreen extends State<EnterEmailOTpScreen> {
  late TextEditingController phoneController;
  TextEditingController otp1 = TextEditingController();
  TextEditingController otp2 = TextEditingController();
  TextEditingController otp3 = TextEditingController();
  TextEditingController otp4 = TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController(text: widget.email);
  }

  String getEnteredOtp() {
    return otp1.text + otp2.text + otp3.text + otp4.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: TColors.primary),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            signInHeader(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => CreateAccount()),
                );
              },
            ),
            mSpacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Phone Number", style: mTextStyle12()),
                  mSpacer(mHeight: 5.0),
                  CustomTextField(
                    controller: phoneController,
                    hintText: widget.email,
                    fillColor: Colors.white,
                  ),
                  mSpacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      otpInputBox(otp1),
                      otpInputBox(otp2),
                      otpInputBox(otp3),
                      otpInputBox(otp4),
                    ],
                  ),
                  mSpacer(),
                  mSpacer(),
                  commonRedContainer(
                    text: "Log In",
                    onTap: () {
                      try {
                        final enteredOtp = getEnteredOtp();
                        print("Entered OTP: $enteredOtp");
                      } catch (e, stack) {
                        print("Login Click Error: $e");
                        print(stack);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Unexpected error occurred")),
                        );
                      }
                    },
                  ),
                  mSpacer(mHeight: 12.0),
                  Center(
                    child: Text(
                      "Resend OTP",
                      style: mTextStyle12(mColor: Color(0xff4D81E7)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget otpInputBox(TextEditingController controller) {
    return Container(
      height: 48,
      width: 60,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          counterText: "",
          border: InputBorder.none,
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
      ),
    );
  }
}
