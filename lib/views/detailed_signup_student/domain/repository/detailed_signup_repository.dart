import 'dart:io';

import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/basic_user_data_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/colleges_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/courses_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/job_roles_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/specialization_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/submit_detailed_user_profile.dart';
import 'package:job_portal/views/detailed_signup_student/domain/entities/metadata_entities.dart';

import '../../../user_profile/data/models/update_user_profile_model.dart';

abstract class DetailedSignupRepository {

  Future<DataState<dynamic>> getMasterAllData();

  Future<DataState<BasicUserInfoResponse>> getBasicUserInfo(
      Map<String, dynamic> emailMap);

  Future<DataState<CollegeListEntity>> getColleges(
      Map<String, dynamic> emailMap);

  Future<DataState<List<SpecializationEntity>>> getSpecialization(
      String course_id);

  Future<DataState<CourseListEntity>> getCourses();

  Future<DataState<LocationListEntity>> getLocations();

  Future<DataState<JobRolesListResponse>> getJobRoles();

  Future<DataState<SubmitDetailedUserProfile>> submitDetailedUserProfile(
      Map<String, dynamic> params);


}
