class UniversityRegistrationResponse {
  final String? message;
  final bool? success;

  UniversityRegistrationResponse({
    this.message,
    this.success,
  });

  factory UniversityRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return UniversityRegistrationResponse(
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );
  }
}
