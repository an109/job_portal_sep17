class UserAuthOtpResponseModel {
  final bool success;
  final String message;
  final String? otp;

  UserAuthOtpResponseModel({
    required this.success,
    required this.message,
    this.otp,
  });

  factory UserAuthOtpResponseModel.fromJson(Map<String, dynamic> json) {
    bool isSuccess = json['success'] == true ||
        (json['message'] as String).toLowerCase().contains('success');

    return UserAuthOtpResponseModel(
      success: isSuccess,
      message: json['message'] ?? 'Operation failed.',
      otp: json['otp'], // Optional: useful during dev
    );
  }
}