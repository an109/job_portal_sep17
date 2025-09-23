import 'package:equatable/equatable.dart';

class UniversityFollowerFollowingModel extends Equatable {
  final int id;
  final String name;
  final String username;
  final String profileImage;

  const UniversityFollowerFollowingModel({
    required this.id,
    required this.name,
    required this.username,
    required this.profileImage,
  });

  @override
  List<Object> get props => [id, name, username, profileImage];

  factory UniversityFollowerFollowingModel.fromJson(Map<String, dynamic> json) {
    return UniversityFollowerFollowingModel(
      id: json['id'],
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      profileImage: json['profile_image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'profile_image': profileImage,
    };
  }
}