import 'dart:developer' as developer show log;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_portal/views/feed/domain/usecases/feed_usecase.dart';
import 'package:job_portal/views/feed/presentation/bloc/create_feed_post_bloc/create_feed_post_event.dart';
import 'package:job_portal/views/feed/presentation/bloc/create_feed_post_bloc/create_feed_post_state.dart';

class CreateFeedPostBloc
    extends Bloc<CreateFeedPostEvent, CreateFeedPostState> {
  final CreateFeedPostUsecase _createFeedPostUsecase;
  CreateFeedPostBloc(this._createFeedPostUsecase)
      : super(const CreateFeedPostInitial()) {
    on<PickImagesCreatePost>(_onPickImages);
    on<LoadCreateFeedPost>(_onLoadCreateFeedPost);
  }

  Future<void> _onPickImages(
      PickImagesCreatePost event, Emitter<CreateFeedPostState> emit) async {
    try {
      emit(const PickImagesCreatePostLoading());

      final result = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (result != null) {
        emit(PickImagesCreatePostLoaded(result));
      } else {
        emit(const PickImagesCreatePostNoPhotoSelected());
      }
    } catch (e) {
      emit(const PickImagesCreatePostError());
    }
  }

  Future<void> _onLoadCreateFeedPost(
      LoadCreateFeedPost event, Emitter<CreateFeedPostState> emit) async {
    try {
      emit(const CreateFeedPostLoading());

      final response = await _createFeedPostUsecase(params: event.params);
      developer.log('Success in create feed post');
      emit(CreateFeedPostLoaded(response.data!));

      // final
    } catch (e) {
      emit(const CreateFeedPostError());
      developer.log('Error in create feed post : $e');
    }
  }
}
