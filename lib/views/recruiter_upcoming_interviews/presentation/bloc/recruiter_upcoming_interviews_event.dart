import 'package:equatable/equatable.dart';

abstract class RecruiterUpcomingInterviewsEvent extends Equatable {
  const RecruiterUpcomingInterviewsEvent();

  @override
  List<Object> get props => [];
}

class FetchUpcomingInterviews extends RecruiterUpcomingInterviewsEvent {}