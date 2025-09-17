import 'dart:developer' as developer show log;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:job_portal/UI_Helper/responsive_extensions.dart';

import '../../../../Widgets/widgets.dart';
import '../../../../injection_container.dart';
import '../../../post_opportunities/presentation/views/post_opportunity_screen.dart';
import '../../data/data_sources/company_register_api_service.dart';
import '../../domain/usecases/company_register_usecase.dart';
import '../bloc/company_register_bloc.dart';
import '../bloc/company_register_event.dart';
import '../bloc/company_register_state.dart';
import 'controller.dart';
import 'model.dart';

class CompanyProfileScreen extends StatefulWidget {
  const CompanyProfileScreen({super.key});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  Map<String, dynamic>? masterData;
  final _formKey = GlobalKey<FormState>();

  final controller = Get.put(CompanyProfileController());

  // Controllers
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController aboutCompanyController = TextEditingController();

  // Selected values
  String? selectedDesignation;
  String? selectedIndustry;
  String? selectedLocation;
  List<String> selectedLanguages = [];

  // File paths
  String? companyLogoPath;
  String? profilePicturePath;

  // Checkboxes
  bool isEmailVerified = false;
  bool isPhoneVerified = false;
  bool isGstVerified = false;

  @override
  void initState() {
    super.initState();
    _loadMasterData();
    controller.fetchMasterData();
  }

  void _loadMasterData() async {
    try {
      final apiService = sl<CompanyRegisterApiService>();
      final response = await apiService.getMasterAllData();

      if (response.success) {
        setState(() {
          masterData = response.data;
        });

        final domains = masterData?['domains'] as List?;
        final domainNames = domains?.map((d) => d['domain_name'] as String).toList();
        developer.log("📄 Available industries: $domainNames", name: "data.domains");

        developer.log(" Master data loaded", name: "data.loaded");
        developer.log(" Available domains: ${masterData?['domains']?.map((d) => d['domain_name'])}", name: "data.debug");
      } else {
        developer.log("❌ Failed to load master data", name: "data.error");
      }
    } catch (e) {
      developer.log("❌ Error loading master data: $e", name: "data.error");
    }
  }

  String? _getDesignationId(String? designation) {
    if (masterData == null || designation == null) return null;
    try {
      final role = masterData!['jobRoles'].firstWhere(
            (r) => r['title'] == designation,
        orElse: () => {},
      );
      return role['id']?.toString();
    } catch (e) {
      developer.log("❌ Error finding designation ID: $e", name: "designation.id");
      return null;
    }
  }

  String? _getIndustryId(String? industry) {
    if (masterData == null || industry == null) return null;
    try {
      final domain = masterData!['domains'].firstWhere(
            (d) => d['domain_name'] == industry,
        orElse: () => {},
      );
      return domain['domain_id']?.toString();
    } catch (e) {
      developer.log("❌ Error finding industry ID: $e", name: "industry.id");
      return null;
    }
  }

  String? _getLocationId(String? location) {
    if (masterData == null || location == null) return null;
    try {
      final loc = masterData!['locations'].firstWhere(
            (l) => l['name'] == location,
        orElse: () => {},
      );
      return loc['id']?.toString(); // ✅ 'id' is correct
    } catch (e) {
      developer.log("❌ Error finding location ID: $e", name: "location.id");
      return null;
    }
  }

  List<int> _getLanguageIds(List<String> selectedLanguages) {
    if (masterData == null) return [];
    try {
      return (masterData!['languages'] as List)
          .where((l) => selectedLanguages.contains(l['name']))
          .map<int>((l) => l['id'] as int)
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use your responsive extensions
    final screenWidth = context.screenWidth;
    final screenHeight = context.screenHeight;

    // 🔁 Show loading if masterData is not loaded
    if (masterData == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: context.rh(2)), // Responsive height
              Text("Loading master data..."),
            ],
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) => CompanyRegisterBloc(
        createCompanyUsecase: sl<CreateCompanyUsecase>(),
        getMasterDataUsecase: sl<GetMasterDataUsecase>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create Profile"),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocListener<CompanyRegisterBloc, CompanyRegisterState>(
          listener: (context, state) {
            if (state is CompanyRegisterSuccess) {
              developer.log("✅ Company registered successfully", name: "api.success");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile created successfully!")),
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostInternshipsScreen()),
              );
            } else if (state is CompanyRegisterError) {
              developer.log("❌ Registration failed: ${state.message}", name: "api.error");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${state.message}")),
              );
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.rw(6), // Responsive padding
              vertical: context.rh(2.5), // Responsive padding
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Designation Field
                  Text(
                    "Designation",
                    style: TextStyle(
                        fontSize: context.responsiveFontSize(baseSize: 14),
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: context.rh(1)), // Responsive spacing
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedDesignation,
                      items: (masterData?['jobRoles'] as List)
                          .map((role) {
                        final title = role['title'] as String? ?? '';
                        return DropdownMenuItem(
                          value: title,
                          child: Text(title),
                        );
                      })
                          .toList(),
                      hint: Text("Select your designation"),
                      onChanged: (value) {
                        setState(() {
                          selectedDesignation = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Designation is required";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: context.rh(1.5)), // Responsive spacing

                  // Company Name Field
                  Text(
                    "Company Name",
                    style: TextStyle(
                        fontSize: context.responsiveFontSize(baseSize: 14),
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: context.rh(1)), // Responsive spacing
                  TextFormField(
                    controller: companyNameController,
                    decoration: InputDecoration(
                      hintText: "e.g. Tech Solutions Inc.",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Company name is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: context.rh(1.5)), // Responsive spacing

                  // Industry Field
                  Text(
                    "Industry",
                    style: TextStyle(
                        fontSize: context.responsiveFontSize(baseSize: 14),
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: context.rh(1)), // Responsive spacing
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedIndustry,
                      items: (masterData?['domains'] as List)
                          .map((domain) {
                        final name = domain['domain_name'] as String;
                        return DropdownMenuItem(value: name, child: Text(name));
                      })
                          .toList(),
                      onChanged: (value) => setState(() => selectedIndustry = value),
                    ),
                  ),

                  SizedBox(height: context.rh(1.5)), // Responsive spacing

                  // Company Location Field
                  Text(
                    "Company Location",
                    style: TextStyle(
                        fontSize: context.responsiveFontSize(baseSize: 14),
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: context.rh(1)), // Responsive spacing
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedLocation,
                      items: (masterData?['locations'] as List)
                          .map((location) {
                        final name = location['name'] as String? ?? '';
                        return DropdownMenuItem(
                          value: name,
                          child: Text(name),
                        );
                      })
                          .toList(),
                      hint: Text("Select location"),
                      onChanged: (value) {
                        setState(() {
                          selectedLocation = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: context.rh(1.5)), // Responsive spacing

                  // About Company Field
                  Text(
                    "About Company",
                    style: TextStyle(
                        fontSize: context.responsiveFontSize(baseSize: 15),
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: context.rh(1)), // Responsive spacing
                  TextFormField(
                    controller: aboutCompanyController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Describe your company...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 10) {
                        return "About section must be at least 10 characters";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: context.rh(1.5)), // Responsive spacing

                  // Company Logo Upload
                  Text(
                    "Company Logo",
                    style: TextStyle(
                        fontSize: context.responsiveFontSize(baseSize: 14),
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: context.rh(1)), // Responsive spacing
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await FilePicker.platform.pickFiles(allowMultiple: false);
                            if (result != null && result.files.isNotEmpty) {
                              final file = result.files.first;
                              setState(() {
                                companyLogoPath = file.name;
                              });
                            }
                          },
                          child: Text("Choose File"),
                        ),
                      ),
                      SizedBox(width: context.rw(2)), // Responsive spacing
                      if (companyLogoPath != null)
                        Expanded(
                          child: Text(
                            companyLogoPath!,
                            style: TextStyle(fontSize: context.responsiveFontSize(baseSize: 12)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      SizedBox(width: context.rw(2)), // Responsive spacing
                      if (companyLogoPath != null)
                        Container(
                          width: context.rw(10), // Responsive width
                          height: context.rw(10), // Responsive height
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              "L",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: context.responsiveFontSize(baseSize: 16)
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: context.rh(1.5)), // Responsive spacing

                  // Profile Picture Upload
                  Text(
                    "Profile Picture",
                    style: TextStyle(
                        fontSize: context.responsiveFontSize(baseSize: 14),
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: context.rh(1)), // Responsive spacing
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await FilePicker.platform.pickFiles(allowMultiple: false);
                            if (result != null && result.files.isNotEmpty) {
                              final file = result.files.first;
                              setState(() {
                                profilePicturePath = file.name;
                              });
                            }
                          },
                          child: Text("Choose File"),
                        ),
                      ),
                      SizedBox(width: context.rw(2)), // Responsive spacing
                      if (profilePicturePath != null)
                        Expanded(
                          child: Text(
                            profilePicturePath!,
                            style: TextStyle(fontSize: context.responsiveFontSize(baseSize: 12)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: context.rh(1.5)), // Responsive spacing

                  // Languages Dropdown
                  Text(
                    "Languages (Optional)",
                    style: TextStyle(
                        fontSize: context.responsiveFontSize(baseSize: 14),
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: context.rh(1)), // Responsive spacing
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      items: [
                        DropdownMenuItem(value: "English", child: Text("English")),
                        DropdownMenuItem(value: "Hindi", child: Text("Hindi")),
                        DropdownMenuItem(value: "Spanish", child: Text("Spanish")),
                      ],
                      hint: Text("Select languages"),
                      onChanged: (value) {
                        setState(() {
                          if (value != null && !selectedLanguages.contains(value)) {
                            selectedLanguages.add(value);
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(height: context.rh(1.5)), // Responsive spacing

                  // Checkboxes
                  Row(
                    children: [
                      Checkbox(
                        value: isEmailVerified,
                        onChanged: (value) {
                          setState(() {
                            isEmailVerified = value!;
                          });
                        },
                      ),
                      Text("Email Verified", style: TextStyle(
                          fontSize: context.responsiveFontSize(baseSize: 12)
                      )),
                      SizedBox(width: context.rw(5)), // Responsive spacing
                      Checkbox(
                        value: isPhoneVerified,
                        onChanged: (value) {
                          setState(() {
                            isPhoneVerified = value!;
                          });
                        },
                      ),
                      Text("Phone Verified", style: TextStyle(
                          fontSize: context.responsiveFontSize(baseSize: 12)
                      )),
                      SizedBox(width: context.rw(5)), // Responsive spacing
                      Checkbox(
                        value: isGstVerified,
                        onChanged: (value) {
                          setState(() {
                            isGstVerified = value!;
                          });
                        },
                      ),
                      Text("GST Verified", style: TextStyle(
                          fontSize: context.responsiveFontSize(baseSize: 12)
                      )),
                    ],
                  ),
                  SizedBox(height: context.rh(3)), // Responsive spacing

                  // Submit Button
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: context.rw(40), // Responsive width
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final designationId = _getDesignationId(selectedDesignation);
                            final industryId = _getIndustryId(selectedIndustry);
                            final locationId = _getLocationId(selectedLocation);
                            final languageIds = _getLanguageIds(selectedLanguages);

                            if (designationId == null) {
                              showSnackbar("Please select a valid designation", context);
                              return;
                            }
                            if (industryId == null) {
                              showSnackbar("Please select a valid industry", context);
                              return;
                            }
                            if (locationId == null) {
                              showSnackbar("Please select a valid location", context);
                              return;
                            }
                            if (languageIds.isEmpty) {
                              showSnackbar("Please select at least one language", context);
                              return;
                            }

                            final request = CompanyProfileRequest(
                              designationId: int.parse(designationId),
                              companyName: companyNameController.text.trim(),
                              industryId: int.parse(industryId),
                              companyLocationId: int.parse(locationId),
                              about: aboutCompanyController.text.trim(),
                              logoUrl: companyLogoPath ?? "",
                              profilePic: profilePicturePath ?? "kj",
                              hiringPreferences: "Looking for experienced developers...",
                              isEmailVerified: isEmailVerified,
                              isPhoneVerified: isPhoneVerified,
                              isGstVerified: isGstVerified,
                              languageIds: [1,2,3],
                            );

                            print("Response===============>>>>>>>>>>>>>>>>>");

                            controller.createCompanyProfile(request);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text("Create Profile"),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    companyNameController.dispose();
    aboutCompanyController.dispose();
    super.dispose();
  }
}