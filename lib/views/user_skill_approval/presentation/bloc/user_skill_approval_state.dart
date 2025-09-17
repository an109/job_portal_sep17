abstract class UserSkillApprovalState {}

class UserSkillApprovalInitial extends UserSkillApprovalState {}

class UserSkillApprovalLoading extends UserSkillApprovalState {}

class UserSkillApprovalLoaded extends UserSkillApprovalState {
  final List<Map<String, dynamic>> skills;
  UserSkillApprovalLoaded(this.skills);
}

class UserSkillApprovalSaved extends UserSkillApprovalState {
  final bool success;
  UserSkillApprovalSaved(this.success);
}

class UserSkillApprovalError extends UserSkillApprovalState {
  final String message;
  UserSkillApprovalError(this.message);
}