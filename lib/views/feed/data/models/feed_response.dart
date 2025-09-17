import 'package:job_portal/views/feed/domain/entities/feed_entity.dart';

class FeedResponseModel extends FeedEntity {
  const FeedResponseModel({
    required super.totalPosts,
    required super.currentPage,
    required super.totalPages,
    required super.posts,
  });

  factory FeedResponseModel.fromJson(Map<String, dynamic> json) {
    return FeedResponseModel(
      totalPosts: json['totalPosts'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      posts:
          List<PostModel>.from(json['posts'].map((e) => PostModel.fromJson(e))),
    );
  }
}

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.user_id,
    required super.image,
    required super.caption,
    required super.user_role,
    required super.profile_pic,
    required super.like_count,
    required super.comment_count,
    required super.comments,
    required super.created_at,
    required super.updated_at,
    required super.user,
    required super.isLiked,
    super.slug,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      user_id: json['user_id'],
      image: json['image'],
      caption: json['caption'],
      user_role: json['user_role'],
      profile_pic: json['profile_pic'],
      like_count: json['like_count'],
      comment_count: json['comment_count'],
      comments: List<CommentModel>.from(
          json['comments'].map((e) => CommentModel.fromJson(e))),
      created_at: DateTime.parse(json['created_at']),
      updated_at: DateTime.parse(json['updated_at']),
      user: UserModel.fromJson(json['User']),
      isLiked: json['isLiked'],
      slug: json['slug'],
    );
  }
}

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.user_id,
    required super.comment,
    required super.created_at,
    required super.first_name,
    required super.last_name,
    required super.profile_pic,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      user_id: json['user_id'],
      comment: json['comment'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      profile_pic: json['profile_pic'],
      created_at: DateTime.parse(json['created_at']),
    );
  }
}

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.first_name,
    required super.last_name,
    required super.profile_pic,
    required super.followersCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      profile_pic: json['profile_pic'],
      followersCount: json['followersCount'],
    );
  }
}
