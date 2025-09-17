class AllJobsEntity {
  final int job_id;
  final String company_name;
  final String? logo_url;
  final String jobRole;
  final List<SkillEntity> skills;
  final double matchPercentage;
  final String experience;
  final String salary;
  final String? cityChoice;

  const AllJobsEntity({
    required this.job_id,
    required this.company_name,
    this.logo_url,
    required this.jobRole,
    required this.skills,
    required this.matchPercentage,
    required this.experience,
    required this.salary,
    this.cityChoice,

  });
}

class SkillEntity {
  final int skillId;
  final String skillName;

  const SkillEntity({
    required this.skillId,
    required this.skillName,
  });
}

