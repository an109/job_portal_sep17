import 'package:job_portal/views/user_profile/domain/entities/user_details_entity.dart';

class SchoolCollegeModel extends SchoolCollegeEntity {
  SchoolCollegeModel({required super.name, super.logo_pic});

  factory SchoolCollegeModel.fromJson(Map<String, dynamic> json) {
    return SchoolCollegeModel(
      name: json['name'] ?? '',
      logo_pic: json['logo_pic'],
    );
  }
}

class CourseModel extends UDCourseEntity {
  CourseModel({required super.name});

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(name: json['name'] ?? '');
  }
}

class SpecializationModel extends UDSpecializationEntity {
  SpecializationModel({required super.name});

  factory SpecializationModel.fromJson(Map<String, dynamic> json) {
    return SpecializationModel(name: json['name'] ?? '');
  }
}

class SkillModel extends ProfileSkillEntity {
  SkillModel({
    required super.domain,
    required super.subSkills,
    required super.authority,
    required super.certificateImages,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      domain: json['domain'] ?? '',
      subSkills: (json['subSkills'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          const [],
      authority: (json['authority'] as List<dynamic>?)
          ?.map((e) => e['name']?.toString() ?? '')
          .toList() ??
          const [],
      certificateImages: (json['certificate_image'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          const [],
    );
  }
}

class CompanyRecruiterProfileModel extends CompanyRecruiterProfileEntity {
  CompanyRecruiterProfileModel({
    required super.company_name,
    super.logo_url,
  });

  factory CompanyRecruiterProfileModel.fromJson(Map<String, dynamic> json) {
    return CompanyRecruiterProfileModel(
      company_name: json['company_name'] ?? '',
      logo_url: json['logo_url'],
    );
  }
}

class UserExperienceModel extends UserExperienceEntity {
  UserExperienceModel({
    required super.id,
    required super.user_detail_id,
    super.company_recruiter_profile_id,
    super.start_date,
    super.end_date,
    super.current_job_role,
    super.current_company,
    super.status,
    super.experienceCertificate,
    required super.created_at,
    required super.updated_at,
    super.companyRecruiterProfile,
  });

  factory UserExperienceModel.fromJson(Map<String, dynamic> json) {
    return UserExperienceModel(
      id: json['id'],
      user_detail_id: json['user_detail_id'],
      company_recruiter_profile_id: json['company_recruiter_profile_id'],
      start_date: json['start_date'],
      end_date: json['end_date'],
      current_job_role: json['current_job_role'],
      current_company: json['current_company'],
      status: json['status'],
      experienceCertificate: json['experienceCertificate'],
      created_at: DateTime.parse(json['created_at']),
      updated_at: DateTime.parse(json['updated_at']),
      companyRecruiterProfile: json['companyRecruiterProfile'] != null
          ? CompanyRecruiterProfileModel.fromJson(
              json['companyRecruiterProfile'])
          : null,
    );
  }
}

class UserEducationModel extends UserEducationEntity {
  UserEducationModel({
    required super.id,
    required super.level,
    required super.school_college_id,
    required super.board_or_university,
    required super.course_id,
    required super.specialization_id,
    required super.start_year,
    required super.end_year,
    required super.percentage_or_cgpa,
    required super.education_certificate,
    super.schoolCollege,
    super.course,
    super.specialization,
  });

  factory UserEducationModel.fromJson(Map<String, dynamic> json) {
    return UserEducationModel(
      id: json['id'],
      level: json['level'] ?? '',
      school_college_id: json['school_college_id'],
      board_or_university: json['board_or_university'] ?? '',
      course_id: json['course_id'],
      specialization_id: json['specialization_id'],
      start_year: json['start_year'] ?? '',
      end_year: json['end_year'] ?? '',
      percentage_or_cgpa: json['percentage_or_cgpa'] ?? '',
      education_certificate: json['education_certificate'] ?? '',
      schoolCollege: json['schoolCollege'] != null
          ? SchoolCollegeModel.fromJson(json['schoolCollege'])
          : null,
      course:
          json['course'] != null ? CourseModel.fromJson(json['course']) : null,
      specialization: json['specialization'] != null
          ? SpecializationModel.fromJson(json['specialization'])
          : null,
    );
  }
}

class UserDetailModel extends UserDetailEntity {
  UserDetailModel({
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
    required super.educations,
    required super.experiences,
    required super.skills,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    final user = json['userDetail'] as Map<String, dynamic>? ?? {};

    DateTime? tryParseDate(String? s) {
      if (s == null) return null;
      try {
        return DateTime.parse(s);
      } catch (_) {
        return null;
      }
    }

    return UserDetailModel(
      id: user['id'] ?? 0,
      user_id: user['user_id'] ?? 0,
      first_name: user['first_name'] ?? '',
      last_name: user['last_name'] ?? '',
      email: user['email'] ?? '',
      phone: user['phone'] ?? '',
      dob: user['dob'] ?? '',
      // NOTE: API uses snake_case keys:
      aadhaarNumber: user['aadhaar_number'],
      aadhaarCardFile: user['aadhaar_card_file'],
      isAadhaarVerified: user['is_aadhaar_verified'] ?? false,
      // currentLocation & jobLocation are inside userDetail (and are objects or null)
      currentLocation: (user['currentLocation'] as Map<String, dynamic>?)?['name'],
      gender: user['gender'] ?? '',
      user_type: user['user_type'] ?? '',
      jobLocation: (user['jobLocation'] as Map<String, dynamic>?)?['name'],
      salary_details: user['salary_details'],
      currently_looking_for: user['currently_looking_for'],
      work_mode: user['work_mode'],
      aboutUs: user['about_us'],
      career_objective: user['career_objective'],
      resume: user['resume'],
      language: user['language'],
      is_email_verified: user['is_email_verified'] ?? false,
      is_phone_verified: user['is_phone_verified'] ?? false,
      is_gst_verified: user['is_gst_verified'] ?? false,
      userProfilePic: user['user_profile_pic'],
      terms_and_condition: user['terms_and_condition'] ?? false,
      created_at: tryParseDate(user['created_at']) ?? DateTime.now(),
      updated_at: tryParseDate(user['updated_at']) ?? DateTime.now(),
      educations: (user['userEducations'] as List<dynamic>? ?? [])
          .map((e) => UserEducationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      experiences: (user['experiences'] as List<dynamic>? ?? [])
          .map((e) => UserExperienceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      // skills are at top-level 'skills' in API response (not inside userDetail)
      skills: (json['skills'] as List<dynamic>? ?? [])
          .map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

}
