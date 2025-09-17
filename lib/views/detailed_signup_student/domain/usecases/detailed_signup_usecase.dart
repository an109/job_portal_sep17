import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/basic_user_data_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/colleges_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/courses_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/job_roles_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/specialization_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/submit_detailed_user_profile.dart';
import 'package:job_portal/views/detailed_signup_student/domain/entities/metadata_entities.dart';
import 'package:job_portal/views/detailed_signup_student/domain/repository/detailed_signup_repository.dart';

class DetailedSignupUsecase {
  final DetailedSignupRepository _repository;
  DetailedSignupUsecase(this._repository);

  Future<DataState<dynamic>> getMasterAllData() async {
    return await _repository.getMasterAllData();
  }

  Future<DataState<BasicUserInfoResponse>> getBasicUserInfo(
      Map<String, dynamic> emailMap) async {
    final response = await _repository.getBasicUserInfo(emailMap);
    return response;
  }

  Future<DataState<CollegeListEntity>> getColleges(
      Map<String, dynamic> emailMap) async {
    final response = await _repository.getColleges(emailMap);
    return response;
  }

  Future<DataState<List<SpecializationEntity>>> getSpecialization(
      String course_id) async {
    final response = await _repository.getSpecialization(course_id);
    return response;
  }

  Future<DataState<CourseListEntity>> getCourses() async {
    final response = await _repository.getCourses();
    return response;
  }

  Future<DataState<LocationListEntity>> getLocations() async {
    final response = await _repository.getLocations();
    return response;
  }

  Future<DataState<JobRolesListResponse>> getJobRoles() async {
    final response = await _repository.getJobRoles();
    return response;
  }

  Future<DataState<SubmitDetailedUserProfile>> submitDetailedUserProfile(
      Map<String, dynamic> params) async {
    final response = await _repository.submitDetailedUserProfile(params);
    return response;
  }
}
