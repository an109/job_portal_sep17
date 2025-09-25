import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
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
  String _universityName = "Delhi Technical University";
  String _websiteLink = "www.dtu.ac.in";
  String _address = "Shahbad Daulatpur, Main Bawana Road";
  String _pincode = "110042";
  String _logoUrlText = ""; // Editable logo URL
  CourseEntity? _selectedCourse;
  File? _profileImage;
  String? _profilePicUrl;
  File? _logoImage;
  String? _logoImageUrl;
  String? _currentUploadType; // Track which upload we're doing

  final prefs = sl<PreferencesManager>();

  @override
  void initState() {
    super.initState();
    developer.log("UniversityProfilescreen2 initState called");
    developer.log('JWT Token: ${prefs.getToken()}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      developer.log("PostFrameCallback: Loading MasterData, ProfileData, LogoImage");
      context.read<MasterDataBloc>().add(LoadMasterData());
      _loadProfileData();
      _loadProfileImage();
      _loadLogoImage();
    });
  }

  Future<void> _loadProfileData() async {
    developer.log("_loadProfileData called");
    final prefs = sl<PreferencesManager>();
    setState(() {
      _universityName =
          prefs.getString('university_name') ?? "Delhi Technical University";
      _aboutText = prefs.getString('university_about') ?? _aboutText;
      _contactInfo = prefs.getString('university_contact') ?? _contactInfo;
      _socialMedia =
          prefs.getString('university_social_media') ?? _socialMedia;
      _websiteLink = prefs.getString('university_website') ?? _websiteLink;
      _address = prefs.getString('university_address') ?? _address;
      _pincode = prefs.getString('university_pincode') ?? _pincode;
      _logoUrlText = prefs.getString('university_logo_url_text') ?? "";

      final courseIdStr = prefs.getString('university_selected_course_id');
      final courseName = prefs.getString('university_selected_course_name');
      if (courseIdStr != null && courseName != null) {
        final courseId = int.tryParse(courseIdStr);
        if (courseId != null) {
          _selectedCourse = CourseEntity(id: courseId, name: courseName);
          developer.log("Loaded course: ${_selectedCourse!.name}");
        }
      }
    });
  }

  Future<void> _loadProfileImage() async {
    final prefs = sl<PreferencesManager>();
    final relativePath = prefs.getString('university_profile_pic_url');
    if (relativePath != null && relativePath.isNotEmpty) {
      setState(() {
        _profilePicUrl = Urls.getFullImageUrl(relativePath);
        _profileImage = null;
      });
      return;
    }
    final savedImagePath = prefs.getString('university_profile_pic');
    if (savedImagePath != null && File(savedImagePath).existsSync()) {
      setState(() {
        _profileImage = File(savedImagePath);
        _profilePicUrl = null;
      });
    }
  }

  Future<void> _loadLogoImage() async {
    developer.log("_loadLogoImage called");
    final prefs = sl<PreferencesManager>();
    final relativePath = prefs.getString('university_logo_pic_url');
    if (relativePath != null && relativePath.isNotEmpty) {
      setState(() {
        _logoImageUrl = Urls.getFullImageUrl(relativePath);
        _logoImage = null;
      });
      developer.log("Loaded logoImageUrl from server: $_logoImageUrl");
      return;
    }
    final savedLogoPath = prefs.getString('university_logo_pic');
    if (savedLogoPath != null && File(savedLogoPath).existsSync()) {
      setState(() {
        _logoImage = File(savedLogoPath);
        _logoImageUrl = null;
      });
      developer.log("Loaded logoImage from local file: $savedLogoPath");
    }
  }

  Future<void> _saveAllProfileData() async {
    developer.log("_saveAllProfileData called");
    final prefs = sl<PreferencesManager>();
    if (_selectedCourse != null) {
      await prefs.setString('university_selected_course_id',
          _selectedCourse!.id.toString());
      await prefs.setString(
          'university_selected_course_name', _selectedCourse!.name);
      developer.log("Saved selectedCourse: ${_selectedCourse!.name}");
    }
    if (_profileImage != null) {
      await prefs.setString('university_profile_pic', _profileImage!.path);
      developer.log("Saved profileImage: ${_profileImage!.path}");
    }
    if (_logoImage != null) {
      await prefs.setString('university_logo_pic', _logoImage!.path);
      developer.log("Saved logoImage: ${_logoImage!.path}");
    }
    await prefs.setString('university_about', _aboutText);
    await prefs.setString('university_contact', _contactInfo);
    await prefs.setString('university_social_media', _socialMedia);
    await prefs.setString('university_website', _websiteLink);
    await prefs.setString('university_address', _address);
    await prefs.setString('university_pincode', _pincode);
    await prefs.setString('university_logo_url_text', _logoUrlText);
    developer.log("All profile data saved to prefs");
  }

  @override
  Widget build(BuildContext context) {
    final prefs = sl<PreferencesManager>();
    final userName = prefs.getString(PreferencesManager.USER_NAME) ?? 'Recruiter Name';
    final userEmail = prefs.getString(PreferencesManager.USER_EMAIL) ?? 'recruiter@email.com';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: Icon(Icons.message), onPressed: () {}),
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
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
                      final uploadedUrls = uploadState.uploadFileEntity.url;
                      if (uploadedUrls.isNotEmpty) {
                        final relativePath = uploadedUrls.first;

                        if (_currentUploadType == 'profile_pic') {
                          setState(() {
                            _profilePicUrl = Urls.getFullImageUrl(relativePath);
                          });
                          await prefs.setString('university_profile_pic_url', relativePath);
                        } else if (_currentUploadType == 'university_logo') {
                          setState(() {
                            _logoImageUrl = Urls.getFullImageUrl(relativePath);
                          });
                          await prefs.setString('university_logo_pic_url', relativePath);
                        }

                        _currentUploadType = null;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Image uploaded successfully!')),
                        );
                        _instantSave();
                      }
                    } else if (uploadState is UploadFileError) {
                      _currentUploadType = null;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to upload image.')),
                      );
                    }
                  },
                  builder: (context, uploadState) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                Container(
                                  height: 88,
                                  width: 88,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(75),
                                    image: _profilePicUrl != null && _profilePicUrl!.isNotEmpty
                                        ? DecorationImage(image: NetworkImage(_profilePicUrl!), fit: BoxFit.cover)
                                        : (_profileImage != null
                                        ? DecorationImage(image: FileImage(_profileImage!), fit: BoxFit.cover)
                                        : null),
                                  ),
                                  child: (_profileImage == null && (_profilePicUrl == null || _profilePicUrl!.isEmpty))
                                      ? Icon(Icons.school, size: 50, color: Colors.grey[600])
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
                                          _profileImage = File(pickedFile.path);
                                          _profilePicUrl = null;
                                        });
                                        final formData = FormData.fromMap({
                                          'image': await MultipartFile.fromFile(pickedFile.path, filename: pickedFile.name),
                                        });
                                        _currentUploadType = 'profile_pic';
                                        context.read<UploadFileBloc>().add(LoadUploadFile(formData));
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
                                      ),
                                      child: (uploadState is UploadFileLoading)
                                          ? SizedBox(height: 14, width: 14, child: CircularProgressIndicator(strokeWidth: 2))
                                          : Icon(Icons.edit, size: 14, color: Colors.blue),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 16),
                          Text(
                            _universityName ?? "Delhi Technological University",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            prefs.getString(PreferencesManager.USER_EMAIL) ?? '@email.com',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                          ),

                          SizedBox(height: 52),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildProfileSection(
                                  title: "About",
                                  content: _aboutText,
                                  editText: "View/Edit About",
                                  onEdit: () => _showEditDialog("Edit About", _aboutText, (value) {
                                    setState(() => _aboutText = value);
                                    _instantSave();
                                  }),
                                ),
                                SizedBox(height: 18),

                                _buildProfileSection(
                                  title: "Contact Information",
                                  content: _contactInfo,
                                  editText: "Edit Info",
                                  onEdit: () => _showEditDialog("Edit Contact Information", _contactInfo, (value) {
                                    setState(() => _contactInfo = value);
                                    _instantSave();
                                  }),
                                ),
                                SizedBox(height: 18),

                                _buildProfileSection(
                                  title: "Website",
                                  content: _websiteLink,
                                  editText: "Edit Website",
                                  onEdit: () => _showEditDialog("Edit Website", _websiteLink, (value) {
                                    setState(() => _websiteLink = value);
                                    _instantSave();
                                  }),
                                ),
                                SizedBox(height: 18),

                                _buildProfileSection(
                                  title: "Address",
                                  content: _address,
                                  editText: "Edit Address",
                                  onEdit: () => _showEditDialog("Edit Address", _address, (value) {
                                    setState(() => _address = value);
                                    _instantSave();
                                  }),
                                ),
                                SizedBox(height: 18),

                                _buildProfileSection(
                                  title: "Pincode",
                                  content: _pincode,
                                  editText: "Edit Pincode",
                                  onEdit: () => _showEditDialog("Edit Pincode", _pincode, (value) {
                                    setState(() => _pincode = value);
                                    _instantSave();
                                  }),
                                ),
                                SizedBox(height: 18),

                                Text("University Logo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),),
                                SizedBox(height: 9),

                                // Optional: Add "Upload Logo" button below the URL field
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: InkWell(
                                    onTap: () async {
                                      final picker = ImagePicker();
                                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                      if (pickedFile != null) {
                                        setState(() {
                                          _logoImage = File(pickedFile.path);
                                          _logoImageUrl = null;
                                        });
                                        final formData = FormData.fromMap({
                                          'image': await MultipartFile.fromFile(pickedFile.path, filename: pickedFile.name),
                                        });
                                        _currentUploadType = 'university_logo';
                                        context.read<UploadFileBloc>().add(LoadUploadFile(formData));
                                      }
                                    },
                                    child: Text(
                                      "Upload Logo",
                                      style: TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 18),

                                // Courses
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Courses",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
                                    ),
                                    SizedBox(height: 5),
                                    GestureDetector(
                                      onTap: () => FocusScope.of(context).unfocus(),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 8),
                                        decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
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
                                  onEdit: () => _showEditDialog("Edit Social Media", _socialMedia, (value) {
                                    setState(() => _socialMedia = value);
                                    _instantSave();
                                  }),
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
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
        SizedBox(height: 5),
        Text(
          content,
          style: TextStyle(fontSize: 14, color: Color(0xff9095A0), fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 3),
        InkWell(
          onTap: onEdit,
          child: Text(editText, style: TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.w400)),
        ),
      ],
    );
  }

  Widget _buildAuthenticationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Authentication", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
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
        InkWell(
          onTap: () {},
          child: Text("Get Verified", style: TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildAuthItem(String text, IconData icon, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 8),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 14, color: Color(0xff9095A0), fontWeight: FontWeight.w400)),
      ],
    );
  }

  void _showEditDialog(String title, String currentValue, Function(String) onSave) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(controller: controller, decoration: InputDecoration(border: OutlineInputBorder()), maxLines: null),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _instantSave() {
    try {
      final entity = _buildUniversityProfileEntity();
      context.read<UniversityProfileBloc>().add(SaveUniversityProfile(entity));
      _saveAllProfileData();
      _loadProfileImage();
      _loadLogoImage();
    } catch (e) {
      developer.log('Error in _instantSave: $e');
    }
  }

  UniversityProfileEntity _buildUniversityProfileEntity() {
    String phone = _contactInfo;
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
      courseIds = [1];
    }

    String? getRelativePath(String? fullUrl) {
      if (fullUrl == null || fullUrl.isEmpty) return null;
      // Remove baseUrl: "http://bvrcrafts.com:5000/api/"
      return fullUrl.replaceFirst(Urls.baseUrl, '');
    }

    String t(String? s) => s?.trim() ?? "";

    return UniversityProfileEntity(
      // userId: int.tryParse(prefs.getString('user_id') ?? '0'),
      collegeName: _universityName,
      address: _address,
      pincode: _pincode,
      websiteLink: t(_websiteLink).startsWith("http")
          ? t(_websiteLink)
          : "https://${t(_websiteLink).startsWith('www.') ? t(_websiteLink) : 'www.${t(_websiteLink)}'}",
      socialMediaLink: t(_socialMedia).startsWith("http")
          ? t(_socialMedia)
          : "https://${t(_socialMedia).startsWith('www.') ? t(_socialMedia) : 'www.${t(_socialMedia)}'}",
      about: t(_aboutText),
      // profilePic: _profilePicUrl,
      // universityLogoUrl: _logoImageUrl,
      profilePic: getRelativePath(_profilePicUrl) ?? "",
      universityLogoUrl: getRelativePath(_logoImageUrl) ?? "",
      // emailIdVerified: true,
      // aadharVerified: false,
      // phoneVerified: true,
      phone: phone,
      // email: email,
      courseIds: courseIds,
    );
  }
}
