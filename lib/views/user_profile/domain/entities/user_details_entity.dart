// user_skill_approval/domain/entities/user_details_entity.dart
class UserDetailEntity {
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
  final List<UserEducationEntity> educations;
  final List<UserExperienceEntity> experiences;
  final List<ProfileSkillEntity> skills;

  UserDetailEntity({
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
    required this.educations,
    required this.experiences,
    required this.skills,
  });

  // Add this toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'phone': phone,
      'dob': dob,
      'aadhaar_number': aadhaarNumber,
      'aadhaar_card_file': aadhaarCardFile,
      'is_aadhaar_verified': isAadhaarVerified,
      // For currentLocation and jobLocation, you might need to send their IDs
      // or a specific structure if the API expects it.
      // Assuming they are just strings for now, or you'd need to map them back to IDs.
      'current_location': currentLocation, // This might need to be 'current_location_id'
      'job_location': jobLocation, // This might need to be 'job_location_id'
      'gender': gender,
      'user_type': user_type,
      'salary_details': salary_details,
      'currently_looking_for': currently_looking_for,
      'work_mode': work_mode,
      'about_us': aboutUs,
      'career_objective': career_objective,
      'resume': resume,
      'language': language,
      'is_email_verified': is_email_verified,
      'is_phone_verified': is_phone_verified,
      'is_gst_verified': is_gst_verified,
      'user_profile_pic': userProfilePic,
      'terms_and_condition': terms_and_condition,
      'created_at': created_at.toIso8601String(),
      'updated_at': updated_at.toIso8601String(),
      'educations': educations.map((e) => e.toJson()).toList(),
      'experiences': experiences.map((e) => e.toJson()).toList(),
      'skills': skills.map((e) => e.toJson()).toList(),
    };
  }
}

class UserEducationEntity {
  final int id;
  final String level;
  final int school_college_id;
  final String board_or_university;
  final int course_id;
  final int specialization_id;
  final String start_year;
  final String end_year;
  final String percentage_or_cgpa;
  final String education_certificate;
  final SchoolCollegeEntity? schoolCollege;
  final UDCourseEntity? course;
  final UDSpecializationEntity? specialization;

  UserEducationEntity({
    required this.id,
    required this.level,
    required this.school_college_id,
    required this.board_or_university,
    required this.course_id,
    required this.specialization_id,
    required this.start_year,
    required this.end_year,
    required this.percentage_or_cgpa,
    required this.education_certificate,
    this.schoolCollege,
    this.course,
    this.specialization,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'school_college_id': school_college_id,
      'board_or_university': board_or_university,
      'course_id': course_id,
      'specialization_id': specialization_id,
      'start_year': start_year,
      'end_year': end_year,
      'percentage_or_cgpa': percentage_or_cgpa,
      'education_certificate': education_certificate,
      // schoolCollege, course, specialization are typically not sent back in update
    };
  }
}

class SchoolCollegeEntity {
  final String name;
  final String? logo_pic;

  SchoolCollegeEntity({
    required this.name,
    this.logo_pic,
  });
}

class UDCourseEntity {
  final String name;

  UDCourseEntity({required this.name});
}

class UDSpecializationEntity {
  final String name;

  UDSpecializationEntity({required this.name});
}

class ProfileSkillEntity {
  final String domain;
  final List<String> subSkills;
  final List<String> authority;
  final List<String> certificateImages;

  ProfileSkillEntity({
    required this.domain,
    required this.subSkills,
    required this.authority,
    required this.certificateImages,
  });

  // Add toJson for ProfileSkillEntity if it's part of the base payload
  Map<String, dynamic> toJson() {
    return {
      'domain': domain,
      'subSkills': subSkills,
      'authority': authority,
      'certificate_images': certificateImages,
    };
  }
}

class CompanyRecruiterProfileEntity {
  final String company_name;
  final String? logo_url;

  CompanyRecruiterProfileEntity({
    required this.company_name,
    this.logo_url,
  });
}

class UserExperienceEntity {
  final int id;
  final int user_detail_id;
  final int? company_recruiter_profile_id;
  final String? start_date;
  final String? end_date;
  final String? current_job_role;
  final String? current_company;
  final String? status;
  final String? experienceCertificate;
  final DateTime created_at;
  final DateTime updated_at;
  final CompanyRecruiterProfileEntity? companyRecruiterProfile;

  UserExperienceEntity({
    required this.id,
    required this.user_detail_id,
    this.company_recruiter_profile_id,
    this.start_date,
    this.end_date,
    this.current_job_role,
    this.current_company,
    this.status,
    this.experienceCertificate,
    required this.created_at,
    required this.updated_at,
    this.companyRecruiterProfile,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_detail_id': user_detail_id,
      'company_recruiter_profile_id': company_recruiter_profile_id,
      'start_date': start_date,
      'end_date': end_date,
      'current_job_role': current_job_role,
      'current_company': current_company,
      'status': status,
      'experienceCertificate': experienceCertificate,
      'created_at': created_at.toIso8601String(),
      'updated_at': updated_at.toIso8601String(),
      // companyRecruiterProfile is typically not sent back in update
    };
  }
}