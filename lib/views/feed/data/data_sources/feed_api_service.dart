import 'package:dio/dio.dart';
import 'package:job_portal/utils/constants/urls.dart';
import 'package:job_portal/views/feed/data/models/create_feed_post_model.dart';
import 'package:job_portal/views/feed/data/models/feed_post_comment_model.dart';
import 'package:job_portal/views/feed/data/models/feed_post_like_model.dart';
import 'package:job_portal/views/feed/data/models/feed_response.dart';
import 'package:retrofit/retrofit.dart';

part 'feed_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class FeedApiService {
  factory FeedApiService(Dio dio, {String? baseUrl}) = _FeedApiService;

  @GET(Urls.getFeedPosts)
  Future<HttpResponse<FeedResponseModel>> getFeedPosts(
    @Query('page') String page,
    @Query('limit') String limit,
  );

  @POST("${Urls.feedPostLike1}{feedPostId}${Urls.feedPostLike2}")
  Future<HttpResponse<FeedPostLikeModel>> feedPostLike(
      @Path() String feedPostId, @Body() Map<String, dynamic> params);

  @POST("${Urls.feedPostComment1}{feedPostId}${Urls.feedPostComment2}")
  Future<HttpResponse<FeedPostCommentModel>> feedPostComment(
      @Path() String feedPostId, @Body() Map<String, dynamic> params);

  @POST(Urls.createFeedPost)
  Future<HttpResponse<CreateFeedPostModel>> createFeedPost(
    @Body() Map<String, dynamic> params,
  );
}
