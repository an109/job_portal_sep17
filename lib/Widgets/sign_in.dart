import 'package:flutter/material.dart';

import '../../../../../utils/theme/custom_themes/color_theme.dart';


class SignInHeader extends StatelessWidget {
  final VoidCallback onTap;

  const SignInHeader({required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive sizes
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.13;
    final textFontSize = screenWidth * 0.045;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalSpacing),
      decoration: BoxDecoration(color: TColors.primary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sign in to your Account",
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontFamily: "Inter",
            ),
          ),
          SizedBox(height: verticalSpacing),
          Row(
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(
                  fontSize: textFontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Inter",
                ),
              ),
              InkWell(
                onTap: onTap,
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: TColors.secondary,
                    fontSize: textFontSize,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
