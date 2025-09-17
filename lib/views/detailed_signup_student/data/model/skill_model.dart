import '../../domain/entities/metadata_entities.dart';

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

class SkillListResponse {
  final bool success;
  final List<SkillModel> skills;
  final String message;

  const SkillListResponse({
    required this.success,
    required this.skills,
    required this.message,
  });

  factory SkillListResponse.fromJson(Map<String, dynamic> json) {
    return SkillListResponse(
      success: json['success'] ?? false,
      skills: (json['data'] as List<dynamic>? ?? [])
          .map((e) => SkillModel.fromJson(e))
          .toList(),
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': skills.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}
