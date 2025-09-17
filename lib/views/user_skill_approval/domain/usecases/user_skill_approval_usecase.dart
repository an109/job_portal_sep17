import '../repository/user_skill_approval_repository.dart';

class UpdateUserSkillsUseCase {
  final UserSkillApprovalRepository repository;

  UpdateUserSkillsUseCase(this.repository);

  Future<bool> execute(int userId, Map<String, dynamic> body) async {
    return await repository.updateUserSkills(userId, body);
  }
}