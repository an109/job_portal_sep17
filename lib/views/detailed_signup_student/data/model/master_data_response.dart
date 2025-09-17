import '../../domain/entities/metadata_entities.dart';
import 'colleges_response.dart';
import 'courses_response.dart';
import 'domian_all_response.dart';
import 'skill_model.dart';
import 'specialization_model.dart';

class MasterDataResponse {
  final bool success;
  final String message;
  final MasterData data;

  MasterDataResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MasterDataResponse.fromJson(Map<String, dynamic> json) {
    return MasterDataResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: MasterData.fromJson(json['data'] ?? {}),
    );
  }
}

class MasterData {
  final List<LocationEntity> locations;
  final List<CourseEntity> courses;
  final List<CollegeEntity> colleges;
  final List<DomainEntity> domains;
  final List<SkillEntity> skills;
  final List<SpecializationEntity> specializations;
  final List<CompanyEntity> companies;


  MasterData({
    required this.locations,
    required this.courses,
    required this.colleges,
    required this.domains,
    required this.skills,
    required this.specializations,
    required this.companies,

  });

  factory MasterData.fromJson(Map<String, dynamic> json) {
    return MasterData(
      locations: (json['locations'] as List<dynamic>? ?? [])
          .map((e) => LocationModel.fromJson(e))
          .toList(),
      courses: (json['courses'] as List<dynamic>? ?? [])
          .map((e) => CourseModel.fromJson(e))
          .toList(),
      colleges: (json['schoolColleges'] as List<dynamic>? ?? [])
          .map((e) => CollegeModel.fromJson(e))
          .toList(),
      domains: (json['domains'] as List<dynamic>? ?? [])
          .map((e) => DomainModel.fromJson({
        'id': e['domain_id'],
        'name': e['domain_name'],
      }))
          .toList(),
      skills: (json['skillsByDomain'] as List<dynamic>? ?? [])
          .expand((d) => (d['skills'] as List<dynamic>)
          .map((s) => SkillModel.fromJson({
        'id': s['skill_id'],
        'name': s['skill_name'],
      })))
          .toList(),
      specializations: (json['specializations'] as List<dynamic>? ?? [])
          .map((e) => SpecializationModel.fromJson(e))
          .toList(),
      companies: (json['companies'] as List)
          .map((e) => CompanyEntity(id: e['id'], name: e['company_name']))
          .toList(),

    );
  }
}
