import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/courses_response.dart';
import 'package:job_portal/views/detailed_signup_student/domain/entities/metadata_entities.dart';

abstract class UniversitySignupRepository {
  Future<DataState<CourseListEntity>> getCourses();
}
