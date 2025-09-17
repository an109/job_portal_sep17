import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/views/feed/domain/entities/create_feed_post_entity.dart';
import 'package:job_portal/views/feed/domain/entities/feed_entity.dart';
import 'package:job_portal/views/feed/domain/entities/feed_post_comment_entity.dart';
import 'package:job_portal/views/feed/domain/entities/feed_post_like_entity.dart';

abstract class FeedRepository {
  Future<DataState<FeedEntity>> getFeedPosts(String page, String limit);

  Future<DataState<FeedPostLikeEntity>> feedPostLike(
      String feedPostId, Map<String, dynamic> params);

  Future<DataState<FeedPostCommentEntity>> feedPostComment(
      String feedPostId, Map<String, dynamic> params);

  Future<DataState<CreateFeedPostEntity>> createFeedPost(
    Map<String, dynamic> params,
  );
}
