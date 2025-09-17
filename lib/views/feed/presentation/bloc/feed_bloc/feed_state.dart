import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:job_portal/views/feed/domain/entities/create_feed_post_entity.dart';
import 'package:job_portal/views/feed/domain/entities/feed_entity.dart';
import 'package:job_portal/views/feed/domain/entities/feed_post_comment_entity.dart';
import 'package:job_portal/views/feed/domain/entities/feed_post_like_entity.dart';

@immutable
abstract class FeedState extends Equatable {
  const FeedState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FeedInitial extends FeedState {
  const FeedInitial();
}

class FeedPostsLoading extends FeedState {
  const FeedPostsLoading();
}

class FeedPostsLoaded extends FeedState {
  // final FeedEntity feedEntity;
  final List<PostEntity> postEntity;
  const FeedPostsLoaded(this.postEntity);
}

class FeedPostsError extends FeedState {
  const FeedPostsError();
}

class FeedPostLikeLoading extends FeedState {
  const FeedPostLikeLoading();
}

class FeedPostLikeLoaded extends FeedState {
  final FeedPostLikeEntity feedPostLikeEntity;

  const FeedPostLikeLoaded(this.feedPostLikeEntity);
}

class FeedPostLikeError extends FeedState {
  const FeedPostLikeError();
}

class FeedPostCommentLoading extends FeedState {
  const FeedPostCommentLoading();
}

class FeedPostCommentLoaded extends FeedState {
  final FeedPostCommentEntity feedPostCommentEntity;

  const FeedPostCommentLoaded(this.feedPostCommentEntity);
}

class FeedPostCommentError extends FeedState {
  const FeedPostCommentError();
}
