abstract class UserSkillApprovalEvent {}

class LoadUserSkills extends UserSkillApprovalEvent {
  final int userId;
  LoadUserSkills(this.userId);
}

class SaveUserSkills extends UserSkillApprovalEvent {
  final int userId;
  final List<Map<String, dynamic>> skills;
  SaveUserSkills(this.userId, this.skills);
}