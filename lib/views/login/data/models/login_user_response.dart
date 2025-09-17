// class LoginUserResponse {
//   final String message;
//   final String token;
//   final User user;
//   final String profile_status;
//
//   LoginUserResponse({
//     required this.message,
//     required this.token,
//     required this.user,
//     required this.profile_status,
//   });
//
//   factory LoginUserResponse.fromJson(Map<String, dynamic> json) {
//     return LoginUserResponse(
//       message: json['message'],
//       token: json['token'],
//       user: User.fromJson(json['user']),
//       profile_status: json['profile_status'] ?? "0",
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'message': message,
//       'token': token,
//       'user': user.toJson(),
//       'profile_status': profile_status,
//     };
//   }
// }
//
// class User {
//   final int id;
//   final String first_name;
//   final String last_name;
//   final String email;
//   final String phone;
//   final String user_role;
//
//   User({
//     required this.id,
//     required this.first_name,
//     required this.last_name,
//     required this.email,
//     required this.phone,
//     required this.user_role,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       first_name: json['first_name'],
//       last_name: json['last_name'],
//       email: json['email'],
//       phone: json['phone'],
//       user_role: json['user_role'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'first_name': first_name,
//       'last_name': last_name,
//       'email': email,
//       'phone': phone,
//       'user_role': user_role,
//     };
//   }
// }

class LoginUserResponse {
  final bool success;
  final String message;
  final int profile_status;
  final String? email;        // Only present in profile_status=0
  final String? user_role;    // Only present in profile_status=0
  final String? token;        // Only present in profile_status=1/2
  final User? user;           // Only present in profile_status=1/2

  LoginUserResponse({
    required this.success,
    required this.message,
    required this.profile_status,
    this.email,
    this.user_role,
    this.token,
    this.user,
  });

  factory LoginUserResponse.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];

    return LoginUserResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      profile_status: json['profile_status'] ?? (userJson?['profile_status'] ?? 0),
      email: json['email'] ?? userJson?['email'],
      user_role: json['user_role'] ?? userJson?['user_role'],
      token: json['token'],
      user: userJson != null ? User.fromJson(userJson) : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'profile_status': profile_status,
      if (email != null) 'email': email,
      if (user_role != null) 'user_role': user_role,
      if (token != null) 'token': token,
      if (user != null) 'user': user!.toJson(),
    };
  }
}

class User {
  final int id;
  final String first_name;
  final String last_name;
  final String email;
  final String phone;
  final String user_role;
  final int profile_status;
  final String? user_profile_pic;
  final String? about_us;
  final String? organization_name;
  final String? organization_logo;

  User({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.phone,
    required this.user_role,
    required this.profile_status,
    this.user_profile_pic,
    this.about_us,
    this.organization_name,
    this.organization_logo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      user_role: json['user_role'],
      profile_status: json['profile_status'] ?? 0, // <-- Added
      user_profile_pic: json['user_profile_pic'],
      about_us: json['about_us'],
      organization_name: json['organization_name'],
      organization_logo: json['organization_logo'],
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
      'profile_status': profile_status,
      if (user_profile_pic != null) 'user_profile_pic': user_profile_pic,
      if (about_us != null) 'about_us': about_us,
      if (organization_name != null) 'organization_name': organization_name,
      if (organization_logo != null) 'organization_logo': organization_logo,
    };
  }
}
