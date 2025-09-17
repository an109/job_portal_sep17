// class SubSkillResponse {
//   final List<String> skills;

//   SubSkillResponse({required this.skills});

//   factory SubSkillResponse.fromJson(Map<String, dynamic> json) {
//     return SubSkillResponse(
//       skills: List<String>.from(json['skills'] ?? []),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'skills': skills,
//     };
//   }
// }

// skill_model.dart
import 'package:job_portal/views/detailed_signup_student/domain/entities/metadata_entities.dart';

class SkillModel extends SkillEntity {
  const SkillModel({
    required int id,
    required String name,
  }) : super(id: id, name: name);

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class SkillListModel extends SkillListEntity {
  const SkillListModel({
    required List<SkillEntity> skills,
  }) : super(skills: skills);

  factory SkillListModel.fromJson(Map<String, dynamic> json) {
    return SkillListModel(
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => SkillModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skills': skills
          .map((skill) => SkillModel(
                id: skill.id,
                name: skill.name,
              ).toJson())
          .toList(),
    };
  }
}
