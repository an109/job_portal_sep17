// lib/views/user_education_approval/domain/entities/user_education_approval_entity.dart
class CollegeEntity {
  final int id;
  final String name;
  final String logo_pic;

  CollegeEntity({
    required this.id,
    required this.name,
    required this.logo_pic,
  });

  factory CollegeEntity.fromJson(Map<String, dynamic> json) {
    return CollegeEntity(
      id: json['id'] as int,
      name: json['name'] as String,
      logo_pic: json['logo_pic'] as String,
    );
  }
}

class CourseEntity {
  final int id;
  final String name;

  CourseEntity({
    required this.id,
    required this.name,
  });

  factory CourseEntity.fromJson(Map<String, dynamic> json) {
    return CourseEntity(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

// class SpecializationEntity {
//   final int? id;
//   final String? name;
//   final int? course_id;
//   final SCourseEntity? course;
//
//   SpecializationEntity({
//     this.id,
//     this.name,
//     this.course_id,
//     this.course,
//   });
//
//   factory SpecializationEntity.fromJson(Map<String, dynamic> json) {
//     return SpecializationEntity(
//       id: json['id'] as int?,
//       name: json['name'] as String?,
//       course_id: json['course_id'] as int?,
//       course: json['course'] != null
//           ? SCourseEntity.fromJson(json['course'])
//           : null,
//     );
//   }
// }

class SCourseEntity {
  final String name;

  SCourseEntity({required this.name});

  factory SCourseEntity.fromJson(Map<String, dynamic> json) {
    return SCourseEntity(
      name: json['name'] as String,
    );
  }
}