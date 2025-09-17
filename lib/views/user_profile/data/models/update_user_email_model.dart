import 'package:job_portal/views/user_profile/domain/entities/update_user_email_entity.dart';

class UpdateUserEmailModel extends UpdateUserEmailEntity {
  UpdateUserEmailModel({
    required super.message,
    required super.email,
  });

  factory UpdateUserEmailModel.fromJson(Map<String, dynamic> json) {
    return UpdateUserEmailModel(
      message: json['message'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'email': email,
    };
  }
}
