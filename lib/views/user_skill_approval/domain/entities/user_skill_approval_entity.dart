// user_skill_approval_entity.dart
class UserSkillApprovalEntity {
  final int id;
  final List<SkillEntity> skills;

  const UserSkillApprovalEntity({required this.id, required this.skills});
}

class SkillEntity {
  final String skill;
  final String authority;
  final int skillId;

  const SkillEntity({
    required this.skill,
    required this.authority,
    required this.skillId,
  });
}