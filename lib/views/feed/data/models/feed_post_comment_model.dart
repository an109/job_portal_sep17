import 'package:job_portal/views/feed/domain/entities/feed_post_comment_entity.dart';

class FeedPostCommentModel extends FeedPostCommentEntity {
  FeedPostCommentModel({
    required super.message,
    required List<CommentModel> comments,
    required super.comment_count,
  }) : super(comments: comments);

  factory FeedPostCommentModel.fromJson(Map<String, dynamic> json) {
    return FeedPostCommentModel(
      message: json['message'] ?? '',
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => CommentModel.fromJson(e))
              .toList() ??
          [],
      comment_count: json['comment_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'comments': comments.map((e) => (e as CommentModel).toJson()).toList(),
      'comment_count': comment_count,
    };
  }
}

class CommentModel extends CommentEntity {
  CommentModel({
    required super.user_id,
    required super.comment,
    required super.created_at,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      user_id: json['user_id'],
      comment: json['comment'],
      created_at: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'comment': comment,
      'created_at': created_at.toIso8601String(),
    };
  }
}
