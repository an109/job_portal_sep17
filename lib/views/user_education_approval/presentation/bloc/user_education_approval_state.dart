import '../../data/models/user_education_approval_response_model.dart';

abstract class UserEducationApprovalState {}

class UserEducationApprovalInitial extends UserEducationApprovalState {}

class UserEducationApprovalLoading extends UserEducationApprovalState {}

class UserEducationApprovalLoaded extends UserEducationApprovalState {
  final UserEducationResponse entity;

  UserEducationApprovalLoaded(this.entity);
}

class UserEducationApprovalUpdated extends UserEducationApprovalState {
  final dynamic entity;

  UserEducationApprovalUpdated(this.entity);
}

class UserEducationApprovalError extends UserEducationApprovalState {
  final String message;

  UserEducationApprovalError(this.message);
}