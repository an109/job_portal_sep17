import 'dart:convert';
import 'dart:developer' as developer show log;

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/utils/constants/image_string.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:job_portal/utils/upload_file_get_url/presentation/bloc/upload_file_bloc.dart';
import 'package:job_portal/utils/upload_file_get_url/presentation/bloc/upload_file_event.dart';
import 'package:job_portal/utils/upload_file_get_url/presentation/bloc/upload_file_state.dart';
import 'package:job_portal/views/detailed_signup_student/domain/entities/metadata_entities.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/skill_bloc/skill_bloc.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/skill_bloc/skill_event.dart' as se;
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/skill_bloc/skill_state.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/views/signup_your_preferences_view.dart';
import 'package:job_portal/ui_helper/ui_helper.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_state.dart';
import 'package:job_portal/Widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPageYourSkills extends StatefulWidget {
  Map<String, dynamic> params;
  SignupPageYourSkills({super.key, required this.params});

  @override
  State<SignupPageYourSkills> createState() => _SignupPageYourSkillsState();
}

class _SignupPageYourSkillsState extends State<SignupPageYourSkills> {
  TextEditingController skillsSearchController = TextEditingController();
  String? token;
  String? selectedDomain;

  final _prefs = sl<PreferencesManager>();

  final _formKey = GlobalKey<FormState>();
  UniqueKey _autoCompleteKey = UniqueKey();

  List<DomainEntity> allDomains = [];
  List<String> tempSelectedDomains = [];
  List<String> selectedDomains = [];

  var skillParams = {};
  Map<String, List<SkillEntity>> subSkillsMap = {};
  Map<String, List<SkillEntity>> selectedSubSkillsPerDomain = {};
  final Map<String, TextEditingController> courseCollegeControllers = {};
  Map<String, dynamic> certificateImages = {};
  Map<String, dynamic> finalSkillData = {};
  Map<String, int?> selectedAuthorityIdPerDomain = {};

  @override
  void initState() {
    super.initState();
    developer.log("✅ [SignupPageYourSkills] initState called");
  }

  Future<void> cacheSkills() async {
    var map = {
      'selectedDomains': selectedDomains,
      'selectedSubSkillsPerDomain': selectedSubSkillsPerDomain
    };
    await _prefs.setSkillParams(map);
    developer.log("💾 [cacheSkills] Saved to prefs: $map");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    developer.log("🔄 [didChangeDependencies] Triggering LoadDomains and Load Companies");
    context.read<SkillBloc>().add(const se.LoadDomains());
  }

  void _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
    });
    developer.log("🔑 [loadToken] Token loaded: $token");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(""),
        leading: IconButton(
          onPressed: () async {
            await cacheSkills();
            developer.log("⬅️ [AppBar] Back button pressed, cached skills, popping...");
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mSpacer(mHeight: 8.0),
                    BlocListener<SkillBloc, SkillState>(
                      listener: (context, state) {
                        if (state is SkillStateDomainLoaded) {
                          setState(() {
                            allDomains = state.domainAllResponse.domains;
                          });
                          developer.log("🌐 [BlocListener SkillBloc] Domains loaded: ${allDomains.length} items");
                        } else if (state is SubSkillLoaded) {
                          final data = state.subSkillResponse;
                          final domain = state.domain;
                          developer.log('📚 [BlocListener SkillBloc] Subskills loaded for domain: $domain');
                          if (!subSkillsMap.containsKey(domain)) {
                            setState(() {
                              subSkillsMap[domain] = data.skills;
                            });
                            developer.log('📌 [BlocListener SkillBloc] Added to subSkillsMap: $domain → ${data.skills.length} skills');
                          }
                        } else if (state is SkillCertificatesLoaded) {
                          final certificates = state.skillCertificates;
                          setState(() {
                            certificateImages = certificates;
                          });
                          developer.log('🖼️ [BlocListener SkillBloc] Certificates loaded: $certificates');
                        } else if (state is SkillCertificateLoading) {
                          developer.log('⏳ [BlocListener SkillBloc] Picking Certificate...');
                        }
                      },
                      child: Container(
                        key: _autoCompleteKey,
                        child: CustomAutocompleteGeneric(
                          options: allDomains,
                          label: 'Select Area of interest',
                          displayStringForOption: (p0) => p0.name,
                          onSelected: (value) {
                            if (!selectedDomains.contains(value.name)) {
                              context.read<SkillBloc>().add(se.LoadSubSkills(value.name, value.id.toString()));
                              setState(() {
                                selectedDomains.add(value.name);
                                _autoCompleteKey = UniqueKey();
                              });
                              developer.log('✅ [Autocomplete] Domain selected: ${value.name}');
                            } else {
                              showSnackbar('Skill already selected.', context);
                              setState(() {
                                _autoCompleteKey = UniqueKey();
                              });
                              developer.log('❌ [Autocomplete] Domain already selected: ${value.name}');
                            }
                          },
                        ),
                      ),
                    ),
                    mSpacer(mHeight: 16.0),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: selectedDomains.length,
                      itemBuilder: (context, index) {
                        final domain = selectedDomains[index];
                        final subSkills = subSkillsMap[domain] ?? [];
                        final selectedSkills = selectedSubSkillsPerDomain[domain] ?? [];

                        courseCollegeControllers.putIfAbsent(domain, () => TextEditingController());

                        return Column(
                          children: [
                            preferenceContainer(
                              cName: domain,
                              fileName: certificateImages[domain]?.files.first.name,
                              onTap: () {},
                              subSkills: subSkills,
                              selectedSubSkills: selectedSkills,
                              onSkillTap: (skill) {
                                setState(() {
                                  final selected = selectedSubSkillsPerDomain[domain] ?? [];
                                  if (selected.contains(skill)) {
                                    selected.remove(skill);
                                    developer.log('➖ [Skill Tap] Skill deselected: ${skill.name}');
                                  } else {
                                    selected.add(skill);
                                    developer.log('➕ [Skill Tap] Skill selected: ${skill.name}');
                                  }
                                  selectedSubSkillsPerDomain[domain] = List.from(selected);
                                });
                              },
                              courseCollegeController: courseCollegeControllers[domain]!,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter the details';
                                }
                                return null;
                              },
                              onCollegeSelected: (collegeId) {
                                setState(() {
                                  selectedAuthorityIdPerDomain[domain] = collegeId;
                                });
                              },                              onUploadCertificateTap: () {
                                if (domain.isNotEmpty) {
                                  final skill = domain;
                                  developer.log('📎 [Upload Tap] Preparing to upload certificate for: $skill');
                                  context.read<SkillBloc>().add(se.PickCertificate(skillName: skill));
                                } else {
                                  showSnackbar('Please select only one skill to upload certificate.', context);
                                }
                              },
                              onCrossTap: () {
                                setState(() {
                                  courseCollegeControllers.remove(domain);
                                  context.read<SkillBloc>().add(se.RemoveCertificate(skillName: domain));
                                  selectedSubSkillsPerDomain.remove(domain);
                                  selectedAuthorityIdPerDomain.remove(domain);
                                  selectedDomains.removeAt(index);
                                });
                                developer.log('🗑️ [Cross Tap] Domain removed: $domain');
                              },
                            ),
                            mSpacer(),
                          ],
                        );
                      },
                    ),
                    mSpacer(mHeight: 24.0),
                    BlocListener<MyProfileBloc, MyProfileState>(
                      listener: (context, state) {
                        if (state is UpdateProfileLoaded) {
                          developer.log('✅ [MyProfileBloc] Profile update SUCCESS: ${state.updateUserProfileEntity.message}');
                          showSnackbar(state.updateUserProfileEntity.message, context);
                        } else if (state is UpdateProfileLoading) {
                          developer.log('⏳ [MyProfileBloc] Profile update LOADING...');
                        } else if (state is UpdateProfileError) {
                          developer.log('❌ [MyProfileBloc] Profile update ERROR: ${state}');
                        }
                      },
                      child: const SizedBox(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocListener<UploadFileBloc, UploadFileState>(
                          listener: (context, state) {
                            if (state is UploadFileLoaded) {
                              final urls = state.uploadFileEntity;
                              developer.log('✅ [UploadFileBloc] Certificates uploaded successfully. URLs: $urls');

                              finalSkillData = createSkillList(urls.url);
                              developer.log('📋 [UploadFileBloc] Final skill data constructed: $finalSkillData');

                              final _prefs = sl<PreferencesManager>();
                              final user_id = _prefs.getUserId();
                              developer.log('🆔 [UploadFileBloc] User ID for profile update: $user_id');

                              context.read<MyProfileBloc>().add(LoadUpdateProfile(user_id ?? '6', finalSkillData));
                            } else if (state is UploadFileLoading) {
                              developer.log('⏳ [UploadFileBloc] Uploading certificates...');
                            } else if (state is UploadFileError) {
                              developer.log('❌ [UploadFileBloc] Error uploading certificates.');
                            }
                          },
                          child: const SizedBox(),
                        ),
                        nextButton(
                          title: "Save Changes",
                          onTap: () async {
                            developer.log('🚀 [Save Changes Button] Tapped');

                            if (_formKey.currentState!.validate()) {
                              developer.log('✅ [Save Changes] Form validation PASSED');

                              await uploadCertificates();

                              _prefs.clear(PreferencesManager.SKILL_PARAMS);
                              developer.log('🧹 [Save Changes] Cleared SKILL_PARAMS from prefs');

                              final Map<String, dynamic> paramsCopy = Map.from(widget.params);
                              final userId = _prefs.getUserId();

                              if (userId != null) paramsCopy['user_id'] = userId;
                              developer.log('📋 [Save Changes] Params copy with user_id: $paramsCopy');

                              // Validate required fields
                              List<String> missingFields = [];
                              if (!paramsCopy.containsKey('first_name')) missingFields.add('first_name');
                              if (!paramsCopy.containsKey('email')) missingFields.add('email');
                              if (!paramsCopy.containsKey('gender')) missingFields.add('gender');
                              if (!paramsCopy.containsKey('dob')) missingFields.add('dob');
                              if (!paramsCopy.containsKey('phone')) missingFields.add('phone');

                              if (missingFields.isNotEmpty) {
                                String message = 'Missing fields: ${missingFields.join(", ")}';
                                showSnackbar(message, context);
                                developer.log('❌ [Save Changes] Validation FAILED: $message');
                                return;
                              }

                              developer.log('✅ [Save Changes] All required fields present. Navigating to next screen...');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupPageYourPreferences(params: paramsCopy),
                                ),
                              );
                            } else {
                              showSnackbar('Please enter all the details', context);
                              developer.log('❌ [Save Changes] Form validation FAILED');
                            }
                          },
                        ),
                      ],
                    ),
                    mSpacer(mHeight: 24.0),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> uploadCertificates() async {
    developer.log('📤 [uploadCertificates] Starting certificate upload process...');

    final formData = FormData();

    int index = 0;
    for (var domain in certificateImages.keys) {
      final file = certificateImages[domain].files.first;
      if (file != null) {
        final fileName = file.path.split('/').last;
        formData.files.add(
          MapEntry(
            'certificateImage',
            await MultipartFile.fromFile(file.path, filename: fileName),
          ),
        );
        developer.log('📎 [uploadCertificates] Attached file: $fileName for domain: $domain');
        index++;
      }
    }

    if (formData.files.isEmpty) {
      developer.log('ℹ️ [uploadCertificates] No files to upload. Skipping API call.');
      finalSkillData = createSkillList(null);
      final _prefs = sl<PreferencesManager>();
      final user_id = _prefs.getUserId();
      context.read<MyProfileBloc>().add(LoadUpdateProfile(user_id ?? '6', finalSkillData));
    } else {
      developer.log('📡 [uploadCertificates] Dispatching LoadUploadFile event with ${formData.files.length} files');
      context.read<UploadFileBloc>().add(LoadUploadFile(formData));
    }
  }

  Map<String, dynamic> createSkillList(List<dynamic>? urls) {
    developer.log('🧮 [createSkillList] Constructing skill list. Certificate URLs: $urls');

    List<Map<String, dynamic>> skillList = [];

    for (int i = 0; i < selectedDomains.length; i++) {
      final domain = selectedDomains[i];
      final authority = courseCollegeControllers[domain]?.text ?? '';
      final authorityId = selectedAuthorityIdPerDomain[domain] ?? 1;      final subSkills = selectedSubSkillsPerDomain[domain] ?? [];

      for (int j = 0; j < subSkills.length; j++) {
        final skill = subSkills[j];
        if (skill.id != null && skill.name?.isNotEmpty == true) {
          skillList.add({
            'skills_id': skill.id,
            "skills": skill.name,
            "authority_id": authorityId,
            "authority": authority,
          });
          developer.log('📝 [createSkillList] Added skill: ${skill.name} (ID: ${skill.id}) with authority: $authority');
        }
      }
    }

    final map = {'skills': skillList, 'certificate_image': urls};
    developer.log('✅ [createSkillList] Final payload: $map');
    return map;
  }
}