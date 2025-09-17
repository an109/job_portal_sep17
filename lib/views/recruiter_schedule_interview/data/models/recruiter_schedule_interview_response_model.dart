class RecruiterScheduleInterviewResponseModel {
  final int id;
  final String name;
  final int jobId;
  final String message;
  final String interviewType;
  final String interviewDate;
  final String startTime;
  final String endTime;
  final String videoLink;
  final DateTime createdAt;
  final DateTime updatedAt;

  RecruiterScheduleInterviewResponseModel({
    required this.id,
    required this.name,
    required this.jobId,
    required this.message,
    required this.interviewType,
    required this.interviewDate,
    required this.startTime,
    required this.endTime,
    required this.videoLink,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RecruiterScheduleInterviewResponseModel.fromJson(Map<String, dynamic> json) {
    return RecruiterScheduleInterviewResponseModel(
      id: json['id'],
      name: json['name'],
      jobId: json['job_id'],
      message: json['message'],
      interviewType: json['interview_type'],
      interviewDate: json['interview_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      videoLink: json['video_link'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}