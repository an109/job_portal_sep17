// import 'package:job_portal/models/application_screening_details.dart';

import '../../data/models/application_screening_details.dart';
import '../../data/models/recruiter_full_view_appliaction_response_model.dart';

class FullApplicantEntity {
  final int applicationId;
  final int userId;
  final int jobId;
  final String status;
  final String applicantName;
  final ApplicationScreeningDetails applicationDetails;

  FullApplicantEntity({
    required this.applicationId,
    required this.userId,
    required this.jobId,
    required this.status,
    required this.applicantName,
    required this.applicationDetails,
  });
  FullApplicantEntity copyWith({String? applicantName}) {
    return FullApplicantEntity(
      applicationId: applicationId,
      userId: userId,
      jobId: jobId,
      status: status,
      applicantName: applicantName ?? this.applicantName,
      applicationDetails: applicationDetails,
    );
  }
}