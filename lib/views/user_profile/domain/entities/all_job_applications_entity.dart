class AllJobApplicationsEntity {
  final List<JobApplicationEntity> applications;

  AllJobApplicationsEntity({required this.applications});
}

class JobApplicationEntity {
  final int application_id;
  final int job_post_id;
  final String company_name;
  final String? company_logo;
  final String jobRole;
  final double skill_match_percentage;
  final int? number_of_openings;
  final String status;
  final int applicantCount;
  final String applied_date; // 👈 Keep as String
  final bool has_interview_invitation;
  final List<dynamic> interviews;
  final dynamic upcoming_interview;
  final bool has_assignment;
  final List<dynamic> assignments;
  final dynamic upcoming_assignment;

  JobApplicationEntity({
    required this.application_id,
    required this.job_post_id,
    required this.company_name,
    this.company_logo,
    required this.jobRole,
    required this.skill_match_percentage,
    required this.number_of_openings,
    required this.status,
    required this.applicantCount,
    required this.applied_date,
    required this.has_interview_invitation,
    required this.interviews,
    required this.upcoming_interview,
    required this.has_assignment,
    required this.assignments,
    required this.upcoming_assignment,
  });
}

// 👇 REMOVE ApplicationDetailsEntity — it's not in API