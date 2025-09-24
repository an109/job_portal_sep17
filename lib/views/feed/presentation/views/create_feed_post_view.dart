import 'dart:developer' as developer show log;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:job_portal/utils/upload_file_get_url/presentation/bloc/upload_file_bloc.dart';
import 'package:job_portal/utils/upload_file_get_url/presentation/bloc/upload_file_event.dart';
import 'package:job_portal/utils/upload_file_get_url/presentation/bloc/upload_file_state.dart';
import 'package:job_portal/views/feed/presentation/bloc/create_feed_post_bloc/create_feed_post_bloc.dart';
import 'package:job_portal/views/feed/presentation/bloc/create_feed_post_bloc/create_feed_post_event.dart';
import 'package:job_portal/views/feed/presentation/bloc/create_feed_post_bloc/create_feed_post_state.dart';
import 'package:job_portal/views/feed/presentation/bloc/feed_bloc/feed_bloc.dart';
import 'package:job_portal/views/feed/presentation/bloc/feed_bloc/feed_event.dart';
import 'package:job_portal/widgets/widgets.dart';

import '../../../../utils/constants/urls.dart';

class CreateFeedPostView extends StatefulWidget {
  const CreateFeedPostView({super.key});

  @override
  State<CreateFeedPostView> createState() => _CreateFeedPostViewState();
}

class _CreateFeedPostViewState extends State<CreateFeedPostView> {
  final _captionController = TextEditingController();

  XFile? imageFile;

  Future<void> onUploadPostImages() async {
    if (imageFile == null) return;

    final fileName = imageFile!.path.split('/').last;

    final formData = FormData.fromMap({
      'feedImage':
      await MultipartFile.fromFile(imageFile!.path, filename: fileName),
    });

    context.read<UploadFileBloc>().add(LoadUploadFile(formData));
  }

  Future<void> onUploadPost(String imageUrl) async {
    final _prefs = sl<PreferencesManager>();
    final user_id = _prefs.getUserId();

    final map = {
      "user_id": user_id ?? 16,
      "image": imageUrl,
      "caption": _captionController.text.trim()
    };

    context.read<CreateFeedPostBloc>().add(LoadCreateFeedPost(map));
  }

  @override
  Widget build(BuildContext context) {
    // Get responsive values
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                developer.log('start to pick images.');
                context
                    .read<CreateFeedPostBloc>()
                    .add(const PickImagesCreatePost());
              },
              icon: Icon(
                Icons.photo_outlined,
                color: Colors.grey[500],
                size: screenWidth * 0.06, // Responsive icon size
              )),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03, // Responsive padding
            ),
            child: InkWell(
              onTap: () {
                if (imageFile != null) {
                  onUploadPostImages();
                } else if (_captionController.text.trim().isNotEmpty) {
                  onUploadPost("http://example.com/image.jpg");
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 3, 36, 102)),
                    borderRadius: BorderRadius.circular(999),
                    color: const Color.fromARGB(255, 3, 36, 102)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04, // Responsive padding
                    vertical: screenHeight * 0.01, // Responsive padding
                  ),
                  child: Text(
                    'Post',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: screenWidth * 0.04, // Responsive font size
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  // Profile Picture
                  BlocBuilder<UploadFileBloc, UploadFileState>(
                    builder: (context, state) {
                      // Get user profile pic from preferences or API
                      final _prefs = sl<PreferencesManager>();
                      final profilePic = _prefs.getProfilePic() ?? ''; // Assuming you have this method

                      return
                        Container(
                          width: screenWidth * 0.1,
                          height: screenWidth * 0.1,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                          ),
                          child: FutureBuilder<String?>(
                            future: _loadUniversityProfilePic(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                );
                              }

                              final profilePicUrl = snapshot.data;

                              if (profilePicUrl != null && profilePicUrl.isNotEmpty) {
                                return ClipOval(
                                  child: Image.network(
                                    _getFullImageUrl(profilePicUrl),
                                    width: screenWidth * 0.1,
                                    height: screenWidth * 0.1,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildDefaultProfileIcon(screenWidth);
                                    },
                                  ),
                                );
                              } else {
                                return _buildDefaultProfileIcon(screenWidth);
                              }
                            },
                          ),
                        );
                    },
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  // User Name
                  Text(
                    'Your Name', // Replace with actual user name from preferences
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              BlocListener<CreateFeedPostBloc, CreateFeedPostState>(
                listener: (context, state) {
                  if (state is CreateFeedPostLoaded) {
                    final data = state.createFeedPostEntity;
                    showSnackbar(data.message, context);
                    Navigator.pop(context);
                  } else if (state is CreateFeedPostLoading) {
                    developer.log('Create feed post is loading.');
                  } else if (state is CreateFeedPostError) {
                    developer.log('Create feed post ended up in error.');
                  }
                },
                child: const SizedBox(),
              ),
              BlocListener<UploadFileBloc, UploadFileState>(
                listener: (context, state) {
                  if (state is UploadFileLoaded) {
                    final imageUrl = state.uploadFileEntity;
                    developer.log('Image url : ${imageUrl.url.first}');
                    onUploadPost(imageUrl.url.first);
                    context.read<FeedBloc>().add(const LoadFeedPosts('1', '10'));
                  } else if (state is UploadFileLoading) {
                    developer.log('Upload File Loading');
                  } else if (state is UploadFileError) {
                    developer.log('Upload File error');
                  }
                },
                child: const SizedBox(),
              ),
              TextFormField(
                controller: _captionController,
                maxLength: 255,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Share your thoughts...',
                  hintStyle: TextStyle(
                    fontSize: screenWidth * 0.045, // Responsive font size
                  ),
                ),
                maxLines: null,
                style: TextStyle(
                  fontSize: screenWidth * 0.045, // Responsive font size
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03, // Responsive spacing
              ),

              BlocBuilder<CreateFeedPostBloc, CreateFeedPostState>(
                  builder: (context, state) {
                    if (state is PickImagesCreatePostLoaded) {
                      developer.log('Images picked;');
                      final image = state.image;
                      imageFile = image;
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03), // Responsive border radius
                        child: Image.file(
                          File(image.path),
                          width: screenWidth * 0.9, // Responsive width
                          height: screenHeight * 0.3, // Responsive height
                          fit: BoxFit.cover,
                        ),
                      );
                    } else if (state is PickImagesCreatePostLoading) {
                      developer.log('Images loading;');
                      return SizedBox(
                        height: screenHeight * 0.3, // Consistent height
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is PickImagesCreatePostNoPhotoSelected) {
                      developer.log('no images selected');
                      return const SizedBox();
                    } else if (state is PickImagesCreatePostError) {
                      developer.log('error in picking images');
                      return SizedBox(
                        height: screenHeight * 0.1,
                        child: Center(
                          child: Text(
                            'Error loading image',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
String _getFullImageUrl(String url) {
  if (url.isEmpty) return '';
  if (url.startsWith('http')) return url;
  // Use your actual URL formatter
  return Urls.getFullImageUrl(url); // Changed this line
}

Future<String?> _loadUniversityProfilePic() async {
  final _prefs = sl<PreferencesManager>();

  // First try to get the relative path from university profile
  final relativePath = _prefs.getString('university_profile_pic_url');
  if (relativePath != null && relativePath.isNotEmpty) {
    developer.log('Loaded university profile pic: $relativePath');
    return relativePath;
  }

  // Fallback to regular user profile pic
  final userProfilePic = _prefs.getProfilePic();
  if (userProfilePic != null && userProfilePic.isNotEmpty) {
    developer.log('Loaded user profile pic: $userProfilePic');
    return userProfilePic;
  }

  developer.log('No profile picture found');
  return null;
}
Widget _buildDefaultProfileIcon(double screenWidth) {
  return Icon(
    Icons.school, // Use school icon for university, or Icons.person for user
    size: screenWidth * 0.05,
    color: Colors.grey,
  );
}