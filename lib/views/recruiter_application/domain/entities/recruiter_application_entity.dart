class RecruiterApplicationEntity {
  final int applicationId;
  final int userId;
  final String applicantName;
  final String location;
  final String experience;
  final String appliedDate;
  final int matchPercentage;
  final List<String> skills;

  RecruiterApplicationEntity({
    required this.applicationId,
    required this.userId,
    required this.applicantName,
    required this.location,
    required this.experience,
    required this.appliedDate,
    required this.matchPercentage,
    required this.skills,
  });
}