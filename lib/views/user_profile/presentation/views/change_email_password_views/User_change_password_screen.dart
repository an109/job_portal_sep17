import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../ui_helper/ui_helper.dart';
import '../../../../../widgets/widgets.dart';
import '../../bloc/manage_account_bloc/manage_account_bloc.dart';
import '../../bloc/manage_account_bloc/manage_account_event.dart';
import '../../bloc/manage_account_bloc/manage_account_state.dart';

class UserChangePasswordScreen extends StatelessWidget {
  final TextEditingController oldPassWordController = TextEditingController();
  final TextEditingController NewPassWordController = TextEditingController();
  final TextEditingController Re_enterPassWordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/message_icon.svg"),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/notifications_icon.svg"),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 11.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Change Password",
              style: mTextStyle32(mColor: Colors.black),
            ),
            const SizedBox(height: 15),
            Text(
              "Old Password",
              style: mTextStyle12(),
            ),
            CustomTextField(
              controller: oldPassWordController,
              hintText: "******",
              suffixIcon: Icons.visibility_off_outlined,
            ),
            const SizedBox(height: 15),
            Text("New Password", style: mTextStyle12()),
            CustomTextField(
              controller: NewPassWordController,
              hintText: "******",
              suffixIcon: Icons.visibility_off_outlined,
            ),
            const SizedBox(height: 15),
            Text("Re-enter Password", style: mTextStyle12()),
            CustomTextField(
              controller: Re_enterPassWordController,
              hintText: "******",
              suffixIcon: Icons.visibility_off_outlined,
            ),
            const SizedBox(height: 15),

            // 👇 NEW: BlocListener to show success/error messages
            BlocListener<ManageAccountBloc, ManageAccountState>(
              listener: (context, state) {
                if (state is ChangePasswordLoading) {
                  // Optional: Show a circular progress indicator here if desired
                } else if (state is ChangePasswordLoaded) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(' ${state.message}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Clear fields on success
                  oldPassWordController.clear();
                  NewPassWordController.clear();
                  Re_enterPassWordController.clear();
                } else if (state is ChangePasswordError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ ${state.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const SizedBox(), // Required placeholder
            ),

            Center(
              child: nextButton(
                title: "Save Changes",
                onTap: () {
                  final oldPass = oldPassWordController.text.trim();
                  final newPass = NewPassWordController.text.trim();
                  final reEnterPass = Re_enterPassWordController.text.trim();

                  if (oldPass.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enter current password')),
                    );
                    return;
                  }
                  if (newPass.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enter new password')),
                    );
                    return;
                  }
                  if (newPass != reEnterPass) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match')),
                    );
                    return;
                  }

                  final map = {
                    'oldPassword': oldPass,
                    'newPassword': newPass,
                  };

                  context.read<ManageAccountBloc>().add(LoadChangePassword(map));
                },
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}