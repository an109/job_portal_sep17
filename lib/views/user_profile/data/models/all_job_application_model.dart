import 'package:job_portal/views/user_profile/domain/entities/all_job_applications_entity.dart';

class AllJobApplicationsModel extends AllJobApplicationsEntity {
  AllJobApplicationsModel({required List<JobApplicationModel> applications})
      : super(applications: applications);

  factory AllJobApplicationsModel.fromJson(Map<String, dynamic> json) {
    return AllJobApplicationsModel(
      applications: (json['applications'] as List<dynamic>)
          .map((e) => JobApplicationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class JobApplicationModel extends JobApplicationEntity {
  JobApplicationModel({
    required int application_id,
    required int job_post_id,
    required String company_name,
    String? company_logo,
    required String jobRole,
    required double skill_match_percentage,
    required int? number_of_openings,
    required String status,
    required int applicantCount,
    required String applied_date,
    required bool has_interview_invitation,
    required List<dynamic> interviews,
    required dynamic upcoming_interview,
    required bool has_assignment,
    required List<dynamic> assignments,
    required dynamic upcoming_assignment,
  }) : super(
    application_id: application_id,
    job_post_id: job_post_id,
    company_name: company_name,
    company_logo: company_logo,
    jobRole: jobRole,
    skill_match_percentage: skill_match_percentage,
    number_of_openings: number_of_openings,
    status: status,
    applicantCount: applicantCount,
    applied_date: applied_date,
    has_interview_invitation: has_interview_invitation,
    interviews: interviews,
    upcoming_interview: upcoming_interview,
    has_assignment: has_assignment,
    assignments: assignments,
    upcoming_assignment: upcoming_assignment,
  );

  factory JobApplicationModel.fromJson(Map<String, dynamic> json) {
    return JobApplicationModel(
      application_id: json['application_id'] ?? 0,
      job_post_id: json['job_post_id'] ?? 0,
      company_name: json['company_name'] ?? '',
      company_logo: json['company_logo'],
      jobRole: json['jobRole'] ?? '',
      skill_match_percentage: (json['skill_match_percentage'] as num?)?.toDouble() ?? 0.0,
      number_of_openings: json['number_of_openings'],
      status: json['status'] ?? 'Applied',
      applicantCount: json['applicantCount'] ?? 0,
      applied_date: json['applied_date'] ?? '1970-01-01',
      has_interview_invitation: json['has_interview_invitation'] ?? false,
      interviews: json['interviews'] as List<dynamic> ?? [],
      upcoming_interview: json['upcoming_interview'],
      has_assignment: json['has_assignment'] ?? false,
      assignments: json['assignments'] as List<dynamic> ?? [],
      upcoming_assignment: json['upcoming_assignment'],
    );
  }
}