import 'package:equatable/equatable.dart';

abstract class RaiseTicketEvent extends Equatable {
  const RaiseTicketEvent();
}

class RaiseATicket extends RaiseTicketEvent {
  final Map<String, dynamic> params;
  const RaiseATicket(this.params);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
