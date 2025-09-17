class UpdateUserProfileEntity {
  final String message;
  final UpdateUserDetailEntity userDetail;

  UpdateUserProfileEntity({
    required this.message,
    required this.userDetail,
  });
}

class UpdateUserDetailEntity {
  final int id;
  final int user_id;
  final String first_name;
  final String last_name;
  final String email;
  final String phone;
  final String dob;
  final String? aadhaarNumber;
  final String? aadhaarCardFile;
  final bool isAadhaarVerified;
  final String? currentLocation;
  final String gender;
  final String user_type;
  final String? standard;
  final String? course;
  final String? specialization;
  final String? college;
  final String? start_year;
  final String? end_year;
  final String? jobLocation;
  final String? salary_details;
  final String? currently_looking_for;
  final String? work_mode;
  final String? aboutUs;
  final String? career_objective;
  final String? resume;
  final String? language;
  final bool is_email_verified;
  final bool is_phone_verified;
  final bool is_gst_verified;
  final String? userProfilePic;
  final bool terms_and_condition;
  final DateTime created_at;
  final DateTime updated_at;

  UpdateUserDetailEntity({
    required this.id,
    required this.user_id,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.phone,
    required this.dob,
    required this.aadhaarNumber,
    required this.aadhaarCardFile,
    required this.isAadhaarVerified,
    required this.currentLocation,
    required this.gender,
    required this.user_type,
    this.standard,
    this.course,
    this.specialization,
    this.college,
    this.start_year,
    this.end_year,
    required this.jobLocation,
    required this.salary_details,
    required this.currently_looking_for,
    required this.work_mode,
    required this.aboutUs,
    this.career_objective,
    required this.resume,
    required this.language,
    required this.is_email_verified,
    required this.is_phone_verified,
    required this.is_gst_verified,
    this.userProfilePic,
    required this.terms_and_condition,
    required this.created_at,
    required this.updated_at,
  });
}
