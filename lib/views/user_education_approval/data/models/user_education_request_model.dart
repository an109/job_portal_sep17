class UserEducationRequest {
  final dynamic educations;
  // final List<EducationItem> educations;

  UserEducationRequest({required this.educations});

  factory UserEducationRequest.fromJson(Map<String, dynamic> json) {
    final educations = (json['educations'] as List)
        .map((e) => EducationItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return UserEducationRequest(educations: educations);
  }

  Map<String, dynamic> toJson() {
    return {
      'educations': educations.map((e) => e.toJson()).toList(),
    };
  }
}

class EducationItem {
  final String level;
  final int school_college_id;
  final String board_or_university;
  final int course_id;
  final int specialization_id;
  final String start_year;
  final String end_year;
  final String percentage_or_cgpa;
  final String education_certificate;

  EducationItem({
    required this.level,
    required this.school_college_id,
    required this.board_or_university,
    required this.course_id,
    required this.specialization_id,
    required this.start_year,
    required this.end_year,
    required this.percentage_or_cgpa,
    required this.education_certificate,
  });

  factory EducationItem.fromJson(Map<String, dynamic> json) {
    return EducationItem(
      level: json['level'] as String,
      school_college_id: json['school_college_id'] as int,
      board_or_university: json['board_or_university'] as String,
      course_id: json['course_id'] as int,
      specialization_id: json['specialization_id'] as int,
      start_year: json['start_year'] as String,
      end_year: json['end_year'] as String,
      percentage_or_cgpa: json['percentage_or_cgpa'] as String,
      education_certificate: json['education_certificate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'school_college_id': school_college_id,
      'board_or_university': board_or_university,
      'course_id': course_id,
      'specialization_id': specialization_id,
      'start_year': start_year,
      'end_year': end_year,
      'percentage_or_cgpa': percentage_or_cgpa,
      'education_certificate': education_certificate,
    };
  }
}