import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/utils/usecase/usecases.dart';
import 'package:job_portal/views/feed/domain/entities/create_feed_post_entity.dart';
import 'package:job_portal/views/feed/domain/entities/feed_entity.dart';
import 'package:job_portal/views/feed/domain/entities/feed_post_comment_entity.dart';
import 'package:job_portal/views/feed/domain/entities/feed_post_like_entity.dart';
import 'package:job_portal/views/feed/domain/repository/feed_repository.dart';

class FeedUsecase
    implements UseCase<DataState<FeedEntity>, Map<String, dynamic>> {
  final FeedRepository _repository;
  FeedUsecase(this._repository);

  @override
  Future<DataState<FeedEntity>> call({Map<String, dynamic>? params}) async {
    return _repository.getFeedPosts(params!['page'], params['limit']);
  }
}

class FeedPostLikeUsecase
    implements UseCase<DataState<FeedPostLikeEntity>, Map<String, dynamic>> {
  final FeedRepository _repository;
  FeedPostLikeUsecase(this._repository);

  @override
  Future<DataState<FeedPostLikeEntity>> call(
      {Map<String, dynamic>? params}) async {
    return _repository.feedPostLike(params!['feedPostId'], params['params']);
  }
}

class FeedPostCommentUsecase
    implements UseCase<DataState<FeedPostCommentEntity>, Map<String, dynamic>> {
  final FeedRepository _repository;
  FeedPostCommentUsecase(this._repository);

  @override
  Future<DataState<FeedPostCommentEntity>> call(
      {Map<String, dynamic>? params}) async {
    return _repository.feedPostComment(params!['feedPostId'], params['params']);
  }
}

class CreateFeedPostUsecase
    implements UseCase<DataState<CreateFeedPostEntity>, Map<String, dynamic>> {
  final FeedRepository _repository;
  CreateFeedPostUsecase(this._repository);

  @override
  Future<DataState<CreateFeedPostEntity>> call(
      {Map<String, dynamic>? params}) async {
    return _repository.createFeedPost(params!);
  }
}
