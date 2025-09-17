import 'dart:developer' as developer show log;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/utils/constants/image_string.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:job_portal/views/user_profile/domain/entities/public_profile_entity.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/profile_bloc/profile_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/profile_bloc/profile_state.dart';
import 'package:job_portal/views/user_profile/presentation/views/User_Notifications_Screen.dart';
import 'package:job_portal/views/user_profile/presentation/views/User_messages_screen.dart';
import 'package:job_portal/views/user_profile/presentation/views/follower_following_screens/followers_view.dart';
import 'package:job_portal/views/user_profile/presentation/views/follower_following_screens/following_view.dart';

class UserPublicProfileScreen extends StatefulWidget {
  final bool selfProfile;
  final UserProfileEntity userProfile;
  const UserPublicProfileScreen(
      {super.key, required this.userProfile, required this.selfProfile});

  @override
  State<UserPublicProfileScreen> createState() =>
      _UserPublicProfileScreenState();
}

class _UserPublicProfileScreenState extends State<UserPublicProfileScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    final _prefs = sl<PreferencesManager>();

    final user_id = _prefs.getUserId();

    final bloc = context.read<ProfileBloc>();
    bloc.add(LoadPublicProfileWithFollowersAndFollowing(user_id ?? '77'));
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: SvgPicture.asset(
          ImageString.jobPortalLogo,
          height: 30,
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MessagesScreen()));
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
                      builder: (context) => const NotificationsScreen()));
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
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is PublicProfileWithFollowersAndFollowingLoaded) {
              final profileData = state.publicProfile;
              final followerData = state.followersEntity;
              final followingData = state.followingEntity;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none, // <--- allow overflow
                    alignment: Alignment.bottomLeft,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          ImageString.dummyImageUrl,
                          height: 125,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: -20, // this overlaps below the image
                        left: 16,
                        child: SvgPicture.asset(
                          ImageString.profileIcon,
                          height: 80,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: 20), // Add space after to avoid layout jump

                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${profileData.publicProfile.first_name} ${profileData.publicProfile.last_name}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            const SizedBox(height: 4),
                            Text(
                                '@${profileData.publicProfile.first_name.toLowerCase()}',
                                style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 8),
                            Text(profileData.publicProfile.user_type.isNotEmpty
                                ? profileData.publicProfile.user_type
                                : '—'),
                            const SizedBox(height: 4),
                            Text(
                              profileData.publicProfile.about_us,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      !widget.selfProfile
                          ? ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .transparent, // transparent background
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                elevation: 0,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                side: const BorderSide(
                                  // blue border
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
                            )
                          : const SizedBox()
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FollowersView(
                                followersData: followerData,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 29, 97, 231),
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6), // Slimmer padding
                          elevation: 0, // optional: flat modern look
                          minimumSize: Size.zero, // removes min size constraint
                          tapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, // tighter tap area
                        ),
                        child: Text(
                          '${followerData.count} followers',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13, // smaller font for a sleeker look
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
                              builder: (context) => FollowingView(
                                followingData: followingData,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 29, 97, 231),
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6), // Slimmer padding
                          elevation: 0, // optional: flat modern look
                          minimumSize: Size.zero, // removes min size constraint
                          tapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, // tighter tap area
                        ),
                        child: Text(
                          '${followingData.count} following',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13, // smaller font for a sleeker look
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  // const SectionTitle('Your Activity'),
                  if (profileData.activity.isNotEmpty)
                    ExpandableSection(
                      title: 'Your Activity',
                      items: profileData.activity.map((act) {
                        final subtitle =
                            '${act.like_count} likes • ${act.comment_count} comments • ${act.created_at.toLocal().toString().split('.').first}';
                        return ActivityCard(
                          avatarUrl: ImageString.dummyImageUrl,
                          name:
                              '${profileData.publicProfile.first_name} ${profileData.publicProfile.last_name}',
                          subtitle: subtitle,
                          content: act.caption,
                        );
                      }).toList(),
                    )
                  else
                    const Text('No recent activity'),
                  const SeeMoreDivider(),
                  // const SectionTitle('Work Experience'),
                  if (profileData.experiences.isNotEmpty)
                    ExpandableSection(
                      title: 'Work Experience',
                      items: profileData.experiences.map((exp) {
                        return InfoCard(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Icon(Icons.work, color: Colors.white),
                          ),
                          title: exp.current_job_role,
                          subtitles: [
                            exp.current_company,
                            if (exp.status.isNotEmpty) exp.status,
                            if (exp.totalExperience.isNotEmpty)
                              'Experience: ${exp.totalExperience}',
                          ],
                        );
                      }).toList(),
                    )
                  else
                    const Text('No work experience added'),
                  const SeeMoreDivider(),
                  // const SectionTitle('Skills'),
                  if (profileData.skills.isNotEmpty)
                    ExpandableSection(
                      title: 'Skills',
                      items: profileData.skills.map((skill) {
                        final subtitles = <String>[];
                        if (skill.subSkills.isNotEmpty) {
                          subtitles
                              .add('Skills: ${skill.subSkills.join(', ')}');
                        }
                        if (skill.authority.isNotEmpty) {
                          subtitles
                              .add('Authority: ${skill.authority.join(', ')}');
                        }
                        return InfoCard(
                          leading: const Icon(Icons.design_services_outlined,
                              color: Colors.purple),
                          title:
                              skill.domain.isNotEmpty ? skill.domain : 'Skill',
                          subtitles: subtitles,
                        );
                      }).toList(),
                    )
                  else
                    const Text('No skills added'),

                  // SeeMoreDivider(),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              );
            } else if (state is PublicProfileWithFollowersAndFollowingLoading) {
              developer.log(
                  'Public profile is loading with folllowers and following.');
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PublicProfileWithFollowersAndFollowingError) {
              developer.log(
                  'Public profile with folllowers and following ended up in error.');
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              developer.log('Unhandeled state of Profile Bloc : $state');
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
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
    final visibleItems =
        expanded ? widget.items : widget.items.take(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(widget.title),
        ...visibleItems,
        if (widget.items.length > 1)
          GestureDetector(
            onTap: () {
              setState(() => expanded = !expanded);
            },
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
      child: Text(title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  backgroundImage: NetworkImage(avatarUrl),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(subtitle),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.more_vert),
              ],
            ),
            const SizedBox(height: 8),
            Text(content),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    // Icon(Icons.thumb_up_alt_outlined),

                    SvgPicture.asset(
                      ImageString.likeIcon,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Like',
                      style: TextStyle(
                        color: Color.fromARGB(255, 88, 92, 96),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    // Icon(Icons.comment),
                    SvgPicture.asset(
                      ImageString.commentIcon,
                      color: const Color.fromARGB(255, 88, 92, 96),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    const Text(
                      'Comment',
                      style: TextStyle(
                          color: Color.fromARGB(255, 88, 92, 96),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  children: [
                    // Icon(Icons.share),
                    SvgPicture.asset(
                      ImageString.shareIcon,
                      color: const Color.fromARGB(255, 88, 92, 96),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    const Text(
                      'Share',
                      style: TextStyle(
                          color: Color.fromARGB(255, 88, 92, 96),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  children: [
                    // Icon(Icons.send),
                    SvgPicture.asset(
                      ImageString.sendIcon,
                      color: const Color.fromARGB(255, 88, 92, 96),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    const Text(
                      'Send',
                      style: TextStyle(
                          color: Color.fromARGB(255, 88, 92, 96),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
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
            title: Text(title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var subtitle in subtitles) Text(subtitle),
                if (subtitles.length > 1) const SizedBox(height: 4),
              ],
            ),
            trailing: const Icon(Icons.more_vert),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class SeeMoreDivider extends StatelessWidget {
  const SeeMoreDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TextButton(
        //     onPressed: () {},
        //     child: const Text(
        //       "See more",
        //       style: TextStyle(
        //         color: Color.fromARGB(255, 29, 97, 231),
        //       ),
        //     )),
        Divider()
      ],
    );
  }
}
