// lib/views/user_profile/presentation/bloc/language_bloc/language_state.dart

import 'package:equatable/equatable.dart';

import '../../../domain/entities/metadata_entities.dart';

abstract class LanguageState extends Equatable {
  const LanguageState();
}

class LanguageInitial extends LanguageState {
  @override
  List<Object?> get props => [];
}

class LanguageLoading extends LanguageState {
  @override
  List<Object?> get props => [];
}

class LanguageLoaded extends LanguageState {
  final List<LanguageEntity> languages;

  const LanguageLoaded({required this.languages});

  @override
  List<Object?> get props => [languages];
}

class LanguageError extends LanguageState {
  final String message;

  const LanguageError({required this.message});

  @override
  List<Object?> get props => [message];
}