import 'dart:developer' as developer show log;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:job_portal/views/login/presentation/views/login_page_first_view.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_state.dart';

class LogOutDialogView extends StatelessWidget {
  const LogOutDialogView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: AlertDialog(
        // titlePadding: EdgeInsets.all(1),
        actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        surfaceTintColor: Color.fromARGB(255, 247, 248, 255),
        actionsAlignment: MainAxisAlignment.end,
        backgroundColor: const Color.fromARGB(255, 247, 248, 255),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Log out',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 300,
            maxWidth: 400, // Wider dialog
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // padding:
                  //     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 247, 248, 255),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Are you sure you want to leave?",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 144, 149, 160),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
          TextButton(
            onPressed: () {
              final _prefs = sl<PreferencesManager>();

              _prefs.clear(PreferencesManager.USER_TYPE);
              _prefs.clear(PreferencesManager.TOKEN);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LogInPage1()),
                  (_) => false);
            },
            child: const Text(
              'LOGOUT',
              style: TextStyle(
                  color: Color.fromARGB(255, 77, 129, 231), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
