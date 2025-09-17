import 'package:dio/dio.dart';
import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/domian_all_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/skill_submission_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/subskill_response.dart';
import 'package:job_portal/views/detailed_signup_student/domain/entities/metadata_entities.dart';

abstract class SkillRepository {
  Future<DataState<DomainListEntity>> getDomains();

  Future<DataState<SkillListEntity>> getSubSkills(String domain);

  Future<DataState<SkillSubmitionResponse>> submitSkillsAndCertificates(
      Map<String, dynamic> data);
}
