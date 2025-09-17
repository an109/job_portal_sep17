import 'package:job_portal/views/detailed_signup_student/domain/entities/metadata_entities.dart';

// class CoursesListResponse {
//   final List<String> courses;

//   CoursesListResponse({required this.courses});

//   factory CoursesListResponse.fromJson(List<dynamic> json) {
//     return CoursesListResponse(
//       courses: List<String>.from(json),
//     );
//   }

//   List<dynamic> toJson() {
//     return courses;
//   }
// }

class CourseModel extends CourseEntity {
  const CourseModel({
    required int id,
    required String name,
  }) : super(id: id, name: name);

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
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

class CourseListModel extends CourseListEntity {
  const CourseListModel({
    required bool success,
    required List<CourseEntity> courses,
    required String message,
  }) : super(success: success, courses: courses, message: message);

  factory CourseListModel.fromJson(Map<String, dynamic> json) {
    return CourseListModel(
      success: json['success'] ?? false,
      courses: (json['data'] as List<dynamic>?)
              ?.map((e) => CourseModel.fromJson(e))
              .toList() ??
          [],
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': courses
          .map((course) => CourseModel(
                id: course.id,
                name: course.name,
              ).toJson())
          .toList(),
      'message': message,
    };
  }
}

class LocationModel extends LocationEntity {
  const LocationModel({
    required int id,
    required String name,
  }) : super(id: id, name: name);

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
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

class LocationListModel extends LocationListEntity {
  const LocationListModel({
    required bool success,
    required List<LocationEntity> locations,
    required String message,
  }) : super(success: success, locations: locations, message: message);

  factory LocationListModel.fromJson(Map<String, dynamic> json) {
    return LocationListModel(
      success: json['success'] ?? false,
      locations: (json['data'] as List<dynamic>?)
              ?.map((e) => LocationModel.fromJson(e))
              .toList() ??
          [],
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': locations
          .map((location) =>
              LocationModel(id: location.id, name: location.name).toJson())
          .toList(),
      'message': message,
    };
  }
}
