import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer show log;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/ui_helper/ui_helper.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:job_portal/utils/upload_file_get_url/presentation/bloc/upload_file_bloc.dart';
import 'package:job_portal/utils/upload_file_get_url/presentation/bloc/upload_file_event.dart';
import 'package:job_portal/utils/upload_file_get_url/presentation/bloc/upload_file_state.dart';
import 'package:job_portal/views/detailed_signup_student/domain/entities/metadata_entities.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/master_data_bloc/master_data_bloc.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/skill_bloc/skill_bloc.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/skill_bloc/skill_event.dart' as se;
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/skill_bloc/skill_state.dart';
import 'package:job_portal/views/user_profile/domain/entities/user_details_entity.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_state.dart';

import '../../../../Widgets/widgets.dart';
import '../../../detailed_signup_student/presentation/bloc/master_data_bloc/master_data_event.dart';
import '../../../detailed_signup_student/presentation/bloc/master_data_bloc/master_data_state.dart';
import '../../../detailed_signup_student/presentation/bloc/signup_as_anyone_bloc/detailed_signup_bloc.dart';
import '../../../detailed_signup_student/presentation/bloc/signup_as_anyone_bloc/detailed_signup_event.dart';
import '../../../user_profile/presentation/views/User_Notifications_Screen.dart';
import '../../../user_profile/presentation/views/User_messages_screen.dart';

class UserSkillsApprovalScreen extends StatefulWidget {
  final List<ProfileSkillEntity> skillList;
  const UserSkillsApprovalScreen({super.key, required this.skillList});

  @override
  State<UserSkillsApprovalScreen> createState() => _UserSkillsApprovalScreenState();
}

class _UserSkillsApprovalScreenState extends State<UserSkillsApprovalScreen> {
  TextEditingController skillsSearchController = TextEditingController();

  UserDetailEntity? _currentUserProfile; // This needs to be populated
  final _prefs = sl<PreferencesManager>();

  final _formKey = GlobalKey<FormState>();
  UniqueKey _autoCompleteKey = UniqueKey();
  int? authorityId; // This will hold the selected authority ID
  List<DomainEntity> allDomains = [];
  List<String> selectedDomains = [];

  Map<String, List<SkillEntity>> subSkillsMap = {};
  Map<String, List<SkillEntity>> selectedSubSkillsPerDomain = {};
  final Map<String, TextEditingController> courseCollegeControllers = {};
  final Map<String, PlatformFile> certificateImages = {};
  Map<String, dynamic> finalSkillData = {};

  @override
  void initState() {
    super.initState();

    developer.log(' [SkillsScreen] initState: Loading ${widget.skillList.length} skills from widget');

    /// Pre-fill data from profileSkills
    for (final skill in widget.skillList) {
      final domain = skill.domain ?? 'Other';
      developer.log(' [SkillsScreen] Processing domain: $domain');

      if (!selectedDomains.contains(domain)) {
        selectedDomains.add(domain);
        subSkillsMap[domain] = [];
        selectedSubSkillsPerDomain[domain] = [];
        courseCollegeControllers.putIfAbsent(
          domain,
              () => TextEditingController(
            text: skill.authority.isNotEmpty ? skill.authority.first : '',
          ),
        );
        developer.log('🏷 [SkillsScreen] Added domain: $domain');
      }

      // Assuming SkillEntity has 'name' and 'id'
      final subSkillEntities = skill.subSkills
          .asMap()
          .entries
          .map((e) => SkillEntity(name: e.value, id: e.key)) // Assuming e.key can be used as skill ID
          .toList();

      developer.log(' [SkillsScreen] Found ${subSkillEntities.length} sub-skills for $domain');

      subSkillsMap[domain]!.addAll(subSkillEntities);
      selectedSubSkillsPerDomain[domain]!.addAll(subSkillEntities);
    }

    setState(() {});
    developer.log(' [SkillsScreen] initState completed. Domains: $selectedDomains');
  }

  String? getCertificateImageName(String domain) {
    final file = certificateImages[domain];
    if (file != null) {
      developer.log('📎 [SkillsScreen] Certificate selected for $domain: ${file.name}');
      return file.name;
    }
    return null;
  }

  Future<void> cacheSkills() async {
    var map = {
      'selectedDomains': selectedDomains,
      'selectedSubSkillsPerDomain': selectedSubSkillsPerDomain
    };
    await _prefs.setSkillParams(map);
    developer.log('💾 [SkillsScreen] Skills cached to SharedPreferences');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bloc = context.read<SkillBloc>();
    bloc.add(const se.LoadDomains());
    developer.log('📡 [SkillsScreen] LoadDomains event added to SkillBloc');

    final masterDataBloc = context.read<MasterDataBloc>();
    masterDataBloc.add(const LoadMasterData());
    developer.log('🏫 [SkillsScreen] LoadMasterData event added to MasterDataBloc');

    final myProfileBloc = context.read<MyProfileBloc>();
    final userId = _prefs.getUserId() ?? '6';
    myProfileBloc.add(LoadMyProfileDetails(userId));
    developer.log('👤 [SkillsScreen] Loading current user profile for ID: $userId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(""),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MessagesScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: SvgPicture.asset("assets/Icons/message_icon.svg"),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/notifications_icon.svg"),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          // onPressed: () async {
          //   await cacheSkills();
          //   Navigator.pop(context);
          // },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 42,
                    width: double.infinity,
                    child: Text(
                      "Your Skills",
                      style: mTextStyle32(mColor: Color(0xff1A1C1E)),
                    ),
                  ),
                  mSpacer(mHeight: 25.0),

                  // Domain Autocomplete
                  BlocListener<SkillBloc, SkillState>(
                    listener: (context, state) {
                      if (state is SkillStateDomainLoaded) {
                        developer.log(' [SkillsScreen] Domains loaded: ${state.domainAllResponse.domains.map((d) => d.name)}');
                        setState(() {
                          allDomains = state.domainAllResponse.domains;
                        });
                      } else if (state is SubSkillLoaded) {
                        final data = state.subSkillResponse;
                        final domain = state.domain;
                        if (!subSkillsMap.containsKey(domain)) {
                          developer.log(' [SkillsScreen] Sub-skills loaded for $domain: ${data.skills.map((s) => s.name)}');
                          setState(() {
                            subSkillsMap[domain] = data.skills;
                          });
                        }
                      } else if (state is SkillCertificatesLoaded) {
                        setState(() {
                          // Ignore — we use PlatformFile only
                        });
                      }
                    },
                    child: Container(
                      key: _autoCompleteKey,
                      child: CustomAutocompleteGeneric(
                        options: allDomains,
                        label: 'List your skills here',
                        displayStringForOption: (p0) => p0.name,
                        onSelected: (value) {
                          if (!selectedDomains.contains(value.name)) {
                            context.read<SkillBloc>().add(se.LoadSubSkills(value.name, value.id.toString()));
                            setState(() {
                              selectedDomains.add(value.name);
                              _autoCompleteKey = UniqueKey();
                            });
                            developer.log('➕ [SkillsScreen] Added new domain: ${value.name}');
                          } else {
                            showSnackbar('Skill already selected.', context);
                            setState(() {
                              _autoCompleteKey = UniqueKey();
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  mSpacer(mHeight: 16.0),

                  // Selected Skills List
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: selectedDomains.length,
                    itemBuilder: (context, index) {
                      final domain = selectedDomains[index];
                      final subSkills = subSkillsMap[domain] ?? [];
                      final selectedSkills = selectedSubSkillsPerDomain[domain] ?? [];

                      courseCollegeControllers.putIfAbsent(domain, () => TextEditingController());

                      final fileName = getCertificateImageName(domain);

                      // Color for skill card
                      final bgColor = index % 4 == 0
                          ? Color(0xFFE8F5E8) // Green
                          : index % 4 == 1
                          ? Color(0xFFF3E5F5) // Pink
                          : index % 4 == 2
                          ? Color(0xFFFFF3E0) // Orange
                          : Color(0xFFE3F2FD); // Blue

                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Skill Name & Upload Button
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF1961F3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    domain,
                                    style: TextStyle(color: Colors.white, fontSize: 10),
                                  ),
                                ),
                                Spacer(),
                                if (fileName != null)
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset("assets/Icons/certificate.svg", color: Colors.grey),
                                          SizedBox(width: 4),
                                          Text("View", style: TextStyle(fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  GestureDetector(
                                    onTap: () {
                                      if (domain.isNotEmpty) {
                                        context.read<SkillBloc>().add(se.PickCertificate(skillName: domain));
                                        developer.log('📎 [SkillsScreen] PickCertificate triggered for $domain');
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset("assets/Icons/certificate.svg", color: Colors.grey),
                                          SizedBox(width: 4),
                                          Text("Upload Certificate", style: TextStyle(fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text("Where did you learn this skill?", style: mTextStyle12()),
                            SizedBox(height: 8),
                            BlocBuilder<MasterDataBloc, MasterDataState>(
                              builder: (context, state) {
                                if (state is MasterDataLoaded) {
                                  return CustomAutocompleteGeneric<CollegeEntity>(
                                    options: state.colleges,
                                    label: "Course",
                                    displayStringForOption: (college) => college.name,
                                    onSelected: (college) {
                                      setState(() {
                                        authorityId = college.id; // Store the ID here
                                        // selectedCourseId = course.id;
                                        // selectedSpecialization = null;
                                        // selectedSpecializationId = null;
                                      });
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {});
                                      });
                                      context.read<DetailedSignupBloc>().add(
                                        DetailedSignupGetSpecializations(college.id.toString()),
                                      );
                                    },
                                  );
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                            SizedBox(height: 8),
                            Text("Related skills you might know", style: mTextStyle12()),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: subSkills.map((skill) {
                                final isSelected = selectedSkills.any((s) => s.name == skill.name);
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      final selected = List<SkillEntity>.from(selectedSubSkillsPerDomain[domain] ?? []);
                                      if (isSelected) {
                                        selected.removeWhere((s) => s.name == skill.name);
                                        developer.log(' [SkillsScreen] Deselected: ${skill.name} in $domain');
                                      } else {
                                        selected.add(skill);
                                        developer.log(' [SkillsScreen] Selected: ${skill.name} in $domain');
                                      }
                                      selectedSubSkillsPerDomain[domain] = selected;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Color(0xFF1961F3) : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected ? Color(0xFF1961F3) : Colors.grey.shade200,
                                      ),
                                    ),
                                    child: Text(
                                      skill.name,
                                      style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  mSpacer(mHeight: 24.0),

                  // Save Button
                  BlocListener<MyProfileBloc, MyProfileState>(
                    listener: (context, state) {
                      if (state is MyProfileDetailsLoaded) { // Listen for MyProfileLoaded to get current user data
                        _currentUserProfile = state.userDetailEntity;
                        developer.log(' [SkillsScreen] Current user profile loaded: ${_currentUserProfile?.first_name}');
                      } else if (state is UpdateProfileLoaded) {
                        final bloc = context.read<MyProfileBloc>();
                        final _prefs = sl<PreferencesManager>();
                        final user_id = _prefs.getUserId();
                        bloc.add(LoadMyProfileDetails(user_id ?? '6'));
                      } else if (state is UpdateProfileError) {
                        developer.log(' [SkillsScreen] Profile update failed');
                        showSnackbar('Failed to update profile.', context);
                      }
                    },
                    child: BlocListener<UploadFileBloc, UploadFileState>(
                      listener: (context, state) {
                        if (state is UploadFileLoaded) {
                          final urls = state.uploadFileEntity;
                          developer.log(' [SkillsScreen] Certificate upload successful: $urls');
                          finalSkillData = createSkillList(urls.url);
                          final user_id = _prefs.getUserId();
                          context.read<MyProfileBloc>().add(LoadUpdateProfile(user_id ?? '6', finalSkillData));
                        } else if (state is UploadFileError) {
                          developer.log(' [SkillsScreen] Certificate upload failed: ');
                          showSnackbar('Error uploading certificate.', context);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 150,
                            child: nextButton(
                              title: "Save Changes",
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {

                                  developer.log(' [SkillsScreen] Form valid. Starting upload...');
                                  await uploadCertificates();
                                  Navigator.pop(context);
                                  _prefs.clear(PreferencesManager.SKILL_PARAMS);
                                } else {
                                  showSnackbar('Please fill all fields.', context);
                                  developer.log(' [SkillsScreen] Form validation failed');
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  mSpacer(mHeight: 24.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> uploadCertificates() async {
    final formData = FormData();

    for (var domain in certificateImages.keys) {
      final file = certificateImages[domain];
      if (file != null && file.path != null) {
        final fileName = file.path!.split('/').last;
        final multipartFile = await MultipartFile.fromFile(file.path!, filename: fileName);
        formData.files.add(MapEntry('certificateImage', multipartFile));
        developer.log('📎 [SkillsScreen] Adding file for upload: $fileName (domain: $domain)');
      }
    }

    if (formData.files.isEmpty) {
      developer.log('📤 [SkillsScreen] No new certificates to upload. Proceeding with existing data.');
      finalSkillData = createSkillList(null);
      final user_id = _prefs.getUserId();
      context.read<MyProfileBloc>().add(LoadUpdateProfile(user_id ?? '6', finalSkillData));
      return;
    }

    developer.log('📤 [SkillsScreen] Uploading ${formData.files.length} certificate(s)...');
    context.read<UploadFileBloc>().add(LoadUploadFile(formData));
  }

  Map<String, dynamic> createSkillList(List<dynamic>? urls) {
    // START WITH CURRENT PROFILE DATA — CRITICAL!
    // Ensure _currentUserProfile is populated from MyProfileLoaded state
    final Map<String, dynamic> currentData = _currentUserProfile?.toJson() ?? <String, dynamic>{};

    // BUILD YOUR UPDATED SKILLS LIST
    List<Map<String, dynamic>> skillList = [];

    for (int i = 0; i < selectedDomains.length; i++) {
      final domain = selectedDomains[i];
      // Use the stored authorityId, which is an int
      final int? selectedAuthorityId = authorityId;
      final subSkills = selectedSubSkillsPerDomain[domain] ?? [];

      if (selectedAuthorityId != null) { // Only add skills if an authority is selected
        for (int j = 0; j < subSkills.length; j++) {
          skillList.add({
            'skill_id': subSkills[j].id, // Ensure subSkills[j].id is the correct skill ID
            'authority_id': selectedAuthorityId, // Use the integer ID
          });
        }
      }
    }

    // OVERRIDE ONLY skills and certificate_images
    currentData['skills'] = skillList;
    currentData['certificate_images'] = urls ?? [];

    developer.log('🎯 [SkillsScreen] Final merged data for API: ${jsonEncode(currentData)}');
    return currentData;
  }
}