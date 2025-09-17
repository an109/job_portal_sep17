// models/application_screening_details.dart
class ApplicationScreeningDetails {
  final String whyShouldWeHireYou;
  final String confirmAvailability;
  final String project;
  final String githubLink;
  final String portfolioLink;
  final String additionalDetails;

  ApplicationScreeningDetails({
    required this.whyShouldWeHireYou,
    required this.confirmAvailability,
    required this.project,
    required this.githubLink,
    required this.portfolioLink,
    required this.additionalDetails,
  });

  factory ApplicationScreeningDetails.fromJson(Map<String, dynamic> json) {
    return ApplicationScreeningDetails(
      whyShouldWeHireYou: json['why_should_we_hire_you'] ?? 'Not provided',
      confirmAvailability: json['confirm_availability'] ?? 'Not specified',
      project: json['project'] ?? 'No project description',
      githubLink: json['github_link'] ?? '',
      portfolioLink: json['portfolio_link'] ?? '',
      additionalDetails: json['additional_details'] ?? '',
    );
  }
}