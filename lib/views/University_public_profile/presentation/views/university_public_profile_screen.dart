import 'dart:developer' as developer; // show log;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/utils/constants/image_string.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';

// Import the specific entities and bloc for University Public Profile
import '../../../university_followers_following/presentation/bloc/university_followers_following_bloc.dart';
import '../../../university_followers_following/presentation/bloc/university_followers_following_event.dart';
import '../../../university_followers_following/presentation/bloc/university_followers_following_state.dart';
import '../../../university_followers_following/presentation/views/university_followers_screen.dart';
import '../../../university_followers_following/presentation/views/university_following_screen.dart';
import '../../../user_profile/presentation/views/follower_following_screens/following_view.dart';
import '../../domain/entities/university_public_profile_entity.dart';
import '../bloc/university_public_profile_bloc.dart';
import '../bloc/university_public_profile_event.dart';
import '../bloc/university_public_profile_state.dart';

import 'package:job_portal/views/user_profile/presentation/views/User_Notifications_Screen.dart';
import 'package:job_portal/views/user_profile/presentation/views/User_messages_screen.dart';

import '../../../../utils/constants/urls.dart';


class ActivityItem {
  final String caption;
  final int likeCount;
  final int commentCount;
  final DateTime createdAt;

  ActivityItem({
    required this.caption,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
  });
}


class UniversityPublicProfileScreen extends StatefulWidget {
  final int userId;
  final bool selfProfile; // To match UserPublicProfileScreen structure

  const UniversityPublicProfileScreen({
    Key? key,
    required this.userId,
    this.selfProfile = false, // Default to false for public profile
  }) : super(key: key);

  @override
  State<UniversityPublicProfileScreen> createState() => _UniversityPublicProfileScreenState();
}

class _UniversityPublicProfileScreenState extends State<UniversityPublicProfileScreen> {


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    developer.log('Fetching profile for user ID: ${widget.userId}');

    final bloc = context.read<UniversityPublicProfileBloc>();
    bloc.add(FetchUniversityPublicProfile(widget.userId));

    final followBloc = context.read<UniversityFollowersFollowingBloc>();
    followBloc.add(LoadFollowersCount(widget.userId));
    followBloc.add(LoadFollowingCount(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: SvgPicture.asset(
          ImageString.jobPortalLogo, // Assuming this path is correct
          height: 30,
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MessagesScreen())); // Assuming MessagesScreen exists
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/message_icon.svg"),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationsScreen())); // Assuming NotificationsScreen exists
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/notifications_icon.svg"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<UniversityPublicProfileBloc, UniversityPublicProfileState>(
          builder: (context, state) {
            developer.log('=== UNIVERSITY PROFILE STATE: $state ===');
            developer.log('Current state: $state');
            if (state is UniversityPublicProfileLoading) {
              developer.log('>>>>>>>>>>University public profile is loading.');
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UniversityPublicProfileError) {
              developer.log('>>>>>>>>>>>>>>>University public profile error: ${state.message}');
              return Center(child: Text("Error: ${state.message}"));
            }
            if (state is UniversityPublicProfileLoaded) {
              final profile = state.profile;
              developer.log('Profile loaded: ${profile.toJson()}');

              final int followersCount = 0;
              final int alumniCount = 0;

              final List<ActivityItem> activityItems = _getActivityFromProfile(profile);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Cover Image and Profile Picture Stack ---
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomLeft,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          Urls.getFullImageUrl(profile.universityLogoUrl ?? ''),
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 125,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: Center(
                                child: CircularProgressIndicator(
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            developer.log('Error loading cover image: $error');
                            return Container(
                              height: 125,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Icon(Icons.school, size: 50, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: -20,
                        left: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: (profile.profilePic?.isNotEmpty == true)
                                ? NetworkImage(Urls.getFullImageUrl(profile.profilePic!))
                                : null,
                            child: (profile.profilePic?.isEmpty == true || profile.profilePic == null)
                                ? SvgPicture.asset("assets/Icons/profile_icon.svg", width: 40, height: 40)
                                : null,
                            onBackgroundImageError: (exception, stackTrace) {
                              developer.log('Error loading profile pic: $exception');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40), // Space to avoid layout jump

                  // --- University Name, Handle, Location, About, Follow Button ---
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.collegeName ?? 'University Name Not Available',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '@${_getHandleFromProfile(profile)}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${profile.address ?? 'Address not available'}, ${_getLocationFromPincode(profile.pincode)}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.about ?? 'No description available',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      if (!widget.selfProfile)
                        ElevatedButton(
                          onPressed: () {
                            // Implement follow action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            elevation: 0,
                            side: const BorderSide(
                              color: Color.fromARGB(255, 29, 97, 231),
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            'Follow',
                            style: TextStyle(
                              color: Color.fromARGB(255, 29, 97, 231),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // --- Followers and Alumni (Following) Buttons ---
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UniversityFollowersScreen(
                                userId: widget.userId,
                              ),
                            ),
                          );
                          developer.log('Navigate to University Followers View');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 29, 97, 231),
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          elevation: 0,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          '$followersCount followers',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UniversityFollowingScreen(
                                userId:  widget.userId,
                              ),
                            ),
                          );
                          developer.log('Navigate to University Alumni View');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 29, 97, 231),
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          elevation: 0,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          '$alumniCount alumni',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      BlocBuilder<UniversityFollowersFollowingBloc, UniversityFollowersFollowingState>(
                        builder: (context, state) {
                          if (state is FollowersCountLoading) {
                            return const SizedBox(width: 80, height: 30, child: CircularProgressIndicator(strokeWidth: 2));
                          }
                          if (state is FollowersCountLoaded) {
                            return ElevatedButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => UniversityFollowersScreen(userId: widget.userId))),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 29, 97, 231),
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              ),
                              child: Text('${state.count} followers', style: const TextStyle(color: Colors.white, fontSize: 13)),
                            );
                          }
                          return const SizedBox(); // or retry button
                        },
                      ),
                      const SizedBox(width: 12),
                      BlocBuilder<UniversityFollowersFollowingBloc, UniversityFollowersFollowingState>(
                        builder: (context, state) {
                          if (state is FollowingCountLoading) {
                            return const SizedBox(width: 80, height: 30, child: CircularProgressIndicator(strokeWidth: 2));
                          }
                          if (state is FollowingCountLoaded) {
                            return ElevatedButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => UniversityFollowingScreen(userId: widget.userId))),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 29, 97, 231),
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              ),
                              child: Text('${state.count} alumni', style: const TextStyle(color: Colors.white, fontSize: 13)),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // --- Overview Section ---
                  if ((profile.about ?? '').isNotEmpty)
                    ExpandableSection(
                      title: 'Overview',
                      items: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            profile.about ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('No overview added', style: TextStyle(color: Colors.grey)),
                    ),

                  const SeeMoreDivider(),

                  // --- Page Posts as Activity Section ---
                  if (activityItems.isNotEmpty)
                    ExpandableSection(
                      title: 'Page Posts',
                      items: activityItems.map((act) {
                        final subtitle =
                            '${act.likeCount} likes • ${act.commentCount} comments • ${act.createdAt.toLocal().toString().split('.').first}';
                        return ActivityCard(
                          avatarUrl: profile.profilePic ?? ImageString.dummyImageUrl,
                          name: profile.collegeName ?? 'University',
                          subtitle: subtitle,
                          content: act.caption,
                        );
                      }).toList(),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('No page posts', style: TextStyle(color: Colors.grey)),
                    ),
                  const SizedBox(height: 100),
                ],
              );
            }
            developer.log('Unhandled state of UniversityPublicProfileBloc: $state');
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }


  List<ActivityItem> _getActivityFromProfile(UniversityPublicProfileEntity profile) {

    if (profile.activity != null && profile.activity!.isNotEmpty) {
      return profile.activity!.map((dynamic item) {

        return ActivityItem(
          caption: item['caption'] ?? 'No caption available.',
          likeCount: item['like_count'] ?? 0,
          commentCount: item['comment_count'] ?? 0,
          createdAt: DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now(),
        );
      }).toList();
    }
    return [
      ActivityItem(
        caption: 'India is currently home to 106 unicorn startups. Out of these at least 10 startups have a DTU alumni as its founder/co-founder. See more...',
        likeCount: 100,
        commentCount: 20,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

}

class ExpandableSection extends StatefulWidget {
  final String title;
  final List<Widget> items;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final visibleItems = expanded ? widget.items : widget.items.take(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(widget.title),
        ...visibleItems,
        if (widget.items.length > 1)
          GestureDetector(
            onTap: () => setState(() => expanded = !expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                expanded ? "See less" : "See more",
                style: const TextStyle(
                  color: Color.fromARGB(255, 29, 97, 231),
                ),
              ),
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String subtitle;
  final String content;

  const ActivityCard({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.subtitle,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), // Add margin for spacing between cards
      decoration: BoxDecoration(
        color: const Color(0xffFFFFFC),
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: (avatarUrl.isNotEmpty)
                      ? NetworkImage(Urls.getFullImageUrl(avatarUrl))
                      : null,
                  child: avatarUrl.isEmpty
                      ? const Icon(Icons.school, color: Colors.grey, size: 20)
                      : null,
                  onBackgroundImageError: (exception, stackTrace) {
                    developer.log('Error loading activity avatar: $exception');
                  },
                ),

                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert),
              ],
            ),
            const SizedBox(height: 8),
            Text(content, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionColumn(ImageString.likeIcon, 'Like'),
                _buildActionColumn(ImageString.commentIcon, 'Comment'),
                _buildActionColumn(ImageString.shareIcon, 'Share'),
                _buildActionColumn(ImageString.sendIcon, 'Send'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionColumn(String iconPath, String label) {
    return Column(
      children: [
        SvgPicture.asset(
          iconPath,
          colorFilter: const ColorFilter.mode(Color.fromARGB(255, 88, 92, 96), BlendMode.srcIn),
          height: 20,
          width: 20,
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 88, 92, 96),
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final List<String> subtitles;

  const InfoCard({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: const Color(0xffFFFFFC),
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                spreadRadius: 0,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ListTile(
            leading: leading,
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var subtitle in subtitles)
                  if (subtitle.isNotEmpty) Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                if (subtitles.length > 1) const SizedBox(height: 4),
              ],
            ),
            trailing: const Icon(Icons.more_vert),
          ),
        ),
      ],
    );
  }
}

class SeeMoreDivider extends StatelessWidget {
  const SeeMoreDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Divider(height: 32, thickness: 1, color: Colors.grey),
      ],
    );
  }
}
String _getHandleFromProfile(UniversityPublicProfileEntity profile) {
  if (profile.collegeName != null) {
    return profile.collegeName!.toLowerCase().replaceAll(' ', '_');
  }
  return 'university_handle';
}

String _getLocationFromPincode(String? pincode) {
  // Simple mapping - you can expand this
  if (pincode == null) return 'Delhi';
  if (pincode.startsWith('11')) return 'Delhi';
  if (pincode.startsWith('12')) return 'Haryana';
  if (pincode.startsWith('30')) return 'Punjab';
  return 'India';
}