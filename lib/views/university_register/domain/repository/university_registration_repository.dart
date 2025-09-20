import '../../../../utils/resourses/data_state.dart';
import '../entities/university_registration_entity.dart';

abstract class UniversityRegistrationRepository {
  Future<DataState<UniversityRegistrationEntity>> registerUniversity(UniversityRegistrationEntity entity);
}