import 'dart:io';

import 'package:dio/dio.dart'; // Import Dio for FormData
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Widgets/widgets.dart';
import '../../../../utils/constants/urls.dart';
import '../../../../utils/storage/shared_preference.dart';
import '../../../detailed_signup_student/presentation/bloc/master_data_bloc/master_data_bloc.dart';
import '../../../detailed_signup_student/presentation/bloc/master_data_bloc/master_data_event.dart';
import '../../../detailed_signup_student/presentation/bloc/master_data_bloc/master_data_state.dart';
import '../../../detailed_signup_student/domain/entities/metadata_entities.dart';

import '../../domain/entities/university_profile_entity.dart';
import '../bloc/university_profile_bloc.dart';
import '../bloc/university_profile_event.dart';
import '../bloc/university_profile_state.dart';

// Import for UploadFileBloc and its events/states
import '../../../../utils/upload_file_get_url/presentation/bloc/upload_file_bloc.dart';
import '../../../../utils/upload_file_get_url/presentation/bloc/upload_file_event.dart';
import '../../../../utils/upload_file_get_url/presentation/bloc/upload_file_state.dart';

final sl = GetIt.instance;

class UniversityProfilescreen2 extends StatefulWidget {
  @override
  _UniversityProfilescreen2State createState() => _UniversityProfilescreen2State();
}

class _UniversityProfilescreen2State extends State<UniversityProfilescreen2> {
  String _aboutText = "82 years of Tradition of excellence in Engineering.";
  String _contactInfo = "+91 XXXXXXXXXX - dtu@gmail.com";
  String _socialMedia = "www.instagram.com";
  String _universityName = "University Name";
  String _websiteLink = "www.dtu.ac.in";
  String _address = "Shahbad Daulatpur, Main Bawana Road";
  String _pincode = "110042";
  CourseEntity? _selectedCourse;
  File? _profileImage;
  String? _profilePicUrl; // <-- backend/full URL from API
  File? _logoImage; // <-- local file for university logo
  String? _logoUrl; // <-- backend/full URL from API for university logo

  final prefs = sl<PreferencesManager>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MasterDataBloc>().add(LoadMasterData());
      _loadProfileImage();
      _loadProfileData();
      _loadLogoImage();
    });
  }

  Future<void> _loadProfileData() async {
    final prefs = sl<PreferencesManager>();

    setState(() {
      _universityName = prefs.getString('university_name') ?? "University Name";

      _aboutText = prefs.getString('university_about') ?? _aboutText;
      _contactInfo = prefs.getString('university_contact') ?? _contactInfo;
      _socialMedia = prefs.getString('university_social_media') ?? _socialMedia; // Changed key
      _websiteLink = prefs.getString('university_website') ?? _websiteLink;
      _address = prefs.getString('university_address') ?? _address;
      _pincode = prefs.getString('university_pincode') ?? _pincode;
    });
  }

  Future<void> _loadProfileImage() async {
    final prefs = sl<PreferencesManager>();
    final savedImagePath = prefs.getString('university_profile_pic'); // This is for local file path

    if (savedImagePath != null && File(savedImagePath).existsSync()) {
      setState(() {
        _profileImage = File(savedImagePath); // local file
      });
    } else {
      // If no local file, try to load from backend URL
      final backendUrl = prefs.getString('university_profile_pic_url'); // This is the URL from the backend
      if (backendUrl != null && backendUrl.isNotEmpty) {
        setState(() {
          _profilePicUrl = Urls.getFullImageUrl(backendUrl); // Use full URL for NetworkImage
        });
      }
    }
  }
  // New: Load university logo image (similar to profile pic)
  Future<void> _loadLogoImage() async {
    final prefs = sl<PreferencesManager>();
    final savedLogoPath = prefs.getString('university_logo_pic'); // Local file path for logo

    if (savedLogoPath != null && File(savedLogoPath).existsSync()) {
      setState(() {
        _logoImage = File(savedLogoPath); // local file
      });
    } else {
      // If no local file, try to load from backend URL
      final backendLogoUrl = prefs.getString('university_logo_pic_url'); // Backend URL for logo
      if (backendLogoUrl != null && backendLogoUrl.isNotEmpty) {
        setState(() {
          _logoUrl = Urls.getFullImageUrl(backendLogoUrl); // Use full URL for NetworkImage
        });
      }
    }
  }

  Future<void> _saveAllProfileData() async {
    final prefs = sl<PreferencesManager>();

    // Save profile image path if exists (local path)
    if (_profileImage != null) {
      await prefs.setString('university_profile_pic', _profileImage!.path);
    }
    // The _profilePicUrl (from backend) is saved when the upload API returns it.
    // New: Save university logo local path if exists
    if (_logoImage != null) {
      await prefs.setString('university_logo_pic', _logoImage!.path);
    }
// The _logoUrl (from backend) is saved when the upload API returns it.

    // Save other profile fields
    await prefs.setString('university_about', _aboutText);
    await prefs.setString('university_contact', _contactInfo);
    await prefs.setString('university_social_media', _socialMedia); // Corrected key
    await prefs.setString('university_website', _websiteLink);
    await prefs.setString('university_address', _address);
    await prefs.setString('university_pincode', _pincode);
  }
  // New: Helper to clear all university profile data from shared preferences (call this on logout)
  Future<void> _clearUniversityProfileData() async {
    final prefs = sl<PreferencesManager>();
    await prefs.clear('university_profile_pic');
    await prefs.clear('university_profile_pic_url');
    await prefs.clear('university_logo_pic');
    await prefs.clear('university_logo_pic_url');
    await prefs.clear('university_name');
    await prefs.clear('university_about');
    await prefs.clear('university_contact');
    await prefs.clear('university_social_media');
    await prefs.clear('university_website');
    await prefs.clear('university_address');
    await prefs.clear('university_pincode');
    // Add more keys if needed (e.g., course selection)
    // Example usage in logout (in another file/bloc):
    // final prefs = sl<PreferencesManager>(); await prefs.remove('university_profile_pic'); // etc., or make this public/static
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<MasterDataBloc, MasterDataState>(
        listener: (context, state) {},
        builder: (context, masterState) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<UniversityProfileBloc>(
                create: (context) => sl<UniversityProfileBloc>(),
              ),
              // Provide the UploadFileBloc
              BlocProvider<UploadFileBloc>(
                create: (context) => sl<UploadFileBloc>(),
              ),
            ],
            child: BlocConsumer<UniversityProfileBloc, UniversityProfileState>(
              listener: (context, uniState) {
                if (uniState is UniversityProfileFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(uniState.message)),
                  );
                } else if (uniState is UniversityProfileSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('University profile updated successfully!')),
                  );
                }
              },
              builder: (context, uniState) {
                return BlocConsumer<UploadFileBloc, UploadFileState>(
                  listener: (context, uploadState) async {
                    if (uploadState is UploadFileLoaded) {
                      // Image uploaded successfully, save the URL
                      final uploadedUrls = uploadState.uploadFileEntity.url;
                      if (uploadedUrls.isNotEmpty) {
                        final newProfilePicUrl = uploadedUrls.first; // Assuming single image upload
                        setState(() {
                          _profilePicUrl = Urls.getFullImageUrl(newProfilePicUrl); // Update UI with new URL
                        });
                        // Save the backend URL to shared preferences
                        await prefs.setString('university_profile_pic_url', newProfilePicUrl);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Profile picture uploaded successfully!')),
                        );
                        // Trigger a profile save to update the backend with the new URL
                        _instantSave();
                      }
                    } else if (uploadState is UploadFileError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to upload profile picture.')),
                      );
                    }
                  },
                  builder: (context, uploadState) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          // University Logo/Image
                          Center(
                            child: Stack(
                              children: [
                                Container(
                                  height: 88,
                                  width: 88,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(75),
                                    image: _profileImage != null
                                        ? DecorationImage(
                                      image: FileImage(_profileImage!), // local file
                                      fit: BoxFit.cover,
                                    )
                                        : (_profilePicUrl != null && _profilePicUrl!.isNotEmpty
                                        ? DecorationImage(
                                      image: NetworkImage(_profilePicUrl!), // backend URL
                                      fit: BoxFit.cover,
                                    )
                                        : null),
                                  ),
                                  child: (_profileImage == null && (_profilePicUrl == null || _profilePicUrl!.isEmpty))
                                      ? Icon(
                                    Icons.school,
                                    size: 50,
                                    color: Colors.grey[600],
                                  )
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () async {
                                      final picker = ImagePicker();
                                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                      if (pickedFile != null) {
                                        setState(() {
                                          _profileImage = File(pickedFile.path); // Update local file for instant display
                                          _profilePicUrl = null; // Clear backend URL to show local file first
                                        });

                                        // Upload the image to the API
                                        final formData = FormData.fromMap({
                                          'image': await MultipartFile.fromFile(
                                            pickedFile.path,
                                            filename: pickedFile.name,
                                          ),
                                        });
                                        context.read<UploadFileBloc>().add(LoadUploadFile(formData, uploadType: 'university_profile_pic'));
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
                                        ],
                                      ),
                                      child: (uploadState is UploadFileLoading )
                                          ? SizedBox(
                                        height: 14,
                                        width: 14,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                          : Icon(Icons.edit, size: 14, color: Colors.blue),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // University Name
                          SizedBox(height: 16),
                          Text(
                            prefs.getString('university_name') ?? "Delhi Technological University",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),

                          // University Handle
                          Text(
                            "@${prefs.getString('university_name')?.toLowerCase().replaceAll(' ', '') ?? "dtudelhi"}",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                          ),

                          SizedBox(height: 52),

                          // Profile Sections
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildProfileSection(
                                  title: "About",
                                  content: _aboutText,
                                  editText: "View/Edit About",
                                  onEdit: () => _showEditDialog(
                                    "Edit About",
                                    _aboutText,
                                        (value) {
                                      setState(() => _aboutText = value);
                                      _instantSave();
                                    },
                                  ),
                                ),

                                SizedBox(height: 18),

                                _buildProfileSection(
                                  title: "Contact Information",
                                  content: _contactInfo,
                                  editText: "Edit Info",
                                  onEdit: () => _showEditDialog(
                                    "Edit Contact Information",
                                    _contactInfo,
                                        (value) {
                                      setState(() => _contactInfo = value);
                                      _instantSave();
                                    },
                                  ),
                                ),

                                SizedBox(height: 18),

                                _buildProfileSection(
                                  title: "Website",
                                  content: _websiteLink,
                                  editText: "Edit Website",
                                  onEdit: () => _showEditDialog(
                                    "Edit Website",
                                    _websiteLink,
                                        (value) {
                                      setState(() => _websiteLink = value);
                                      _instantSave();
                                    },
                                  ),
                                ),

                                SizedBox(height: 18),

                                _buildProfileSection(
                                  title: "Address",
                                  content: _address,
                                  editText: "Edit Address",
                                  onEdit: () => _showEditDialog(
                                    "Edit Address",
                                    _address,
                                        (value) {
                                      setState(() => _address = value);
                                      _instantSave();
                                    },
                                  ),
                                ),

                                SizedBox(height: 18),

                                _buildProfileSection(
                                  title: "Pincode",
                                  content: _pincode,
                                  editText: "Edit Pincode",
                                  onEdit: () => _showEditDialog(
                                    "Edit Pincode",
                                    _pincode,
                                        (value) {
                                      setState(() => _pincode = value);
                                      _instantSave();
                                    },
                                  ),
                                ),

                                SizedBox(height: 18),

                                // Courses Offered Section
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Courses",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 8),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _selectedCourse?.name ?? "Biotechnology",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: _selectedCourse == null ? Color(0xff9095A0) : Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (masterState is MasterDataLoaded)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: CustomAutocompleteGeneric<CourseEntity>(
                                          options: masterState.courses,
                                          label: 'Select Course',
                                          displayStringForOption: (course) => course.name,
                                          onSelected: (course) {
                                            setState(() {
                                              _selectedCourse = course;
                                            });
                                            _instantSave();
                                          },
                                        ),
                                      ),
                                  ],
                                ),

                                SizedBox(height: 18),

                                _buildProfileSection(
                                  title: "Social Media",
                                  content: _socialMedia,
                                  editText: "View/Edit",
                                  onEdit: () => _showEditDialog(
                                    "Edit Social Media",
                                    _socialMedia,
                                        (value) {
                                      setState(() => _socialMedia = value);
                                      _instantSave();
                                    },
                                  ),
                                ),

                                SizedBox(height: 18),

                                _buildAuthenticationSection(),

                                SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileSection({
    required String title,
    required String content,
    required String editText,
    required VoidCallback onEdit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xff9095A0),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 3),
        Row(
          children: [
            InkWell(
              onTap: onEdit,
              child: Text(
                editText,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAuthenticationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Authentication",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5),
        Wrap(
          spacing: 11,
          runSpacing: 8,
          children: [
            _buildAuthItem("Email ID", Icons.circle, Colors.green),
            _buildAuthItem("Phone no.", Icons.circle, Colors.green),
            _buildAuthItem("Aadhaar", Icons.circle, Colors.red),
          ],
        ),
        SizedBox(height: 6),
        Row(
          children: [
            InkWell(
              onTap: () {
                // TODO: Navigate to verification screen
              },
              child: Text(
                "Get Verified",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAuthItem(String text, IconData icon, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 8,
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xff9095A0),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  void _showEditDialog(String title, String currentValue, Function(String) onSave) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          maxLines: null,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text); // update local state + save instantly
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _instantSave() {
    final entity = _buildUniversityProfileEntity();
    context.read<UniversityProfileBloc>().add(SaveUniversityProfile(entity));
    _saveAllProfileData(); // Save local preferences
  }

  UniversityProfileEntity _buildUniversityProfileEntity() {
    String phone = "+91 XXXXXXXXXX";
    String email = "dtu@gmail.com";

    if (_contactInfo.contains(" - ")) {
      List<String> parts = _contactInfo.split(" - ");
      if (parts.length >= 2) {
        phone = parts[0].trim();
        email = parts[1].trim();
      }
    }

    List<int> courseIds = [];
    if (_selectedCourse != null) {
      courseIds = [_selectedCourse!.id];
    } else {
      courseIds = [1]; // Default course ID if none selected
    }

    return UniversityProfileEntity(
      collegeName: _universityName, // Use the state variable
      address: _address,
      pincode: _pincode,
      websiteLink: _websiteLink.startsWith("http")
          ? _websiteLink
          : "https://${_websiteLink.startsWith('www.') ? _websiteLink : 'www.$_websiteLink'}",
      socialMediaLink: _socialMedia.startsWith("http")
          ? _socialMedia
          : "https://${_socialMedia.startsWith('www.') ? _socialMedia : 'www.$_socialMedia'}",
      about: _aboutText,
      // Use the URL from the backend if available, otherwise local path (though backend URL is preferred for persistence)
      profilePic: _profilePicUrl ?? _profileImage?.path ?? "",
      // universityLogoUrl: _profilePicUrl ?? "", // Assuming universityLogoUrl is the same as profilePic for now
      emailIdVerified: true,
      adharVerified: false,
      phoneVerified: true,
      phone: phone,
      email: email,
      courseIds: courseIds, universityLogoUrl: '',
    );
  }
}