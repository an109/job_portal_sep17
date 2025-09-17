import 'package:job_portal/views/job_related/domain/entities/job_apply_entity.dart';

class JobApplyModel extends JobApplyEntity {
  const JobApplyModel({required String message}) : super(message: message);

  factory JobApplyModel.fromJson(Map<String, dynamic> json) {
    return JobApplyModel(
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
