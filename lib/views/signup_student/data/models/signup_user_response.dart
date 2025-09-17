class SignUpUserResponse {
  final String message;
  final String? token;
  final User? user;

  SignUpUserResponse({
    required this.message,
    this.token,
    this.user,
  });

  factory SignUpUserResponse.fromJson(Map<String, dynamic> json) {
    return SignUpUserResponse(
      message: json['message'] ?? '',
      token: json['token'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      if (token != null) 'token': token,
      if (user != null) 'user': user!.toJson(),
    };
  }
}

// "user": {
//         "id": 112,
//         "first_name": "John",
//         "last_name": "Doe",
//         "phone": "58798598",
//         "email": "axqwwqc@gmail.com",
//         "user_role": "STUDENT"
//     }

class User {
  final int id;
  final String first_name;
  final String last_name;
  final String phone;
  final String email;
  final String user_role;

  User({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.phone,
    required this.email,
    required this.user_role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      phone: json['phone'],
      email: json['email'],
      user_role: json['user_role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
    };
  }
}
