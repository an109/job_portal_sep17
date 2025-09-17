import 'dart:developer' as developer show log;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_state.dart';

class EditCareerObjectiveView extends StatefulWidget {
  final String career_objective;

  const EditCareerObjectiveView({super.key, required this.career_objective});

  @override
  State<EditCareerObjectiveView> createState() =>
      _EditCareerObjectiveViewState();
}

class _EditCareerObjectiveViewState extends State<EditCareerObjectiveView> {
  late TextEditingController _controller;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.career_objective);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> updateAboutApi(String newAbout) async {
    setState(() => _isUpdating = true);

    final map = {'career_objective': _controller.text.trim()};
    final _prefs = sl<PreferencesManager>();

    final user_id = _prefs.getUserId();

    context.read<MyProfileBloc>().add(LoadUpdateProfile(user_id ?? '6', map));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: AlertDialog(
        // titlePadding: EdgeInsets.all(1),
        actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        surfaceTintColor: Color.fromARGB(255, 247, 248, 255),
        actionsAlignment: MainAxisAlignment.start,
        backgroundColor: const Color.fromARGB(255, 247, 248, 255),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Career Objective',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        content: BlocListener<MyProfileBloc, MyProfileState>(
          listener: (context, state) {
            if (state is UpdateProfileLoaded) {
              developer.log(
                  'Profile update status: ${state.updateUserProfileEntity.message}');
              Navigator.of(context).pop(_controller.text.trim());
            } else if (state is UpdateProfileError) {
              developer.log('Profile update error');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to update about')),
              );
              setState(() => _isUpdating = false);
            }
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 300,
              maxWidth: 400, // Wider dialog
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    // padding:
                    //     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 247, 248, 255),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 144, 149, 160),
                        fontSize: 14,
                      ),
                      minLines: 1,
                      maxLines: null, // grows dynamically
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        hintText: "Enter Career Objective info...",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 144, 149, 160),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isUpdating
                ? null
                : () => updateAboutApi(_controller.text.trim()),
            child: _isUpdating
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color.fromARGB(255, 77, 129, 231),
                    ),
                  )
                : const Text(
                    'Update',
                    style: TextStyle(color: Color.fromARGB(255, 77, 129, 231)),
                  ),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     appBar: AppBar(
  //       backgroundColor: Colors.white,
  //       title: const Text("Edit Career Objective"),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           BlocListener<MyProfileBloc, MyProfileState>(
  //             listener: (context, state) {
  //               if (state is UpdateProfileLoaded) {
  //                 final data = state.updateUserProfileEntity;
  //                 developer.log('Profile update status : ${data.message}');
  //                 setState(() => _isUpdating = true);
  //                 Navigator.pop(context);
  //               } else if (state is UpdateProfileLoading) {
  //                 developer.log('Profile update status : $state');
  //               } else if (state is UpdateProfileError) {
  //                 developer.log('Profile update status : $state');
  //               }
  //             },
  //             child: SizedBox(),
  //           ),
  //           TextField(
  //             controller: _controller,
  //             maxLines: 5,
  //             decoration: const InputDecoration(
  //               border: OutlineInputBorder(),
  //               labelText: 'Career Objective',
  //               alignLabelWithHint: true,
  //             ),
  //           ),
  //           const SizedBox(height: 20),
  //           ElevatedButton(
  //             onPressed: _isUpdating
  //                 ? null
  //                 : () => updateAboutApi(_controller.text.trim()),
  //             child: _isUpdating
  //                 ? const CircularProgressIndicator(color: Colors.white)
  //                 : const Text("Update"),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
