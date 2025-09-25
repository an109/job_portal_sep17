

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repository/language_repository.dart';
import 'laguage_event.dart';
import 'lanuage_state.dart';


class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final MasterDataRepository _repository;

  LanguageBloc(this._repository) : super(LanguageInitial()) {
    on<FetchLanguages>((event, emit) async {
      emit(LanguageLoading());
      try {
        final langs = await _repository.getAllLanguages();
        emit(LanguageLoaded(languages: langs));
      } catch (e) {
        emit(LanguageError(message: e.toString()));
      }
    });
  }
}