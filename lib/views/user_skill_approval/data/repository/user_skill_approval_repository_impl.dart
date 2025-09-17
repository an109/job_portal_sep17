import '../../domain/entities/user_skill_approval_entity.dart';
import '../../domain/repository/user_skill_approval_repository.dart';
import '../data_sources/user_skill_approval_api_service.dart';

class UserSkillApprovalRepositoryImpl implements UserSkillApprovalRepository {
  final UserSkillApprovalApiService apiService;

  UserSkillApprovalRepositoryImpl(this.apiService);

  @override
  Future<UserSkillApprovalEntity> getUserSkills(int userId) async {
    try {
      final response = await apiService.getUserSkills(userId);
      final List<SkillEntity> skillEntities = [];

      for (var skillModel in response.skills) {
        final String authorityName = skillModel.authority.isNotEmpty
            ? skillModel.authority.first.name
            : 'Unknown Authority';

        final int skillId = skillModel.authorityIds.isNotEmpty
            ? skillModel.authorityIds.first
            : 0;

        skillEntities.add(
          SkillEntity(
            skill: skillModel.domain,
            authority: authorityName,
            skillId: skillId,
          ),
        );
      }

      return UserSkillApprovalEntity(
        id: response.id,
        skills: skillEntities,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateUserSkills(int userId, Map<String, dynamic> body) async {
    try {
      await apiService.updateUserSkills(userId, body);
      return true;
    } catch (e) {
      return false;
    }
  }
}