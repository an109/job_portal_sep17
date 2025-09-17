import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:job_portal/utils/upload_file_get_url/domain/usecases/upload_file_usecase.dart';
import 'package:job_portal/views/Recruiter_Profile_Screens/presentation/bloc/Recruiter_update_profile_bloc.dart';
import 'package:job_portal/views/Recruiter_Profile_Screens/presentation/bloc/Recruiter_update_profile_event.dart';
import 'package:job_portal/views/Recruiter_Profile_Screens/presentation/bloc/Recruiter_update_profile_state.dart';
import '../../ui_helper/ui_helper.dart';
import '../user_profile/presentation/views/User_Notifications_Screen.dart';
import '../user_profile/presentation/views/User_messages_screen.dart';
import 'Recruiter_GST_Auth_Screen.dart';

class RecruiterProfileScreen2 extends StatefulWidget {
  @override
  _RecruiterProfileScreen2State createState() => _RecruiterProfileScreen2State();
}

class _RecruiterProfileScreen2State extends State<RecruiterProfileScreen2> {

  String _aboutText = "Lead Recruiter, Flipkart, Bangalore, India";
  String _contactText = "+91XXXXXXXXX, email:";
  String _languagesText = "Hindi, English";
  List<String> _hiringPreferences = ["Design", "Tech", "Sales", "SEO"];
  String _profilePicPath = ""; // Will hold uploaded image URL
  String PREF_ABOUT = 'recruiter_about';
  String PREF_CONTACT = 'recruiter_contact';
  String PREF_LANGUAGES = 'recruiter_languages';
  String PREF_HIRING_PREFS = 'recruiter_hiring_prefs';
  String PREF_PROFILE_PIC = 'recruiter_profile_pic';

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = sl<PreferencesManager>();

    setState(() {
      _aboutText = prefs.getString(PREF_ABOUT) ?? "Lead Recruiter, Flipkart, Bangalore, India";
      _contactText = prefs.getString(PREF_CONTACT) ?? "+91XXXXXXXXX, email:";
      _languagesText = prefs.getString(PREF_LANGUAGES) ?? "Hindi, English";
      final hiringPrefs = prefs.getString(PREF_HIRING_PREFS);
      _hiringPreferences = hiringPrefs?.split(',') ?? ["Design", "Tech", "Sales", "SEO"];
      _profilePicPath = prefs.getString(PREF_PROFILE_PIC) ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefs = sl<PreferencesManager>();
    final userName = prefs.getString(PreferencesManager.USER_NAME) ?? 'Recruiter Name';
    final userEmail = prefs.getString(PreferencesManager.USER_EMAIL) ?? 'recruiter@email.com';

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back),
        ),
        actions: [
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MessagesScreen())),
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/message_icon.svg"),
            ),
          ),
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsScreen())),
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/notifications_icon.svg"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    height: 88,
                    width: 64,
                    child: _profilePicPath.isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(_profilePicPath, fit: BoxFit.cover),
                    )
                        : SvgPicture.asset("assets/Icons/profile_icon.svg"),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
                          ],
                        ),
                        child: Icon(Icons.edit, size: 16, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              userName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Text(
              userEmail,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 52),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("About", style: mTextStyle16(mColor: Colors.black)),
                  SizedBox(height: 5),
                  BlocBuilder<RecruiterUpdateProfileBloc, RecruiterUpdateProfileState>(
                    builder: (context, state) {
                      if (state is SuccessState) {

                        Future.delayed(Duration(seconds: 2), () {
                          context.read<RecruiterUpdateProfileBloc>().add(InitialEvent());
                        });
                      } else if (state is ErrorState) {
                        Future.delayed(Duration(seconds: 2), () {
                          context.read<RecruiterUpdateProfileBloc>().add(InitialEvent());
                        });
                      }

                      return Text(
                        _aboutText,
                        style: mTextStyle14(mColor: Color(0xff9095A0)),
                      );
                    },
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _showEditAboutDialog(context, _aboutText),
                        child: Text("View / Edit About", style: mTextStyle14(mColor: AppColors.blueTextColor)),
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  Text("Contact Information", style: mTextStyle16(mColor: Colors.black)),
                  SizedBox(height: 5),
                  Text(_contactText, style: mTextStyle14(mColor: Color(0xff9095A0))),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _showEditContactDialog(context, _contactText),
                        child: Text("View / Edit Contact", style: mTextStyle14(mColor: AppColors.blueTextColor)),
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Languages you know", style: mTextStyle16(mColor: Colors.black)),
                      SizedBox(height: 5),
                      Text(_languagesText, style: mTextStyle14(mColor: Color(0xff9095A0))),
                      SizedBox(height: 3),
                      Row(
                        children: [
                          InkWell(
                            onTap: () => _showEditLanguagesDialog(context, _languagesText),
                            child: Text("View / Edit Languages", style: mTextStyle14(mColor: AppColors.blueTextColor)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  profileSection(
                    title: "Hiring Preferences",
                    items: _hiringPreferences,
                    onEditTap: () => _showEditHiringPreferencesDialog(context, _hiringPreferences.join(", ")),
                    editText: "Edit Hiring Preferences",
                  ),
                  SizedBox(height: 4),
                  profileSection(
                    title: "Authentication",
                    items: ["Email", "Phone No.", "Aadhar"],
                    onEditTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecruiterGSTAUTH_Screen()),
                      );
                    },
                    editText: "Get Verified",
                    isGetVerified: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditAboutDialog(BuildContext context, String currentAbout) {
    final aboutController = TextEditingController(text: currentAbout);

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) => AlertDialog(
        title: Text("Edit About"),
        content: TextField(
          autofocus: true,
          controller: aboutController,
          decoration: InputDecoration(
            hintText: "Enter your about text",
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final updatedAbout = aboutController.text.trim();
              if (updatedAbout.isNotEmpty) {
                setState(() {
                  _aboutText = updatedAbout;
                });

                sl<PreferencesManager>().setString(PREF_ABOUT, updatedAbout);
                _updateProfile(context, about: updatedAbout);
              }
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showEditContactDialog(BuildContext context, String currentContact) {
    final contactController = TextEditingController(text: currentContact);

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) => AlertDialog(
        title: Text("Edit Contact"),
        content: TextField(
          autofocus: true,
          controller: contactController,
          decoration: InputDecoration(
            hintText: "Enter contact info",
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final updatedContact = contactController.text.trim();
              if (updatedContact.isNotEmpty) {
                setState(() {
                  _contactText = updatedContact;
                });

                sl<PreferencesManager>().setString(PREF_CONTACT, updatedContact);
                // _updateProfile(context, hiringPreferences: updatedContact);
              }
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showEditLanguagesDialog(BuildContext context, String currentLanguages) {
    final languagesController = TextEditingController(text: currentLanguages);

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) => AlertDialog(
        title: Text("Edit Languages"),
        content: TextField(
          autofocus: true,
          controller: languagesController,
          decoration: InputDecoration(
            hintText: "Enter languages (comma separated)",
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final updatedLanguages = languagesController.text.trim();
              if (updatedLanguages.isNotEmpty) {
                setState(() {
                  _languagesText = updatedLanguages;
                });

                sl<PreferencesManager>().setString(PREF_LANGUAGES, updatedLanguages);
                _updateProfile(context, languages: updatedLanguages);
              }
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showEditHiringPreferencesDialog(BuildContext context, String currentPrefs) {
    final prefsController = TextEditingController(text: currentPrefs);

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) => AlertDialog(
        title: Text("Edit Hiring Preferences"),
        content: TextField(
          autofocus: true,
          controller: prefsController,
          decoration: InputDecoration(
            hintText: "Enter preferences (comma separated)",
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final updatedPrefs = prefsController.text.trim();
              if (updatedPrefs.isNotEmpty) {
                setState(() {
                  _hiringPreferences = updatedPrefs.split(',').map((e) => e.trim()).toList();
                });
                //  Save to SharedPreferences
                sl<PreferencesManager>().setString(PREF_HIRING_PREFS, updatedPrefs);
                _updateProfile(context, hiringPreferences: updatedPrefs);
              }
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _updateProfile(BuildContext context, {String? about, String? hiringPreferences, String? languages}) {
    logUpdate("Updating profile: about=$about, hiringPreferences=$hiringPreferences, languages=$languages");

    final languageIds = _mapLanguagesToIds(languages ?? _languagesText);

    context.read<RecruiterUpdateProfileBloc>().add(
      UpdateProfileEvent(
        about: about ?? _aboutText,
        hiringPreferences: hiringPreferences ?? _hiringPreferences.join(", "),
        languages: languages ?? _languagesText,
        languageIds: languageIds, contact: '',
      ),
    );
  }

  List<int> _mapLanguagesToIds(String languages) {
    final Map<String, int> langMap = {
      'Hindi': 1,
      'English': 2,
      'Spanish': 3,
      'French': 4,
      'German': 5,
      'Chinese': 6,
      'Japanese': 7,
      'Korean': 8,
      'Arabic': 9,
      'Russian': 10,
    };

    final ids = languages
        .split(',')
        .map((lang) => lang.trim())
        .where((lang) => langMap.containsKey(lang))
        .map((lang) => langMap[lang]!)
        .toList();

    logUpdate("Mapped languages '$languages' to IDs: $ids");
    return ids;
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      logUpdate("Image picked: ${file.path}");

      try {
        final uploadUseCase = sl<UploadFileUsecase>();

        // Create FormData
        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
        });

        final response = await uploadUseCase.call(params: {'formdata': formData});
        const String baseUrl = "https://leafyscape.com/api/";

        if (response != null && response.data != null && response.data!.url.isNotEmpty) {
          String uploadedUrl = response.data!.url[0].toString();

          // Fix: prepend base URL if only relative path is returned
          if (!uploadedUrl.startsWith("http")) {
            uploadedUrl = "$baseUrl$uploadedUrl";
          }

          setState(() {
            _profilePicPath = uploadedUrl;
          });

          logUpdate("Image uploaded successfully: $uploadedUrl");
        }


        // if (response != null && response.data != null && response.data!.url.isNotEmpty) {
        //   // Extract first URL from list
        //   final uploadedUrl = response.data!.url[0].toString();
        //
        //   setState(() {
        //     _profilePicPath = uploadedUrl;
        //   });
        //
        //   logUpdate("Image uploaded successfully: $uploadedUrl");
        //
        //   // Optional: Send to profile API
        //   //  _updateProfile(context, profilePic: uploadedUrl);
        // }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to upload image")),
          );
          logUpdate("Upload failed: No URL returned");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload error: $e")),
        );
        logUpdate("Upload exception: $e");
      }
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: $error"),
        backgroundColor: Colors.red,
      ),
    );
  }

  void logUpdate(String message) {
    print("[RecruiterProfileUpdate] $message");
    // You can also log to file or remote service here
  }
}

/// Widget for common Column

Widget profileSection({
  required String title,
  required List<String> items,
  required VoidCallback onEditTap,
  required String editText,
  bool isGetVerified = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 18),
      Text(
        title,
        style: mTextStyle16(mColor: Colors.black),
      ),
      SizedBox(height: 5),
      Wrap(
        spacing: 11,
        runSpacing: 8,
        children: items.map((item) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                color: item == items.first ? Colors.green : Colors.red,
                size: 8,
              ),
              SizedBox(width: 4),
              Text(
                item,
                style: mTextStyle14(mColor: Color(0xff9095A0)),
              ),
            ],
          );
        }).toList(),
      ),
      SizedBox(height: 6),
      Row(
        children: [
          InkWell(
            onTap: onEditTap,
            child: Text(
              isGetVerified ? editText : "View / ",
              style: mTextStyle14(mColor: AppColors.blueTextColor),
            ),
          ),
          if (!isGetVerified)
            InkWell(
              onTap: onEditTap,
              child: Text(
                editText,
                style: mTextStyle14(
                  mColor: AppColors.blueTextColor,
                  mFontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    ],
  );
}