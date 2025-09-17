import 'package:job_portal/views/signup_student/domain/entities/verify_otp_entity.dart';

class VerifyOtpResponse extends VerifyOtpEntity {
  const VerifyOtpResponse({
    required super.message,
    required super.token,
    required super.emailVerified,
    required super.user,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      message: json['message'] ?? '',
      token: json['token'],
      emailVerified: json['emailVerified'] ?? false,
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'token': token,
      'emailVerified': emailVerified,
      'user': (user as UserModel).toJson(),
    };
  }
}

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.first_name,
    required super.last_name,
    required super.email,
    required super.phone,
    required super.user_role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      first_name: json['first_name'] ?? '',
      last_name: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      user_role: json['user_role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'phone': phone,
      'user_role': user_role,
    };
  }
}
