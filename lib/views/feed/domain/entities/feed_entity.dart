class FeedEntity {
  final int totalPosts;
  final int currentPage;
  final int totalPages;
  final List<PostEntity> posts;

  const FeedEntity({
    required this.totalPosts,
    required this.currentPage,
    required this.totalPages,
    required this.posts,
  });
}

class PostEntity {
  final int id;
  final int user_id;
  final String? image;
  final String caption;
  final String user_role;
  final String? profile_pic;
  final int like_count;
  final int comment_count;
  final List<CommentEntity> comments;
  final DateTime created_at;
  final DateTime updated_at;
  final UserEntity user;
  final bool isLiked;
  final String? slug;

  const PostEntity({
    required this.id,
    required this.user_id,
    required this.image,
    required this.caption,
    required this.user_role,
    required this.profile_pic,
    required this.like_count,
    required this.comment_count,
    required this.comments,
    required this.created_at,
    required this.updated_at,
    required this.user,
    required this.isLiked,
    this.slug,
  });
}

class CommentEntity {
  final dynamic user_id;
  final String comment;
  final DateTime created_at;
  final String first_name;
  final String last_name;
  final String? profile_pic;

  const CommentEntity({
    required this.user_id,
    required this.comment,
    required this.created_at,
    required this.first_name,
    required this.last_name,
    required this.profile_pic,
  });
}

// "first_name": "Amarjeet",
// "last_name": "Patel",
// "profile_pic": null

class UserEntity {
  final int id;
  final String first_name;
  final String last_name;
  final String? profile_pic;
  final int followersCount;

  const UserEntity({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.profile_pic,
    required this.followersCount,
  });
}
