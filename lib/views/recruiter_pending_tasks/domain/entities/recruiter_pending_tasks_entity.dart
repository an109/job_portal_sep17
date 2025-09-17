class RecruiterPendingTasksEntity {
  final int applicationId;
  final int userId;
  final int jobId;
  final String status;
  final String jobProfile;

  RecruiterPendingTasksEntity({
    required this.applicationId,
    required this.userId,
    required this.jobId,
    required this.status,
    required this.jobProfile,
  });

  Map<String, dynamic> toJson() => {
    'application_id': applicationId,
    'user_id': userId,
    'job_post_id': jobId,
    'status': status,
    'jobProfile': jobProfile,
  };

  // Optional: Factory to create from JSON (if needed later)
  factory RecruiterPendingTasksEntity.fromJson(Map<String, dynamic> json) =>
      RecruiterPendingTasksEntity(
        applicationId: json['application_id'],
        userId: json['user_id'],
        jobId: json['job_post_id'],
        status: json['status'],
        jobProfile: json['jobProfile'],
      );
}