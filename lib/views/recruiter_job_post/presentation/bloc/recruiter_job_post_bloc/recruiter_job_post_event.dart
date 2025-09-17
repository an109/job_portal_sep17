import 'package:equatable/equatable.dart';

abstract class RecruiterJobPostEvent extends Equatable {
  const RecruiterJobPostEvent();
  @override
  List<Object?> get props => [];
}

class FetchAllJobPosts extends RecruiterJobPostEvent {}