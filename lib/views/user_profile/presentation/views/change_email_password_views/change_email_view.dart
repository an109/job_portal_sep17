import 'dart:developer' as developer show log;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/ui_helper/ui_helper.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/manage_account_bloc/manage_account_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/manage_account_bloc/manage_account_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/manage_account_bloc/manage_account_state.dart';
import 'package:job_portal/widgets/widgets.dart';

class ChangeEmailView extends StatelessWidget {
  final TextEditingController changedEmailController = TextEditingController();
  final TextEditingController ChangedEmail_PasswordController = TextEditingController();

  ChangeEmailView({super.key});

  Map<String, dynamic> onPressedSaveChanges() {
    final _prefs = sl<PreferencesManager>();
    final user_id = _prefs.getUserId();
    final map = {
      'user_id': user_id ?? '2',
      'newEmail': changedEmailController.text.trim(),
    };

    developer.log("onPressedSaveChanges() called with map: $map");

    return map;
  }

  @override
  Widget build(BuildContext context) {
    developer.log("ChangeEmailView build() called");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: () {
              developer.log("Message icon tapped");
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/message_icon.svg"),
            ),
          ),
          InkWell(
            onTap: () {
              developer.log("Notification icon tapped");
            },
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
              "Change Email",
              style: mTextStyle32(mColor: Colors.black),
            ),
            const SizedBox(height: 12),
            Container(
              height: 51,
              width: 300,
              child: Text(
                "Please note that all the data associated with your account will be linked to your new email address after this change.",
                style: mTextStyle12(),
              ),
            ),
            const SizedBox(height: 15),
            const Text("New Email ID"),
            CustomTextField(
              controller: changedEmailController,
              hintText: "agupta@gmail.com",
            ),
            const SizedBox(height: 15),
            const Text("Password"),
            CustomTextField(
              controller: ChangedEmail_PasswordController,
              isPasswordField: true,
              hintText: "*******",
              suffixIcon: Icons.visibility_off_outlined,
            ),
            const SizedBox(height: 15),
            BlocListener<ManageAccountBloc, ManageAccountState>(
              listener: (context, state) {
                if (state is ChangeEmailLoading) {
                  developer.log('[BLOC] ChangeEmailLoading triggered');
                } else if (state is ChangeEmailLoaded) {
                  developer.log('[BLOC] ChangeEmailLoaded: ${state.updateUserEmailEntity.message}');
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email updated successfully!')),
                  );
                } else if (state is ChangeEmailError) {
                  developer.log('[BLOC] ChangeEmailError: ${state.toString()}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to update email. Please check your password and try again.')),
                  );
                } else {
                  developer.log('[BLOC] Unknown state: $state');
                }
              },
              child: const SizedBox(),
            ),
            Center(
              child: nextButton(
                title: "Save Changes",
                onTap: () {
                  developer.log("Save Changes button tapped");

                  final email = changedEmailController.text.trim();
                  final password = ChangedEmail_PasswordController.text.trim();

                  developer.log("Entered Email: $email, Password: $password");

                  if (email.isEmpty) {
                    developer.log("Validation failed: Email empty");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a new email address')),
                    );
                    return;
                  }

                  if (password.isEmpty) {
                    developer.log("Validation failed: Password empty");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter your current password')),
                    );
                    return;
                  }

                  final _prefs = sl<PreferencesManager>();
                  final userId = _prefs.getUserId();
                  final map = {
                    'user_id': userId ?? '2',
                    'newEmail': email,
                    'password': password,
                  };

                  developer.log("Dispatching LoadChangeEmail event with map: $map");

                  context.read<ManageAccountBloc>().add(LoadChangeEmail(map));
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
