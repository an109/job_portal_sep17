import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:job_portal/utils/constants/urls.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/basic_user_data_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/colleges_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/courses_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/domian_all_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/job_roles_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/skill_submission_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/specialization_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/submit_detailed_user_profile.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/subskill_response.dart';
import 'package:retrofit/retrofit.dart';

part 'detailed_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class DetailedApiService {
  factory DetailedApiService(Dio dio, {String? baseUrl}) = _DetailedApiService;

  @GET(Urls.getMasterAllData)
  Future<HttpResponse<dynamic>> getMasterAllData();

  @POST(Urls.getUserBasicInfo)
  Future<HttpResponse<BasicUserInfoResponse>> getBasicUserInfo(
      @Body() Map<String, dynamic> emailMap);

  @GET(Urls.getColleges)
  Future<HttpResponse<CollegeListModel>> getColleges(
      @Body() Map<String, dynamic> emailMap);

  @GET(Urls.getSpecialization)
  Future<HttpResponse<SpecializationResponse>> getSpecialization(
      @Path() String course_id);

  @GET(Urls.getCourses)
  Future<HttpResponse<CourseListModel>> getCourses();

  @GET('${Urls.getSubSkills}/{domain}')
  Future<HttpResponse<SkillListModel>> getSubSkills(@Path() String domain);

  @GET(Urls.getDomainAll)
  Future<HttpResponse<DomainListModel>> getDomains();

  @GET(Urls.getJobRoles)
  Future<HttpResponse<JobRolesListResponse>> getJobRoles();

  @POST(Urls.submitDetailedUserProfile)
  Future<HttpResponse<SubmitDetailedUserProfile>> submitDetailedUserProfile(
      @Body() Map<String, dynamic> params);

  @POST(Urls.submitSkillsAndCertificates)
  @MultiPart()
  Future<HttpResponse<SkillSubmitionResponse>> submitSkillsAndCertificates(
      @Body() Map<String, dynamic> data);

  @GET(Urls.getLocations)
  Future<HttpResponse<LocationListModel>> getLocations();
}

// List<dynamic>
