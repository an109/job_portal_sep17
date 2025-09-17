class CompanyRegisterResponseModel {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  CompanyRegisterResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory CompanyRegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return CompanyRegisterResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data,
  };
}