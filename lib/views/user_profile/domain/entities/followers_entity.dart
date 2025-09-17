class FollowersEntity {
  final int count;
  final List<Follower> followers;

  FollowersEntity({
    required this.count,
    required this.followers,
  });
}

class Follower {
  final String first_name;
  final String last_name;
  final String user_role;

  Follower({
    required this.first_name,
    required this.last_name,
    required this.user_role,
  });
}

class FollowingEntity {
  final int count;
  final List<Following> following;

  FollowingEntity({
    required this.count,
    required this.following,
  });
}

class Following {
  final String first_name;
  final String last_name;
  final String user_role;

  Following({
    required this.first_name,
    required this.last_name,
    required this.user_role,
  });
}
