class VerifyOtpEntity {
  final String message;
  final String? token;
  final bool emailVerified;
  final UserEntity user;

  const VerifyOtpEntity({
    required this.message,
    required this.token,
    required this.emailVerified,
    required this.user,
  });
}

class UserEntity {
  final int id;
  final String first_name;
  final String last_name;
  final String email;
  final String phone;
  final String user_role;

  const UserEntity({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.phone,
    required this.user_role,
  });
}
