import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';
import '../../../user_profile/presentation/views/User_messages_screen.dart';
import '../../../feed/presentation/views/feed_view.dart';
import 'job_details_view.dart';
import '../../../../ui_helper/ui_helper.dart';
import '../../../../widgets/widgets.dart';

class FeedScreen2 extends StatefulWidget {
  final VoidCallback? onBack;
  FeedScreen2({this.onBack});

  @override
  State<FeedScreen2> createState() => _FeedScreen2State();
}

class _FeedScreen2State extends State<FeedScreen2> {
  TextEditingController fSearchController = TextEditingController();
  TextEditingController sendController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "LOGO",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w700,
                    color: TColors.primary),
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MessagesScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: SvgPicture.asset("assets/Icons/message_icon.svg"),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child:
                      SvgPicture.asset("assets/Icons/notifications_icon.svg"),
                ),
              ),
            ]),
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(children: [
                  Row(
                    children: [
                      SizedBox(
                          width: 330,
                          child: CustomTextField(
                            controller: fSearchController,
                            hintText: "Search",
                            suffixIcon: Icons.search,
                            fillColor: Colors.white,
                          )),
                      Spacer(),
                      SvgPicture.asset("assets/Icons/settings-sliders 1.svg")
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height: 56,
                            width: 56,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: Image.network(
                                  "https://img.freepik.com/free-photo/portrait-white-man-isolated_53876-40306.jpg",
                                  fit: BoxFit.cover,
                                ))),
                        Spacer(),
                        SizedBox(
                            width: 270,
                            child: CustomTextField(
                              controller: sendController,
                              hintText: "Share something...",
                              fillColor: Colors.white,
                              suffixIcon: Icons.send,
                              onSuffixTap: () {},
                            ))

                        /* Container(
                      height: 46,
                      width: 290,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xffEDF1F3), width: 2)
                      ),
                    )*/
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset("assets/Icons/Image icon.svg"),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: () {},
                          child: Text(
                            "Add Media",
                            style: mTextStyle12(),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  FeedCard(
                    like_count: 1,
                    feedPostId: '2',
                    slug: 'demo-post-1',
                    bodyText:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ',
                    imageUrl:
                        "https://static-00.iconduck.com/assets.00/uber-icon-1024x1024-4icncyyo.png",
                    company: "Uber",
                    posted: "2 days",
                    noFollowers: "123,456 followers",
                    mainImage: "assets/Images/uber_driver.jpg",
                    initialLiked: false,
                    onCommentTap: () {},
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Color(0xffEDF1F3))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                  height: 36,
                                  width: 36,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Image.network(
                                        "https://img.freepik.com/free-photo/portrait-white-man-isolated_53876-40306.jpg",
                                        fit: BoxFit.cover,
                                      ))),
                              SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rohan",
                                    style: mTextStyle14(),
                                  ),
                                  Text(
                                    "Digital Marketer @Uber",
                                    style: mTextStyle12(),
                                  )
                                ],
                              ),
                              Spacer(),
                              Icon(Icons.more_vert)
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                              width: 60,
                              child: greyContainer(
                                  text: "3 days", bgColor: Color(0xffEFF0F6))),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              "Hey! Just started a new project.Check the link in my profile and comment your suggestions. see more..."),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              iconNamePair(
                                  imgUrl: "assets/Icons/All_the_best_icon.svg",
                                  iconName: "Like"),
                              iconNamePair(
                                  imgUrl: "assets/Icons/messenger.svg",
                                  iconName: "Comment"),
                              iconNamePair(
                                  imgUrl: "assets/Icons/share_icon.svg",
                                  iconName: "Share"),
                              iconNamePair(
                                  imgUrl: "assets/Icons/send_icon.svg",
                                  iconName: "Send")
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ])),
          ),
        ));
  }
}

/// Widget for Icon and its name
Widget iconNamePair({required String imgUrl, required String iconName}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SvgPicture.asset(imgUrl, height: 15),
      SizedBox(height: 4),
      Text(iconName, style: TextStyle(fontSize: 12)),
    ],
  );
}
