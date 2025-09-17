// lib/models/master_data_model.dart

class MasterDataModel {
  List<DurationItem>? duration;
  List<PerkItem>? perks;
  List<LocationItem>? locations;
  List<CourseItem>? courses;
  List<SchoolCollegeItem>? schoolColleges;
  List<JobRoleItem>? jobRoles;
  List<SpecializationItem>? specializations;
  List<DomainItem>? domains;
  List<SkillsByDomainItem>? skillsByDomain;
  List<SpecializationByCourseItem>? specializationByCourse;
  List<IndustryItem>? industries;
  List<LanguageItem>? languages;
  List<CompanyItem>? companies;

  MasterDataModel({
    this.duration,
    this.perks,
    this.locations,
    this.courses,
    this.schoolColleges,
    this.jobRoles,
    this.specializations,
    this.domains,
    this.skillsByDomain,
    this.specializationByCourse,
    this.industries,
    this.languages,
    this.companies,
  });

  factory MasterDataModel.fromJson(Map<String, dynamic> json) {
    return MasterDataModel(
      duration: (json['duration'] as List?)
          ?.map((e) => DurationItem.fromJson(e))
          .toList(),
      perks: (json['perks'] as List?)
          ?.map((e) => PerkItem.fromJson(e))
          .toList(),
      locations: (json['locations'] as List?)
          ?.map((e) => LocationItem.fromJson(e))
          .toList(),
      courses: (json['courses'] as List?)
          ?.map((e) => CourseItem.fromJson(e))
          .toList(),
      schoolColleges: (json['schoolColleges'] as List?)
          ?.map((e) => SchoolCollegeItem.fromJson(e))
          .toList(),
      jobRoles: (json['jobRoles'] as List?)
          ?.map((e) => JobRoleItem.fromJson(e))
          .toList(),
      specializations: (json['specializations'] as List?)
          ?.map((e) => SpecializationItem.fromJson(e))
          .toList(),
      domains: (json['domains'] as List?)
          ?.map((e) => DomainItem.fromJson(e))
          .toList(),
      skillsByDomain: (json['skillsByDomain'] as List?)
          ?.map((e) => SkillsByDomainItem.fromJson(e))
          .toList(),
      specializationByCourse: (json['specializationByCourse'] as List?)
          ?.map((e) => SpecializationByCourseItem.fromJson(e))
          .toList(),
      industries: (json['industries'] as List?)
          ?.map((e) => IndustryItem.fromJson(e))
          .toList(),
      languages: (json['languages'] as List?)
          ?.map((e) => LanguageItem.fromJson(e))
          .toList(),
      companies: (json['companies'] as List?)
          ?.map((e) => CompanyItem.fromJson(e))
          .toList(),
    );
  }
}

// Duration Item
class DurationItem {
  int? id;
  String? value;

  DurationItem({this.id, this.value});

  factory DurationItem.fromJson(Map<String, dynamic> json) {
    return DurationItem(
      id: json['id'],
      value: json['value'],
    );
  }
}

// Perk Item
class PerkItem {
  int? id;
  String? value;

  PerkItem({this.id, this.value});

  factory PerkItem.fromJson(Map<String, dynamic> json) {
    return PerkItem(
      id: json['id'],
      value: json['value'],
    );
  }
}

// Location Item
class LocationItem {
  int? id;
  String? name;

  LocationItem({this.id, this.name});

  factory LocationItem.fromJson(Map<String, dynamic> json) {
    return LocationItem(
      id: json['id'],
      name: json['name'],
    );
  }
}

// Course Item
class CourseItem {
  int? id;
  String? name;

  CourseItem({this.id, this.name});

  factory CourseItem.fromJson(Map<String, dynamic> json) {
    return CourseItem(
      id: json['id'],
      name: json['name'],
    );
  }
}

// School/College Item
class SchoolCollegeItem {
  int? id;
  String? name;

  SchoolCollegeItem({this.id, this.name});

  factory SchoolCollegeItem.fromJson(Map<String, dynamic> json) {
    return SchoolCollegeItem(
      id: json['id'],
      name: json['name'],
    );
  }
}

// Job Role Item
class JobRoleItem {
  int? id;
  String? title;
  String? description;

  JobRoleItem({this.id, this.title, this.description});

  factory JobRoleItem.fromJson(Map<String, dynamic> json) {
    return JobRoleItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }
}

// Specialization Item
class SpecializationItem {
  int? id;
  String? name;
  int? courseId;
  CourseItem? course;

  SpecializationItem({this.id, this.name, this.courseId, this.course});

  factory SpecializationItem.fromJson(Map<String, dynamic> json) {
    return SpecializationItem(
      id: json['id'],
      name: json['name'],
      courseId: json['course_id'],
      course: json['course'] != null
          ? CourseItem.fromJson(json['course'])
          : null,
    );
  }
}

// Domain Item
class DomainItem {
  int? domainId;
  String? domainName;

  DomainItem({this.domainId, this.domainName});

  factory DomainItem.fromJson(Map<String, dynamic> json) {
    return DomainItem(
      domainId: json['domain_id'],
      domainName: json['domain_name'],
    );
  }
}

// Skill Item
class SkillItem {
  int? skillId;
  String? skillName;

  SkillItem({this.skillId, this.skillName});

  factory SkillItem.fromJson(Map<String, dynamic> json) {
    return SkillItem(
      skillId: json['skill_id'],
      skillName: json['skill_name'],
    );
  }
}

// Skills By Domain Item
class SkillsByDomainItem {
  int? domainId;
  String? domainName;
  List<SkillItem>? skills;

  SkillsByDomainItem({this.domainId, this.domainName, this.skills});

  factory SkillsByDomainItem.fromJson(Map<String, dynamic> json) {
    return SkillsByDomainItem(
      domainId: json['domain_id'],
      domainName: json['domain_name'],
      skills: (json['skills'] as List?)
          ?.map((e) => SkillItem.fromJson(e))
          .toList(),
    );
  }
}

// Specialization By Course Item
class SpecializationByCourseItem {
  int? id;
  String? name;
  List<SpecializationItem>? specializations;

  SpecializationByCourseItem({this.id, this.name, this.specializations});

  factory SpecializationByCourseItem.fromJson(Map<String, dynamic> json) {
    return SpecializationByCourseItem(
      id: json['id'],
      name: json['name'],
      specializations: (json['specializations'] as List?)
          ?.map((e) => SpecializationItem.fromJson(e))
          .toList(),
    );
  }
}

// Industry Item
class IndustryItem {
  int? id;
  String? name;

  IndustryItem({this.id, this.name});

  factory IndustryItem.fromJson(Map<String, dynamic> json) {
    return IndustryItem(
      id: json['id'],
      name: json['name'],
    );
  }
}

// Language Item
class LanguageItem {
  int? id;
  String? name;

  LanguageItem({this.id, this.name});

  factory LanguageItem.fromJson(Map<String, dynamic> json) {
    return LanguageItem(
      id: json['id'],
      name: json['name'],
    );
  }
}

// Company Item
class CompanyItem {
  int? id;
  String? companyName;

  CompanyItem({this.id, this.companyName});

  factory CompanyItem.fromJson(Map<String, dynamic> json) {
    return CompanyItem(
      id: json['id'],
      companyName: json['company_name'],
    );
  }
}