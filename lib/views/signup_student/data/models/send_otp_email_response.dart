import 'package:job_portal/views/signup_student/domain/entities/send_otp_email_entity.dart';

class SendOtpEmailResponse extends SendOtpEmailEntity {
  SendOtpEmailResponse({required super.message});

  factory SendOtpEmailResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpEmailResponse(
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
