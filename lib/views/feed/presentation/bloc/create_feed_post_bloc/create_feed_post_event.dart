import 'package:equatable/equatable.dart';

abstract class CreateFeedPostEvent extends Equatable {
  const CreateFeedPostEvent();
}

class PickImagesCreatePost extends CreateFeedPostEvent {
  const PickImagesCreatePost();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadCreateFeedPost extends CreateFeedPostEvent {
  final Map<String, dynamic> params;

  const LoadCreateFeedPost(this.params);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
