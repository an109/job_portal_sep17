// import 'package:job_portal/models/application_screening_details.dart';

import 'application_screening_details.dart';

class RecruiterFullViewApplicationData {
  final int applicationId;
  final int userId;
  final int jobId;
  final String status;
  // final String applicantName;
  final ApplicationScreeningDetails applicationDetails;

  RecruiterFullViewApplicationData({
    required this.applicationId,
    required this.userId,
    required this.jobId,
    required this.status,
    // required this.applicantName,
    required this.applicationDetails,
  });

  factory RecruiterFullViewApplicationData.fromJson(Map<String, dynamic> json) {
    return RecruiterFullViewApplicationData(
      applicationId: json['application_id'],
      userId: json['user_id'],
      jobId: json['job_post_id'],
      status: json['status'],
      // applicantName: json['applicant_name'],
      applicationDetails: ApplicationScreeningDetails.fromJson(json['applicationDetails']),
    );
  }
}