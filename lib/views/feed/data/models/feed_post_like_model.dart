import 'package:job_portal/views/feed/domain/entities/feed_post_like_entity.dart';

class FeedPostLikeModel extends FeedPostLikeEntity {
  FeedPostLikeModel({
    required super.message,
    required super.like_count,
  });

  factory FeedPostLikeModel.fromJson(Map<String, dynamic> json) {
    return FeedPostLikeModel(
      message: json['message'] ?? '',
      like_count: json['like_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'like_count': like_count,
    };
  }
}
