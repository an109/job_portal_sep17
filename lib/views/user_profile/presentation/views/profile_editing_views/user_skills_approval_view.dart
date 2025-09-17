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
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/skill_bloc/skill_bloc.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/skill_bloc/skill_event.dart'
    as se;
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/skill_bloc/skill_state.dart';
import 'package:job_portal/views/user_profile/domain/entities/user_details_entity.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_state.dart';
// import 'package:job_portal/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../../Widgets/widgets.dart'; // for MediaType

class UserSkillsApprovalScreen extends StatefulWidget {
  final List<ProfileSkillEntity> skillList;
  const UserSkillsApprovalScreen({super.key, required this.skillList});

  @override
  State<UserSkillsApprovalScreen> createState() =>
      _UserSkillsApprovalScreenState();
}

class _UserSkillsApprovalScreenState extends State<UserSkillsApprovalScreen> {
  TextEditingController skillsSearchController = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    int j = 0;

    /// Pre-fill data from profileSkills
    for (int i = 0; i < widget.skillList.length; i++) {
      j = 0;
      final skill = widget.skillList[i];

      // 1. Add domain
      selectedDomains.add(skill.domain);

      // 2. Convert subSkills (String) → List<SkillEntity>
      final subSkillEntities = skill.subSkills
          .map((s) => SkillEntity(
              name: s, id: j++)) // adapt according to your SkillEntity
          .toList();

      subSkillsMap[skill.domain] = subSkillEntities;
      selectedSubSkillsPerDomain[skill.domain] = subSkillEntities;

      // 3. Authorities / College input
      courseCollegeControllers[skill.domain] = TextEditingController(
        text: skill.authority.isNotEmpty ? skill.authority.first : '',
      );

      // 4. Certificates
      if (skill.certificateImages.isNotEmpty) {
        certificateImages[skill.domain] = skill.certificateImages[0];
        // "files": skill.certificateImages
        //     .map((img) => {"name": img}) // mimic file structure
        //     .toList()
      }
    }

    setState(() {}); // rebuild UI with filled data
  }

  String? getCertificateImageName(
      dynamic domain, Map<String, dynamic> certificateImages) {
    try {
      // Try to access as a file
      return certificateImages[domain]?.files.first.name ?? null;
    } catch (e) {
      // If not a file, assume it's a string
      return certificateImages[domain]?.toString() ?? null;
    }
  }

  // Create a param for skills selected. to preserve state when going back and fourth.
  Future<void> cacheSkills() async {
    var map = {
      'selectedDomains': selectedDomains,
      'selectedSubSkillsPerDomain': selectedSubSkillsPerDomain
    };

    await _prefs.setSkillParams(map);
  }

  int iterator = 0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    final bloc = context.read<SkillBloc>();
    bloc.add(const se.LoadDomains());

    // context.read<SkillBloc>().add(LoadSubSkills(tempSelectedDomains.first));

    super.didChangeDependencies();
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
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/message_icon.svg"),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset("assets/Icons/notifications_icon.svg"),
            ),
          ),
        ],
        leading: IconButton(
            onPressed: () async {
              await cacheSkills();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(
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
                        } else if (state is SubSkillLoaded) {
                          final data = state.subSkillResponse;
                          final domain = state.domain;
                          developer.log('Subskills loaded.');
                          if (!subSkillsMap.containsKey(domain)) {
                            developer.log('Subskills loaded unique.');
                            setState(() {
                              subSkillsMap[domain] = data.skills;
                              developer.log('Subskills map : $subSkillsMap');
                            });
                          }
                        } else if (state is SkillCertificatesLoaded) {
                          final certificates = state.skillCertificates;

                          setState(() {
                            certificateImages = certificates;
                          });

                          developer.log('Certificates : $certificates');
                        } else if (state is SkillCertificateLoading) {
                          developer.log('Picking Certificate.');
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
                              context.read<SkillBloc>().add(se.LoadSubSkills(
                                  value.name, value.id.toString()));
                              setState(() {
                                selectedDomains.add(value.name);
                                _autoCompleteKey = UniqueKey();
                              });
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
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: selectedDomains.length,
                      itemBuilder: (context, index) {
                        final domain = selectedDomains[index];
                        final subSkills = subSkillsMap[domain] ?? [];
                        final selectedSkills =
                            selectedSubSkillsPerDomain[domain] ?? [];

                        // Initialize the controller if not already present
                        courseCollegeControllers.putIfAbsent(
                            domain, () => TextEditingController());

                        final fname =
                            getCertificateImageName(domain, certificateImages);

                        return Column(
                          children: [
                            preferenceContainer(
                              cName: domain,
                              // fileName:
                              //     certificateImages[domain]?.files.first.name,
                              fileName: (fname != null && fname.length > 10)
                                  ? fname.substring(fname.length - 10)
                                  : (fname),

                              onTap: () {},
                              subSkills: subSkills,
                              selectedSubSkills: selectedSkills,
                              onSkillTap: (skill) {
                                setState(() {
                                  final selected =
                                      selectedSubSkillsPerDomain[domain] ?? [];
                                  if (selected.contains(skill)) {
                                    selected.remove(skill);
                                  } else {
                                    selected.add(skill);
                                  }
                                  selectedSubSkillsPerDomain[domain] =
                                      List.from(selected);
                                });
                              },
                              courseCollegeController:
                                  courseCollegeControllers[domain]!,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter the details';
                                }
                                return null;
                              },
                              onUploadCertificateTap: () {
                                if (domain.isNotEmpty) {
                                  final skill = domain;
                                  developer.log('Skill : $skill');
                                  if (skill != null) {
                                    context.read<SkillBloc>().add(
                                        se.PickCertificate(skillName: skill));
                                  } else {
                                    // show snackbar or dialog to tell user to select only one
                                    showSnackbar(
                                        'Please select only one skill to upload certificate.',
                                        context);
                                  }
                                }
                              },
                              onCrossTap: () {
                                setState(() {
                                  courseCollegeControllers.remove(domain);
                                  // remove the certificate for this skill too
                                  context.read<SkillBloc>().add(
                                      se.RemoveCertificate(skillName: domain));
                                  selectedSubSkillsPerDomain.remove(domain);
                                  selectedDomains.removeAt(index);
                                });
                              }, onCollegeSelected: (int? collegeId) {  },
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
                          developer
                              .log('update profile loaded in skills screen');
                          showSnackbar(
                              state.updateUserProfileEntity.message, context);
                          Navigator.pop(context);
                        } else if (state is UpdateProfileLoading) {
                          developer
                              .log('update profile loading in skills screen');
                        } else if (state is UpdateProfileError) {
                          developer
                              .log('update profile error in skills screen');
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

                              finalSkillData = createSkillList(urls.url);

                              final _prefs = sl<PreferencesManager>();
                              final user_id = _prefs.getUserId();
                              context.read<MyProfileBloc>().add(
                                  LoadUpdateProfile(
                                      user_id ?? '6', finalSkillData));
                            } else if (state is UploadFileLoading) {
                              developer.log(
                                  'Wait we are uploading your certificates.');
                            } else if (state is UploadFileError) {
                              developer
                                  .log('Error while uploading certificates.');
                            }
                          },
                          child: const SizedBox(),
                        ),
                        SizedBox(
                          width: 150,
                          child: nextButton(
                            title: "Save Changes",
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                // final skillList = await createSkillList();
                                await uploadCertificates();
                                _prefs.clear(PreferencesManager.SKILL_PARAMS);
                              } else {
                                showSnackbar(
                                    'Please enter all the details', context);
                              }
                            },
                          ),
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
    // Step 2: Create FormData
    final formData = FormData();

    // Step 3: Attach certificate images with indexed keys
    // ignore: unused_local_variable
    int index = 0;
    for (var domain in certificateImages.keys) {
      final file = certificateImages[domain].files.first;
      if (file != null) {
        final fileName = file.path.split('/').last;
        formData.files.add(
          MapEntry(
            // 'certificate_image_$index',
            'certificateImage',
            await MultipartFile.fromFile(file.path, filename: fileName),
          ),
        );
        index++;
      }
    }
    // ✅ Skip API call if no files
    if (formData.files.isEmpty) {
      developer.log('No certificate files to upload, skipping API call.');
      finalSkillData = createSkillList(null);
      final _prefs = sl<PreferencesManager>();
      final user_id = _prefs.getUserId();
      context
          .read<MyProfileBloc>()
          .add(LoadUpdateProfile(user_id ?? '6', finalSkillData));
      return;
    }
    context.read<UploadFileBloc>().add(LoadUploadFile(formData));

    developer.log(
        'For Data of skill\nfields : ${formData.fields}\nfiles : ${formData.files}');
  }

  Map<String, dynamic> createSkillList(List<dynamic>? urls) {
    // Step 1: Construct skill list
    List<Map<String, dynamic>> skillList = [];

    for (int i = 0; i < selectedDomains.length; i++) {
      final domain = selectedDomains[i];
      final authority = courseCollegeControllers[domain]?.text ?? '';
      final subSkills = selectedSubSkillsPerDomain[domain] ?? [];

      for (int j = 0; j < subSkills.length; j++) {
        skillList.add({
          'skill_id': subSkills[j].id, // check this
          "skill": subSkills[j].name,
          "authority": authority,
        });
      }
    }

    final map = {'skills': skillList, 'certificate_images': urls};

    developer.log('Skill map : $map');

    return map;
  }
}
