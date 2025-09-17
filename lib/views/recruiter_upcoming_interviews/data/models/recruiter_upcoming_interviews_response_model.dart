class UpcomingInterviewResponseModel {
  final String interviewType;
  final String startTime;
  final String endTime;
  final String interviewDate;
  final String name;
  final String jobProfile;
  final String? status;

  UpcomingInterviewResponseModel({
    required this.interviewType,
    required this.startTime,
    required this.endTime,
    required this.interviewDate,
    required this.name,
    required this.jobProfile,
    this.status,
  });

  factory UpcomingInterviewResponseModel.fromJson(Map<String, dynamic> json) =>
      UpcomingInterviewResponseModel(
        interviewType: json['interview_type'],
        startTime: json['start_time'],
        endTime: json['end_time'],
        interviewDate: json['interview_date'],
        name: json['name'],
        jobProfile: json['jobProfile'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
    'interview_type': interviewType,
    'start_time': startTime,
    'end_time': endTime,
    'interview_date': interviewDate,
    'name': name,
    'jobProfile': jobProfile,
    'status': status,
  };
}