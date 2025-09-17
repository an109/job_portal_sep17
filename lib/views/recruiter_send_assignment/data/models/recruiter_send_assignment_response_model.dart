class RecruiterSendAssignmentResponseModel {
  final int id;
  final String message;
  final String deadline;
  final String assignmentUrl;
  final DateTime createdAt;

  RecruiterSendAssignmentResponseModel({
    required this.id,
    required this.message,
    required this.deadline,
    required this.assignmentUrl,
    required this.createdAt,
  });

  factory RecruiterSendAssignmentResponseModel.fromJson(Map<String, dynamic> json) {
    return RecruiterSendAssignmentResponseModel(
      id: json['id'],
      message: json['message'],
      deadline: json['deadline'],
      assignmentUrl: json['assignment_url'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}