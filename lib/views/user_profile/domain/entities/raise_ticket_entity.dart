class RaiseTicketResponseEntity {
  final bool success;
  final String? message;
  final RaiseTicketEntity ticket;

  const RaiseTicketResponseEntity({
    required this.success,
    required this.message,
    required this.ticket,
  });
}

class RaiseTicketEntity {
  final String status;
  final int id;
  final int user_id;
  final String? name;
  final String? email;
  final String? role;
  final String? issue_title;
  final String? issue_detail;
  final String? priority;
  final DateTime updated_at;
  final DateTime created_at;

  const RaiseTicketEntity({
    required this.status,
    required this.id,
    required this.user_id,
    required this.name,
    required this.email,
    required this.role,
    required this.issue_title,
    required this.issue_detail,
    required this.priority,
    required this.updated_at,
    required this.created_at,
  });
}
