import 'package:job_portal/views/user_profile/domain/entities/raise_ticket_entity.dart';

class RaiseTicketResponseModel extends RaiseTicketResponseEntity {
  const RaiseTicketResponseModel({
    required super.success,
    required super.message,
    required super.ticket,
  });

  factory RaiseTicketResponseModel.fromJson(Map<String, dynamic> json) {
    return RaiseTicketResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      ticket: RaiseTicketModel.fromJson({'ticket': json['ticket']}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'ticket': (ticket as RaiseTicketModel).toJson(),
    };
  }
}

class RaiseTicketModel extends RaiseTicketEntity {
  const RaiseTicketModel({
    required super.status,
    required super.id,
    required super.user_id,
    required super.name,
    required super.email,
    required super.role,
    required super.issue_title,
    required super.issue_detail,
    required super.priority,
    required super.updated_at,
    required super.created_at,
  });

  factory RaiseTicketModel.fromJson(Map<String, dynamic> json) {
    final ticket = json['ticket'];

    return RaiseTicketModel(
      status: ticket['status'] ?? '',
      id: ticket['id'] ?? 0,
      user_id: int.tryParse(ticket['user_id'].toString()) ?? 0,
      name: ticket['name'] ?? '',
      email: ticket['email'] ?? '',
      role: ticket['role'] ?? '',
      issue_title: ticket['issue_title'] ?? '',
      issue_detail: ticket['issue_detail'] ?? '',
      priority: ticket['priority'] ?? '',
      updated_at: DateTime.parse(ticket['updated_at']),
      created_at: DateTime.parse(ticket['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'id': id,
      'user_id': user_id,
      'name': name,
      'email': email,
      'role': role,
      'issue_title': issue_title,
      'issue_detail': issue_detail,
      'priority': priority,
      'updated_at': updated_at.toIso8601String(),
      'created_at': created_at.toIso8601String(),
    };
  }
}
