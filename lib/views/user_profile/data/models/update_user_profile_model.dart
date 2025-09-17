import 'package:job_portal/views/user_profile/domain/entities/update_user_profile_entity.dart';

class UpdateUserProfileModel extends UpdateUserProfileEntity {
  UpdateUserProfileModel({
    required super.message,
    required super.userDetail,
  });

  factory UpdateUserProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateUserProfileModel(
      message: json['message'],
      userDetail: UpdateUserDetailModel.fromJson(json['userDetail']),
    );
  }
}

class UpdateUserDetailModel extends UpdateUserDetailEntity {
  UpdateUserDetailModel({
    required super.id,
    required super.user_id,
    required super.first_name,
    required super.last_name,
    required super.email,
    required super.phone,
    required super.dob,
    required super.aadhaarNumber,
    required super.aadhaarCardFile,
    required super.isAadhaarVerified,
    required super.currentLocation,
    required super.gender,
    required super.user_type,
    super.standard,
    super.course,
    super.specialization,
    super.college,
    super.start_year,
    super.end_year,
    required super.jobLocation,
    required super.salary_details,
    required super.currently_looking_for,
    required super.work_mode,
    required super.aboutUs,
    super.career_objective,
    required super.resume,
    required super.language,
    required super.is_email_verified,
    required super.is_phone_verified,
    required super.is_gst_verified,
    super.userProfilePic,
    required super.terms_and_condition,
    required super.created_at,
    required super.updated_at,
  });

  factory UpdateUserDetailModel.fromJson(Map<String, dynamic> json) {
    return UpdateUserDetailModel(
      id: json['id'],
      user_id: json['user_id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      dob: json['dob'],
      aadhaarNumber: json['aadhaarNumber'],
      aadhaarCardFile: json['aadhaarCardFile'],
      isAadhaarVerified: json['isAadhaarVerified'] == true,
      currentLocation: json['currentLocation'],
      gender: json['gender'],
      user_type: json['user_type'],
      standard: json['Standard'],
      course: json['course'],
      specialization: json['specialization'],
      college: json['college'],
      start_year: json['start_year'],
      end_year: json['end_year'],
      jobLocation: json['jobLocation'],
      salary_details: json['salary_details'],
      currently_looking_for: json['currently_looking_for'],
      work_mode: json['work_mode'],
      aboutUs: json['about_us'],
      career_objective: json['career_objective'],
      resume: json['resume'],
      language: json['language'],
      is_email_verified: json['is_email_verified'] == true,
      is_phone_verified: json['is_phone_verified'] == true,
      is_gst_verified: json['is_gst_verified'] == true,
      userProfilePic: json['user_profile_pic'],
      terms_and_condition: json['terms_and_condition'],
      created_at: DateTime.parse(json['created_at']),
      updated_at: DateTime.parse(json['updated_at']),
    );
  }
}
