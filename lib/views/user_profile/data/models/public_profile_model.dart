// public_profile_model.dart

import 'package:job_portal/views/user_profile/domain/entities/public_profile_entity.dart';

class PublicProfileModel extends PublicProfileEntity {
  const PublicProfileModel({
    required super.first_name,
    required super.last_name,
    required super.user_type,
    required super.email,
    required super.language,
    required super.about_us,
    required super.career_objective,
  });

  factory PublicProfileModel.fromJson(Map<String, dynamic> json) {
    return PublicProfileModel(
      first_name: json['first_name'] ?? '',
      last_name: json['last_name'] ?? '',
      user_type: json['user_type'] ?? '',
      email: json['email'] ?? '',
      language: json['language'] ?? '',
      about_us: json['about_us'] ?? '',
      career_objective: json['career_objective'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': first_name,
      'last_name': last_name,
      'user_type': user_type,
      'email': email,
      'language': language,
      'about_us': about_us,
      'career_objective': career_objective,
    };
  }
}

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.publicProfile,
    required super.skills,
    required super.activity,
    required super.experiences,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      publicProfile: PublicProfileModel.fromJson(json['publicProfile']),
      skills: (json['skills'] as List<dynamic>)
          .map((e) => SkillModel.fromJson(e))
          .toList(),
      activity: (json['activity'] as List<dynamic>)
          .map((e) => ActivityModel.fromJson(e))
          .toList(),
      // experiences: List<String>.from(json['experiences'] ?? []),
      experiences: (json['experiences'] as List<dynamic>)
          .map((e) => ExperienceModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'publicProfile': (publicProfile as PublicProfileModel).toJson(),
      'skills': skills.map((e) => (e as SkillModel).toJson()).toList(),
      'activity': activity.map((e) => (e as ActivityModel).toJson()).toList(),
      'experiences':
          experiences.map((e) => (e as ExperienceModel).toJson()).toList(),
    };
  }
}

class SkillModel extends SkillEntity {
  const SkillModel({
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
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      certificateImages: (json['certificate_image'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'domain': domain,
        'subSkills': subSkills,
        'authority': authority,
        'certificate_image': certificateImages,
      };
}

class ActivityModel extends ActivityEntity {
  const ActivityModel({
    required super.caption,
    required super.image,
    required super.like_count,
    required super.comment_count,
    required super.created_at,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      caption: json['caption'] ?? '',
      image: json['image'] ?? '',
      like_count: json['like_count'] ?? 0,
      comment_count: json['comment_count'] ?? 0,
      created_at: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'caption': caption,
        'image': image,
        'like_count': like_count,
        'comment_count': comment_count,
        'created_at': created_at.toIso8601String(),
      };
}

class ExperienceModel extends ExperienceEntity {
  const ExperienceModel({
    super.company_recruiter_profile_id,
    required super.totalExperience,
    required super.current_job_role,
    required super.current_company,
    required super.status,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      company_recruiter_profile_id: json['company_recruiter_profile_id'],
      totalExperience: json['totalExperience'] ?? '',
      current_job_role: json['current_job_role'] ?? '',
      current_company: json['current_company'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_recruiter_profile_id': company_recruiter_profile_id,
      'totalExperience': totalExperience,
      'current_job_role': current_job_role,
      'current_company': current_company,
      'status': status,
    };
  }
}
