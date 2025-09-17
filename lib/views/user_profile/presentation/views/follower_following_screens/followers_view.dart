import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_portal/utils/constants/image_string.dart';
import 'package:job_portal/views/user_profile/domain/entities/followers_entity.dart';
import 'package:job_portal/widgets/widgets.dart';

class FollowersView extends StatefulWidget {
  final FollowersEntity followersData;
  const FollowersView({super.key, required this.followersData});

  @override
  State<FollowersView> createState() => _FollowersViewState();
}

class _FollowersViewState extends State<FollowersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
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
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: SizedBox(
                  height: 75,
                  child: SearchTextField(
                    onTextChanged: (value) {
                      // Call your API here
                      print("API call for: $value");
                    },
                  ),
                ),
              ),
              const Row(
                children: [
                  ChoiceChip(text: 'All'),
                  SizedBox(
                    width: 10,
                  ),
                  ChoiceChip(text: 'Company'),
                  SizedBox(
                    width: 10,
                  ),
                  ChoiceChip(text: 'University'),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.followersData.count,
                itemBuilder: (context, index) {
                  final curr = widget.followersData.followers[index];
                  return FollowerCard(
                    followerName: "${curr.first_name} ${curr.last_name}",
                    followerProfilePhoto: 'photoUrl',
                    followerSkill: 'skill',
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChoiceChip extends StatefulWidget {
  final String text;
  const ChoiceChip({
    super.key,
    required this.text,
  });

  @override
  State<ChoiceChip> createState() => _ChoiceChipState();
}

class _ChoiceChipState extends State<ChoiceChip> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(239, 240, 246, 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "  ${widget.text}  ",
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}

class FollowerCard extends StatefulWidget {
  final String followerName;
  final String followerSkill;
  final String followerProfilePhoto;
  const FollowerCard({
    super.key,
    required this.followerName,
    required this.followerSkill,
    required this.followerProfilePhoto,
  });

  @override
  State<FollowerCard> createState() => _FollowerCardState();
}

class _FollowerCardState extends State<FollowerCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                ImageString.profileIcon,
                height: 40,
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.followerName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.followerSkill,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(108, 114, 120, 1),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 0.5,
                      color: Color.fromRGBO(29, 97, 231, 0.5),
                    ),
                    color: const Color.fromRGBO(29, 97, 231, 0.1)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Follows you',
                    style: TextStyle(
                      color: Color.fromRGBO(29, 97, 231, 1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}
