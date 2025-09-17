class PipelineCandidateEntity {
  final int applicationId;
  final String status;
  final DateTime appliedDate;
  final User user;
  final Job job;

  PipelineCandidateEntity({
    required this.applicationId,
    required this.status,
    required this.appliedDate,
    required this.user,
    required this.job,
  });

  Map<String, dynamic> toJson() => {
    'application_id': applicationId,
    'status': status,
    'applied_date': appliedDate.toUtc().toLocal().toString(),
    'user': user.toJson(),
    'job': job.toJson(),
  };
}

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? profilePic;
  final String? resume;
  final String totalExperience;
  final List<Experience> experiences;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profilePic,
    this.resume,
    required this.totalExperience,
    required this.experiences,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'profile_pic': profilePic,
    'resume': resume,
    'total_experience': totalExperience,
    'experiences': experiences.map((e) => e.toJson()).toList(),
  };
}

class Experience {
  final int id;
  final String currentJobRole;
  final DateTime? startDate;
  final DateTime? endDate;

  Experience({
    required this.id,
    required this.currentJobRole,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'current_job_role': currentJobRole,
    'start_date': startDate?.toUtc().toLocal().toString(),
    'end_date': endDate?.toUtc().toLocal().toString(),
  };
}

class Job {
  final int jobId;
  final int jobRoleId;
  final DateTime createdAt;
  final JobRole jobRole;
  final CompanyRecruiterProfile companyRecruiterProfile;

  Job({
    required this.jobId,
    required this.jobRoleId,
    required this.createdAt,
    required this.jobRole,
    required this.companyRecruiterProfile,
  });

  Map<String, dynamic> toJson() => {
    'job_id': jobId,
    'job_role_id': jobRoleId,
    'created_at': createdAt.toUtc().toLocal().toString(),
    'JobRole': jobRole.toJson(),
    'CompanyRecruiterProfile': companyRecruiterProfile.toJson(),
  };
}

class JobRole {
  final int id;
  final String title;

  JobRole({required this.id, required this.title});

  Map<String, dynamic> toJson() => {'id': id, 'title': title};
}

class CompanyRecruiterProfile {
  final int id;
  final String companyName;
  final String? logoUrl;

  CompanyRecruiterProfile({
    required this.id,
    required this.companyName,
    this.logoUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'company_name': companyName,
    'logo_url': logoUrl,
  };
}