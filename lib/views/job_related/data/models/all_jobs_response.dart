import 'package:job_portal/views/job_related/domain/entities/all_jobs_entity.dart';

class AllJobsResponse {
  final List<JobModel> data;

  AllJobsResponse({required this.data});

  factory AllJobsResponse.fromJson(Map<String, dynamic> json) {
    return AllJobsResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => JobModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class JobModel extends AllJobsEntity {
  JobModel({
    required super.job_id,
    required super.company_name,
    required super.company_location,
    super.logo_url,
    required super.jobRole,
    required super.skills,
    required super.matchPercentage,
    required super.experience,
    required super.salary,
    required super.cityChoice,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      job_id: json['job_id'] ?? 0,
      company_name: json['company_name'] ?? '',
      company_location: json['company_location'] ?? '',
      logo_url: json['logo_url'],
      jobRole: json['jobRole'] ?? '',
      skills: (json['skills'] as List<dynamic>? ?? [])
          .map((skill) => SkillModel.fromJson(skill as Map<String, dynamic>))
          .toList(),
      matchPercentage: (json['matchPercentage'] is int)
          ? (json['matchPercentage'] as int).toDouble()
          : (json['matchPercentage'] ?? 0.0),
      experience: json['experience'] ?? '',
      salary: json['salary'] ?? '',
      cityChoice: json['cityChoice'] ?? '',
    );
  }
}

class SkillModel extends SkillEntity {
  SkillModel({
    required super.skillId,
    required super.skillName,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      skillId: json['skill_id'] ?? 0,
      skillName: json['skill_name'] ?? '',
    );
  }
}
