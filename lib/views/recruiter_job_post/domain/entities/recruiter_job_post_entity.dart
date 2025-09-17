import 'package:equatable/equatable.dart';

class RecruiterJobPostEntity extends Equatable {
  final int jobId;
  final String jobRole;
  final String status;
  final int views;
  final int totalApplications;
  final DateTime? lastApplicationDate;

  const RecruiterJobPostEntity({
    required this.jobId,
    required this.jobRole,
    required this.status,
    required this.views,
    required this.totalApplications,
    this.lastApplicationDate,
  });

  @override
  List<Object?> get props => [
    jobId,
    jobRole,
    status,
    views,
    totalApplications,
    lastApplicationDate,
  ];
}