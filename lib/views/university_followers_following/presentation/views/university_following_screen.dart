// lib/views/University_public_profile/presentation/screens/university_following_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:job_portal/utils/constants/image_string.dart';
import 'package:job_portal/widgets/widgets.dart';

import '../../../../injection_container.dart';
import '../../../user_profile/presentation/views/follower_following_screens/following_view.dart';
import '../bloc/university_followers_following_bloc.dart';
import '../bloc/university_followers_following_event.dart';
import '../bloc/university_followers_following_state.dart';

class UniversityFollowingScreen extends StatefulWidget {
  final int userId; // Pass user_id of the university profile
  const UniversityFollowingScreen({super.key, required this.userId});

  @override
  State<UniversityFollowingScreen> createState() => _UniversityFollowingScreenState();
}

class _UniversityFollowingScreenState extends State<UniversityFollowingScreen> {
  late UniversityFollowersFollowingBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<UniversityFollowersFollowingBloc>();
    _bloc.add(LoadFollowing(widget.userId)); // Load following on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Following',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: BlocProvider.value(
        value: _bloc,
        child: BlocBuilder<UniversityFollowersFollowingBloc, UniversityFollowersFollowingState>(
          builder: (context, state) {
            if (state is FollowingLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FollowingError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Failed to load following'),
                    TextButton(
                      onPressed: () {
                        _bloc.add(LoadFollowing(widget.userId));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is FollowingLoaded) {
              final following = state.following;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Following',
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SizedBox(
                          height: 50,
                          child: SrchTextField(
                            hintText: "Search following...",
                            onTextChanged: (value) {
                              // TODO: Implement search filtering locally or via API
                              print("Search: $value");
                            },
                          ),
                        ),
                      ),
                      const Row(
                        children: [
                          choiceChip(text: 'All'),
                          SizedBox(width: 10),
                          choiceChip(text: 'Company'),
                          SizedBox(width: 10),
                          choiceChip(text: 'University'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: following.length,
                        itemBuilder: (context, index) {
                          final followee = following[index];
                          return FollowingCard(
                            followingName: followee.name,
                            followingProfilePhoto: followee.profileImage,
                            followingSkill: 'Student', // You can enhance this later
                          );
                        },
                      )
                    ],
                  ),
                ),
              );
            }

            return const SizedBox(); // Initial or unknown state
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
// lib/widgets/widgets.dart

class choiceChip extends StatelessWidget {
  final String text;

  const choiceChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(239, 240, 246, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
// lib/widgets/widgets.dart

class SrchTextField extends StatefulWidget {
  final String? hintText;
  final void Function(String)? onTextChanged;

  const SrchTextField({
    super.key,
    this.hintText,
    this.onTextChanged,
  });

  @override
  State<SrchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SrchTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      ),
      onChanged: widget.onTextChanged,
    );
  }
}