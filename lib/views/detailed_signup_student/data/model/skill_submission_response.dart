class SkillSubmitionResponse {
  final String message;

  SkillSubmitionResponse({required this.message});

  factory SkillSubmitionResponse.fromJson(Map<String, dynamic> json) {
    return SkillSubmitionResponse(
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
