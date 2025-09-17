class UserExperienceRequest {
  final List<ExperienceItem> experiences;

  UserExperienceRequest({required this.experiences});

  factory UserExperienceRequest.fromJson(Map<String, dynamic> json) {
    final experiences = (json['experiences'] as List)
        .map((e) => ExperienceItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return UserExperienceRequest(experiences: experiences);
  }

  Map<String, dynamic> toJson() {
    return {
      'experiences': experiences.map((e) => e.toJson()).toList(),
    };
  }
}

class ExperienceItem {
  final int company_id;
  final int job_role_id;
  final String start_date;
  final String? end_date;
  final String status;
  final String experience_certificate;

  ExperienceItem({
    required this.company_id,
    required this.job_role_id,
    required this.start_date,
    this.end_date,
    required this.status,
    required this.experience_certificate,
  });

  factory ExperienceItem.fromJson(Map<String, dynamic> json) {
    return ExperienceItem(
      company_id: json['company_id'] as int,
      job_role_id: json['job_role_id'] as int,
      start_date: json['start_date'] as String,
      end_date: json['end_date'] as String?,
      status: json['status'] as String,
      experience_certificate: json['experience_certificate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_id': company_id,
      'job_role_id': job_role_id,
      'start_date': start_date,
      'end_date': end_date,
      'status': status,
      'experience_certificate': experience_certificate,
    };
  }
}