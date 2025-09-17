import 'dart:developer' as developer show log;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/user_profile/domain/usecases/profile_usecases.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/raise_ticket_bloc/raise_ticket_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/raise_ticket_bloc/raise_ticket_state.dart';

class RaiseTicketBloc extends Bloc<RaiseTicketEvent, RaiseTicketState> {
  final RaiseTicketUsecase _raiseTicketUsecase;
  RaiseTicketBloc(this._raiseTicketUsecase)
      : super(const RaiseTicketInitial()) {
    on<RaiseATicket>(_onLoadRaiseTicket);
  }

  Future<void> _onLoadRaiseTicket(
      RaiseATicket event, Emitter<RaiseTicketState> emit) async {
    try {
      emit(const RaiseATicketLoading());
      final response = await _raiseTicketUsecase(params: event.params);
      emit(RaiseATicketLoaded(response.data!));
    } catch (e) {
      developer.log('Error in raise ticket : $e');

      emit(const RaiseATicketError());
    }
  }
}
