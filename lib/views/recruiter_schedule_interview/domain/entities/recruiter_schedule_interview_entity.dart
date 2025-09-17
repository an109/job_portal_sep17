class RecruiterScheduleInterviewEntity {
  final String message;
  final String interviewType;
  final String interviewDate;
  final String startTime;
  final String endTime;
  final String? videoLink;

  RecruiterScheduleInterviewEntity({
    required this.message,
    required this.interviewType,
    required this.interviewDate,
    required this.startTime,
    required this.endTime,
    this.videoLink,
  });
}