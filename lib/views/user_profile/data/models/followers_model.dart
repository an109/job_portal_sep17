import 'package:job_portal/views/user_profile/domain/entities/followers_entity.dart';

class FollowersModel extends FollowersEntity {
  FollowersModel({
    required int count,
    required List<FollowerModel> followers,
  }) : super(count: count, followers: followers);

  factory FollowersModel.fromJson(Map<String, dynamic> json) {
    return FollowersModel(
      count: json['count'] ?? 0,
      followers: (json['followers'] as List<dynamic>?)
              ?.map((e) => FollowerModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'followers': followers.map((e) => (e as FollowerModel).toJson()).toList(),
    };
  }
}

class FollowerModel extends Follower {
  FollowerModel({
    required String first_name,
    required String last_name,
    required String user_role,
  }) : super(
          first_name: first_name,
          last_name: last_name,
          user_role: user_role,
        );

  factory FollowerModel.fromJson(Map<String, dynamic> json) {
    return FollowerModel(
      first_name: json['first_name'] ?? '',
      last_name: json['last_name'] ?? '',
      user_role: json['user_role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': first_name,
      'last_name': last_name,
      'user_role': user_role,
    };
  }
}

class FollowingModel extends FollowingEntity {
  FollowingModel({
    required int count,
    required List<FollowingItemModel> following,
  }) : super(count: count, following: following);

  factory FollowingModel.fromJson(Map<String, dynamic> json) {
    return FollowingModel(
      count: json['count'] ?? 0,
      following: (json['following'] as List<dynamic>?)
              ?.map((e) => FollowingItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'following':
          following.map((e) => (e as FollowingItemModel).toJson()).toList(),
    };
  }
}

class FollowingItemModel extends Following {
  FollowingItemModel({
    required String first_name,
    required String last_name,
    required String user_role,
  }) : super(
          first_name: first_name,
          last_name: last_name,
          user_role: user_role,
        );

  factory FollowingItemModel.fromJson(Map<String, dynamic> json) {
    return FollowingItemModel(
      first_name: json['first_name'] ?? '',
      last_name: json['last_name'] ?? '',
      user_role: json['user_role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': first_name,
      'last_name': last_name,
      'user_role': user_role,
    };
  }
}
