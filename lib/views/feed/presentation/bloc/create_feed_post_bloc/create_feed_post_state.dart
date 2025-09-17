import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_portal/views/feed/domain/entities/create_feed_post_entity.dart';

abstract class CreateFeedPostState extends Equatable {
  const CreateFeedPostState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CreateFeedPostInitial extends CreateFeedPostState {
  const CreateFeedPostInitial();
}

class PickImagesCreatePostLoading extends CreateFeedPostState {
  const PickImagesCreatePostLoading();
}

class PickImagesCreatePostLoaded extends CreateFeedPostState {
  final XFile image;

  const PickImagesCreatePostLoaded(this.image);
}

class PickImagesCreatePostError extends CreateFeedPostState {
  const PickImagesCreatePostError();
}

class PickImagesCreatePostNoPhotoSelected extends CreateFeedPostState {
  const PickImagesCreatePostNoPhotoSelected();
}

class CreateFeedPostLoading extends CreateFeedPostState {
  const CreateFeedPostLoading();
}

class CreateFeedPostLoaded extends CreateFeedPostState {
  final CreateFeedPostEntity createFeedPostEntity;

  const CreateFeedPostLoaded(this.createFeedPostEntity);
}

class CreateFeedPostError extends CreateFeedPostState {
  const CreateFeedPostError();
}
