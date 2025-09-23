
import 'package:equatable/equatable.dart';

import '../../data/models/university_followers_following_model.dart';

class UniversityFollowerFollowingEntity extends Equatable {
  final int id;
  final String name;
  final String username;
  final String profileImage;

  const UniversityFollowerFollowingEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.profileImage,
  });

  @override
  List<Object> get props => [id, name, username, profileImage];

  factory UniversityFollowerFollowingEntity.fromModel(UniversityFollowerFollowingModel model) {
    return UniversityFollowerFollowingEntity(
      id: model.id,
      name: model.name,
      username: model.username,
      profileImage: model.profileImage,
    );
  }
}