class UpdateUserEmailEntity {
  final String message;
  final String email;

  UpdateUserEmailEntity({
    required this.message,
    required this.email,
  });

  factory UpdateUserEmailEntity.fromJson(Map<String, dynamic> json) {
    return UpdateUserEmailEntity(
      message: json['message'] ?? '',
      email: json['email'] ?? '',
    );
  }
}