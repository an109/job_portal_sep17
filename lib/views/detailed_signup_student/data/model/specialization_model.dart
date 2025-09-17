import '../../domain/entities/metadata_entities.dart';

class SpecializationModel extends SpecializationEntity {
  const SpecializationModel({
    required int? id,
    required String? name,
    required int? course_id,
    required SCourseEntity? course,
  }) : super(
    id: id,
    name: name,
    course_id: course_id,
    course: course,
  );

  factory SpecializationModel.fromJson(Map<String, dynamic> json) {
    return SpecializationModel(
      id: json['id'],
      name: json['name'],
      course_id: json['course_id'],
      course: json['course'] != null
          ? SCourseModel.fromJson(json['course'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'course_id': course_id,
      'course': course != null ? (course as SCourseModel).toJson() : null,
    };
  }
}

class SCourseModel extends SCourseEntity {
  const SCourseModel({required super.name}) : super();

  factory SCourseModel.fromJson(Map<String, dynamic> json) {
    return SCourseModel(name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class SpecializationResponse {
  final bool success;
  final List<SpecializationModel> specializations;
  final String message;

  const SpecializationResponse({
    required this.success,
    required this.specializations,
    required this.message,
  });

  factory SpecializationResponse.fromJson(Map<String, dynamic> json) {
    return SpecializationResponse(
      success: json['success'] ?? false,
      specializations: (json['data'] as List<dynamic>? ?? [])
          .map((e) => SpecializationModel.fromJson(e))
          .toList(),
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': specializations.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}
