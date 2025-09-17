import 'dart:io';

class RecruiterSendAssignmentEntity {
  final String message;
  final String deadline;
  final File? assignmentFile;

  RecruiterSendAssignmentEntity({
    required this.message,
    required this.deadline,
    this.assignmentFile,
  });
}