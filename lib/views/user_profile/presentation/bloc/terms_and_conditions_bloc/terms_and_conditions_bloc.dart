import 'dart:developer' as developer show log;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/user_profile/domain/usecases/profile_usecases.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/terms_and_conditions_bloc/terms_and_conditions_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/terms_and_conditions_bloc/terms_and_conditions_state.dart';

class TermsAndConditionsBloc
    extends Bloc<TermsAndConditionsEvent, TermsAndConditionsState> {
  final TermsAndConditionsUsecase _termsAndConditionsUsecase;
  TermsAndConditionsBloc(this._termsAndConditionsUsecase)
      : super(const TnCInitial()) {
    on<LoadTnC>(_onLoadTnC);
  }

  Future<void> _onLoadTnC(
      LoadTnC event, Emitter<TermsAndConditionsState> emit) async {
    try {
      emit(const TnCLoading());
      final respones = await _termsAndConditionsUsecase();
      // developer.log('checking in bloc : ${respones.data!.first_name}');
      emit(TnCLoaded(respones.data!));
    } catch (e) {
      developer.log('checking error in bloc : ${e}');

      emit(const TnCError());
    }
  }
}
