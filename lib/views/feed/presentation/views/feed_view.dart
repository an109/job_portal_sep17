import 'dart:developer' as developer show log;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/utils/constants/image_string.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:job_portal/views/feed/data/models/feed_response.dart';
import 'package:job_portal/views/feed/presentation/views/create_feed_post_view.dart';
import 'package:job_portal/views/user_profile/presentation/views/User_Notifications_Screen.dart';
import 'package:job_portal/views/feed/domain/entities/feed_entity.dart';
import 'package:job_portal/views/feed/presentation/bloc/feed_bloc/feed_bloc.dart';
import 'package:job_portal/views/feed/presentation/bloc/feed_bloc/feed_event.dart';
import 'package:job_portal/views/feed/presentation/bloc/feed_bloc/feed_state.dart';
import 'package:job_portal/views/job_related/presentation/views/Feed_Screen_2.dart';
import '../../../../ui_helper/ui_helper.dart';
import '../../../../utils/constants/urls.dart';
import '../../../../widgets/widgets.dart';
import '../../../user_profile/presentation/views/User_messages_screen.dart';
import '../../../job_related/presentation/views/job_details_view.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:share_plus/share_plus.dart';

class FeedScreen extends StatefulWidget {
  final bool showFeed2;
  final VoidCallback? onCallBackFromFeed2;

  FeedScreen({this.onCallBackFromFeed2, this.showFeed2 = false});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  ScrollController _scrollController = ScrollController();

  TextEditingController feedSearchController = TextEditingController();
  String? activePostId;
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController newPostController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  int page = 1;
  int limit = 5;
  // FeedEntity? feedPostsData;
  List<PostEntity>? postList;
  List<PostEntity>? filteredPostList;

  List<Map<String, dynamic>> uList = [
    {
      "company_name": "Uber",
      "image":
          "https://static-00.iconduck.com/assets.00/uber-icon-1024x1024-4icncyyo.png",
      "posted": "2 days",
      "No_followers": "123,456 followers",
      "mainImage": "assets/Images/uber_driver.jpg"
    },
  ];

  String getPostedDaysAgo(String isoDateString) {
    final postDate = DateTime.parse(isoDateString).toLocal();
    final now = DateTime.now();
    final difference = now.difference(postDate);

    if (difference.inDays == 0) {
      if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${difference.inDays} days ago';
    }
  }



  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    final bloc = context.read<FeedBloc>();
    bloc.add(const LoadFeedPosts('1', '10'));
  }
  final token = PreferencesManager.instance.getToken();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _commentFocusNode.addListener(() {
      if (!_commentFocusNode.hasFocus) {
        setState(() => activePostId = null);
      }
    });

    page = 1;

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        developer.log('At bottom');
        context
            .read<FeedBloc>()
            .add(LoadFeedPosts(page.toString(), limit.toString()));
      } else {
        developer.log('At top');
      }
    });
  }

  void commentBottomSheet(List<CommentEntity> comments) {
    TextEditingController _commentController = TextEditingController();

    // Make a local copy of comments so we can update it
    List<CommentEntity> commentList = List.from(comments);

    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      builder: (context) {
        return StatefulBuilder(builder: (context, setSheetState) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.80,
            child: DraggableScrollableSheet(
              initialChildSize: 1,
              minChildSize: 1,
              maxChildSize: 1,
              expand: false,
              builder: (_, controller) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '___________',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 18),
                      ),

                      // Scrollable comment list
                      Expanded(
                        child: commentList.isNotEmpty
                            ? ListView.builder(
                                controller: controller,
                                padding: const EdgeInsets.only(bottom: 70),
                                itemCount: commentList.length,
                                itemBuilder: (_, index) {
                                  final curr = commentList[index];
                                  return ListTile(
                                    title: Text(
                                      '${curr.first_name}_${curr.user_id}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(curr.comment),
                                    // leading: const Icon(Icons.person_sharp),
                                    // leading: const CircleAvatar(
                                    //   backgroundColor: Colors.transparent,
                                    //   backgroundImage: NetworkImage(
                                    //       ImageString.dummyImageUrl),
                                    // ),
                                    leading: SvgPicture.asset(
                                      ImageString.profileIcon,
                                      height: 40,
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: Text(
                                  'Be the first one to comment...',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                      ),

                      // Sticky TextField at bottom
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                          left: 12,
                          right: 12,
                          top: 8,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _commentController,
                                    decoration: InputDecoration(
                                      hintText: 'Write a comment...',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(90),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon:
                                      const Icon(Icons.send, color: Colors.red),
                                  onPressed: () {
                                    final text = _commentController.text.trim();
                                    if (text.isNotEmpty) {
                                      final _prefs = sl<PreferencesManager>();
                                      final user_id = _prefs.getUserId();

                                      /// 🆕 Update UI immediately
                                      setSheetState(() {
                                        commentList.insert(
                                          0,
                                          CommentEntity(
                                              user_id: user_id ?? '2',
                                              comment: text,
                                              created_at: DateTime.now(),
                                              first_name: 'You',
                                              last_name: 'Last Name',
                                              profile_pic: 'profile picture'),
                                        );
                                      });

                                      // Fire API call as before
                                      context.read<FeedBloc>().add(
                                            LoadFeedPostComment(
                                              activePostId ?? '2',
                                              {
                                                "user_id": user_id ?? "2",
                                                "comment": text,
                                              },
                                            ),
                                          );

                                      _commentController.clear();
                                      FocusScope.of(context).unfocus();
                                    }
                                  },
                                )
                              ],
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showFeed2) {
      return FeedScreen2(onBack: widget.onCallBackFromFeed2);
    }

    return RefreshIndicator(
      onRefresh: () async {
        page = 1;
        context.read<FeedBloc>().add(LoadFeedPosts('1', limit.toString()));

        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: SvgPicture.asset(
              ImageString.jobPortalLogo,
              height: 30,
              // width: 40,
              fit: BoxFit.contain,
              allowDrawingOutsideViewBox: true, // optional
            ),
            // child: Image.asset(ImageString.pngLogo),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MessagesScreen(),
                  ),
                );
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
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: SvgPicture.asset("assets/Icons/notifications_icon.svg"),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                BlocListener<FeedBloc, FeedState>(
                  listener: (context, state) {
                    if (state is FeedPostsLoaded) {
                      final data = state.postEntity;
                      page += 1;
                      setState(() {
                        // feedPostsData = data;
                        postList = data;
                        filteredPostList = data;
                      });
                      // developer.log('Feed posts data : ${data.posts.first.id}');
                      developer.log('Feed posts data : ${data.first.id}');
                    } else if (state is FeedPostCommentLoaded) {
                      final data = state.feedPostCommentEntity;
                      developer.log('Comment successfully posted.');
                      showSnackbar(data.message, context);
                      _commentController.clear();
                      FocusScope.of(context).unfocus();
                      setState(() => activePostId = null);

                      // Reset page to 1 and reload
                      page = 1;
                      context
                          .read<FeedBloc>()
                          .add(LoadFeedPosts('1', limit.toString()));
                    } else if (state is FeedPostCommentLoading) {
                      developer.log('Commentting .');
                    } else if (state is FeedPostCommentError) {
                      developer.log('Comment posting error.');
                    }
                  },
                  child: const SizedBox(),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SearchTextField(
                        onTextChanged: (value) {
                          final query = value.toLowerCase();
                          if (query.isEmpty) {
                            setState(() {
                              filteredPostList = postList;
                            });
                          } else {
                            setState(() {
                              filteredPostList = postList?.where((post) {
                                final caption = post.caption.toLowerCase();
                                final username = post.user.first_name.toLowerCase();
                                return caption.contains(query) || username.contains(query);
                              }).toList();
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    SvgPicture.asset("assets/Icons/settings-sliders 1.svg")
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    // CircleAvatar(
                    //   child: Image.asset(ImageString.placeHolderImage),
                    // ),
                    Container(
                      // height: 88,
                      // width: 64,
                      child: SvgPicture.asset("assets/Icons/profile_icon.svg"),
                    ),
                    const SizedBox(
                      width: 18,
                    ),
                    // Expanded(
                    //   child: CustomTextField(
                    //     controller: newPostController,
                    //     hintText: 'Share something...',
                    //   ),
                    // )
                    Expanded(
                        child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Share something...',
                        hintStyle:
                            TextStyle(color: Color.fromRGBO(188, 193, 202, 1)),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color.fromRGBO(237, 241, 243, 1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color.fromRGBO(237, 241, 243, 1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color.fromRGBO(237, 241, 243, 1),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color.fromRGBO(237, 241, 243, 1),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateFeedPostView(),
                          ),
                        );
                      },
                    )),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                // feedPostsData != null
                postList != null
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredPostList?.length,
                        padding: const EdgeInsets.only(bottom: 16),
                        itemBuilder: (context, index) {
                          // final item = uList[index];
                          // return Padding(
                          //   padding: const EdgeInsets.only(bottom: 20),
                          //   child: FeedCard(
                          //     // imageUrl: item["image"],
                          //     imageUrl: ImageString.dummyImageUrl,
                          //     company: item["company_name"],
                          //     posted: item["posted"],
                          //     noFollowers: item["No_followers"],
                          //     mainImage: item["mainImage"],
                          //   ),
                          // );

                          final item = filteredPostList?[index];
                          final feedPostId = item?.id ?? '2';
                          final slug = item?.slug ?? 'post-${item?.id}';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: FeedCard(
                              like_count: item!.like_count,
                              feedPostId: feedPostId.toString(),
                              slug: slug,
                              // imageUrl: item["image"],
                              imageUrl: ImageString.dummyImageUrl,
                              company: item!.user.first_name,
                              // posted: '1 day ago',
                              posted:
                                  getPostedDaysAgo(item.created_at.toString()),
                              bodyText: item.caption,
                              // bodyText:
                              //     'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.\n\nThe standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.',
                              noFollowers:
                                  "${item.user.followersCount} followers",
                              // mainImage: item.image,
                              mainImage: item.image,
                              // mainImage:  ImageString.placeHolderImage,
                              initialLiked: item.isLiked,
                              onCommentTap: () {
                                setState(
                                    () => activePostId = feedPostId.toString());
                                // FocusScope.of(context)
                                //     .requestFocus(_commentFocusNode);
                                // Delayed focus ensures TextField is built first
                                // WidgetsBinding.instance.addPostFrameCallback(
                                //   (_) {
                                //     FocusScope.of(context)
                                //         .requestFocus(_commentFocusNode);
                                //   },
                                // );
                                commentBottomSheet(item.comments);
                              },
                            ),
                          );
                        },
                      )
                    : const CircularProgressIndicator(),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// FEED CARD WIDGET
class FeedCard extends StatefulWidget {
  final String feedPostId;
  final String imageUrl, company, posted, noFollowers;
  final String? mainImage;
  final String bodyText;
  final bool initialLiked;
  final VoidCallback onCommentTap;
  final int like_count;
  final String slug;

  const FeedCard({
    super.key,
    required this.feedPostId,
    required this.imageUrl,
    required this.company,
    required this.posted,
    required this.noFollowers,
    this.mainImage,
    required this.bodyText,
    required this.initialLiked,
    required this.onCommentTap,
    required this.like_count,
    required this.slug,
  });

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  bool isExpanded = false;
  late bool liked;
  late int like_count;
  bool isOverflowing = false;

  final GlobalKey _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    liked = widget.initialLiked;
    like_count = widget.like_count;

    // Check if body text overflows after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  void _checkOverflow() {
    final renderBox = _textKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      final textPainter = TextPainter(
        text: TextSpan(
          text: widget.bodyText,
          style: mTextStyle12(
            mFontWeight: FontWeight.w400,
            mColor: const Color.fromARGB(255, 84, 76, 76),
          ),
        ),
        maxLines: 2,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(maxWidth: size.width);
      setState(() {
        isOverflowing = textPainter.didExceedMaxLines;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// First Row - Icon + Title + Company + Right Tags
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                ImageString.profileIcon,
                height: 40,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.company,
                        style: const TextStyle(color: Colors.grey)),
                    Text(widget.noFollowers),
                  ],
                ),
              ),
              const Icon(Icons.more_vert)
            ],
          ),
          const SizedBox(height: 12),

          /// Tags
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              greyContainer(
                text: widget.posted,
                bgColor: Colors.white,
                txtClr: Colors.grey[700],
                border: true,
              ),
              const SizedBox(width: 8),
              greyContainer(
                text: "Sponsored",
                bgColor: const Color(0xffEFF0F6),
              ),
            ],
          ),

          /// Optional Image
          if (widget.mainImage != null &&
              widget.mainImage != 'http://example.com/image.jpg' &&
              widget.mainImage != '')
            Padding(
              padding: const EdgeInsets.fromLTRB(2.0, 6.0, 2.0, 20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: FadeInImage.assetNetwork(
                  placeholder: ImageString.placeHolderImage,
                  placeholderColor: Colors.grey[400],
                  placeholderFit: BoxFit.cover,
                  image: Urls.getFullImageUrl(widget.mainImage),
                ),
              ),
            ),
          if (widget.mainImage == null ||
              widget.mainImage == 'http://example.com/image.jpg' ||
              widget.mainImage == '')
            const SizedBox(height: 20),

          /// Body Text with Read More
          AnimatedCrossFade(
            firstChild: Text(
              widget.bodyText,
              key: _textKey,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: mTextStyle12(
                mFontWeight: FontWeight.w400,
                mColor: const Color.fromARGB(255, 84, 76, 76),
              ),
            ),
            secondChild: Text(
              widget.bodyText,
              style: mTextStyle12(
                mFontWeight: FontWeight.w400,
                mColor: const Color.fromARGB(255, 84, 76, 76),
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),

          /// Read more / Read less button only if overflowing
          if (isOverflowing)
            GestureDetector(
              onTap: () => setState(() => isExpanded = !isExpanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  isExpanded ? "Read less..." : "Read more...",
                  style: mTextStyle12(
                    mColor: Colors.blue,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 10),

          /// Actions Row (Like / Comment / Share / Send)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  final _prefs = sl<PreferencesManager>();
                  final user_id = _prefs.getUserId();
                  if (liked) {
                    final map = {'user_id': user_id ?? '2', 'action': 'unlike'};
                    context
                        .read<FeedBloc>()
                        .add(LoadFeedPostLike(widget.feedPostId, map));
                  } else {
                    final map = {'user_id': user_id ?? '2', 'action': 'like'};
                    context
                        .read<FeedBloc>()
                        .add(LoadFeedPostLike(widget.feedPostId, map));
                  }
                  setState(() {
                    liked = !liked;
                    like_count += liked ? 1 : -1;
                  });
                },
                child: Column(
                  children: [
                    SvgPicture.asset(
                      ImageString.likeIcon,
                      color: liked
                          ? Colors.blue
                          : const Color.fromARGB(255, 88, 92, 96),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$like_count Like',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 88, 92, 96),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: widget.onCommentTap,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      ImageString.commentIcon,
                      color: const Color.fromARGB(255, 88, 92, 96),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Comment',
                      style: TextStyle(
                        color: Color.fromARGB(255, 88, 92, 96),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  //final baseUrl = "https://leafyscape.com/api/feed/post";
                  final baseUrl = "https://dummyUrl.com/api/feed/post";
                  final url = "$baseUrl/${widget.slug}";
                  developer.log('url: $url');
                  Share.share("Check out this post: $url");
                },
                child: Column(
                  children: [
                    SvgPicture.asset(
                      ImageString.shareIcon,
                      color: const Color.fromARGB(255, 88, 92, 96),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Share',
                      style: TextStyle(
                        color: Color.fromARGB(255, 88, 92, 96),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      ImageString.sendIcon,
                      color: const Color.fromARGB(255, 88, 92, 96),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Send',
                      style: TextStyle(
                        color: Color.fromARGB(255, 88, 92, 96),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

