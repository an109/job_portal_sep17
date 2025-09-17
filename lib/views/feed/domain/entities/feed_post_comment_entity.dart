class FeedPostCommentEntity {
  final String message;
  final List<CommentEntity> comments;
  final int comment_count;

  FeedPostCommentEntity({
    required this.message,
    required this.comments,
    required this.comment_count,
  });
}

class CommentEntity {
  final dynamic user_id;
  final String comment;
  final DateTime created_at;

  CommentEntity({
    required this.user_id,
    required this.comment,
    required this.created_at,
  });
}
