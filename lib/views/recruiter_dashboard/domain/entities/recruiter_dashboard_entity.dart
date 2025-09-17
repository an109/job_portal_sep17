class RecruiterDashboardEntity {
  final int totalCount;
  final int pendingTasksCount;
  final int upcomingInterviewsCount;

  const RecruiterDashboardEntity({
    required this.totalCount,
    this.pendingTasksCount = 0,
    this.upcomingInterviewsCount = 0,
  });

  factory RecruiterDashboardEntity.fromJson(Map<String, dynamic> json) {
    return RecruiterDashboardEntity(
      totalCount: json['totalJobPosts'] ?? json['jobsPosted'] ?? 0,
      pendingTasksCount: json['pendingTasks'] ?? 0,
      upcomingInterviewsCount: json['upcomingInterviews'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'pendingTasksCount': pendingTasksCount,
      'upcomingInterviewsCount': upcomingInterviewsCount,
    };
  }
}