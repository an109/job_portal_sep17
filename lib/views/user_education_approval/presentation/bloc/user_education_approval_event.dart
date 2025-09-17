import '../../data/models/user_education_request_model.dart';

abstract class UserEducationApprovalEvent {}

class LoadMasterData extends UserEducationApprovalEvent {}

class UpdateUserEducation extends UserEducationApprovalEvent {
  final int id;
  // final UserEducationRequest request;
  final dynamic request;

  UpdateUserEducation(this.id, this.request);
}