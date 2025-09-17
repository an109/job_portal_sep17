import '../../data/models/Recruiter_update_profile_response_model.dart';
import '../entities/Recruiter_update_profile_entity.dart';

abstract class RecruiterUpdateProfileRepository {
  Future<RecruiterUpdateProfileResponse> updateProfile(RecruiterUpdateProfileEntity entity);
}