import 'package:job_portal/views/signup_recruiter/domain/entities/sigup_user_entity.dart'
    as ent;

class SignUpRecruiterResponse extends ent.SignUpUserEntity {
  SignUpRecruiterResponse({
    required String message,
    User? user,
  }) : super(
          message: message,
          user: user != null ? ent.User(id: user.id, email: user.email) : null,
        );

  factory SignUpRecruiterResponse.fromJson(Map<String, dynamic> json) {
    return SignUpRecruiterResponse(
      message: json['message'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}

class User {
  final int id;
  final String email;

  User({required this.id, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
    );
  }
}
