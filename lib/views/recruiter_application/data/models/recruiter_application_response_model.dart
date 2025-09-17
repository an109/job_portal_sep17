class RecruiterApplicationResponseModel {
  final List<Applicant> applicants;

  RecruiterApplicationResponseModel({required this.applicants});

  factory RecruiterApplicationResponseModel.fromJson(Map<String, dynamic> json) {
    final applicants = (json['applicants'] as List?)
        ?.map((e) => Applicant.fromJson(e))
        .toList();
    return RecruiterApplicationResponseModel(applicants: applicants ?? []);
  }
}

class RecruiterApplicantCountResponseModel {
  final int allApplicantsCount;

  RecruiterApplicantCountResponseModel({required this.allApplicantsCount});

  factory RecruiterApplicantCountResponseModel.fromJson(Map<String, dynamic> json) {
    return RecruiterApplicantCountResponseModel(
      allApplicantsCount: json['allApplicantsCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'allApplicantsCount': allApplicantsCount,
  };
}

class Applicant {
  final int applicationId;
  final int userId;
  final int matchPercentage;
  final ApplicationDetails applicationDetails;
  final String appliedDate;

  final String? applicantName;
  final String location;
  final String experience;

  Applicant({
    required this.applicationId,
    required this.userId,
    required this.matchPercentage,
    required this.applicationDetails,
    required this.appliedDate,
    this.applicantName,
    required this.location,
    required this.experience,
  });

  factory Applicant.fromJson(Map<String, dynamic> json) {
    final details = ApplicationDetails.fromJson(json);
    return Applicant(
      applicationId: json['application_id'] as int,
      userId: json['user_id'] as int,
      matchPercentage: json['skillMatchPercentage'] as int? ?? 0,
      applicationDetails: details,
      appliedDate: json['appliedDate'] as String? ?? '',
      applicantName: details.name,
      location: details.location,
      experience: details.experience,
    );
  }
}

class ApplicationDetails {
  final String name;
  final String location;
  final String experience;

  ApplicationDetails({
    required this.name,
    required this.location,
    required this.experience,
  });

  factory ApplicationDetails.fromJson(Map<String, dynamic> json) {
    return ApplicationDetails(
      name: json['name'] as String? ?? 'N/A',
      location: json['currentLocation'] as String? ?? 'N/A',
      experience: (json['totalExperience'] as int? ?? 0).toString(),  //as String? ?? '0',
    );
  }
}