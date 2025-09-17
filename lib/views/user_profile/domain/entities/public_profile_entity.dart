// public_profile_entity.dart
class PublicProfileEntity {
  final String first_name;
  final String last_name;
  final String user_type;
  final String email;
  final String language;
  final String about_us;
  final String career_objective;

  const PublicProfileEntity({
    required this.first_name,
    required this.last_name,
    required this.user_type,
    required this.email,
    required this.language,
    required this.about_us,
    required this.career_objective,
  });
}

// activity_entity.dart
class ActivityEntity {
  final String caption;
  final String image;
  final int like_count;
  final int comment_count;
  final DateTime created_at;

  const ActivityEntity({
    required this.caption,
    required this.image,
    required this.like_count,
    required this.comment_count,
    required this.created_at,
  });
}

class UserProfileEntity {
  final PublicProfileEntity publicProfile;
  final List<SkillEntity> skills;
  final List<ActivityEntity> activity;
  final List<ExperienceEntity> experiences; // updated from List<String>

  const UserProfileEntity({
    required this.publicProfile,
    required this.skills,
    required this.activity,
    required this.experiences,
  });
}

// skill_entity.dart
class SkillEntity {
  final String domain;
  final List<String> subSkills;
  final List<String> authority;
  final List<String> certificateImages;

  const SkillEntity({
    required this.domain,
    required this.subSkills,
    required this.authority,
    required this.certificateImages,
  });
}

class ExperienceEntity {
  final String? company_recruiter_profile_id;
  final String totalExperience;
  final String current_job_role;
  final String current_company;
  final String status;

  const ExperienceEntity({
    this.company_recruiter_profile_id,
    required this.totalExperience,
    required this.current_job_role,
    required this.current_company,
    required this.status,
  });
}
