
import '../../data/models/Recruiter_update_profile_response_model.dart';
import '../entities/Recruiter_update_profile_entity.dart';
import '../repository/Recruiter_update_profile_repository.dart';

class RecruiterUpdateProfileUseCase {
  final RecruiterUpdateProfileRepository repository;

  RecruiterUpdateProfileUseCase(this.repository);

  Future<RecruiterUpdateProfileResponse> call(RecruiterUpdateProfileEntity entity) async {
    return await repository.updateProfile(entity);
  }
}