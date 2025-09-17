class CreateFeedPostEntity {
  final String message;
  final FeedPostEntity feedPost;

  CreateFeedPostEntity({
    required this.message,
    required this.feedPost,
  });
}

class FeedPostEntity {
  final int like_count;
  final int comment_count;
  final String comments;
  final int id;
  final String user_id;
  final String image;
  final String caption;
  final String user_role;
  final String? profile_pic;
  final DateTime updated_at;
  final DateTime created_at;

  FeedPostEntity({
    required this.like_count,
    required this.comment_count,
    required this.comments,
    required this.id,
    required this.user_id,
    required this.image,
    required this.caption,
    required this.user_role,
    required this.profile_pic,
    required this.updated_at,
    required this.created_at,
  });
}
