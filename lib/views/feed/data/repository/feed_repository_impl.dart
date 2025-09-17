import 'dart:developer' as develop show log;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/views/feed/data/data_sources/feed_api_service.dart';
import 'package:job_portal/views/feed/domain/entities/create_feed_post_entity.dart';
import 'package:job_portal/views/feed/domain/entities/feed_entity.dart';
import 'package:job_portal/views/feed/domain/entities/feed_post_comment_entity.dart';
import 'package:job_portal/views/feed/domain/entities/feed_post_like_entity.dart';
import 'package:job_portal/views/feed/domain/repository/feed_repository.dart';

class FeedRepositoryImpl extends FeedRepository {
  final FeedApiService _apiService;

  FeedRepositoryImpl(this._apiService);

  @override
  Future<DataState<FeedEntity>> getFeedPosts(String page, String limit) async {
    try {
      final response = await _apiService.getFeedPosts(page, limit);

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      } else {
        develop.log('.Ending up in repo error : ${response.response}');
        return DataFailed(
          DioException(
              error: response.response.statusMessage,
              requestOptions: response.response.requestOptions,
              response: response.response,
              type: DioExceptionType.badResponse),
        );
      }
    } on DioException catch (e) {
      develop.log('Ending up in repo error : $e');
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<FeedPostLikeEntity>> feedPostLike(
      String feedPostId, Map<String, dynamic> params) async {
    try {
      final response = await _apiService.feedPostLike(feedPostId, params);

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      } else {
        develop.log('.Ending up in repo error : ${response.response}');
        return DataFailed(
          DioException(
              error: response.response.statusMessage,
              requestOptions: response.response.requestOptions,
              response: response.response,
              type: DioExceptionType.badResponse),
        );
      }
    } on DioException catch (e) {
      develop.log('Ending up in repo error : $e');
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<FeedPostCommentEntity>> feedPostComment(
      String feedPostId, Map<String, dynamic> params) async {
    try {
      final response = await _apiService.feedPostComment(feedPostId, params);

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      } else {
        develop.log('.Ending up in repo error : ${response.response}');
        return DataFailed(
          DioException(
              error: response.response.statusMessage,
              requestOptions: response.response.requestOptions,
              response: response.response,
              type: DioExceptionType.badResponse),
        );
      }
    } on DioException catch (e) {
      develop.log('Ending up in repo error : $e');
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<CreateFeedPostEntity>> createFeedPost(
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await _apiService.createFeedPost(
        params,
      );

      if (response.response.statusCode == HttpStatus.ok ||
          response.response.statusCode == HttpStatus.created) {
        return DataSuccess(response.data);
      } else {
        develop.log('.Ending up in repo error : ${response.response}');
        return DataFailed(
          DioException(
              error: response.response.statusMessage,
              requestOptions: response.response.requestOptions,
              response: response.response,
              type: DioExceptionType.badResponse),
        );
      }
    } on DioException catch (e) {
      develop.log('Ending up in repo error : $e');
      return DataFailed(e);
    }
  }
}
