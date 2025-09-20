import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/UI_Helper/responsive_extensions.dart';
import 'package:job_portal/ui_helper/ui_helper.dart';
import 'package:job_portal/widgets/widgets.dart';
import '../../../Bottom_Nav_Bar/University_Bottom_Nav_Bar.dart';
import '../../../detailed_signup_student/domain/entities/metadata_entities.dart';
import '../../../detailed_signup_student/presentation/bloc/master_data_bloc/master_data_bloc.dart';
import '../../../detailed_signup_student/presentation/bloc/master_data_bloc/master_data_event.dart';
import '../../../detailed_signup_student/presentation/bloc/master_data_bloc/master_data_state.dart';
import '../../../university_register/domain/entities/university_registration_entity.dart';
import '../../../university_register/presentation/bloc/university_registration_event.dart';
import '../../../university_register/presentation/bloc/university_registration_state.dart';
import 'package:get_it/get_it.dart';

import '../bloc/university_registration_bloc.dart';

final sl = GetIt.instance;

class UniversityFillDetailsScreen extends StatefulWidget {
  const UniversityFillDetailsScreen({Key? key}) : super(key: key);

  @override
  State<UniversityFillDetailsScreen> createState() => _UniversityFillDetailsScreenState();
}

class _UniversityFillDetailsScreenState extends State<UniversityFillDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController universityNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController weblinkController = TextEditingController();
  final TextEditingController medialinkController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  CourseEntity? selectedCourse;
  int? selectedCourseId;
  String? universityLogoPath;
  String? profilePicPath;

  SpecializationEntity? selectedSpecialization;
  int? selectedSpecializationId;

  @override
  void initState() {
    super.initState();
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

      // Create entity from form data
      final entity = UniversityRegistrationEntity(
        collegeName: universityName,
        courseIds: [selectedCourseId!],
        profilePic: profilePicPath ?? 'uploads/default_profile.jpg',
        universityLogoUrl: universityLogoPath ?? 'uploads/default_logo.png',
        address: address,
        pincode: pincode,
        websiteLink: websiteLink,
        about: about,
        socialMediaLink: socialMediaLink,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UniversityBottomNavBar(),
        ),
      );

      print('📤 [LOG] Submitting University Registration: $entity');

      context.read<UniversityRegistrationBloc>().add(RegisterUniversityEvent(entity));
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
            if (masterState is MasterDataInitial || masterState is MasterDataLoading) {
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
                child: BlocConsumer<UniversityRegistrationBloc, UniversityRegistrationState>(
                  listener: (context, state) {
                    if (state is UniversityRegistrationSuccess) {
                      print('✅ [LOG] Success: ${state.entity.collegeName}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('University registered successfully!')),
                      );
                    } else if (state is UniversityRegistrationFailure) {
                      print('❌ [LOG] Failed: ${state.message}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${state.message}')),
                      );
                    }
                  },
                  builder: (context, uniState) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('College Name', style: mTextStyle14(mFontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: universityNameController,
                              hintText: 'Enter university name',
                              validator: (val) => val == null || val.isEmpty ? 'University name required' : null,
                            ),
                            const SizedBox(height: 20),

                            Text('Select Courses', style: mTextStyle14(mFontWeight: FontWeight.w600)),
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

                            Text('Address', style: mTextStyle14(mFontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Container(
                              child: CustomTextField(
                                controller: addressController,
                                hintText: 'Enter complete address',
                                validator: (val) => val == null || val.isEmpty ? 'Address required' : null,
                              ),
                            ),
                            const SizedBox(height: 20),

                            Text('Pincode', style: mTextStyle14(mFontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: pincodeController,
                              hintText: 'Enter 6-digit pincode',
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                if (val == null || val.isEmpty) return 'Pincode required';
                                if (val.length != 6) return 'Pincode must be 6 digits';
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            Text('Website Link', style: mTextStyle14(mFontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: weblinkController,
                              hintText: 'https://www.youruniversity.edu  ',
                              keyboardType: TextInputType.url,
                              validator: (val) => val == null || val.isEmpty ? 'Website URL required' : null,
                            ),
                            const SizedBox(height: 20),

                            Text('About University', style: mTextStyle14(mFontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: aboutController,
                              hintText: 'Tell us about your university...',
                              validator: (val) => val == null || val.isEmpty ? 'About information required' : null,
                            ),
                            const SizedBox(height: 20),

                            Text(
                              "University Logo",
                              style: TextStyle(
                                  fontSize: context.responsiveFontSize(baseSize: 14),
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: context.rh(1)),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final result = await FilePicker.platform.pickFiles(
                                        allowMultiple: false,
                                        type: FileType.image,
                                      );
                                      if (result != null && result.files.isNotEmpty) {
                                        final file = result.files.first;
                                        setState(() {
                                          universityLogoPath = file.name;
                                        });
                                      }
                                    },
                                    child: Text("Choose File"),
                                  ),
                                ),
                                SizedBox(width: context.rw(2)),
                                if (universityLogoPath != null)
                                  Expanded(
                                    child: Text(
                                      universityLogoPath!,
                                      style: TextStyle(fontSize: context.responsiveFontSize(baseSize: 12)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                SizedBox(width: context.rw(2)),
                                if (universityLogoPath != null)
                                  Container(
                                    width: context.rw(10),
                                    height: context.rw(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "L",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: context.responsiveFontSize(baseSize: 16)),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: context.rh(1.5)),

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
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final result = await FilePicker.platform.pickFiles(
                                        allowMultiple: false,
                                        type: FileType.image,
                                      );
                                      if (result != null && result.files.isNotEmpty) {
                                        final file = result.files.first;
                                        setState(() {
                                          profilePicPath = file.name;
                                        });
                                      }
                                    },
                                    child: Text("Choose File"),
                                  ),
                                ),
                                SizedBox(width: context.rw(2)),
                                if (profilePicPath != null)
                                  Expanded(
                                    child: Text(
                                      profilePicPath!,
                                      style: TextStyle(fontSize: context.responsiveFontSize(baseSize: 12)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: context.rh(1.5)),

                            Text('Social Media Link', style: mTextStyle14(mFontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: medialinkController,
                              hintText: 'https://linkedin.com/company/university  ',
                              keyboardType: TextInputType.url,
                              validator: (val) => val == null || val.isEmpty ? 'Social media link required' : null,
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