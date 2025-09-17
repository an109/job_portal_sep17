import 'package:equatable/equatable.dart';

abstract class RecruiterUpdateProfileEvent extends Equatable {
  const RecruiterUpdateProfileEvent();

  @override
  List<Object> get props => [];
}

class UpdateProfileEvent extends RecruiterUpdateProfileEvent {
  final String about;
  final String contact;
  final String hiringPreferences;
  final String languages;
  final List<int> languageIds;
  final String? profilePic;

  const UpdateProfileEvent({
    required this.about,
    required this.contact,
    required this.hiringPreferences,
    required this.languages,
    required this.languageIds,
    this.profilePic,
  });

  @override
  List<Object> get props => [about, hiringPreferences, contact, languages, languageIds, profilePic ?? ''];
}

class InitialEvent extends RecruiterUpdateProfileEvent {}