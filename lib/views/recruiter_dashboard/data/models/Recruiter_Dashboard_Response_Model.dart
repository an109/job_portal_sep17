import '../../domain/entities/recruiter_dashboard_entity.dart';


class RecruiterDashboardResponseModel extends RecruiterDashboardEntity {

  final int totalCount;

  final int? jobsPosted;
  final int? pendingTasks;
  final int? upcomingInterviews;

  RecruiterDashboardResponseModel({
    required this.totalCount,
    this.jobsPosted,
    this.pendingTasks,
    this.upcomingInterviews,
  }) : super(
    totalCount: totalCount,
    pendingTasksCount: pendingTasks ?? 0,
    upcomingInterviewsCount: upcomingInterviews ?? 0,
  );


  factory RecruiterDashboardResponseModel.fromJson(Map<String, dynamic> json) {

    final int derivedTotalCount = json['totalJobPosts'] ?? json['jobsPosted'] ?? 0;
    final int? pendingTasks = json['pendingTasks'];
    final int? upcomingInterviews = json['upcomingInterviews'];

    return RecruiterDashboardResponseModel(
      totalCount: derivedTotalCount,
      /// Mirror totalCount for clarity when debugging
      jobsPosted: derivedTotalCount,
      pendingTasks: pendingTasks,
      upcomingInterviews: upcomingInterviews,
    );
  }

  /// Convert to JSON (useful for debugging or caching)
  Map<String, dynamic> toJson() => {
    'totalJobPosts': totalCount,
    'jobsPosted': jobsPosted,
    'pendingTasks': pendingTasks,
    'upcomingInterviews': upcomingInterviews,
  };
}