// class UniversityRegistrationResponse {
//   final String? message;
//   final bool? success;
//
//   UniversityRegistrationResponse({
//     this.message,
//     this.success,
//   });
//
//   factory UniversityRegistrationResponse.fromJson(Map<String, dynamic> json) {
//     return UniversityRegistrationResponse(
//       message: json['message'] as String?,
//       success: json['success'] as bool?,
//     );
//   }
// }

// university_registration_response.dart
class UniversityRegistrationResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data; // This will hold the actual entity data

  UniversityRegistrationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UniversityRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return UniversityRegistrationResponse(
      success: json['success'] == true,
      message: json['message'] ?? '',
      data: json['data'] ?? {},
    );
  }
}
