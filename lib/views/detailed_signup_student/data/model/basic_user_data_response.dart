class BasicUserInfoResponse {
  final String message;
  final BasicUser user;

  BasicUserInfoResponse({
    required this.message,
    required this.user,
  });

  factory BasicUserInfoResponse.fromJson(Map<String, dynamic> json) {
    return BasicUserInfoResponse(
      message: json['message'],
      user: BasicUser.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
    };
  }
}

class BasicUser {
  final int id;
  final String first_name;
  final String last_name;
  final String email;
  final String phone;

  BasicUser({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.phone,
  });

  factory BasicUser.fromJson(Map<String, dynamic> json) {
    return BasicUser(
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'phone': phone,
    };
  }
}
