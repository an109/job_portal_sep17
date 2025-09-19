import 'dart:developer' as developer show log;

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/views/detailed_signup_student/domain/repository/detailed_signup_repository.dart';
import 'package:job_portal/views/post_opportunities/presentation/bloc/opportunity_bloc.dart';
import 'package:job_portal/views/post_opportunities/presentation/bloc/opportunity_event.dart';
import 'package:job_portal/views/post_opportunities/presentation/bloc/opportunity_state.dart';
import 'package:job_portal/views/user_profile/data/data_sources/profile_api_service.dart';
import '../../../../../Widgets/widgets.dart';
import '../../../../../utils/resourses/data_state.dart';
import '../../../../../utils/storage/shared_preference.dart';
import '../../../../../utils/upload_file_get_url/presentation/bloc/upload_file_bloc.dart';
import '../../../../../utils/upload_file_get_url/presentation/bloc/upload_file_event.dart';
import '../../../../../utils/upload_file_get_url/presentation/bloc/upload_file_state.dart';
import '../../../../detailed_signup_student/data/model/job_roles_response.dart';
import '../../../../detailed_signup_student/presentation/views/signup_as_anyone_view.dart';
import 'package:job_portal/views/post_opportunities/domain/entities/master_data_entity.dart';
import '../../../domain/entities/user_details_entity.dart';
import '../../bloc/your_experience_bloc/your_experience_bloc.dart';
import '../../bloc/your_experience_bloc/your_experience_event.dart';
import '../../bloc/your_experience_bloc/your_experience_state.dart';

class UserExperienceApprovalScreen extends StatefulWidget {
  final List<UserExperienceEntity> userExperience;
  const UserExperienceApprovalScreen({super.key, required this.userExperience});

  @override
  State<UserExperienceApprovalScreen> createState() =>
      _UserExperienceApprovalScreenState();
}

class _UserExperienceApprovalScreenState extends State<UserExperienceApprovalScreen> {
  final TextEditingController searchJobfieldController = TextEditingController();
  bool _isLoadingJobRoles = false;
  List<String> workedCompanyList = [];
  List<JobExperienceFillingCardData> jobExperienceControllers = [];
  Map<String, PlatformFile> experienceProofs = {};
  List<String> allJobRoles = [];

  List<CompanyItem> _allCompanies = [];
  List<JobRoleItem> _allJobRoles = [];
  Map<String, bool> isUploadComplete = {};

  final _formKey = GlobalKey<FormState>();

  // Track which company's certificate is being uploaded
  String? _lastUploadedCompany;
  Map<String, String> uploadedCertificateUrls = {};
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();

    // Pre-fill existing experiences
    for (var exp in widget.userExperience) {
      if (exp.current_company != null) {
        workedCompanyList.add(exp.current_company!);

        // Store the certificate URL if it exists
        if (exp.experienceCertificate != null && exp.experienceCertificate != "no_file.pdf") {
          uploadedCertificateUrls[exp.current_company!] = exp.experienceCertificate!;
        }

        jobExperienceControllers.add(JobExperienceFillingCardData(
          company_name: exp.current_company!,
          jobRoleController: TextEditingController(text: exp.current_job_role),
          start_year: TextEditingController(text: exp.start_date),
          end_year: TextEditingController(text: exp.end_date ?? ''),
          currentCTC: TextEditingController(text: '123123'),
          expProof: exp.experienceCertificate,
        ));
      }
    }
    _loadJobRoles();
    context.read<OpportunityBloc>().add(const LoadMasterDataEvent());
  }

  Future<void> _loadJobRoles() async {
    setState(() {
      _isLoadingJobRoles = true;
    });

    try {
      final repository = sl<DetailedSignupRepository>();
      final result = await repository.getJobRoles();

      if (result is DataSuccess<JobRolesListResponse>) {
        allJobRoles = result.data!.jobRoles;
        developer.log('Fetched roles: $allJobRoles');

        setState(() {
          _isLoadingJobRoles = false;
        });
      } else {
        developer.log('Failed to fetch job roles: ${result.error}');
        setState(() {
          _isLoadingJobRoles = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load job roles.')),
          );
        });
      }
    } catch (e, s) {
      developer.log('Exception fetching job roles: $e', stackTrace: s);
      setState(() {
        _isLoadingJobRoles = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading job roles.')),
        );
      });
    }
  }

  @override
  void dispose() {
    searchJobfieldController.dispose();
    for (var exp in jobExperienceControllers) {
      exp.jobRoleController.dispose();
      exp.start_year.dispose();
      exp.end_year.dispose();
      exp.currentCTC.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Your Experience", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<YourExperienceBloc>()),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<YourExperienceBloc, YourExperienceState>(
              listener: (context, state) {
                if (state is PickExperienceProofLoaded) {
                  developer.log(">>>>>>>>>>>>>>>File picked: ${state.experienceProof}");
                  final bloc = context.read<YourExperienceBloc>();
                  final blocProofs = bloc.experienceProofs;
                  for (var entry in blocProofs.entries) {
                    if (entry.value is PlatformFile) {
                      final companyName = entry.key;
                      final platformFile = entry.value as PlatformFile;
                      developer.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$platformFile");
                      developer.log("➡️ Picked file ${platformFile.name} for company: $companyName");
                      setState(() {
                        experienceProofs[companyName] = platformFile;
                        final index = jobExperienceControllers.indexWhere((e) => e.company_name == companyName);
                        if (index != -1) {
                          jobExperienceControllers[index].expProof = platformFile.name;
                          developer.log("📝 Updated JobExperienceController for $companyName with file ${platformFile.name}");

                        }
                      });

                      // Upload the file immediately after picking
                      _uploadCertificateForCompany(companyName, platformFile);
                    }
                  }
                } else if (state is PickExperienceProofError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to pick file')),
                  );
                } else if (state is NoExperienceProofPicked) {
                  developer.log("No file picked");
                }
              },
            ),
            BlocListener<UploadFileBloc, UploadFileState>(
              listener: (context, state) {
                if (state is UploadFileLoaded) {
                  final rawUrls = state.uploadFileEntity.url;
                  String? url;

                  if (rawUrls is List && rawUrls.isNotEmpty && rawUrls[0] is String) {
                    url = rawUrls[0] as String;
                  }

                  if (url == null) {
                    developer.log("❌ Invalid URL from upload");
                    _isUploading = false;
                    return;
                  }

                  if (_lastUploadedCompany != null) {
                    setState(() {
                      uploadedCertificateUrls[_lastUploadedCompany!] = url!;
                      isUploadComplete[_lastUploadedCompany!] = true; // ✅ Mark as complete

                      final index = jobExperienceControllers.indexWhere(
                            (e) => e.company_name == _lastUploadedCompany!,
                      );
                      if (index != -1) {
                        jobExperienceControllers[index].expProof = url;
                      }
                    });

                    _lastUploadedCompany = null;
                    _isUploading = false;
                  }
                } else if (state is UploadFileError) {
                  if (_lastUploadedCompany != null) {
                    setState(() {
                      isUploadComplete[_lastUploadedCompany!] = false; // ✅ Mark as failed
                    });
                  }
                  _isUploading = false;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to upload certificate')),
                  );
                }
              },
            ),          ],
          child: BlocBuilder<OpportunityBloc, OpportunityState>(
            builder: (context, state) {
              List<String> companies = [];
              if (state is MasterDataLoaded) {
                final master = state.masterData;

                final List<CompanyItem> companiesList = master.companies ?? [];
                _allCompanies = companiesList.where((c) =>
                c.companyName != null &&
                    !c.companyName!.contains('@') &&
                    !c.companyName!.contains('.com'))
                    .toList();

                final List<JobRoleItem> jobRolesList = master.jobRoles ?? [];
                _allJobRoles = jobRolesList;

                companies = _allCompanies.map((c) => c.companyName!).toList();
                allJobRoles = _allJobRoles.map((jr) => jr.title!).toList();
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Company Autocomplete
                        Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
                            return companies.where((company) => company.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                          },
                          onSelected: (selection) {
                            if (!workedCompanyList.contains(selection)) {
                              setState(() {
                                workedCompanyList.add(selection);
                                jobExperienceControllers.add(JobExperienceFillingCardData(
                                  company_name: selection,
                                  expProof: null,
                                  jobRoleController: TextEditingController(),
                                  start_year: TextEditingController(),
                                  end_year: TextEditingController(),
                                  currentCTC: TextEditingController(),
                                ));
                              });
                              searchJobfieldController.clear();
                            }
                          },
                          fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                hintText: "Select your company",
                                suffixIcon: const Icon(Icons.search),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        // Add Other Company Button
                        GestureDetector(
                          onTap: () {
                            final company = searchJobfieldController.text.trim();
                            if (!workedCompanyList.contains(company) && company.isNotEmpty) {
                              setState(() {
                                workedCompanyList.add(company);
                                jobExperienceControllers.add(JobExperienceFillingCardData(
                                  company_name: company,
                                  expProof: null,
                                  jobRoleController: TextEditingController(),
                                  start_year: TextEditingController(),
                                  end_year: TextEditingController(),
                                  currentCTC: TextEditingController(),
                                ));
                              });
                            }
                            searchJobfieldController.clear();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Icon(Icons.add, color: Colors.blue),
                              SizedBox(width: 8),
                              Text("Add other company", style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Experience Cards
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: jobExperienceControllers.length,
                          itemBuilder: (context, index) {
                            final curr = jobExperienceControllers[index];

                            // Determine the certificate display text
                            String certificateText;
                            if (uploadedCertificateUrls.containsKey(curr.company_name)) {
                              certificateText = 'Certificate uploaded ✓';
                            } else if (curr.expProof != null && curr.expProof != "no_file.pdf") {
                              certificateText = 'Certificate uploaded ✓';
                            } else if (experienceProofs.containsKey(curr.company_name)) {
                              certificateText = 'Uploading...';
                            } else {
                              certificateText = "Upload Certificate";
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                JobExperienceFillingCard(
                                  company_name: curr.company_name,
                                  experienceProofName: certificateText,
                                  jobRoleController: curr.jobRoleController,
                                  start_year: curr.start_year,
                                  end_year: curr.end_year,
                                  currentCTC: curr.currentCTC,
                                  onTapCross: () {
                                    setState(() {
                                      workedCompanyList.remove(curr.company_name);
                                      jobExperienceControllers.removeAt(index);
                                      experienceProofs.remove(curr.company_name);
                                      uploadedCertificateUrls.remove(curr.company_name);
                                    });
                                  },
                                  onTapPickCerti: () {
                                    context.read<YourExperienceBloc>().add(LoadPickExperienceProof(curr.company_name));
                                    setState(() {
                                      _lastUploadedCompany = curr.company_name;
                                    });
                                  },
                                  roles: allJobRoles,
                                  isCertificateUploaded: uploadedCertificateUrls.containsKey(curr.company_name) ||
                                      (curr.expProof != null && curr.expProof != "no_file.pdf"),
                                ),
                                const SizedBox(height: 24),
                              ],
                            );
                          },
                        ),

                        // Save Button
                        Center(
                          child: SizedBox(
                            width: 150,
                            child: nextButton(
                              title: "Save Changes",
                              onTap: () async {
                                if (_isUploading) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please wait for certificate upload to complete')),
                                  );
                                  return;
                                }

                                final companiesWithPendingUploads = jobExperienceControllers
                                    .where((e) => experienceProofs.containsKey(e.company_name)) // File picked
                                    .where((e) => isUploadComplete[e.company_name] != true)   // But upload not done
                                    .map((e) => e.company_name)
                                    .toList();

                                if (companiesWithPendingUploads.isNotEmpty) {
                                  final firstCompany = companiesWithPendingUploads.first;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Please wait — uploading certificate for $firstCompany...')),
                                  );
                                  return;
                                }
                                final isAnyUploadInProgress = jobExperienceControllers.any((e) {
                                  final hasFile = experienceProofs.containsKey(e.company_name);
                                  final isNotComplete = isUploadComplete[e.company_name] != true;
                                  return hasFile && isNotComplete;
                                });

                                if (isAnyUploadInProgress) {
                                  final firstPending = jobExperienceControllers.firstWhere((e) {
                                    final hasFile = experienceProofs.containsKey(e.company_name);
                                    final isNotComplete = isUploadComplete[e.company_name] != true;
                                    return hasFile && isNotComplete;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Uploading certificate for ${firstPending.company_name}...')),
                                  );
                                  return;
                                }


                                // ✅ 3. If all good, save
                                if (_formKey.currentState?.validate() ?? false) {
                                  await saveExperienceChanges();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Please complete all fields")),
                                  );
                                }
                              },
                              // onTap: () async {
                              //   if (_formKey.currentState?.validate() ?? false) {
                              //     if (_isUploading) {
                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //         const SnackBar(content: Text('Please wait for certificate upload to complete')),
                              //       );
                              //       return;
                              //     }
                              //     await saveExperienceChanges();
                              //   } else {
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //       const SnackBar(content: Text("Please complete all fields")),
                              //     );
                              //   }
                              // },
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _uploadCertificateForCompany(String companyName, PlatformFile file) async {
    if (file.path == null || file.path!.isEmpty)  {
      developer.log("No file path for company: $companyName");
      return;
    }

    setState(() {
      _isUploading = true;
      _lastUploadedCompany = companyName;
      isUploadComplete[companyName] = false;
      developer.log("🚀 Upload started for company: $companyName with file: ${file.name}");
    });

    try {
      final formData = FormData();
      final fileName = file.path!.split('/').last;

      formData.files.add(
        MapEntry(
          'certificateImage',
          await MultipartFile.fromFile(file.path!, filename: fileName),
        ),
      );

      developer.log("📤 Dispatching UploadFileBloc event with file: $fileName for $companyName");

      context.read<UploadFileBloc>().add(LoadUploadFile(formData));
    } catch (e) {
      developer.log("❌ Error creating FormData for $companyName: $e");
      setState(() {
        _isUploading = false;
        _lastUploadedCompany = null;
        isUploadComplete[companyName] = false;
      });
    }
  }

  Future<void> saveExperienceChanges() async {
    final repository = sl<ProfileApiService>();
    developer.log("💾 Saving experience changes...");

    final experienceList = jobExperienceControllers.map((e) {
      final totalExp = calculateExperience(e.start_year.text, e.end_year.text);

      final company = _allCompanies.firstWhere(
            (c) => c.companyName == e.company_name,
        orElse: () => CompanyItem(id: null, companyName: ''),
      );

      final jobRole = _allJobRoles.firstWhere(
            (jr) => jr.title == e.jobRoleController.text,
        orElse: () => JobRoleItem(id: null, title: '', description: ''),
      );

      if (company.id == null) {
        throw Exception('Invalid company: ${e.company_name}');
      }
      if (jobRole.id == null) {
        throw Exception('Invalid job role: ${e.jobRoleController.text}');
      }
      String certificateUrl;

// ✅ If upload was triggered (file picked), we MUST use uploaded URL
      if (experienceProofs.containsKey(e.company_name)) {
        // Upload was triggered — must have URL
        final uploadedUrl = uploadedCertificateUrls[e.company_name];
        if (uploadedUrl != null) {
          certificateUrl = uploadedUrl;
        } else {
          // This should not happen if logic is correct — but fail safe
          developer.log("❌ No uploaded URL for ${e.company_name} even though upload was triggered");
          certificateUrl = "no_file.pdf";
        }
      } else {
        // No new upload — use existing proof or default
        certificateUrl = e.expProof ?? "no_file.pdf";
      }
      developer.log("📦 Preparing experience for ${e.company_name}: role=${e.jobRoleController.text}, cert=$certificateUrl");


      return {
        "company_id": company.id,
        "job_role_id": jobRole.id,
        "start_date": e.start_year.text,
        "end_date": e.end_year.text,
        "ctc": e.currentCTC.text,
        "total_experience_years": totalExp,
        "experience_certificate": certificateUrl,
      };
    }).toList();

    final userId = sl<PreferencesManager>().getUserId();
    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found')),
      );
      return;
    }

    final params = {"experiences": experienceList};

    try {
      final result = await repository.updateUserDetailsById(userId, params);

      if (result.response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Experience updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update: ${result.response.statusMessage}')),
        );
      }
    } catch (e, s) {
      developer.log('Save error: $e', stackTrace: s);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Save failed')),
      );
    }
  }

  int calculateExperience(String start, String end) {
    try {
      final startYear = int.parse(start);
      final endYear = end.isEmpty ? DateTime.now().year : int.parse(end);
      return endYear - startYear;
    } catch (_) {
      return 0;
    }
  }
}

class JobExperienceFillingCard extends StatefulWidget {
  final String company_name;
  final String? experienceProofName;
  final TextEditingController jobRoleController;
  final TextEditingController start_year;
  final TextEditingController end_year;
  final TextEditingController currentCTC;
  final VoidCallback onTapCross;
  final VoidCallback onTapPickCerti;
  final List<String> roles;
  final bool isCertificateUploaded;

  const JobExperienceFillingCard({
    super.key,
    required this.company_name,
    required this.experienceProofName,
    required this.jobRoleController,
    required this.start_year,
    required this.end_year,
    required this.currentCTC,
    required this.onTapCross,
    required this.onTapPickCerti,
    required this.roles,
    this.isCertificateUploaded = false,
  });

  @override
  State<JobExperienceFillingCard> createState() => _JobExperienceFillingCardState();
}

class _JobExperienceFillingCardState extends State<JobExperienceFillingCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Name Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.company_name,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: widget.onTapCross,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Job Role/Profile with Autocomplete
            const Text("Job Role/Profile", style: TextStyle(fontSize: 12)),
            Autocomplete<String>(
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) return widget.roles;
                return widget.roles
                    .where((role) => role.toLowerCase().contains(textEditingValue.text.toLowerCase()));
              },
              onSelected: (selection) {
                widget.jobRoleController.text = selection;
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: "Digital Marketing",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                );
              },
            ),

            const SizedBox(height: 8),

            // Start & End Year
            Row(
              children: [
                Expanded(
                  child: DatePickerField(
                    controller: widget.start_year,
                    fillColor: Colors.white,
                    hintText: "Choose year",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DatePickerField(
                    controller: widget.end_year,
                    fillColor: Colors.white,
                    hintText: "Choose year",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // CTC
            const Text("CTC", style: TextStyle(fontSize: 12)),
            CustomTextField(
              controller: widget.currentCTC,
              hintText: "Eg. 4,00,000",
              fillColor: Colors.white,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return "Required";
                return null;
              },
            ),

            // Experience Certificate Upload
            const SizedBox(height: 8),
            GestureDetector(
              onTap: widget.onTapPickCerti,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      "assets/Icons/certificate.svg",
                      color: widget.isCertificateUploaded ? Colors.green : Colors.grey,
                      height: 12,
                      width: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.experienceProofName ?? "Upload Certificate",
                      style: TextStyle(
                        fontSize: 10,
                        color: widget.isCertificateUploaded ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JobExperienceFillingCardData {
  final String company_name;
  String? expProof;
  final TextEditingController jobRoleController;
  final TextEditingController start_year;
  final TextEditingController end_year;
  final TextEditingController currentCTC;

  JobExperienceFillingCardData({
    required this.company_name,
    this.expProof,
    required this.jobRoleController,
    required this.start_year,
    required this.end_year,
    required this.currentCTC,
  });
}