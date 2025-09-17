// models/master_data_entity.dart
import 'package:equatable/equatable.dart';

class MasterDataEntity with EquatableMixin {
  final List<DurationItem> duration;
  final List<PerkItem> perks;
  final List<LocationItem> locations;
  final List<CourseItem> courses;
  final List<CollegeItem> schoolColleges;
  final List<JobRoleItem> jobRoles;
  final List<SpecializationItem> specializations;
  final List<DomainItem> domains;
  final List<SkillsByDomainItem> skillsByDomain;
  final List<SpecializationByCourseItem> specializationByCourse;
  final List<IndustryItem> industries;
  final List<LanguageItem> languages;
    final List<CompanyItem> companies;

  const MasterDataEntity({
    required this.duration,
    required this.perks,
    required this.locations,
    required this.courses,
    required this.schoolColleges,
    required this.jobRoles,
    required this.specializations,
    required this.domains,
    required this.skillsByDomain,
    required this.specializationByCourse,
    required this.industries,
    required this.languages,
    required this.companies,
  });

  factory MasterDataEntity.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return MasterDataEntity(
      duration: (data['duration'] as List)
          .map((e) => DurationItem.fromJson(e))
          .toList(),
      perks: (data['perks'] as List)
          .map((e) => PerkItem.fromJson(e))
          .toList(),
      locations: (data['locations'] as List)
          .map((e) => LocationItem.fromJson(e))
          .toList(),
      courses: (data['courses'] as List)
          .map((e) => CourseItem.fromJson(e))
          .toList(),
      schoolColleges: (data['schoolColleges'] as List)
          .map((e) => CollegeItem.fromJson(e))
          .toList(),
      jobRoles: (data['jobRoles'] as List)
          .map((e) => JobRoleItem.fromJson(e))
          .toList(),
      specializations: (data['specializations'] as List)
          .map((e) => SpecializationItem.fromJson(e))
          .toList(),
      domains: (data['domains'] as List)
          .map((e) => DomainItem.fromJson(e))
          .toList(),
      skillsByDomain: (data['skillsByDomain'] as List)
          .map((e) => SkillsByDomainItem.fromJson(e))
          .toList(),
      specializationByCourse: (data['specializationByCourse'] as List)
          .map((e) => SpecializationByCourseItem.fromJson(e))
          .toList(),
      industries: (data['industries'] as List)
          .map((e) => IndustryItem.fromJson(e))
          .toList(),
      languages: (data['languages'] as List)
          .map((e) => LanguageItem.fromJson(e))
          .toList(),
      companies: (data['companies'] as List)
          .map((e) => CompanyItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'duration': duration.map((e) => e.toJson()).toList(),
        'perks': perks.map((e) => e.toJson()).toList(),
        'locations': locations.map((e) => e.toJson()).toList(),
        'courses': courses.map((e) => e.toJson()).toList(),
        'schoolColleges': schoolColleges.map((e) => e.toJson()).toList(),
        'jobRoles': jobRoles.map((e) => e.toJson()).toList(),
        'specializations': specializations.map((e) => e.toJson()).toList(),
        'domains': domains.map((e) => e.toJson()).toList(),
        'skillsByDomain': skillsByDomain.map((e) => e.toJson()).toList(),
        'specializationByCourse':
        specializationByCourse.map((e) => e.toJson()).toList(),
        'industries': industries.map((e) => e.toJson()).toList(),
        'languages': languages.map((e) => e.toJson()).toList(),
        'companies': companies.map((e) => e.toJson()).toList(),
      }
    };
  }

  @override
  List<Object?> get props => [
    duration,
    perks,
    locations,
    courses,
    schoolColleges,
    jobRoles,
    specializations,
    domains,
    skillsByDomain,
    specializationByCourse,
    industries,
    languages,
    companies,
  ];
}

// --- Support Classes ---

class DurationItem with EquatableMixin {
  final int id;
  final String value;

  const DurationItem({required this.id, required this.value});

  factory DurationItem.fromJson(Map<String, dynamic> json) => DurationItem(
    id: json['id'],
    value: json['value'],
  );

  Map<String, dynamic> toJson() => {'id': id, 'value': value};

  @override
  List<Object?> get props => [id, value];
}

class PerkItem with EquatableMixin {
  final int id;
  final String value;

  const PerkItem({required this.id, required this.value});

  factory PerkItem.fromJson(Map<String, dynamic> json) => PerkItem(
    id: json['id'],
    value: json['value'],
  );

  Map<String, dynamic> toJson() => {'id': id, 'value': value};

  @override
  List<Object?> get props => [id, value];
}

class LocationItem with EquatableMixin {
  final int id;
  final String name;

  const LocationItem({required this.id, required this.name});

  factory LocationItem.fromJson(Map<String, dynamic> json) => LocationItem(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}

class CourseItem with EquatableMixin {
  final int id;
  final String name;

  const CourseItem({required this.id, required this.name});

  factory CourseItem.fromJson(Map<String, dynamic> json) => CourseItem(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}

class CollegeItem with EquatableMixin {
  final int id;
  final String name;

  const CollegeItem({required this.id, required this.name});

  factory CollegeItem.fromJson(Map<String, dynamic> json) => CollegeItem(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}

class JobRoleItem with EquatableMixin {
  final int? id;
  final String? title;
  final String? description;

  const JobRoleItem({required this.id, required this.title, required this.description});

  factory JobRoleItem.fromJson(Map<String, dynamic> json) => JobRoleItem(
    id: json['id'],
    title: json['title'],
    description: json['description'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
  };

  @override
  List<Object?> get props => [id, title, description];
}

class SpecializationItem with EquatableMixin {
  final int? id;
  final String? name;
  final int? course_id;
  final Map<String, dynamic>? course;

  const SpecializationItem({
    this.id,
    this.name,
    this.course_id,
    this.course,
  });

  factory SpecializationItem.fromJson(Map<String, dynamic> json) => SpecializationItem(
    id: json['id'],
    name: json['name'],
    course_id: json['course_id'],
    course: json['course'] as Map<String, dynamic>?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'course_id': course_id,
    'course': course,
  };

  @override
  List<Object?> get props => [id, name, course_id, course];
}

class DomainItem with EquatableMixin {
  final int domainId;
  final String domainName;

  const DomainItem({required this.domainId, required this.domainName});

  factory DomainItem.fromJson(Map<String, dynamic> json) => DomainItem(
    domainId: json['domain_id'],
    domainName: json['domain_name'],
  );

  Map<String, dynamic> toJson() => {
    'domain_id': domainId,
    'domain_name': domainName,
  };

  @override
  List<Object?> get props => [domainId, domainName];
}

class SkillsByDomainItem with EquatableMixin {
  final int domainId;
  final String domainName;
  final List<SkillItem> skills;

  const SkillsByDomainItem({
    required this.domainId,
    required this.domainName,
    required this.skills,
  });

  factory SkillsByDomainItem.fromJson(Map<String, dynamic> json) => SkillsByDomainItem(
    domainId: json['domain_id'],
    domainName: json['domain_name'],
    skills: (json['skills'] as List).map((e) => SkillItem.fromJson(e)).toList(),
  );

  Map<String, dynamic> toJson() => {
    'domain_id': domainId,
    'domain_name': domainName,
    'skills': skills.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [domainId, domainName, skills];
}

class SkillItem with EquatableMixin {
  final int skillId;
  final String skillName;

  const SkillItem({required this.skillId, required this.skillName});

  factory SkillItem.fromJson(Map<String, dynamic> json) => SkillItem(
    skillId: json['skill_id'],
    skillName: json['skill_name'],
  );

  Map<String, dynamic> toJson() => {
    'skill_id': skillId,
    'skill_name': skillName,
  };

  @override
  List<Object?> get props => [skillId, skillName];
}

class SpecializationByCourseItem with EquatableMixin {
  final int id;
  final String name;
  final List<SpecializationItem> specializations;

  const SpecializationByCourseItem({
    required this.id,
    required this.name,
    required this.specializations,
  });

  factory SpecializationByCourseItem.fromJson(Map<String, dynamic> json) =>
      SpecializationByCourseItem(
        id: json['id'],
        name: json['name'],
        specializations: (json['specializations'] as List)
            .map((e) => SpecializationItem.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'specializations': specializations.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [id, name, specializations];
}

class IndustryItem with EquatableMixin {
  final int id;
  final String name;

  const IndustryItem({required this.id, required this.name});

  factory IndustryItem.fromJson(Map<String, dynamic> json) => IndustryItem(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}

class LanguageItem with EquatableMixin {
  final int id;
  final String name;

  const LanguageItem({required this.id, required this.name});

  factory LanguageItem.fromJson(Map<String, dynamic> json) => LanguageItem(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}

class CompanyItem with EquatableMixin {
  final int? id;
  final String? companyName;

  const CompanyItem({required this.id, required this.companyName});

  factory CompanyItem.fromJson(Map<String, dynamic> json) => CompanyItem(
    id: json['id'],
    companyName: json['company_name'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'company_name': companyName,
  };

  @override
  List<Object?> get props => [id, companyName];
}