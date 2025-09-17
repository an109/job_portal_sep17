import 'package:equatable/equatable.dart';
import 'package:job_portal/views/user_profile/domain/entities/raise_ticket_entity.dart';

abstract class RaiseTicketState extends Equatable {
  const RaiseTicketState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class RaiseTicketInitial extends RaiseTicketState {
  const RaiseTicketInitial();
}

class RaiseATicketLoading extends RaiseTicketState {
  const RaiseATicketLoading();
}

class RaiseATicketLoaded extends RaiseTicketState {
  final RaiseTicketResponseEntity raiseTicketEntity;
  const RaiseATicketLoaded(this.raiseTicketEntity);
}

class RaiseATicketError extends RaiseTicketState {
  const RaiseATicketError();
}
