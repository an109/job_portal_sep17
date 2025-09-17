import 'package:job_portal/views/post_opportunities/domain/entities/internship_metadata_entity.dart';

class InternshipMetadataResponseModel extends InternshipMetadataEntity {
  InternshipMetadataResponseModel({
    required super.duration,
    required super.startMonth,
    required super.perks,
    required super.cities,
    required super.domains,
    required super.skills, required super.jobRoles,
  });

  factory InternshipMetadataResponseModel.fromJson(Map<String, dynamic> json) {
    return InternshipMetadataResponseModel(
      duration: List<String>.from(json['duration'] ?? []),
      startMonth: List<String>.from(json['startMonth'] ?? []),
      perks: List<String>.from(json['perks'] ?? []),
      cities: List<String>.from(json['cities'] ?? []),
      domains: List<String>.from(json['domains'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      jobRoles: List<String>.from(json['job_role'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'startMonth': startMonth,
      'perks': perks,
      'cities': cities,
      'domains': domains,
      'skills': skills,
    };
  }
}
