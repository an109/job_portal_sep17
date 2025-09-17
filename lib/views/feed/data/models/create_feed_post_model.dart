import 'package:job_portal/views/feed/domain/entities/create_feed_post_entity.dart';

class CreateFeedPostModel extends CreateFeedPostEntity {
  CreateFeedPostModel({
    required super.message,
    required FeedPostModel super.feedPost,
  });

  factory CreateFeedPostModel.fromJson(Map<String, dynamic> json) {
    return CreateFeedPostModel(
      message: json['message'],
      feedPost: FeedPostModel.fromJson(json['feedPost']),
    );
  }
}

class FeedPostModel extends FeedPostEntity {
  FeedPostModel({
    required super.like_count,
    required super.comment_count,
    required super.comments,
    required super.id,
    required super.user_id,
    required super.image,
    required super.caption,
    required super.user_role,
    required super.profile_pic,
    required super.updated_at,
    required super.created_at,
  });

  factory FeedPostModel.fromJson(Map<String, dynamic> json) {
    return FeedPostModel(
      like_count: json['like_count'],
      comment_count: json['comment_count'],
      comments: json['comments'],
      id: json['id'],
      user_id: json['user_id'],
      image: json['image'],
      caption: json['caption'],
      user_role: json['user_role'],
      profile_pic: json['profile_pic'],
      updated_at: DateTime.parse(json['updated_at']),
      created_at: DateTime.parse(json['created_at']),
    );
  }
}
