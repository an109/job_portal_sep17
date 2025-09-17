class PipelineCandidateResponseModel {
  final int total;
  final List<PipelineCandidate> pipeline;

  PipelineCandidateResponseModel({
    required this.total,
    required this.pipeline,
  });

  factory PipelineCandidateResponseModel.fromJson(Map<String, dynamic> json) =>
      PipelineCandidateResponseModel(
        total: json['total'] as int,
        pipeline: (json['pipeline'] as List)
            .map((e) => PipelineCandidate.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    'total': total,
    'pipeline': pipeline.map((e) => e.toJson()).toList(),
  };
}

class PipelineCandidate {
  final int applicationId;
  final String status;
  final DateTime appliedDate;
  final User user;
  final Job job;

  PipelineCandidate({
    required this.applicationId,
    required this.status,
    required this.appliedDate,
    required this.user,
    required this.job,
  });

  factory PipelineCandidate.fromJson(Map<String, dynamic> json) =>
      PipelineCandidate(
        applicationId: json['application_id'] as int,
        status: json['status'] as String,
        appliedDate: DateTime.parse(json['applied_date'] as String),
        user: User.fromJson(json['user']),
        job: Job.fromJson(json['job']),
      );

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

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int,
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    email: json['email'] as String,
    profilePic: json['profile_pic'] as String?,
    resume: json['resume'] as String?,
    totalExperience: json['total_experience'].toString(),
    experiences: (json['experiences'] as List)
        .map((e) => Experience.fromJson(e))
        .toList(),
  );

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

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    id: json['id'] as int,
    currentJobRole: json['current_job_role'] as String,
    startDate: json['start_date'] != null
        ? DateTime.parse(json['start_date'] as String)
        : null,
    endDate: json['end_date'] != null
        ? DateTime.parse(json['end_date'] as String)
        : null,
  );

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

  factory Job.fromJson(Map<String, dynamic> json) => Job(
    jobId: json['job_id'] as int,
    jobRoleId: json['job_role_id'] as int,
    createdAt: DateTime.parse(json['created_at'] as String),
    jobRole: JobRole.fromJson(json['JobRole']),
    companyRecruiterProfile:
    CompanyRecruiterProfile.fromJson(json['CompanyRecruiterProfile']),
  );

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

  factory JobRole.fromJson(Map<String, dynamic> json) => JobRole(
    id: json['id'] as int,
    title: json['title'] as String,
  );

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

  factory CompanyRecruiterProfile.fromJson(Map<String, dynamic> json) =>
      CompanyRecruiterProfile(
        id: json['id'] as int,
        companyName: json['company_name'] as String,
        logoUrl: json['logo_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'company_name': companyName,
    'logo_url': logoUrl,
  };
}