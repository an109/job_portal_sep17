import 'dart:developer' as developer show log;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/utils/constants/enums.dart';
import 'package:job_portal/utils/constants/image_string.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/basic_user_data_response.dart';
import 'package:job_portal/views/detailed_signup_student/domain/entities/metadata_entities.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/signup_as_anyone_bloc/detailed_signup_bloc.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/signup_as_anyone_bloc/detailed_signup_event.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/signup_as_anyone_bloc/detailed_signup_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../ui_helper/ui_helper.dart';
import '../../../../widgets/widgets.dart';
import '../bloc/master_data_bloc/master_data_bloc.dart';
import '../bloc/master_data_bloc/master_data_event.dart';
import '../bloc/master_data_bloc/master_data_state.dart';
import 'signup_your_skills_view.dart';

class SignupAsAnyOne extends StatefulWidget {
  final String email;
  Map<String, dynamic> params = {};
  // final BasicUserInfoResponse basicUserInfoResponse;

  SignupAsAnyOne({
    super.key,
    // required this.basicUserInfoResponse,
    required this.email,
  });
  @override
  State<SignupAsAnyOne> createState() => _SignInPageUniversityStudentState();
}

class _SignInPageUniversityStudentState extends State<SignupAsAnyOne> {
  String selectedOption = '';
  String? selectedClass;
  String? selectedCourse;
  int? selectedCurrentCity;
  int? selectedPreferredCity;
  int? selectedCourseId;
  String? selectedSpecialization;
  int? selectedSpecializationId;
  String? selectedjobRole;
  List<SpecializationEntity> _specializations = [];
  final FocusNode _specializationFocus = FocusNode();
  TextEditingController totalWorkExp = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  ///FOR COLLEGE DROPDOWN
  final LayerLink _collegeLayerLink = LayerLink();
  OverlayEntry? _collegeOverLayEntry;
  final GlobalKey _collegeFieldKey = GlobalKey();

  String selectedCollege = '';
  List<CollegeEntity> collegeNames = [];
  List<LocationEntity> cities = [];
  List<String> selectedCourses = [];
  final List<String> jobRoles = [
    "Software Engineer",
    "Frontend Developer",
    "Backend Developer",
    "Full Stack Developer",
    "Mobile App Developer",
    "Data Scientist",
    "Machine Learning Engineer",
    "UI/UX Designer",
    "Product Manager",
    "Project Manager",
    "Business Analyst",
    "DevOps Engineer",
    "Cloud Engineer",
    "Cybersecurity Analyst",
    "Database Administrator",
    "Network Engineer",
    "QA Engineer",
    "Game Developer",
    "AI Researcher",
    "Technical Support Engineer",
    "System Administrator",
    "Embedded Systems Engineer",
    "Data Engineer",
    "IT Consultant",
    "Web Developer",
  ];
  // var colleges = [];
  List<CourseEntity> courses = [];
  List<SpecializationEntity> specializations = [];

  @override
  void dispose() {
    _collegeOverLayEntry?.remove();
    _specializationOverlayEntry?.remove();
    collegeController.dispose();
    specializationController.dispose();
    super.dispose();
  }

  void _showDropdown() {
    final renderBox =
        _collegeFieldKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    // context.read<CollegeBloc>().add(FetchColleges());

    _collegeOverLayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        left: offset.dx,
        top: offset.dy,
        child: CompositedTransformFollower(
          link: _collegeLayerLink,
          offset: Offset(0, size.height),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(8),
            // child: BlocBuilder<CollegeBloc, CollegeState>(
            //   builder: (context, state) {
            //     if (state is CollegeLoading) {
            //       return const CircularProgressIndicator();
            //     } else if (state is CollegeLoaded) {
            //       return ListView(
            //         shrinkWrap: true,
            //         children: state.colleges.map((name) {
            //           return ListTile(
            //             visualDensity: VisualDensity(vertical: -4),
            //             title: Text(name),
            //             onTap: () {
            //               collegeController.text = name;
            //               _collegeOverLayEntry?.remove();
            //               _collegeOverLayEntry = null;
            //             },
            //           );
            //         }).toList(),
            //       );
            //     } else if (state is CollegeError) {
            //       return Text(state.message);
            //     }
            //     return const SizedBox.shrink();
            //   },
            // ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_collegeOverLayEntry!);
  }

  /// FOR GENDER DROP DOWN
  final LayerLink _genderLayerLink = LayerLink();
  OverlayEntry? _genderOverlayEntry;
  final GlobalKey _genderKey = GlobalKey();
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  String formatDobToIso(String dob) {
    try {
      final parts = dob.split('-'); // ["25", "07", "1985"]
      if (parts.length != 3) return 'Invalid date format';

      final day = parts[0].padLeft(2, '0');
      final month = parts[1].padLeft(2, '0');
      final year = parts[2];

      return '$year-$month-$day';
    } catch (e) {
      return 'Error formatting date';
    }
  }

  void _toggleGenderDropdown() {
    print("Gender dropdown tapped");
    if (_genderOverlayEntry == null) {
      _genderOverlayEntry = _createGenderOverlay();
      Overlay.of(context).insert(_genderOverlayEntry!);
    } else {
      _genderOverlayEntry?.remove();
      _genderOverlayEntry = null;
    }
  }

  OverlayEntry _createGenderOverlay() {
    if (_genderKey.currentContext == null) {
      debugPrint("genderKey currentContext is null");
      return OverlayEntry(
          builder: (_) => const SizedBox.shrink()); // or handle appropriately
    }

    final renderBox = _genderKey.currentContext!.findRenderObject();
    if (renderBox is! RenderBox) {
      debugPrint("RenderObject is not a RenderBox");
      return OverlayEntry(builder: (_) => const SizedBox.shrink());
    }

    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        left: offset.dx,
        top: offset.dy + size.height + 5,
        child: CompositedTransformFollower(
          link: _genderLayerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 100,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: genderOptions.map((option) {
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    title: Text(option),
                    onTap: () {
                      genderController.text = option;
                      _toggleGenderDropdown();
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// FOR SPECIALIZATION DROP DOWN
  final LayerLink _specializationLayerLink = LayerLink();
  OverlayEntry? _specializationOverlayEntry;
  final GlobalKey _specializationKey = GlobalKey();

  void _showSpecializationDropdown() {
    // Remove existing overlay
    _specializationOverlayEntry?.remove();
    _specializationOverlayEntry = null;

    // Get position of button
    if (_specializationKey.currentContext == null) return;
    final renderBox = _specializationKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _specializationOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        left: offset.dx,
        top: offset.dy + size.height,
        child: CompositedTransformFollower(
          link: _specializationLayerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 200,
              child: BlocBuilder<DetailedSignupBloc, DetailedSignupState>(
                builder: (context, state) {
                  if (state is DetailedSignupSpecializationLoading) {
                    return const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  } else if (state is DetailedSignupSpecializationLoaded) {
                    return ListView(
                      padding: EdgeInsets.zero,
                      children: state.specializationListResponse.map((spec) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedSpecialization = spec.name ?? '';
                            });
                            _specializationOverlayEntry?.remove();
                            _specializationOverlayEntry = null;
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Text(
                              spec.name ?? '',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "No options",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(_specializationOverlayEntry!);
  }

  /// FOR JOB LOCATION DROP DOWN
  final LayerLink _jobLocationLink = LayerLink();
  final GlobalKey _jobLocationFieldKey = GlobalKey();
  OverlayEntry? _jobLocationOverlayEntry;

  void _showJobLocationDropdown() {
    final renderBox =
        _jobLocationFieldKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    // context.read<JobLocationsBloc>().add(FetchJobLocations());

    _jobLocationOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        left: offset.dx,
        top: offset.dy + size.height,
        child: CompositedTransformFollower(
          link: _jobLocationLink,
          offset: Offset(0, size.height),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            // child: BlocBuilder<JobLocationsBloc, JobLocationsState>(
            //   builder: (context, state) {
            //     if (state is JobLocationsLoadingState) {
            //       return const Padding(
            //         padding: EdgeInsets.all(12),
            //         child: Center(child: CircularProgressIndicator()),
            //       );
            //     } else if (state is JobLocationsLoadedState) {
            //       return ListView(
            //         padding: EdgeInsets.zero,
            //         shrinkWrap: true,
            //         children: state.jobLocations.map((location) {
            //           return ListTile(
            //             dense: true,
            //             visualDensity: VisualDensity(vertical: -3),
            //             title: Text(location),
            //             onTap: () {
            //               JobLocationController.text = location;
            //               _jobLocationOverlayEntry?.remove();
            //               _jobLocationOverlayEntry = null;
            //             },
            //           );
            //         }).toList(),
            //       );
            //     } else if (state is JobLocationsErrorState) {
            //       return Padding(
            //         padding: const EdgeInsets.all(12),
            //         child: Text(state.message),
            //       );
            //     }
            //     return const SizedBox.shrink();
            //   },
            // ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_jobLocationOverlayEntry!);
  }

  /// FOR JOB ROLES DROP DOWN
  final LayerLink _jobRoleLink = LayerLink();
  final GlobalKey _jobRoleFieldKey = GlobalKey();
  OverlayEntry? _jobRoleOverlayEntry;

  void _showJobRoleDropdown() {
    final renderBox =
        _jobRoleFieldKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    // context.read<JobRoleBloc>().add(FetchJobRoles());

    _jobRoleOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        left: offset.dx,
        top: offset.dy + size.height,
        child: CompositedTransformFollower(
          link: _jobRoleLink,
          offset: Offset(0, size.height),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_jobRoleOverlayEntry!);
  }

  /// TEXT FIELDS USED
  final firstnameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final DOBController = TextEditingController();
  final cityController = TextEditingController();
  final genderController = TextEditingController();
  final collegeController = TextEditingController();
  final specializationController = TextEditingController();
  final startCourseYearController = TextEditingController();
  final endCourseYearController = TextEditingController();
  final startJobYearController = TextEditingController();
  final endJobYearController = TextEditingController();
  final TWXController = TextEditingController();
  final jobRoleController = TextEditingController();
  final current_company = TextEditingController();
  final CTCController = TextEditingController();
  final JobLocationController = TextEditingController();

  /// API CALLED TO FETCH BASIC USER DATA
  @override
  void initState() {
    super.initState();

    //  Load and prefill from temp data
    final prefs = sl<PreferencesManager>();
    firstnameController.text = prefs.getString('temp_first_name') ?? '';
    surnameController.text = prefs.getString('temp_last_name') ?? '';
    emailController.text = prefs.getString('temp_email') ?? '';
    phoneController.text = prefs.getString('temp_phone') ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MasterDataBloc>().add(LoadMasterData());
    });
  }

  @override
  void didChangeDependencies() {
    final bloc = context.read<DetailedSignupBloc>();
    // final emailMap = {'email': 'dikshavashist2007@gmail.com'};
    final emailMap = {'email': widget.email};
    // bloc.add(DetailedSignupGetCollegeDetails(emailMap));
    bloc.add(DetailedSignupGetBasicUserInfo(emailMap));
    super.didChangeDependencies();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("user_email");
    if (email == null) {
      print("No email found in SharedPreferences.");
    } else {
      print("Retrieved email: $email");
    } //  Email from login screen

    if (email != null && email.isNotEmpty) {
      // context.read<FetchUserBloc>().add(FetchUserDetailsEvent(email: email));
    } else {
      print("No email found in SharedPreferences.");
    }
  }

  @override
  Widget build(BuildContext context) {
    /// MAIN UI PERSPECTIVE CODE
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(""),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlocListener<DetailedSignupBloc, DetailedSignupState>(
                      listener: (context, state) {
                        if (state is DetailedSignupGetBasicUserInfoLoaded) {
                          final data = state.basicUserInfoResponse;
                          final locations = state.locations;
                          setState(() {
                            firstnameController.text = data.user.first_name;
                            surnameController.text = data.user.last_name;
                            emailController.text = data.user.email;
                            phoneController.text = data.user.phone;
                            cities = locations.locations;
                          });
                          final emailMap = {'email': widget.email};
                          context
                              .read<DetailedSignupBloc>()
                              .add(DetailedSignupGetCollegeDetails(emailMap));
                        } else if (state
                            is DetailedSignupGetCollegeDetailsLoaded) {
                          developer.log('Course and clg updated .1');
                          setState(() {
                            collegeNames = state.collegesListResponse.colleges;
                            courses = state.coursesListResponse.courses;
                          });
                        } else if (state
                            is DetailedSignupGetCollegeDetailsError) {
                          showSnackbar('Error loading details', context);
                        }
                      },
                      child: const SizedBox(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: SvgPicture.asset(
                        ImageString.jobPortalLogo,
                        height: 30,
                        fit: BoxFit.contain,
                        allowDrawingOutsideViewBox: true, // optional
                      ),
                    ),
                    mSpacer17(),
                    Container(
                      height: 70,
                      width: double.infinity,
                      child: Text(
                        "Let's get started! ",
                        style: mTextStyle32(mColor: Color(0xff1A1C1E)),
                      ),
                    ),
                    SvgPicture.asset(ImageString.progressBar1),
                    mSpacer17(),

                    /// BODY PART
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "First Name",
                          style: mTextStyle14(),
                        )),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                            child: Text(
                          "Last Name",
                          style: mTextStyle14(),
                        ))
                      ],
                    ),
                    mSpacer(mHeight: 2.0),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: firstnameController,
                            hintText: "Aman",
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'First name is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: surnameController,
                            hintText: "Gupta",
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Last name is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    mSpacer17(),

                    /// EMAIL TEXTFIELD
                    Text(
                      "Email",
                      style: mTextStyle14(),
                    ),
                    mSpacer(mHeight: 2.0),

                    IgnorePointer(
                      ignoring: false,
                      child: Opacity(
                        opacity: 0.7, // slightly greyed out to indicate disabled
                        child: CustomTextField(
                          controller: emailController,
                          hintText: "amangupta@gmail.com",
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),

                    mSpacer17(),

                    /// PHONE NUMBER TEXTFIELD
                    Text(
                      "Phone Number",
                      style: mTextStyle14(),
                    ),
                    CustomTextField(
                      controller: phoneController,
                      hintText: "",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Phone Number is required';
                        }
                        return null;
                      },
                    ),
                    mSpacer17(),

                    /// DATE OF BIRTH TEXTFIELD
                    Text(
                      "Date of Birth",
                      style: mTextStyle14(),
                    ),
                    InkWell(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now()
                              .subtract(const Duration(days: 365 * 40)),
                          firstDate: DateTime(1960),
                          lastDate: DateTime.now(),
                        );

                        if (pickedDate != null) {
                          String formattedDate =
                              "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                          DOBController.text = formattedDate;
                        }
                      },
                      child: IgnorePointer(
                        child: TextFormField(
                          controller: DOBController,
                          style: mTextStyle14(),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'DOB is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Select your DOB",
                            hintStyle: mTextStyle14(
                              mFontWeight: FontWeight.w500,
                              mColor: const Color(0xffBCC1CA),
                            ),
                            suffixIcon: const Icon(
                              Icons.keyboard_arrow_down,
                              size: 18,
                              color: Color(0xffBCC1CA),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14), // match height
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 1, color: Color(0xffBCC1CA)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 1, color: Color(0xffBCC1CA)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 1.5,
                                  color: Theme.of(context).primaryColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(width: 1, color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 1.5, color: Colors.red),
                            ),
                            errorStyle: const TextStyle(
                              fontSize: 12,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    mSpacer17(),

                    /// CURRENT CITY TEXT FIELD
                    Text(
                      "Current City",
                      style: mTextStyle14(),
                    ),
                    BlocBuilder<MasterDataBloc, MasterDataState>(
                      builder: (context, state) {
                        if (state is MasterDataLoaded) {
                          return CustomAutocompleteGeneric<LocationEntity>(
                            options: state.locations,
                            label: "Current City",
                            displayStringForOption: (loc) => loc.name,
                            onSelected: (loc) {
                              selectedCurrentCity = loc.id;
                            },
                          );
                        }
                        return const CircularProgressIndicator();
                      },
                    ),

                    // CustomAutocompleteGeneric(
                    //   options: cities,
                    //   displayStringForOption: (value) => value.name ?? '',
                    //   label: 'Current City',
                    //   onSelected: (value) {
                    //     selectedCurrentCity = value.name;
                    //     // showSnackbar('Selected $selectedCurrentCity', context);
                    //     developer.log(
                    //         'Selected Course variable : $selectedCurrentCity');
                    //   },
                    // ),

                    mSpacer17(),

                    /// JOB LOCATION TEXTFIELD
                    Text(
                      "Preferred Job Location",
                      style: mTextStyle14(),
                    ),

                    BlocBuilder<MasterDataBloc, MasterDataState>(
                      builder: (context, state) {
                        if (state is MasterDataLoaded) {
                          return CustomAutocompleteGeneric<LocationEntity>(
                            options: state.locations,
                            label: "Preferred Job Location",
                            displayStringForOption: (loc) => loc.name,
                            onSelected: (loc) {
                              selectedPreferredCity = loc.id;
                            },
                          );
                        }
                        return const CircularProgressIndicator();
                      },
                    ),

                    // CustomAutocompleteGeneric(
                    //   options: cities,
                    //   label: 'Preferred Job Location',
                    //   displayStringForOption: (value) => value.name ?? '',
                    //   onSelected: (value) {
                    //     selectedPreferredCity = value.name;
                    //     // showSnackbar('Selected $selectedPreferredCity', context);
                    //     developer.log(
                    //         'Selected Course variable : $selectedPreferredCity');
                    //   },
                    // ),
                    mSpacer17(),

                    /// GENDER TEXTFIELD
                    Text(
                      "Gender",
                      style: mTextStyle14(),
                    ),
                    CustomAutocomplete(
                      options: const ['Male', 'Female', 'Other'],
                      label: 'Gender',
                      onSelected: (value) {
                        genderController.text = value;
                        // showSnackbar('Selected ${genderController.text}', context);
                        developer.log(
                            'Selected Course variable : ${genderController.text}');
                      },
                    ),
                    mSpacer17(),

                    /// USER TYPE
                    Text(
                      "Type",
                      style: mTextStyle14(),
                    ),
                    Wrap(
                      spacing: 12, // space between containers horizontally
                      runSpacing: 12, // space between lines
                      children: [
                        OptionContainer(
                          title: "School Student",
                          imgPath: "assets/Icons/school_student.svg",
                          // isSelected: selectedOption == "School Student",
                          isSelected: selectedOption ==
                              JOBSEEKERTYPE.SchoolStudent.name,

                          onTap: () {
                            setState(() {
                              // selectedOption = "School Student";
                              selectedOption = JOBSEEKERTYPE.SchoolStudent.name;
                            });
                          },
                        ),
                        OptionContainer(
                          title: "College Student",
                          imgPath: "assets/Icons/College_Student.svg",
                          // isSelected: selectedOption == "College Student",
                          isSelected: selectedOption ==
                              JOBSEEKERTYPE.CollegeStudent.name,
                          onTap: () {
                            setState(() {
                              // selectedOption = "College Student";
                              selectedOption =
                                  JOBSEEKERTYPE.CollegeStudent.name;
                            });
                          },
                        ),
                        OptionContainer(
                          title: "Fresher",
                          imgPath: "assets/Icons/fresher_icon.svg",
                          // isSelected: selectedOption == "Fresher",
                          isSelected:
                              selectedOption == JOBSEEKERTYPE.Fresher.name,
                          onTap: () {
                            setState(() {
                              // selectedOption = "Fresher";
                              selectedOption = JOBSEEKERTYPE.Fresher.name;
                            });
                          },
                        ),
                        OptionContainer(
                          title: "Working Professional",
                          imgPath: "assets/Icons/working-professional.svg",
                          // isSelected: selectedOption == "Working Professional",
                          isSelected: selectedOption ==
                              JOBSEEKERTYPE.WorkingProffesional.name,
                          onTap: () {
                            setState(() {
                              // selectedOption = "Working Professional";
                              selectedOption =
                                  JOBSEEKERTYPE.WorkingProffesional.name;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    mSpacer(mHeight: 25.0),

                    /// FOR OPTION USER TYPE: SCHOOL STUDENT
                    if (selectedOption == JOBSEEKERTYPE.SchoolStudent.name)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Standard", style: mTextStyle12()),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing:
                                12, // horizontal spacing between OptionContainers
                            runSpacing: 8, // vertical spacing between rows
                            children: [
                              OptionContainer(
                                title: "Class XII",
                                imgPath: "",
                                isSelected: selectedClass == "Class XII",
                                onTap: () {
                                  setState(() {
                                    selectedClass = "Class XII";
                                  });
                                },
                              ),
                              OptionContainer(
                                title: "Class XI",
                                imgPath: "",
                                isSelected: selectedClass == "Class XI",
                                onTap: () {
                                  setState(() {
                                    selectedClass = "Class XI";
                                  });
                                },
                              ),
                              OptionContainer(
                                title: "Class X or below",
                                isSelected: selectedClass == "Class X or below",
                                onTap: () {
                                  setState(() {
                                    selectedClass = "Class X or below";
                                  });
                                },
                              ),
                            ],
                          ),
                          mSpacer(mHeight: 25.0),
                        ],
                      ),

                    /// FOR OPTION USER TYPE: COLLEGE STUDENT OR FRESHER
                    if (selectedOption == JOBSEEKERTYPE.CollegeStudent.name ||
                        selectedOption == JOBSEEKERTYPE.Fresher.name)
                      BlocListener<DetailedSignupBloc, DetailedSignupState>(
                          listener: (context, state) {
                            if (state
                                is DetailedSignupGetCollegeDetailsLoaded) {
                              developer.log('Course and clg updated .1');
                              setState(() {
                                developer.log('Course and clg updated .2');
                                collegeNames =
                                    state.collegesListResponse.colleges;
                                courses = state.coursesListResponse.courses;
                                developer.log('Course and clg updated .3');
                                // if specializations also come from API, update here
                              });
                            } else if (state
                                is DetailedSignupGetCollegeDetailsError) {
                              developer.log('Course and clg updated .4');
                              showSnackbar('Error loading details', context);
                            } else if (state
                                is DetailedSignupGetCollegeDetailsLoading) {
                              developer.log('Course and clg updated .5');
                            }
                          },
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 11.0),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Course",
                                      style: mTextStyle14(),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    BlocBuilder<MasterDataBloc, MasterDataState>(
                                      builder: (context, state) {
                                        if (state is MasterDataLoaded) {
                                          return CustomAutocompleteGeneric<CourseEntity>(
                                            options: state.courses,
                                            label: "Course",
                                            displayStringForOption: (course) => course.name,
                                            onSelected: (course) {
                                              setState(() {
                                                selectedCourse = course.name;
                                                selectedCourseId = course.id;
                                                selectedSpecialization = null;
                                                selectedSpecializationId = null;
                                              });
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                setState(() {});
                                              });
                                              context.read<DetailedSignupBloc>().add(
                                                DetailedSignupGetSpecializations(course.id.toString()),
                                              );
                                            },
                                          );
                                        }
                                        return const CircularProgressIndicator();
                                      },
                                    ),
                                    mSpacer(),
                                    Text(
                                      "College Name",
                                      style: mTextStyle14(),
                                    ),
                                    BlocBuilder<MasterDataBloc, MasterDataState>(
                                      builder: (context, state) {
                                        if (state is MasterDataLoaded) {
                                          return CustomAutocompleteGeneric<CollegeEntity>(
                                            options: state.colleges,
                                            label: "College Name",
                                            displayStringForOption: (college) => college.name,
                                            onSelected: (college) {
                                              selectedCollege = college.name; // or college.id
                                            },
                                          );
                                        }
                                        return const CircularProgressIndicator();
                                      },
                                    ),
                                    // CustomAutocompleteGeneric(
                                    //   options: collegeNames,
                                    //   label: 'College Names',
                                    //   displayStringForOption: (p0) {
                                    //     return p0.name ?? '';
                                    //   },
                                    //   onSelected: (value) {
                                    //     showSnackbar(
                                    //         'Selected ${value.name}', context);
                                    //     selectedCollege = value.name;
                                    //     developer.log(
                                    //         'Selected college variable : $selectedCollege');
                                    //   },
                                    // ),

                                    // --- SPECIALIZATION FIELD ---
                                    mSpacer(),
                                    Text("Specialization", style: mTextStyle14()),
                                    const SizedBox(height: 7),
                                    BlocBuilder<MasterDataBloc, MasterDataState>(
                                      builder: (context, state) {
                                        if (state is MasterDataLoaded) {
                                          final filteredSpecs = selectedCourseId != null
                                              ? state.specializations.where((spec) => spec.course_id == selectedCourseId).toList()
                                              : <SpecializationEntity>[];

                                          return CustomAutocompleteGeneric<SpecializationEntity>(
                                            options: filteredSpecs,
                                            label: "Specialization",
                                            displayStringForOption: (spec) => spec.name ?? "Unknown Specialization",
                                            onSelected: (spec) {
                                              setState(() {
                                                selectedSpecialization = spec.name;   // For display
                                                selectedSpecializationId = spec.id;
                                              });
                                            },
                                            initialText: selectedSpecialization,      // Show selected name
                                            focusNode: _specializationFocus,
                                          );
                                        } else if (state is MasterDataError) {
                                          return Text('Failed to load specializations', style: TextStyle(color: Colors.red));
                                        }
                                        return const Center(child: CircularProgressIndicator());
                                      },
                                    ),


                                    // BlocBuilder<MasterDataBloc, MasterDataState>(
                                    //   builder: (context, state) {
                                    //     if (state is MasterDataLoaded) {
                                    //       // Optional: filter by selected course if you have course-specialization mapping
                                    //       final filteredSpecs = selectedCourse != null
                                    //           ? state.specializations.where((spec) => ).toList()
                                    //           : state.specializations;
                                    //
                                    //       return CustomAutocompleteGeneric<SpecializationEntity>(
                                    //         options: filteredSpecs,
                                    //         label: "Specialization",
                                    //         displayStringForOption: (spec) => spec.course,
                                    //         onSelected: (spec) {
                                    //           selectedSpecialization = spec.name;
                                    //         },
                                    //       );
                                    //     }
                                    //     return const CircularProgressIndicator();
                                    //   },
                                    // ),
                                    mSpacer17(),

                                /// Start Year and End Year labels row
                                Row(
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Start Year",
                                          style: mTextStyle14(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 18),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "End Year",
                                          style: mTextStyle14(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                /// Small vertical space
                                mSpacer(mHeight: 2.0),

                                /// Start Year and End Year date picker fields
                                Row(
                                  children: [
                                    Expanded(
                                      child: DatePickerField(
                                        controller: startCourseYearController,
                                      ),
                                    ),
                                    const SizedBox(width: 18),
                                    Expanded(
                                      child: DatePickerField(
                                        controller: endCourseYearController,
                                      ),
                                    ),
                                  ],
                                ),
                                  ])
                              ])
                      ),

                    /// WHEN USER TYPE : WORKING PROFESSIONAL
                    if (selectedOption ==
                        JOBSEEKERTYPE.WorkingProffesional.name)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // mSpacer(mHeight: 20.0),
                          Row(
                            children: [
                              Text(
                                "Total Work Experience ",
                                style: mTextStyle14(),
                              ),
                              const Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),

                          /// Total Working experience textfield
                          CustomTextField(
                            controller: totalWorkExp,
                            hintText: "Select Experience",
                            suffixIcon: Icons.keyboard_arrow_down_outlined,
                          ),
                          mSpacer17(),
                          Row(
                            children: [
                              Text(
                                "Current Job Role",
                                style: mTextStyle14(),
                              ),
                              Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),

                          BlocBuilder<MasterDataBloc, MasterDataState>(
                            builder: (context, state) {
                              if (state is MasterDataLoaded) {
                                return CustomAutocomplete(
                                  options: state.domains.map((d) => d.name).toList(), // assuming DomainEntity has name
                                  label: "Job Role",
                                  onSelected: (value) {
                                    selectedjobRole = value;
                                  },
                                );
                              }
                              return const CircularProgressIndicator();
                            },
                          ),
                          mSpacer17(),
                          Row(
                            children: [
                              Text(
                                "Current Company",
                                style: mTextStyle14(),
                              ),
                              Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                          CustomTextField(
                            controller: current_company,

                            /// Current Company Textfield
                            hintText:
                                "Current Company", /*suffixIcon: Icons.keyboard_arrow_down_outlined,*/
                          ),
                          mSpacer17(),

                          /// Start year and end year columns
                          Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Start Year",
                                    style: mTextStyle14(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "End Year",
                                    style: mTextStyle14(),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          mSpacer(mHeight: 2.0),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: 160,
                                  child: DatePickerField(
                                      controller: startJobYearController),
                                ),
                              ),
                              SizedBox(
                                width: 18,
                              ),
                              Expanded(
                                child: SizedBox(
                                  width: 160,
                                  child: DatePickerField(
                                      controller: endJobYearController),
                                ),
                              ),
                            ],
                          ),
                          mSpacer17(),
                          Text(
                            "Current or Latest annual Salary/CTC ",
                            style: mTextStyle14(),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "We will use this to find jobs matching/ exceeding your  current salary range.This information is not visible to employers.",
                            style: TextStyle(fontSize: 11),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          CustomTextField(
                              controller: CTCController,
                              hintText: "E.g 4,00,000"),
                        ],
                      ),

                    mSpacer(mHeight: 25.0),

                    /// END PART
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        nextButton(
                          title: "Next",
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              developer.log('Valid Form');
                              fillDataIntoParams();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupPageYourSkills(
                                    params: widget.params,
                                  ),
                                ),
                              );
                            } else {
                              showSnackbar(
                                  'Please fill all the required fields.',
                                  context);
                            }
                          },
                        ),
                      ],
                    ),
                    mSpacer(mHeight: 25.0),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void fillDataIntoParams() {
    final _prefs = sl<PreferencesManager>();

    // Base user info
    widget.params.addAll({
      DETAILEDPROFILEPARAMS.user_id.name: _prefs.getUserId() ?? '59',
      DETAILEDPROFILEPARAMS.first_name.name: firstnameController.text,
      DETAILEDPROFILEPARAMS.last_name.name: surnameController.text,
      DETAILEDPROFILEPARAMS.email.name: emailController.text,
      DETAILEDPROFILEPARAMS.phone.name: phoneController.text,
      DETAILEDPROFILEPARAMS.dob.name: formatDobToIso(DOBController.text),
      DETAILEDPROFILEPARAMS.gender.name: genderController.text,
      DETAILEDPROFILEPARAMS.user_type.name: selectedOption,
      "currently_looking_for": ["Jobs"], // You can make this dynamic later
      "work_mode": ["Work from home"],   // You can make this dynamic later
    });

    // Location IDs
    if (selectedCurrentCity != null) {
      widget.params["current_location_id"] = selectedCurrentCity.toString();
    }
    if (selectedPreferredCity != null) {
      widget.params["preferred_location_id"] = selectedPreferredCity.toString(); // Adjust key if needed
    }

    // Type-specific data
    widget.params
      ..remove(DETAILEDPROFILEPARAMS.educationStandard.name)
      ..remove(DETAILEDPROFILEPARAMS.course.name)
      ..remove(DETAILEDPROFILEPARAMS.college_name.name)
      ..remove(DETAILEDPROFILEPARAMS.specialization.name)
      ..remove(DETAILEDPROFILEPARAMS.start_year.name)
      ..remove(DETAILEDPROFILEPARAMS.end_year.name)
      ..remove(DETAILEDPROFILEPARAMS.experiences.name);

    if (selectedOption == JOBSEEKERTYPE.SchoolStudent.name) {
      widget.params.addAll({
        DETAILEDPROFILEPARAMS.educationStandard.name: selectedClass,
      });
    } else if (selectedOption == JOBSEEKERTYPE.CollegeStudent.name ||
        selectedOption == JOBSEEKERTYPE.Fresher.name) {
      // Send IDs, not names!
      if (selectedCourseId != null) {
        widget.params[DETAILEDPROFILEPARAMS.course.name] = selectedCourseId.toString();
      }
      if (selectedCollege != null && selectedCollege.isNotEmpty) {
        // If you have college ID, send that. Otherwise, you may need to map name → ID or change API.
        // For now, assuming API accepts name or you’ll map it server-side.
        widget.params[DETAILEDPROFILEPARAMS.college_name.name] = selectedCollege;
      }
      if (selectedSpecializationId != null) {
        widget.params[DETAILEDPROFILEPARAMS.specialization.name] = selectedSpecializationId; // int
      }
      widget.params.addAll({
        DETAILEDPROFILEPARAMS.start_year.name: startCourseYearController.text,
        DETAILEDPROFILEPARAMS.end_year.name: endCourseYearController.text,
      });
    } else if (selectedOption == JOBSEEKERTYPE.WorkingProffesional.name) {
      widget.params.addAll({
        DETAILEDPROFILEPARAMS.experiences.name: [
          {
            DETAILEDPROFILEPARAMS.user_id.name: _prefs.getUserId() ?? '59',
            DETAILEDPROFILEPARAMS.jobRole.name: selectedjobRole,
            DETAILEDPROFILEPARAMS.company.name: current_company.text,
            DETAILEDPROFILEPARAMS.start_date.name: startJobYearController.text,
            DETAILEDPROFILEPARAMS.end_date.name: endJobYearController.text,
          }
        ],
      });
    }

    developer.log('Final Params: ${widget.params}');
  }
}

/// Drop down for years
class DatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color? fillColor;

  const DatePickerField({
    required this.controller,
    this.hintText = 'Select Date',
    super.key,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? Colors.transparent,
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        suffixIcon: const Icon(
          Icons.keyboard_arrow_down,
          size: 18,
          color: Color(0xffBCC1CA),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      // onTap: () async {
      //   final DateTime? picked = await showDatePicker(
      //     context: context,
      //     initialDate: DateTime.now(),
      //     firstDate: DateTime(1970),
      //     lastDate: DateTime(2100),
      //   );
      //
      //   if (picked != null) {
      //     controller.text =
      //         '${picked.day} ${_monthName(picked.month)} ${picked.year}';
      //   }
      // },
        onTap: () async {
          final DateTime now = DateTime.now();
          final DateTime? pickedYear = await showModalBottomSheet<DateTime>(
            context: context,
            builder: (context) {
              final ScrollController scrollController = ScrollController(
                initialScrollOffset: 50 * (now.year - 1970).toDouble(),
              );
              return SizedBox(
                height: 300,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        const Text('Select Year'),
                        TextButton(
                          onPressed: () => Navigator.pop(context, DateTime(now.year)),
                          child: const Text('Now'),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: 2100 - 1970,
                        itemBuilder: (context, index) {
                          final year = 1970 + index;
                          return ListTile(
                            title: Center(
                              child: Text(
                                '$year',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            onTap: () => Navigator.pop(context, DateTime(year)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );

          if (pickedYear != null) {
            controller.text = pickedYear.year.toString(); // Only year
          }
        }
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month];
  }
}
