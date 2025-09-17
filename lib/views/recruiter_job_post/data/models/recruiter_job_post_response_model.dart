import '../../domain/entities/recruiter_job_post_entity.dart';

class RecruiterJobPostResponseModel {
  List<JobPostData>? jobPosts;
  int? allApplicantsCount;

  RecruiterJobPostResponseModel({
    this.jobPosts,
    this.allApplicantsCount,
  });

  factory RecruiterJobPostResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] == null || json['data'] is! List) {
      return RecruiterJobPostResponseModel();
    }

    final List<JobPostData> jobs = (json['data'] as List)
        .map((e) => JobPostData.fromJson(e))
        .toList();

    return RecruiterJobPostResponseModel(
      jobPosts: jobs,
      allApplicantsCount: 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'allApplicantsCount': allApplicantsCount,
    'jobPosts': jobPosts?.map((e) => e.toJson()).toList(),
  };
}

class JobPostData {
  int? jobId;
  String? jobRole;
  String? status;
  int? views;
  int? totalApplications;
  String? lastApplicationDate;

  int? jobRoleId;
  String? opportunityType;
  String? internshipStartDate;

  JobPostData({
    this.jobId,
    this.jobRole,
    this.status,
    this.views,
    this.totalApplications,
    this.lastApplicationDate,
    this.jobRoleId,
    this.opportunityType,
    this.internshipStartDate,
  });

  factory JobPostData.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? jobRoleData = json['JobRole'];
    final int? jobRoleId = json['job_role_id'] as int?;
    final String? opportunityType = json['opportunity_type'] as String?;

    return JobPostData(
      jobId: json['job_id'] as int?,
      jobRoleId: json['job_role_id'] as int?,
      opportunityType: json['opportunity_type'] as String?,
      internshipStartDate: json['internship_start_date'] as String?,
      jobRole: jobRoleData?['title'] as String? ?? 'Internship Role',
      // jobRole: _mapJobRoleFromId(json['job_role_id'] as int?, json['opportunityType'] as String?),
      status: json['status'] as String? ?? 'Active',
      views: json['views'] as int? ?? 0,
      lastApplicationDate: json['lastApplicationDate'] as String?,
      // totalApplications: 0, // Default until fetched
      totalApplications: json['applicationCount'] as int? ?? 0,
    );
  }

  static String _mapJobRoleFromId(int? roleId, String? oppType) {
    if (roleId == 1) return 'Frontend Developer';
    if (roleId == 2) return 'Backend Developer';
    if (roleId == 6) return 'Full Stack Developer';
    return oppType == 'Job' ? 'Software Developer' : 'Internship Role';
  }

  Map<String, dynamic> toJson() => {
    'jobId': jobId,
    'jobRole': jobRole,
    'status': status,
    'views': views,
    'totalApplications': totalApplications,
    'lastApplicationDate': lastApplicationDate,
    'jobRoleId': jobRoleId,
    'opportunityType': opportunityType,
    'internshipStartDate': internshipStartDate,
  };

  RecruiterJobPostEntity toEntity() {
    return RecruiterJobPostEntity(
      jobId: jobId ?? 0,
      jobRole: jobRole ?? "Untitled Job",
      status: status ?? "Unknown",
      views: views ?? 0,
      totalApplications: totalApplications ?? 0,
      lastApplicationDate: lastApplicationDate != null
          ? DateTime.tryParse(lastApplicationDate!)
          : null,
    );
  }
}

class ApplicantCountResponseModel {
  final int data;
  final bool success;
  final String message;

  const ApplicantCountResponseModel({
    required this.data,
    required this.success,
    required this.message,
  });

  factory ApplicantCountResponseModel.fromJson(Map<String, dynamic> json) {
    return ApplicantCountResponseModel(
      data: json['data'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }
}