class UserEducationResponse {
  final List<CollegeEntity> colleges;
  final List<CourseEntity> courses;
  final List<SpecializationEntity> specializations;

  UserEducationResponse({
    required this.colleges,
    required this.courses,
    required this.specializations,
  });

  factory UserEducationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    final colleges = (data['schoolColleges'] as List)
        .map((e) => CollegeEntity.fromJson(e as Map<String, dynamic>))
        .toList();

    final courses = (data['courses'] as List)
        .map((e) => CourseEntity.fromJson(e as Map<String, dynamic>))
        .toList();

    final specializations = (data['specializations'] as List)
        .map((e) => SpecializationEntity.fromJson(e as Map<String, dynamic>))
        .toList();

    return UserEducationResponse(
      colleges: colleges,
      courses: courses,
      specializations: specializations,
    );
  }
}

class CollegeEntity {
  final int id;
  final String name;

  CollegeEntity({required this.id, required this.name});

  factory CollegeEntity.fromJson(Map<String, dynamic> json) {
    return CollegeEntity(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class CourseEntity {
  final int id;
  final String name;

  CourseEntity({required this.id, required this.name});

  factory CourseEntity.fromJson(Map<String, dynamic> json) {
    return CourseEntity(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class SpecializationEntity {
  final int id;
  final String name;
  final int course_id;

  SpecializationEntity({required this.id, required this.name, required this.course_id});

  factory SpecializationEntity.fromJson(Map<String, dynamic> json) {
    return SpecializationEntity(
      id: json['id'] as int,
      name: json['name'] as String,
      course_id: json['course_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'course_id': course_id};
  }
}