import '../entities/user_skill_approval_entity.dart';

abstract class UserSkillApprovalRepository {
  Future<UserSkillApprovalEntity> getUserSkills(int userId);
  Future<bool> updateUserSkills(int userId, Map<String, dynamic> body);
}