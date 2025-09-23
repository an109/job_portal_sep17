import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/UI_Helper/responsive_extensions.dart';
import 'package:job_portal/ui_helper/ui_helper.dart';
import 'package:job_portal/widgets/widgets.dart';
import '../../../../utils/constants/urls.dart';
import '../../../../utils/storage/shared_preference.dart';
import '../../../Bottom_Nav_Bar/University_Bottom_Nav_Bar.dart';
import '../../../detailed_signup_student/domain/entities/metadata_entities.dart';
import '../../../detailed_signup_student/presentation/bloc/master_data_bloc/master_data_bloc.dart';
import '../../../detailed_signup_student/presentation/bloc/master_data_bloc/master_data_event.dart';
import '../../../detailed_signup_student/presentation/bloc/master_data_bloc/master_data_state.dart';
import '../../../university_register/domain/entities/university_registration_entity.dart';
import '../../../university_register/presentation/bloc/university_registration_event.dart';
import '../../../university_register/presentation/bloc/university_registration_state.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:job_portal/utils/upload_file_get_url/presentation/bloc/upload_file_bloc.dart';
import 'package:job_portal/utils/upload_file_get_url/presentation/bloc/upload_file_event.dart';
import 'package:job_portal/utils/upload_file_get_url/presentation/bloc/upload_file_state.dart';

import '../bloc/university_registration_bloc.dart';

final sl = GetIt.instance;

class UniversityFillDetailsScreen extends StatefulWidget {
  const UniversityFillDetailsScreen({Key? key}) : super(key: key);

  @override
  State<UniversityFillDetailsScreen> createState() =>
      _UniversityFillDetailsScreenState();
}

class _UniversityFillDetailsScreenState
    extends State<UniversityFillDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController universityNameController =
  TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController weblinkController = TextEditingController();
  final TextEditingController medialinkController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  CourseEntity? selectedCourse;
  int? selectedCourseId;

  // These now hold SERVER URLs after upload
  String? universityLogoUrl;
  String? profilePicUrl;

  // For local preview before upload
  File? _selectedUniversityLogo;
  File? _selectedProfilePic;

  // Loading states for uploads
  bool _isUploadingUniversityLogo = false;
  bool _isUploadingProfilePic = false;

  SpecializationEntity? selectedSpecialization;
  int? selectedSpecializationId;

  @override
  void initState() {
    super.initState();
    final prefs = sl<PreferencesManager>();
    final token = prefs.getToken();
    final userType = prefs.getUserType();
    print('📤>>>>>>>>>>>>>>>>>> [LOG] Using Token: $token');
    print('📤>>>>>>>>>>>>>>>>>> [LOG] Using user type: $userType');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MasterDataBloc>().add(LoadMasterData());
    });
  }

  @override
  void dispose() {
    universityNameController.dispose();
    addressController.dispose();
    pincodeController.dispose();
    weblinkController.dispose();
    medialinkController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  // ✅ UPLOAD UNIVERSITY LOGO
  Future<void> _uploadUniversityLogo(File file) async {
    setState(() {
      _isUploadingUniversityLogo = true;
    });

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      });

      context.read<UploadFileBloc>().add(LoadUploadFile(formData, uploadType: 'university_logo'));

      final state = await context.read<UploadFileBloc>().stream.firstWhere(
            (state) => state is UploadFileLoaded || state is UploadFileError,
      );

      if (state is UploadFileLoaded) {
        if (state.uploadFileEntity.url.isNotEmpty) {
          final uploadedUrl = state.uploadFileEntity.url.first;
          setState(() {
            universityLogoUrl = uploadedUrl;
            _selectedUniversityLogo = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ University logo uploaded!')),
          );
        } else {
          throw Exception("No URL returned from server");
        }
      } else {
        throw Exception("Upload failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Upload failed: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isUploadingUniversityLogo = false;
      });
    }
  }

  // ✅ UPLOAD PROFILE PICTURE
  Future<void> _uploadProfilePic(File file) async {
    setState(() {
      _isUploadingProfilePic = true;
    });

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      });

      context.read<UploadFileBloc>().add(LoadUploadFile(formData, uploadType: 'profile_pic'));

      final state = await context.read<UploadFileBloc>().stream.firstWhere(
            (state) => state is UploadFileLoaded || state is UploadFileError,
      );

      if (state is UploadFileLoaded) {
        if (state.uploadFileEntity.url.isNotEmpty) {
          final uploadedUrl = state.uploadFileEntity.url.first;
          setState(() {
            profilePicUrl = uploadedUrl;
            _selectedProfilePic = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Profile picture uploaded!')),
          );
        } else {
          throw Exception("No URL returned from server");
        }
      } else {
        throw Exception("Upload failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Upload failed: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isUploadingProfilePic = false;
      });
    }
  }

  // ✅ SUBMIT — RESTORED ORIGINAL BEHAVIOR
  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final universityName = universityNameController.text.trim();
      final address = addressController.text.trim();
      final pincode = pincodeController.text.trim();
      final websiteLink = weblinkController.text.trim();
      final socialMediaLink = medialinkController.text.trim();
      final about = aboutController.text.trim();

      if (selectedCourseId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a course')),
        );
        return;
      }

      // Create entity — use uploaded URLs or fallbacks
      final entity = UniversityRegistrationEntity(
        collegeName: universityName,
        courseIds: [selectedCourseId!],
        profilePic: profilePicUrl ?? 'uploads/default_profile.jpg',
        universityLogoUrl: universityLogoUrl ?? 'uploads/default_logo.png',
        address: address,
        pincode: pincode,
        websiteLink: websiteLink,
        about: about,
        socialMediaLink: socialMediaLink,
      );

      // ✅ STEP 1: NAVIGATE IMMEDIATELY (like before)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UniversityBottomNavBar(),
        ),
      );

      // ✅ STEP 2: DISPATCH EVENT AFTER NAVIGATION (like before)
      // This will trigger API call in background
      Future.delayed(Duration.zero, () {
        print('📤 [LOG] Submitting University Registration: $entity');
        context
            .read<UniversityRegistrationBloc>()
            .add(RegisterUniversityEvent(entity));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('University Fill Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SafeArea(
        child: BlocConsumer<MasterDataBloc, MasterDataState>(
          listener: (context, state) {},
          builder: (context, masterState) {
            if (masterState is MasterDataInitial ||
                masterState is MasterDataLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (masterState is MasterDataError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error loading data: ${masterState.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MasterDataBloc>().add(LoadMasterData());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (masterState is MasterDataLoaded) {
              return BlocProvider(
                create: (context) => sl<UniversityRegistrationBloc>(),
                child: BlocConsumer<UniversityRegistrationBloc,
                    UniversityRegistrationState>(
                  listener: (context, state) {
                    if (state is UniversityRegistrationSuccess) {
                      print('✅ [LOG] Success: ${state.entity.collegeName}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                            Text('University registered successfully!')),
                      );
                      // ✅ Already navigated in _submit(), so no need to navigate again
                    } else if (state is UniversityRegistrationFailure) {
                      print('❌ [LOG] Failed: ${state.message}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${state.message}')),
                      );
                    }
                  },
                  builder: (context, uniState) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('College Name',
                                style:
                                mTextStyle14(mFontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: universityNameController,
                              hintText: 'Enter university name',
                              validator: (val) => val == null || val.isEmpty
                                  ? 'University name required'
                                  : null,
                            ),
                            const SizedBox(height: 20),

                            Text('Select Courses',
                                style:
                                mTextStyle14(mFontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                              },
                              child: CustomAutocompleteGeneric<CourseEntity>(
                                options: masterState.courses,
                                label: 'Select Course',
                                displayStringForOption: (course) => course.name,
                                onSelected: (course) {
                                  setState(() {
                                    selectedCourse = course;
                                    selectedCourseId = course.id;
                                    selectedSpecialization = null;
                                    selectedSpecializationId = null;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),

                            Text('Address',
                                style:
                                mTextStyle14(mFontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Container(
                              child: CustomTextField(
                                controller: addressController,
                                hintText: 'Enter complete address',
                                validator: (val) => val == null || val.isEmpty
                                    ? 'Address required'
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 20),

                            Text('Pincode',
                                style:
                                mTextStyle14(mFontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: pincodeController,
                              hintText: 'Enter 6-digit pincode',
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                if (val == null || val.isEmpty)
                                  return 'Pincode required';
                                if (val.length != 6)
                                  return 'Pincode must be 6 digits';
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            Text('Website Link',
                                style:
                                mTextStyle14(mFontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: weblinkController,
                              hintText: 'https://www.youruniversity.edu    ',
                              keyboardType: TextInputType.url,
                              validator: (val) => val == null || val.isEmpty
                                  ? 'Website URL required'
                                  : null,
                            ),
                            const SizedBox(height: 20),

                            Text('About University',
                                style:
                                mTextStyle14(mFontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: aboutController,
                              hintText: 'Tell us about your university...',
                              validator: (val) => val == null || val.isEmpty
                                  ? 'About information required'
                                  : null,
                            ),
                            const SizedBox(height: 20),

                            // ✅ UNIVERSITY LOGO
                            Text(
                              "University Logo",
                              style: TextStyle(
                                fontSize:
                                context.responsiveFontSize(baseSize: 14),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: context.rh(1)),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _isUploadingUniversityLogo
                                        ? null
                                        : () async {
                                      final result =
                                      await FilePicker.platform
                                          .pickFiles(
                                        allowMultiple: false,
                                        type: FileType.image,
                                      );
                                      if (result != null &&
                                          result.files.isNotEmpty) {
                                        final file =
                                        File(result.files.first.path!);
                                        setState(() {
                                          _selectedUniversityLogo = file;
                                        });
                                        await _uploadUniversityLogo(file);
                                      }
                                    },
                                    icon: const Icon(Icons.upload),
                                    label: Text(
                                        _isUploadingUniversityLogo
                                            ? "Uploading..."
                                            : "Upload Logo"),
                                  ),
                                ),
                                SizedBox(width: context.rw(2)),
                                if (_selectedUniversityLogo != null)
                                  Expanded(
                                    child: Text(
                                      _selectedUniversityLogo!.path.split('/').last,
                                      style: TextStyle(
                                          fontSize: context.responsiveFontSize(
                                              baseSize: 12)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                if (universityLogoUrl != null)
                                  Expanded(
                                    child: Text(
                                      universityLogoUrl!.split('/').last,
                                      style: TextStyle(
                                          fontSize: context.responsiveFontSize(
                                              baseSize: 12),
                                          color: Colors.green),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                SizedBox(width: context.rw(2)),
                                if (_selectedUniversityLogo != null)
                                  Container(
                                    width: context.rw(10),
                                    height: context.rw(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.file(
                                      _selectedUniversityLogo!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                if (universityLogoUrl != null &&
                                    !_isUploadingUniversityLogo)
                                  Container(
                                    width: context.rw(10),
                                    height: context.rw(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Colors.green.shade400),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.network(
                                      Urls.getFullImageUrl(universityLogoUrl!),
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image, color: Colors.red),
                                    ),
                                  ),
                              ],
                            ),
                            if (_isUploadingUniversityLogo)
                              Padding(
                                padding: EdgeInsets.only(top: context.rh(1)),
                                child: LinearProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            SizedBox(height: context.rh(1.5)),

                            // ✅ PROFILE PICTURE
                            Text(
                              "Profile Picture",
                              style: TextStyle(
                                  fontSize: context.responsiveFontSize(baseSize: 14),
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: context.rh(1)),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _isUploadingProfilePic
                                        ? null
                                        : () async {
                                      final result =
                                      await FilePicker.platform
                                          .pickFiles(
                                        allowMultiple: false,
                                        type: FileType.image,
                                      );
                                      if (result != null &&
                                          result.files.isNotEmpty) {
                                        final file =
                                        File(result.files.first.path!);
                                        setState(() {
                                          _selectedProfilePic = file;
                                        });
                                        await _uploadProfilePic(file);
                                      }
                                    },
                                    icon: const Icon(Icons.upload),
                                    label: Text(
                                        _isUploadingProfilePic
                                            ? "Uploading..."
                                            : "Upload Picture"),
                                  ),
                                ),
                                SizedBox(width: context.rw(2)),
                                if (_selectedProfilePic != null)
                                  Expanded(
                                    child: Text(
                                      _selectedProfilePic!.path.split('/').last,
                                      style: TextStyle(
                                          fontSize: context.responsiveFontSize(
                                              baseSize: 12)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                if (profilePicUrl != null)
                                  Expanded(
                                    child: Text(
                                      profilePicUrl!.split('/').last,
                                      style: TextStyle(
                                          fontSize: context.responsiveFontSize(
                                              baseSize: 12),
                                          color: Colors.green),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                              ],
                            ),
                            if (_isUploadingProfilePic)
                              Padding(
                                padding: EdgeInsets.only(top: context.rh(1)),
                                child: LinearProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            SizedBox(height: context.rh(1.5)),

                            Text('Social Media Link',
                                style:
                                mTextStyle14(mFontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: medialinkController,
                              hintText:
                              'https://linkedin.com/company/university    ',
                              keyboardType: TextInputType.url,
                              validator: (val) => val == null || val.isEmpty
                                  ? 'Social media link required'
                                  : null,
                            ),

                            const SizedBox(height: 30),

                            // Show loading if in progress
                            if (uniState is UniversityRegistrationLoading)
                              const Center(child: CircularProgressIndicator())
                            else
                              commonRedContainer(
                                text: 'Submit',
                                onTap: _submit,
                              ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}