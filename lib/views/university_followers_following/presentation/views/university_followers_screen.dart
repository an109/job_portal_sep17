
import 'package:flutter/material.dart' hide ChoiceChip;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:job_portal/widgets/widgets.dart';

import '../../../../injection_container.dart';
import '../../../user_profile/presentation/views/follower_following_screens/followers_view.dart';
import '../bloc/university_followers_following_bloc.dart';
import '../bloc/university_followers_following_event.dart';
import '../bloc/university_followers_following_state.dart';

class UniversityFollowersScreen extends StatefulWidget {
  final int userId; // Pass user_id of the university profile
  const UniversityFollowersScreen({super.key, required this.userId});

  @override
  State<UniversityFollowersScreen> createState() => _UniversityFollowersScreenState();
}

class _UniversityFollowersScreenState extends State<UniversityFollowersScreen> {
  late UniversityFollowersFollowingBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<UniversityFollowersFollowingBloc>();
    _bloc.add(LoadFollowers(widget.userId)); // Load followers on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Followers',
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
            if (state is FollowersLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FollowersError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Failed to load followers'),
                    TextButton(
                      onPressed: () {
                        _bloc.add(LoadFollowers(widget.userId));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is FollowersLoaded) {
              final followers = state.followers;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Followers',
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SizedBox(
                          height: 50,
                          child: SearchTextField(
                              // key: "Search followers...",
                            onTextChanged: (value) {
                              // TODO: Implement search filtering locally or via API
                              print("Search: $value");
                            },
                          ),
                        ),
                      ),
                      const Row(
                        children: [
                          ChoiceChip(text: 'All'),
                          SizedBox(width: 10),
                          ChoiceChip(text: 'Company'),
                          SizedBox(width: 10),
                          ChoiceChip(text: 'University'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: followers.length,
                        itemBuilder: (context, index) {
                          final follower = followers[index];
                          return FollowerCard(
                            followerName: follower.name,
                            followerProfilePhoto: follower.profileImage,
                            followerSkill: 'Student', // You can add role/entity later
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