import 'dart:developer' as developer show log;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/feed/domain/entities/feed_entity.dart';
import 'package:job_portal/views/feed/domain/usecases/feed_usecase.dart';
import 'package:job_portal/views/feed/presentation/bloc/feed_bloc/feed_event.dart';
import 'package:job_portal/views/feed/presentation/bloc/feed_bloc/feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedUsecase _feedUsecase;
  final FeedPostLikeUsecase _feedPostLikeUsecase;
  final FeedPostCommentUsecase _feedPostCommentUsecase;

  List<PostEntity> postList = [];

  FeedBloc(this._feedUsecase, this._feedPostLikeUsecase,
      this._feedPostCommentUsecase)
      : super(const FeedInitial()) {
    on<LoadFeedPosts>(_onLoadFeedPosts);
    on<LoadFeedPostLike>(_onLoadFeedPostLike);
    on<LoadFeedPostComment>(_onLoadFeedPostComment);
  }

  Future<void> _onLoadFeedPosts(
      LoadFeedPosts event, Emitter<FeedState> emit) async {
    try {
      emit(const FeedPostsLoading());
      final map = {'page': event.page, 'limit': event.limit};
      final response = await _feedUsecase(params: map);

      // Clear old list only if it's a refresh (e.g., page = 1)
      if (event.page == '1') {
        postList.clear();
      }

      postList.addAll(response.data!.posts);
      emit(FeedPostsLoaded(List<PostEntity>.from(postList))); // Emit fresh copy
    } catch (e) {
      developer.log('Error in loading feed posts : $e');
      emit(const FeedPostsError());
    }
  }

  Future<void> _onLoadFeedPostComment(
      LoadFeedPostComment event, Emitter<FeedState> emit) async {
    try {
      emit(const FeedPostCommentLoading());
      final map = {'feedPostId': event.feedPostId, 'params': event.map};

      final response = await _feedPostCommentUsecase(params: map);
      developer.log('Success in feed comment.');
      emit(FeedPostCommentLoaded(response.data!));

      // final
    } catch (e) {
      emit(const FeedPostCommentError());
      developer.log('Error in feed comment. : $e');
    }
  }

  Future<void> _onLoadFeedPostLike(
      LoadFeedPostLike event, Emitter<FeedState> emit) async {
    try {
      emit(const FeedPostLikeLoading());
      final map = {'feedPostId': event.feedPostId, 'params': event.map};

      final response = await _feedPostLikeUsecase(params: map);
      emit(FeedPostLikeLoaded(response.data!));
      // final
    } catch (e) {
      emit(const FeedPostLikeError());
    }
  }
}
