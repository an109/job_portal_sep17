class SignUpUserEntity {
  final String message;
  final User? user;

  SignUpUserEntity({
    required this.message,
    this.user,
  });
}

class User {
  final int id;
  final String email;

  User({
    required this.id,
    required this.email,
  });
}
