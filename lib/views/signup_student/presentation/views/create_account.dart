import 'package:flutter/material.dart';
import 'package:job_portal/utils/constants/enums.dart';
import 'package:job_portal/utils/constants/image_string.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';
import 'package:job_portal/views/signup_university/presentation/views/signup_university_view.dart';
import '../../../../ui_helper/ui_helper.dart';
import '../../../login/presentation/views/login_page_first_view.dart';
import '../../../signup_recruiter/presentation/views/recruiter_signup_page.dart';
import 'signup_student1_view.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenHeight < 700;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// Top illustration and header
          SliverToBoxAdapter(
            child: LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                height: screenHeight * 0.45,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Curved background
                    Positioned(
                      top: 0,
                      left: 0,
                      child: CustomPaint(
                        size: Size(screenWidth, screenHeight * 0.3),
                        painter: HalfCurvePainter(),
                      ),
                    ),

                    // Illustration
                    // Align(
                    //   alignment: Alignment.topCenter,
                    //   child: Padding(
                    //     padding: EdgeInsets.only(
                    //       top: screenHeight * 0.08,
                    //       left: screenWidth * 0.1,
                    //       right: screenWidth * 0.1,
                    //     ),
                    //     child: Image.asset(
                    //       ImageString.createAccountIllPng,
                    //       // width: screenWidth * 0.6,
                    //       // fit: BoxFit.contain,
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      top: screenHeight * 0.08,
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        ImageString.createAccountIllPng,
                        width: screenWidth,
                        fit: BoxFit
                            .fitWidth, // Or use BoxFit.cover for a different look
                      ),
                    ),

                    // Back button
                    Positioned(
                      top: screenHeight * 0.06,
                      left: screenWidth * 0.04,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                    ),

                    // Title & description
                    Positioned(
                      bottom: -140,
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Create a new account",
                            style: mTextStyle32(
                              mColor: const Color(0xff1A1C1E),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            "Join us and find your dream job or recruit talented candidates.",
                            style: mTextStyle12(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),

          /// Spacer for content to clear top overlay
          SliverToBoxAdapter(child: SizedBox(height: screenHeight * 0.2)),

          /// Form options
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Column(
                children: [
                  OptionContainer(
                    index: 0,
                    isSelected: selectedIndex == 0,
                    title1: "Sign up as a Student/Professional",
                    title2: "Apply for Jobs, Learn",
                    onTap: () {
                      setState(() => selectedIndex = 0);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SignUpStudent1(user_type: USERTYPE.STUDENT.name),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  OptionContainer(
                    index: 1,
                    isSelected: selectedIndex == 1,
                    title1: "Sign up as a Company",
                    title2: "Hire talent, Offer career opportunities",
                    onTap: () {
                      setState(() => selectedIndex = 1);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => RecruiterSignupPage()),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  OptionContainer(
                    index: 2,
                    isSelected: selectedIndex == 2,
                    title1: "Sign up as a University",
                    title2: "Find best placements for students",
                    onTap: () {
                      setState(() => selectedIndex = 2);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SignupUniversityView()),
                      );
                    },
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  /// Login prompt
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?", style: mTextStyle12()),
                        InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LogInPage1(),
                              ),
                              (Route route) => false,
                            );
                          },
                          child: Text(
                            " Login",
                            style: mTextStyle12(
                              mColor: AppColors.blueTextColor,
                              mFontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HalfCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.lightBlue.shade200
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(-100, -100); // Start at top left
    path.lineTo(size.width * 3, 0); // Horizontal to half width
    path.quadraticBezierTo(
      size.width * 0.6, 500, // Control point
      0, 370, // End point of curve
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// OPTION CONTAINER TO SIGN UP AS STUDENT/COMPANY/UNIVERSITY
Widget OptionContainer(
    {required String title1,
    required String title2,
    required int index,
    required bool isSelected,
    required VoidCallback onTap}) {
  final borderColor = isSelected ? TColors.secondary : TColors.primary;
  final textColor = isSelected ? TColors.secondary : TColors.primary;
  final fillColor = isSelected ? Color(0xffFFE4DB) : Color(0xffDFEAFB);
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 81,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 1.0),
          color: fillColor),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 19.0,
              top: 14.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title1,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                mSpacer(mHeight: 7.0),
                Text(
                  title2,
                  style: mTextStyle12(mColor: textColor),
                ),
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: TColors.secondary,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 12),
              ),
            ),
        ],
      ),
    ),
  );
}
